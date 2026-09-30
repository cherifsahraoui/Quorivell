package com.quorivell.app

import android.content.Context
import java.util.Locale
import kotlin.math.abs
import kotlin.math.ceil

/** Smoothed throughput from successive byte samples (matches Dart [DownloadSpeedTracker]). */
internal class TransferSpeedTracker {
    private var sampleAt = 0L
    private var sampleBytes = -1L
    var bytesPerSecond: Double? = null
        private set

    fun observe(
        receivedBytes: Long,
        now: Long = System.currentTimeMillis(),
        minSampleMs: Long = 400L,
    ): Double? {
        if (sampleBytes < 0L) {
            sampleAt = now
            sampleBytes = receivedBytes
            return bytesPerSecond
        }
        val elapsed = now - sampleAt
        if (elapsed < minSampleMs) {
            return bytesPerSecond
        }
        val deltaBytes = receivedBytes - sampleBytes
        if (deltaBytes >= 0L && elapsed > 0L) {
            val instant = deltaBytes * 1000.0 / elapsed
            val previous = bytesPerSecond
            bytesPerSecond = if (previous == null) {
                instant
            } else {
                previous * 0.7 + instant * 0.3
            }
        }
        sampleAt = now
        sampleBytes = receivedBytes
        return bytesPerSecond
    }

    fun remainingSeconds(receivedBytes: Long, totalBytes: Long?): Long? {
        val rate = bytesPerSecond
        if (rate == null || rate <= 0.0 || totalBytes == null || totalBytes <= 0L) {
            return null
        }
        val left = totalBytes - receivedBytes
        if (left <= 0L) {
            return 0L
        }
        return ceil(left / rate).toLong()
    }
}

/** Localized "42% · 3.2 MB/s · ~5 min left" for the ongoing install notification. */
internal object ModelInstallProgressText {
    fun body(
        context: Context,
        percent: Int,
        bytesPerSecond: Double?,
        remainingSeconds: Long?,
    ): String? {
        if (bytesPerSecond == null || bytesPerSecond <= 0.0 || remainingSeconds == null) {
            return null
        }
        return context.getString(
            R.string.model_install_progress_stats,
            percent,
            speedLabel(context, bytesPerSecond),
            remainingLabel(context, remainingSeconds),
        )
    }

    private fun speedLabel(context: Context, bytesPerSecond: Double): String {
        val abs = abs(bytesPerSecond)
        if (abs >= 1000.0 * 1000.0) {
            return context.getString(
                R.string.model_install_speed_mbps,
                rateValue(abs / 1_000_000.0),
            )
        }
        if (abs >= 1000.0) {
            return context.getString(
                R.string.model_install_speed_kbps,
                rateValue(abs / 1000.0),
            )
        }
        return context.getString(R.string.model_install_speed_bps, abs.toInt())
    }

    private fun rateValue(value: Double): String {
        val pattern = if (value >= 10.0) "%.0f" else "%.1f"
        return String.format(Locale.US, pattern, value)
    }

    private fun remainingLabel(context: Context, remainingSeconds: Long): String {
        if (remainingSeconds >= 3600L) {
            val hours = ceil(remainingSeconds / 3600.0).toInt()
            return context.getString(R.string.model_install_time_left_hours, hours)
        }
        if (remainingSeconds >= 60L) {
            val minutes = ceil(remainingSeconds / 60.0).toInt()
            return context.getString(R.string.model_install_time_left_minutes, minutes)
        }
        val seconds = if (remainingSeconds < 1L) 1 else remainingSeconds.toInt()
        return context.getString(R.string.model_install_time_left_seconds, seconds)
    }
}
