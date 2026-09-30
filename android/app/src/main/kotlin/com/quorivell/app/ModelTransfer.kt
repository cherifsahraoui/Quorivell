package com.quorivell.app

import android.content.Context
import android.net.Uri
import org.json.JSONObject
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL

/** HTTP Range download and SAF copy into the existing GGUF `.part` contract. */
object ModelTransfer {
    const val STATUS_RUNNING = "running"
    const val STATUS_COMPLETE = "complete"
    const val STATUS_FAILED = "failed"
    const val STATUS_CANCELLED = "cancelled"

    private const val BUFFER_SIZE = 64 * 1024
    private const val CONNECT_TIMEOUT_MS = 30_000
    private const val READ_TIMEOUT_MS = 60_000
    private const val STATUS_MIN_INTERVAL_MS = 250L
    private var lastStatusAt = 0L

    fun statusFileFor(partPath: String): File = File("$partPath.status")

    fun cancelFileFor(partPath: String): File = File("$partPath.cancel")

    fun requestCancel(partPath: String) {
        val file = cancelFileFor(partPath)
        file.parentFile?.mkdirs()
        file.writeText("1")
    }

    fun clearCancel(partPath: String) {
        cancelFileFor(partPath).delete()
    }

    fun isCancelRequested(partPath: String): Boolean = cancelFileFor(partPath).exists()

    fun writeStatus(
        partPath: String,
        state: String,
        received: Long = 0,
        total: Long? = null,
        error: String? = null,
    ) {
        val now = System.currentTimeMillis()
        if (state == STATUS_RUNNING && now - lastStatusAt < STATUS_MIN_INTERVAL_MS) {
            return
        }
        lastStatusAt = now
        val payload = JSONObject()
            .put("state", state)
            .put("received", received)
        if (total != null && total > 0) {
            payload.put("total", total)
        }
        if (error != null) {
            payload.put("error", error)
        }
        val file = statusFileFor(partPath)
        file.parentFile?.mkdirs()
        file.writeText(payload.toString())
        ModelTransferBus.emit(
            mapOf(
                "state" to state,
                "received" to received,
                "total" to (total ?: -1L),
                "path" to partPath,
                "error" to error,
            ),
        )
    }

    fun downloadToPart(
        url: String,
        partPath: String,
        existingBytes: Long,
        knownTotal: Long?,
        onProgress: (received: Long, total: Long?) -> Unit,
    ): TransferOutcome {
        val partFile = File(partPath)
        partFile.parentFile?.mkdirs()
        var received = existingBytes.coerceAtLeast(0)
        if (received > 0 && !partFile.exists()) {
            received = 0
        }
        var total = knownTotal
        clearCancel(partPath)
        writeStatus(partPath, STATUS_RUNNING, received, total)

        val connection = (URL(url).openConnection() as HttpURLConnection).apply {
            instanceFollowRedirects = true
            connectTimeout = CONNECT_TIMEOUT_MS
            readTimeout = READ_TIMEOUT_MS
            setRequestProperty("User-Agent", "Quorivell/0.1")
            if (received > 0) {
                setRequestProperty("Range", "bytes=$received-")
            }
        }

        try {
            connection.connect()
            if (isCancelRequested(partPath)) {
                writeStatus(partPath, STATUS_CANCELLED, received, total)
                return TransferOutcome.Cancelled
            }

            val code = connection.responseCode
            var append = false
            when (code) {
                HttpURLConnection.HTTP_PARTIAL -> {
                    append = received > 0
                    total = totalFromContentRange(connection.getHeaderField("Content-Range"))
                        ?: total
                    if (total == null) {
                        val remaining = connection.contentLengthLong
                        if (remaining > 0 && received > 0) {
                            total = received + remaining
                        }
                    }
                }
                in 200 until 300 -> {
                    if (received > 0) {
                        partFile.delete()
                        received = 0
                    }
                    val length = connection.contentLengthLong
                    if (length > 0) {
                        total = length
                    }
                }
                416 -> {
                    if (received > 0) {
                        writeStatus(partPath, STATUS_COMPLETE, received, total ?: received)
                        onProgress(received, total ?: received)
                        return TransferOutcome.Complete(received, total ?: received)
                    }
                    writeStatus(partPath, STATUS_FAILED, received, total, "download")
                    return TransferOutcome.Failed
                }
                else -> {
                    writeStatus(partPath, STATUS_FAILED, received, total, "download")
                    return TransferOutcome.Failed
                }
            }

            writeStatus(partPath, STATUS_RUNNING, received, total)
            onProgress(received, total)

            connection.inputStream.use { input ->
                FileOutputStream(partFile, append).use { output ->
                    val buffer = ByteArray(BUFFER_SIZE)
                    while (true) {
                        if (isCancelRequested(partPath)) {
                            writeStatus(partPath, STATUS_CANCELLED, received, total)
                            return TransferOutcome.Cancelled
                        }
                        val read = input.read(buffer)
                        if (read <= 0) break
                        output.write(buffer, 0, read)
                        received += read
                        output.flush()
                        writeStatus(partPath, STATUS_RUNNING, received, total)
                        onProgress(received, total)
                    }
                }
            }

            if (received <= 0) {
                writeStatus(partPath, STATUS_FAILED, received, total, "download")
                return TransferOutcome.Failed
            }
            if (total != null && total > 0 && received < total) {
                writeStatus(partPath, STATUS_FAILED, received, total, "download")
                return TransferOutcome.Failed
            }
            writeStatus(partPath, STATUS_COMPLETE, received, total ?: received)
            onProgress(received, total ?: received)
            return TransferOutcome.Complete(received, total ?: received)
        } catch (error: Exception) {
            if (isCancelRequested(partPath)) {
                writeStatus(partPath, STATUS_CANCELLED, received, total)
                return TransferOutcome.Cancelled
            }
            writeStatus(partPath, STATUS_FAILED, received, total, "download")
            return TransferOutcome.Failed
        } finally {
            connection.disconnect()
            clearCancel(partPath)
        }
    }

    /** Streams a local GGUF out to a SAF [uriString]; [statusPath] tracks cancel/progress. */
    fun copyToUri(
        context: Context,
        sourcePath: String,
        uriString: String,
        statusPath: String,
        onProgress: (received: Long, total: Long?) -> Unit,
    ): TransferOutcome {
        val source = File(sourcePath)
        if (!source.exists() || source.length() <= 0L) {
            writeStatus(statusPath, STATUS_FAILED, 0, null, "export")
            return TransferOutcome.Failed
        }
        val total = source.length()
        var received = 0L
        clearCancel(statusPath)
        writeStatus(statusPath, STATUS_RUNNING, received, total)
        onProgress(received, total)

        val uri = Uri.parse(uriString)
        val output = try {
            context.contentResolver.openOutputStream(uri, "wt")
        } catch (_: Exception) {
            null
        }
        if (output == null) {
            writeStatus(statusPath, STATUS_FAILED, received, total, "export")
            return TransferOutcome.Failed
        }

        try {
            source.inputStream().use { input ->
                output.use { stream ->
                    val buffer = ByteArray(BUFFER_SIZE)
                    while (true) {
                        if (isCancelRequested(statusPath)) {
                            writeStatus(statusPath, STATUS_CANCELLED, received, total)
                            return TransferOutcome.Cancelled
                        }
                        val read = input.read(buffer)
                        if (read <= 0) break
                        stream.write(buffer, 0, read)
                        received += read
                        stream.flush()
                        writeStatus(statusPath, STATUS_RUNNING, received, total)
                        onProgress(received, total)
                    }
                }
            }
            if (received <= 0 || received < total) {
                writeStatus(statusPath, STATUS_FAILED, received, total, "export")
                return TransferOutcome.Failed
            }
            writeStatus(statusPath, STATUS_COMPLETE, received, total)
            onProgress(received, total)
            return TransferOutcome.Complete(received, total)
        } catch (_: Exception) {
            if (isCancelRequested(statusPath)) {
                writeStatus(statusPath, STATUS_CANCELLED, received, total)
                return TransferOutcome.Cancelled
            }
            writeStatus(statusPath, STATUS_FAILED, received, total, "export")
            return TransferOutcome.Failed
        } finally {
            clearCancel(statusPath)
        }
    }

    fun copyFromUri(
        context: Context,
        uriString: String,
        destPath: String,
        existingBytes: Long,
        knownTotal: Long?,
        onProgress: (received: Long, total: Long?) -> Unit,
    ): TransferOutcome {
        val dest = File(destPath)
        dest.parentFile?.mkdirs()
        var received = existingBytes.coerceAtLeast(0)
        if (received > 0 && !dest.exists()) {
            received = 0
        }
        val uri = Uri.parse(uriString)
        var total = knownTotal
        if (total == null || total <= 0) {
            total = queryUriSize(context, uri)
        }
        clearCancel(destPath)
        writeStatus(destPath, STATUS_RUNNING, received, total)
        onProgress(received, total)

        val opener: () -> InputStream? = {
            try {
                context.contentResolver.openInputStream(uri)
            } catch (_: Exception) {
                null
            }
        }
        var input = opener()
        if (input == null) {
            writeStatus(destPath, STATUS_FAILED, received, total, "import")
            return TransferOutcome.Failed
        }

        try {
            if (received > 0) {
                var skipped = 0L
                while (skipped < received) {
                    val step = input.skip(received - skipped)
                    if (step <= 0) break
                    skipped += step
                }
                if (skipped < received) {
                    input.close()
                    dest.delete()
                    received = 0
                    writeStatus(destPath, STATUS_RUNNING, received, total)
                    input = opener()
                    if (input == null) {
                        writeStatus(destPath, STATUS_FAILED, received, total, "import")
                        return TransferOutcome.Failed
                    }
                }
            }

            input.use { stream ->
                FileOutputStream(dest, received > 0).use { output ->
                    val buffer = ByteArray(BUFFER_SIZE)
                    while (true) {
                        if (isCancelRequested(destPath)) {
                            writeStatus(destPath, STATUS_CANCELLED, received, total)
                            return TransferOutcome.Cancelled
                        }
                        val read = stream.read(buffer)
                        if (read <= 0) break
                        output.write(buffer, 0, read)
                        received += read
                        output.flush()
                        writeStatus(destPath, STATUS_RUNNING, received, total)
                        onProgress(received, total)
                    }
                }
            }

            if (received <= 0) {
                writeStatus(destPath, STATUS_FAILED, received, total, "import")
                return TransferOutcome.Failed
            }
            writeStatus(destPath, STATUS_COMPLETE, received, total ?: received)
            onProgress(received, total ?: received)
            return TransferOutcome.Complete(received, total ?: received)
        } catch (_: Exception) {
            if (isCancelRequested(destPath)) {
                writeStatus(destPath, STATUS_CANCELLED, received, total)
                return TransferOutcome.Cancelled
            }
            writeStatus(destPath, STATUS_FAILED, received, total, "import")
            return TransferOutcome.Failed
        } finally {
            clearCancel(destPath)
        }
    }

    fun takePersistableReadPermission(context: Context, uriString: String) {
        try {
            context.contentResolver.takePersistableUriPermission(
                Uri.parse(uriString),
                android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION,
            )
        } catch (_: SecurityException) {
            // Not persistable; copy can still run while the grant is valid.
        } catch (_: Exception) {
            // Ignore — resume after process death may then require a new pick.
        }
    }

    private fun queryUriSize(context: Context, uri: Uri): Long? {
        val cursor = context.contentResolver.query(uri, null, null, null, null)
        cursor?.use {
            val index = it.getColumnIndex(android.provider.OpenableColumns.SIZE)
            if (index >= 0 && it.moveToFirst() && !it.isNull(index)) {
                val size = it.getLong(index)
                if (size > 0) return size
            }
        }
        return null
    }

    private fun totalFromContentRange(header: String?): Long? {
        if (header.isNullOrBlank()) return null
        val slash = header.lastIndexOf('/')
        if (slash < 0 || slash == header.length - 1) return null
        return header.substring(slash + 1).toLongOrNull()
    }
}

sealed class TransferOutcome {
    data class Complete(val received: Long, val total: Long) : TransferOutcome()
    data object Cancelled : TransferOutcome()
    data object Failed : TransferOutcome()
}
