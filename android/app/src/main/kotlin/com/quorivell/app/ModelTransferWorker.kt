package com.quorivell.app

import android.content.Context
import android.content.pm.ServiceInfo
import android.os.Build
import androidx.work.CoroutineWorker
import androidx.work.ExistingWorkPolicy
import androidx.work.ForegroundInfo
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import androidx.work.workDataOf
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class ModelTransferWorker(
    context: Context,
    params: WorkerParameters,
) : CoroutineWorker(context, params) {
    override suspend fun getForegroundInfo(): ForegroundInfo {
        return ExtractionService.foregroundInfo(
            applicationContext,
            title(),
            body(),
        )
    }

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val title = title()
        val body = body()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            setForeground(
                ForegroundInfo(
                    ExtractionService.NOTIFICATION_ID,
                    ExtractionService.createProgressNotification(
                        applicationContext,
                        title,
                        body,
                    ),
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC,
                ),
            )
        } else {
            setForeground(getForegroundInfo())
        }
        ExtractionService.startExtraction(applicationContext, title, body)

        val mode = inputData.getString(KEY_MODE) ?: MODE_DOWNLOAD
        val destPath = inputData.getString(KEY_DEST_PATH) ?: return@withContext Result.failure()
        val existing = inputData.getLong(KEY_EXISTING, 0L)
        val knownTotal = inputData.getLong(KEY_TOTAL, -1L).let { if (it > 0) it else null }
        var lastProgressAt = 0L
        var lastProgressPercent = -1
        val speedTracker = TransferSpeedTracker()

        val onProgress = fun(received: Long, totalBytes: Long?) {
            if (totalBytes == null || totalBytes <= 0L) return
            val percent = if (received <= 0L) {
                0
            } else {
                ((received * 100L) / totalBytes).toInt().coerceIn(1, 100)
            }
            speedTracker.observe(received)
            val now = System.currentTimeMillis()
            if (percent != lastProgressPercent || now - lastProgressAt >= 400L) {
                lastProgressPercent = percent
                lastProgressAt = now
                val finishing = percent >= 100
                // Never post percent-only text. That races Flutter's stats line
                // and makes speed/ETA vanish for each +1% tick.
                val body = when {
                    finishing -> applicationContext.getString(
                        R.string.model_install_finalizing_body,
                    )
                    mode != MODE_DOWNLOAD -> null
                    else -> ModelInstallProgressText.body(
                        applicationContext,
                        percent,
                        speedTracker.bytesPerSecond,
                        speedTracker.remainingSeconds(received, totalBytes),
                    )
                }
                ExtractionService.updateProgress(
                    if (finishing) 0 else percent,
                    if (finishing) 0 else 100,
                    body = body,
                )
            }
        }

        val outcome = when (mode) {
            MODE_COPY -> {
                val uri = inputData.getString(KEY_URI) ?: return@withContext Result.failure()
                ModelTransfer.copyFromUri(
                    applicationContext,
                    uri,
                    destPath,
                    existing,
                    knownTotal,
                    onProgress,
                )
            }
            MODE_EXPORT -> {
                val uri = inputData.getString(KEY_URI) ?: return@withContext Result.failure()
                val sourcePath =
                    inputData.getString(KEY_SOURCE_PATH) ?: return@withContext Result.failure()
                ModelTransfer.copyToUri(
                    applicationContext,
                    sourcePath,
                    uri,
                    destPath,
                    onProgress,
                )
            }
            else -> {
                val url = inputData.getString(KEY_URL) ?: return@withContext Result.failure()
                ModelTransfer.downloadToPart(
                    url,
                    destPath,
                    existing,
                    knownTotal,
                    onProgress,
                )
            }
        }

        return@withContext when (outcome) {
            is TransferOutcome.Complete -> {
                ExtractionService.updateProgress(
                    0,
                    0,
                    body = applicationContext.getString(
                        R.string.model_install_finalizing_body,
                    ),
                )
                Result.success()
            }
            TransferOutcome.Cancelled -> Result.success()
            TransferOutcome.Failed -> Result.failure()
        }
    }

    private fun title(): String {
        return inputData.getString(KEY_TITLE)
            ?: applicationContext.getString(R.string.model_install_download_title)
    }

    private fun body(): String {
        return inputData.getString(KEY_BODY)
            ?: applicationContext.getString(R.string.model_install_download_body)
    }

    companion object {
        const val UNIQUE_DOWNLOAD = "com.quorivell.app.MODEL_DOWNLOAD"
        const val UNIQUE_COPY = "com.quorivell.app.MODEL_COPY"
        const val UNIQUE_EXPORT = "com.quorivell.app.MODEL_EXPORT"
        const val MODE_DOWNLOAD = "download"
        const val MODE_COPY = "copy"
        const val MODE_EXPORT = "export"
        const val KEY_MODE = "mode"
        const val KEY_URL = "url"
        const val KEY_URI = "uri"
        const val KEY_SOURCE_PATH = "sourcePath"
        const val KEY_DEST_PATH = "destPath"
        const val KEY_EXISTING = "existing"
        const val KEY_TOTAL = "total"
        const val KEY_TITLE = "title"
        const val KEY_BODY = "body"

        fun enqueueDownload(
            context: Context,
            url: String,
            destPath: String,
            existingBytes: Long,
            knownTotal: Long?,
            title: String,
            body: String,
        ) {
            enqueue(
                context,
                UNIQUE_DOWNLOAD,
                workDataOf(
                    KEY_MODE to MODE_DOWNLOAD,
                    KEY_URL to url,
                    KEY_DEST_PATH to destPath,
                    KEY_EXISTING to existingBytes,
                    KEY_TOTAL to (knownTotal ?: -1L),
                    KEY_TITLE to title,
                    KEY_BODY to body,
                ),
            )
        }

        fun enqueueCopy(
            context: Context,
            uri: String,
            destPath: String,
            existingBytes: Long,
            knownTotal: Long?,
            title: String,
            body: String,
        ) {
            enqueue(
                context,
                UNIQUE_COPY,
                workDataOf(
                    KEY_MODE to MODE_COPY,
                    KEY_URI to uri,
                    KEY_DEST_PATH to destPath,
                    KEY_EXISTING to existingBytes,
                    KEY_TOTAL to (knownTotal ?: -1L),
                    KEY_TITLE to title,
                    KEY_BODY to body,
                ),
            )
        }

        fun cancelDownload(context: Context, destPath: String) {
            ModelTransfer.requestCancel(destPath)
            WorkManager.getInstance(context).cancelUniqueWork(UNIQUE_DOWNLOAD)
        }

        fun cancelCopy(context: Context, destPath: String) {
            ModelTransfer.requestCancel(destPath)
            WorkManager.getInstance(context).cancelUniqueWork(UNIQUE_COPY)
        }

        fun enqueueExport(
            context: Context,
            sourcePath: String,
            uri: String,
            statusPath: String,
            title: String,
            body: String,
        ) {
            enqueue(
                context,
                UNIQUE_EXPORT,
                workDataOf(
                    KEY_MODE to MODE_EXPORT,
                    KEY_SOURCE_PATH to sourcePath,
                    KEY_URI to uri,
                    KEY_DEST_PATH to statusPath,
                    KEY_EXISTING to 0L,
                    KEY_TOTAL to -1L,
                    KEY_TITLE to title,
                    KEY_BODY to body,
                ),
            )
        }

        fun cancelExport(context: Context, statusPath: String) {
            ModelTransfer.requestCancel(statusPath)
            WorkManager.getInstance(context).cancelUniqueWork(UNIQUE_EXPORT)
        }

        private fun enqueue(
            context: Context,
            uniqueName: String,
            data: androidx.work.Data,
        ) {
            val request = OneTimeWorkRequestBuilder<ModelTransferWorker>()
                .setInputData(data)
                .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                .build()
            WorkManager.getInstance(context).enqueueUniqueWork(
                uniqueName,
                // Retry / switching catalog models must not keep a stale job.
                ExistingWorkPolicy.REPLACE,
                request,
            )
        }
    }
}
