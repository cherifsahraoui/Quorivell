package com.quorivell.app

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import androidx.work.ForegroundInfo
import androidx.work.WorkManager

class ExtractionService : Service() {
    private var wakeLock: PowerManager.WakeLock? = null
    private var lastTitle: String = ""
    private var lastBody: String = ""
    private var lastCurrent: Int = 0
    private var lastTotal: Int = 0

    companion object {
        const val PROGRESS_CHANNEL_ID = "extraction_progress_channel_v2"
        // v2: IMPORTANCE_HIGH so finish alerts can sound when the screen is off.
        // Android freezes channel importance after first create — bump the id.
        const val COMPLETION_CHANNEL_ID = "extraction_complete_channel_v2"
        const val NOTIFICATION_ID = 1001
        const val COMPLETION_NOTIFICATION_ID = 1002
        private const val WAKE_LOCK_WINDOW_MS = 60 * 60 * 1000L

        const val EXTRA_DESTINATION = "com.quorivell.app.EXTRA_DESTINATION"
        private const val EXTRA_TITLE = "title"
        private const val EXTRA_BODY = "body"
        private const val ACTION_START = "com.quorivell.app.START_EXTRACTION"
        private const val ACTION_STOP = "com.quorivell.app.STOP_EXTRACTION"
        private const val ACTION_COMPLETE = "com.quorivell.app.COMPLETE_EXTRACTION"
        private const val ACTION_REFRESH = "com.quorivell.app.REFRESH_EXTRACTION"
        private const val ACTION_PROGRESS = "com.quorivell.app.PROGRESS_EXTRACTION"
        private const val EXTRA_CURRENT = "current"
        private const val EXTRA_TOTAL = "total"

        @Volatile
        private var running: ExtractionService? = null

        @Volatile
        private var lastDestination: String = ""

        fun isRunning(): Boolean = running != null

        fun destinationFrom(intent: Intent?): String? {
            val dest = intent?.getStringExtra(EXTRA_DESTINATION)?.trim().orEmpty()
            return dest.takeIf { it.startsWith("/") }
        }

        fun startExtraction(
            context: Context,
            title: String,
            body: String,
            destination: String = "",
        ) {
            val intent = Intent(context, ExtractionService::class.java).apply {
                action = ACTION_START
                putExtra(EXTRA_TITLE, title)
                putExtra(EXTRA_BODY, body)
                putExtra(EXTRA_DESTINATION, destination)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun refreshKeepAlive(context: Context, title: String, body: String) {
            val intent = Intent(context, ExtractionService::class.java).apply {
                action = ACTION_REFRESH
                putExtra(EXTRA_TITLE, title)
                putExtra(EXTRA_BODY, body)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stopExtraction(context: Context) {
            if (isRunning()) {
                val intent = Intent(context, ExtractionService::class.java).apply {
                    action = ACTION_STOP
                }
                context.startService(intent)
            } else {
                // Service already gone (process death / OEM kill). Still drop
                // the leftover progress shade so Dart idle resume is honest.
                cancelProgressNotification(context)
            }
        }

        fun cancelProgressNotification(context: Context) {
            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.cancel(NOTIFICATION_ID)
        }

        fun completeExtraction(
            context: Context,
            title: String,
            body: String,
            destination: String = "",
        ) {
            val intent = Intent(context, ExtractionService::class.java).apply {
                action = ACTION_COMPLETE
                putExtra(EXTRA_TITLE, title)
                putExtra(EXTRA_BODY, body)
                putExtra(EXTRA_DESTINATION, destination)
            }
            context.startService(intent)
        }

        fun updateProgress(
            current: Int,
            total: Int,
            title: String? = null,
            body: String? = null,
        ) {
            running?.applyProgress(current, total, title, body)
        }

        /**
         * Ongoing data-sync notification with a WhatsApp-style loader.
         *
         * Indeterminate (animated) until [total] > 1 and [current] > 0, then a
         * filling bar. Single-chunk work stays indeterminate because duration
         * is not byte-accurate.
         */
        fun createProgressNotification(
            context: Context,
            title: String,
            body: String,
            current: Int = 0,
            total: Int = 0,
        ): Notification {
            createNotificationChannels(context)
            val indeterminate = total <= 1 || current <= 0
            val builder = NotificationCompat.Builder(context, PROGRESS_CHANNEL_ID)
                .setContentTitle(title)
                .setContentText(body)
                .setSmallIcon(android.R.drawable.stat_notify_sync)
                .setContentIntent(
                    launchPendingIntent(context, lastDestination, NOTIFICATION_ID),
                )
                .setOngoing(true)
                .setOnlyAlertOnce(true)
                .setShowWhen(false)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setCategory(NotificationCompat.CATEGORY_PROGRESS)
                .setForegroundServiceBehavior(
                    NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE,
                )

            if (indeterminate) {
                builder.setProgress(0, 0, true)
            } else {
                builder.setProgress(total, current.coerceIn(0, total), false)
            }

            return builder.build()
        }

        fun foregroundInfo(context: Context, title: String, body: String): ForegroundInfo {
            val notification = createProgressNotification(context, title, body)
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                ForegroundInfo(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC,
                )
            } else {
                ForegroundInfo(NOTIFICATION_ID, notification)
            }
        }

        private fun launchPendingIntent(
            context: Context,
            destination: String,
            requestCode: Int,
        ): PendingIntent {
            var pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                pendingIntentFlags = pendingIntentFlags or PendingIntent.FLAG_IMMUTABLE
            }
            val intent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_MAIN
                addCategory(Intent.CATEGORY_LAUNCHER)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                if (destination.isNotBlank()) {
                    putExtra(EXTRA_DESTINATION, destination)
                    data = android.net.Uri.parse("quorivell://notification$destination")
                }
            }
            return PendingIntent.getActivity(context, requestCode, intent, pendingIntentFlags)
        }

        fun createNotificationChannels(context: Context) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            val progressChannel = NotificationChannel(
                PROGRESS_CHANNEL_ID,
                context.getString(R.string.data_sync_progress_channel_name),
                NotificationManager.IMPORTANCE_LOW,
            ).apply {
                description = context.getString(R.string.data_sync_progress_channel_description)
                setShowBadge(false)
                enableVibration(false)
                setSound(null, null)
            }

            val completionChannel = NotificationChannel(
                COMPLETION_CHANNEL_ID,
                context.getString(R.string.data_sync_complete_channel_name),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = context.getString(R.string.data_sync_complete_channel_description)
                enableVibration(true)
            }

            notificationManager.createNotificationChannel(progressChannel)
            notificationManager.createNotificationChannel(completionChannel)
            notificationManager.deleteNotificationChannel("extraction_channel")
            notificationManager.deleteNotificationChannel("extraction_progress_channel")
            notificationManager.deleteNotificationChannel("extraction_complete_channel")
        }
    }

    override fun onCreate() {
        super.onCreate()
        running = this
        createNotificationChannels(this)
        acquireWakeLock()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                lastCurrent = 0
                lastTotal = 0
                lastDestination = intent.getStringExtra(EXTRA_DESTINATION).orEmpty()
                val title = intent.getStringExtra(EXTRA_TITLE)
                    ?: getString(R.string.extraction_in_progress_title)
                val body = intent.getStringExtra(EXTRA_BODY)
                    ?: getString(R.string.extraction_in_progress_body)
                lastTitle = title
                lastBody = body
                startForegroundCompat(createProgressNotification(this, title, body, 0, 0))
                refreshWakeLock()
            }
            ACTION_REFRESH -> {
                val title = intent.getStringExtra(EXTRA_TITLE)
                    ?: getString(R.string.extraction_in_progress_title)
                val body = intent.getStringExtra(EXTRA_BODY)
                    ?: getString(R.string.extraction_in_progress_body)
                lastTitle = title
                lastBody = body
                startForegroundCompat(
                    createProgressNotification(this, title, body, lastCurrent, lastTotal),
                )
                refreshWakeLock()
            }
            ACTION_PROGRESS -> {
                applyProgress(
                    intent.getIntExtra(EXTRA_CURRENT, 0),
                    intent.getIntExtra(EXTRA_TOTAL, 0),
                    intent.getStringExtra(EXTRA_TITLE),
                    intent.getStringExtra(EXTRA_BODY),
                )
            }
            ACTION_COMPLETE -> {
                running = null
                val title = intent.getStringExtra(EXTRA_TITLE) ?: "Extraction complete"
                val body = intent.getStringExtra(EXTRA_BODY) ?: "Done"
                val destination = intent.getStringExtra(EXTRA_DESTINATION).orEmpty()
                stopForegroundRemove()
                showCompletionNotification(title, body, destination)
                releaseWakeLock()
                stopSelf()
            }
            ACTION_STOP -> {
                running = null
                stopForegroundService()
                cancelProgressNotification(this)
            }
        }
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    /**
     * Recents swipe kills Dart/llama extraction. Drop the progress shade so it
     * does not claim work is still running. Leave the service up when a
     * WorkManager model transfer is active — that path must keep the FGS.
     */
    override fun onTaskRemoved(rootIntent: Intent?) {
        if (isModelTransferRunning()) {
            super.onTaskRemoved(rootIntent)
            return
        }
        running = null
        stopForegroundService()
        cancelProgressNotification(this)
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        if (running === this) {
            running = null
        }
        releaseWakeLock()
        stopForegroundRemove()
        cancelProgressNotification(this)
        super.onDestroy()
    }

    private fun isModelTransferRunning(): Boolean {
        return try {
            val wm = WorkManager.getInstance(this)
            uniqueWorkRunning(wm, ModelTransferWorker.UNIQUE_DOWNLOAD) ||
                uniqueWorkRunning(wm, ModelTransferWorker.UNIQUE_COPY)
        } catch (_: Exception) {
            false
        }
    }

    private fun uniqueWorkRunning(wm: WorkManager, name: String): Boolean {
        return try {
            wm.getWorkInfosForUniqueWork(name).get().any { !it.state.isFinished }
        } catch (_: Exception) {
            false
        }
    }

    private fun applyProgress(
        current: Int,
        total: Int,
        title: String? = null,
        body: String? = null,
    ) {
        lastCurrent = current
        lastTotal = total
        if (!title.isNullOrBlank()) {
            lastTitle = title
        }
        if (!body.isNullOrBlank()) {
            lastBody = body
        }
        val resolvedTitle = lastTitle.ifBlank { getString(R.string.extraction_in_progress_title) }
        val resolvedBody = lastBody.ifBlank { getString(R.string.extraction_in_progress_body) }
        startForegroundCompat(
            createProgressNotification(this, resolvedTitle, resolvedBody, current, total),
        )
        refreshWakeLock()
    }

    private fun startForegroundCompat(notification: Notification) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun showCompletionNotification(
        title: String,
        body: String,
        destination: String,
    ) {
        val notification = NotificationCompat.Builder(this, COMPLETION_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(
                launchPendingIntent(this, destination, COMPLETION_NOTIFICATION_ID),
            )
            .setOngoing(false)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .setCategory(NotificationCompat.CATEGORY_STATUS)
            .build()

        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(COMPLETION_NOTIFICATION_ID, notification)
    }

    private fun acquireWakeLock() {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "Quorivell::DataSyncWakeLock",
        ).apply {
            acquire(WAKE_LOCK_WINDOW_MS)
        }
    }

    private fun refreshWakeLock() {
        val held = wakeLock
        if (held == null || !held.isHeld) {
            acquireWakeLock()
            return
        }
        held.release()
        acquireWakeLock()
    }

    private fun releaseWakeLock() {
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
            }
        }
        wakeLock = null
    }

    private fun stopForegroundRemove() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
    }

    private fun stopForegroundService() {
        stopForegroundRemove()
        stopSelf()
    }
}
