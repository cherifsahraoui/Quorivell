package com.quorivell.app

import android.Manifest
import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val DEVICE_CHANNEL = "com.quorivell.app/device"
    private val EXTRACTION_CHANNEL = "com.quorivell.app/extraction"
    private val PERMISSION_CHANNEL = "com.quorivell.app/permission"
    private val TRANSFER_CHANNEL = "com.quorivell.app/model_transfer"
    private val TRANSFER_EVENTS = "com.quorivell.app/model_transfer_events"
    private val SHARE_CHANNEL = "com.quorivell.app/share"
    private val ENGINE_ID = "com.quorivell.app.flutter_engine"
    private val PERMISSION_REQUEST_CODE = 1001
    private val PICK_GGUF_REQUEST_CODE = 1002
    private val CREATE_GGUF_REQUEST_CODE = 1003
    private val PERMISSION_PREFS = "permission_prefs"
    private val OS_PROMPT_COMPLETED_KEY = "notification_os_prompt_completed"
    /** Legacy flag set *before* the OS sheet; poisoned permanentlyDenied. */
    private val LEGACY_REQUESTED_KEY = "notification_requested"

    private var permissionResult: MethodChannel.Result? = null
    private var pickGgufResult: MethodChannel.Result? = null
    private var createGgufResult: MethodChannel.Result? = null
    private var extractionChannel: MethodChannel? = null
    private var shareChannel: MethodChannel? = null
    private var pendingDestination: String? = null
    private var pendingShare: Map<String, Any>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val reusedEngine =
            FlutterEngineCache.getInstance().get(ENGINE_ID) === flutterEngine
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DEVICE_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceCapability" -> {
                    val capability = getDeviceCapability()
                    result.success(capability)
                }
                "getBackgroundWorkConstraints" -> {
                    result.success(getBackgroundWorkConstraints())
                }
                "openBackgroundWorkSettings" -> {
                    openBackgroundWorkSettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        extractionChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EXTRACTION_CHANNEL
        )
        extractionChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "startForegroundService" -> {
                    val title = call.argument<String>("title")
                        .orFallback(getString(R.string.extraction_in_progress_title))
                    val body = call.argument<String>("body")
                        .orFallback(getString(R.string.extraction_in_progress_body))
                    val destination = call.argument<String>("destination") ?: ""
                    ExtractionService.startExtraction(this, title, body, destination)
                    result.success(null)
                }
                "updateForegroundServiceProgress" -> {
                    val current = call.argument<Int>("current") ?: 0
                    val total = call.argument<Int>("total") ?: 0
                    val title = call.argument<String>("title")
                    val body = call.argument<String>("body")
                    ExtractionService.updateProgress(current, total, title, body)
                    result.success(null)
                }
                "stopForegroundService" -> {
                    ExtractionService.stopExtraction(this)
                    result.success(null)
                }
                "showCompletionNotification" -> {
                    val title = call.argument<String>("title") ?: "Extraction complete"
                    val body = call.argument<String>("body") ?: "Done"
                    val destination = call.argument<String>("destination") ?: ""
                    ExtractionService.completeExtraction(this, title, body, destination)
                    result.success(null)
                }
                "updateForegroundService" -> {
                    val title = call.argument<String>("title")
                        .orFallback(getString(R.string.extraction_in_progress_title))
                    val body = call.argument<String>("body")
                        .orFallback(getString(R.string.extraction_in_progress_body))
                    ExtractionService.refreshKeepAlive(this, title, body)
                    result.success(null)
                }
                "consumeLaunchDestination" -> {
                    val dest = pendingDestination ?: ExtractionService.destinationFrom(intent)
                    pendingDestination = null
                    intent?.removeExtra(ExtractionService.EXTRA_DESTINATION)
                    result.success(dest)
                }
                "isForegroundServiceRunning" -> {
                    result.success(ExtractionService.isRunning())
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            TRANSFER_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "startDownload" -> {
                    val url = call.argument<String>("url")
                    val destPath = call.argument<String>("destPath")
                    if (url.isNullOrBlank() || destPath.isNullOrBlank()) {
                        result.error("invalid", "url and destPath are required", null)
                        return@setMethodCallHandler
                    }
                    val existing = (call.argument<Number>("existingBytes") ?: 0).toLong()
                    val total = call.argument<Number>("totalBytes")?.toLong()
                    val title = call.argument<String>("title")
                        .orFallback(getString(R.string.model_install_download_title))
                    val body = call.argument<String>("body")
                        .orFallback(getString(R.string.model_install_download_body))
                    ExtractionService.startExtraction(this, title, body)
                    ModelTransferWorker.enqueueDownload(
                        this,
                        url,
                        destPath,
                        existing,
                        total,
                        title,
                        body,
                    )
                    result.success(null)
                }
                "startCopy" -> {
                    val uri = call.argument<String>("uri")
                    val destPath = call.argument<String>("destPath")
                    if (uri.isNullOrBlank() || destPath.isNullOrBlank()) {
                        result.error("invalid", "uri and destPath are required", null)
                        return@setMethodCallHandler
                    }
                    val existing = (call.argument<Number>("existingBytes") ?: 0).toLong()
                    val total = call.argument<Number>("totalBytes")?.toLong()
                    val title = call.argument<String>("title")
                        .orFallback(getString(R.string.model_install_copy_title))
                    val body = call.argument<String>("body")
                        .orFallback(getString(R.string.model_install_copy_body))
                    ModelTransfer.takePersistableReadPermission(this, uri)
                    ExtractionService.startExtraction(this, title, body)
                    ModelTransferWorker.enqueueCopy(
                        this,
                        uri,
                        destPath,
                        existing,
                        total,
                        title,
                        body,
                    )
                    result.success(null)
                }
                "cancelDownload" -> {
                    val destPath = call.argument<String>("destPath") ?: ""
                    ModelTransferWorker.cancelDownload(this, destPath)
                    result.success(null)
                }
                "cancelCopy" -> {
                    val destPath = call.argument<String>("destPath") ?: ""
                    ModelTransferWorker.cancelCopy(this, destPath)
                    result.success(null)
                }
                "pickGguf" -> {
                    pickGguf(result)
                }
                "createGgufDocument" -> {
                    val suggestedName =
                        call.argument<String>("suggestedName") ?: "model.gguf"
                    createGgufDocument(suggestedName, result)
                }
                "startExport" -> {
                    val sourcePath = call.argument<String>("sourcePath") ?: ""
                    val uri = call.argument<String>("uri") ?: ""
                    val statusPath = call.argument<String>("statusPath") ?: ""
                    val title = call.argument<String>("title") ?: ""
                    val body = call.argument<String>("body") ?: ""
                    if (sourcePath.isEmpty() || uri.isEmpty() || statusPath.isEmpty()) {
                        result.error("bad_args", "Missing export paths", null)
                    } else {
                        ModelTransferWorker.enqueueExport(
                            this,
                            sourcePath,
                            uri,
                            statusPath,
                            title,
                            body,
                        )
                        result.success(null)
                    }
                }
                "cancelExport" -> {
                    val statusPath = call.argument<String>("statusPath") ?: ""
                    ModelTransferWorker.cancelExport(this, statusPath)
                    result.success(null)
                }
                "isTransferRunning" -> {
                    result.success(isModelTransferRunning())
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            TRANSFER_EVENTS
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                ModelTransferBus.sink = events
            }

            override fun onCancel(arguments: Any?) {
                ModelTransferBus.sink = null
            }
        })

        shareChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SHARE_CHANNEL
        )
        shareChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "consumePendingShare" -> {
                    val share = pendingShare ?: ShareIntents.take(intent)
                    pendingShare = null
                    result.success(share)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PERMISSION_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkNotificationPermission" -> {
                    val status = checkNotificationPermission()
                    result.success(status)
                }
                "requestNotificationPermission" -> {
                    requestNotificationPermission(result)
                }
                "openAppSettings" -> {
                    openAppSettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        if (reusedEngine) {
            deliverPendingShare()
            deliverPendingLaunchDestination()
        }
    }

    override fun getCachedEngineId(): String? {
        return if (FlutterEngineCache.getInstance().get(ENGINE_ID) != null) {
            ENGINE_ID
        } else {
            null
        }
    }

    override fun shouldDestroyEngineWithHost(): Boolean {
        if (ExtractionService.isRunning()) {
            return false
        }
        FlutterEngineCache.getInstance().remove(ENGINE_ID)
        return true
    }

    private fun deliverPendingLaunchDestination() {
        val dest = pendingDestination ?: ExtractionService.destinationFrom(intent)
        if (dest.isNullOrBlank()) return
        pendingDestination = null
        intent?.removeExtra(ExtractionService.EXTRA_DESTINATION)
        extractionChannel?.invokeMethod("onLaunchDestination", dest)
    }

    private fun deliverPendingShare() {
        val share = pendingShare ?: ShareIntents.take(intent)
        if (share == null) return
        pendingShare = null
        shareChannel?.invokeMethod("onSharedText", share)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (pendingShare == null) {
            pendingShare = ShareIntents.take(intent)
        }
        if (pendingDestination == null) {
            pendingDestination = ExtractionService.destinationFrom(intent)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val share = ShareIntents.take(intent)
        if (share != null) {
            pendingShare = share
            shareChannel?.invokeMethod("onSharedText", share)
            return
        }
        val dest = ExtractionService.destinationFrom(intent)
        if (dest != null) {
            pendingDestination = dest
            extractionChannel?.invokeMethod("onLaunchDestination", dest)
        }
    }

    private fun permissionPrefs(): SharedPreferences {
        val prefs = getSharedPreferences(PERMISSION_PREFS, Context.MODE_PRIVATE)
        // Drop the legacy pre-prompt flag so a swallowed first request can be
        // retried instead of being stuck as permanentlyDenied.
        if (prefs.contains(LEGACY_REQUESTED_KEY)) {
            prefs.edit().remove(LEGACY_REQUESTED_KEY).apply()
        }
        return prefs
    }

    private fun markOsPromptCompleted() {
        permissionPrefs().edit().putBoolean(OS_PROMPT_COMPLETED_KEY, true).apply()
    }

    private fun checkNotificationPermission(): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return when {
                ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) == PackageManager.PERMISSION_GRANTED -> "granted"
                ActivityCompat.shouldShowRequestPermissionRationale(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) -> "denied"
                else -> {
                    if (permissionPrefs().getBoolean(OS_PROMPT_COMPLETED_KEY, false)) {
                        "permanentlyDenied"
                    } else {
                        "denied"
                    }
                }
            }
        }
        return "granted"
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success("granted")
            return
        }

        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            result.success("granted")
            return
        }

        // Some OEMs skip the OS sheet unless a channel already exists.
        ExtractionService.createNotificationChannels(this)

        if (permissionResult != null) {
            result.error("busy", "Notification permission request already in flight", null)
            return
        }

        permissionResult = result
        // Launch after this MethodChannel turn so the Flutter dialog is gone.
        window.decorView.post {
            if (isDestroyed || isFinishing) {
                val pending = permissionResult
                permissionResult = null
                pending?.success(checkNotificationPermission())
                return@post
            }
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                PERMISSION_REQUEST_CODE,
            )
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != PERMISSION_REQUEST_CODE) return
        markOsPromptCompleted()
        val pending = permissionResult
        permissionResult = null
        pending?.success(checkNotificationPermission())
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.fromParts("package", packageName, null)
        }
        startActivity(intent)
    }

    private fun openBackgroundWorkSettings() {
        BackgroundWorkConstraintsHelper.openSettings(this)
    }

    private fun getBackgroundWorkConstraints(): Map<String, Boolean> {
        return BackgroundWorkConstraintsHelper.read(this)
    }

    private fun pickGguf(result: MethodChannel.Result) {
        pickGgufResult?.error("cancelled", "Replaced by a new picker request", null)
        pickGgufResult = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("application/octet-stream", "*/*"))
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
        }
        startActivityForResult(intent, PICK_GGUF_REQUEST_CODE)
    }

    private fun createGgufDocument(suggestedName: String, result: MethodChannel.Result) {
        createGgufResult?.error("cancelled", "Replaced by a new save request", null)
        createGgufResult = result
        val name = if (suggestedName.lowercase().endsWith(".gguf")) {
            suggestedName
        } else {
            "$suggestedName.gguf"
        }
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "application/octet-stream"
            putExtra(Intent.EXTRA_TITLE, name)
            addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        startActivityForResult(intent, CREATE_GGUF_REQUEST_CODE)
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            PICK_GGUF_REQUEST_CODE -> handlePickGgufResult(resultCode, data)
            CREATE_GGUF_REQUEST_CODE -> handleCreateGgufResult(resultCode, data)
        }
    }

    private fun handlePickGgufResult(resultCode: Int, data: Intent?) {
        val pending = pickGgufResult
        pickGgufResult = null
        if (pending == null) return
        if (resultCode != RESULT_OK || data?.data == null) {
            pending.success(null)
            return
        }
        val uri = data.data!!
        val takeFlags = data.flags and
            (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
        try {
            contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION,
            )
        } catch (_: Exception) {
            if (takeFlags and Intent.FLAG_GRANT_READ_URI_PERMISSION != 0) {
                try {
                    contentResolver.takePersistableUriPermission(
                        uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION,
                    )
                } catch (_: Exception) {
                    // Copy can still proceed with the temporary grant.
                }
            }
        }
        var displayName = uri.lastPathSegment ?: "model.gguf"
        var size = -1L
        contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            val nameIndex = cursor.getColumnIndex(android.provider.OpenableColumns.DISPLAY_NAME)
            val sizeIndex = cursor.getColumnIndex(android.provider.OpenableColumns.SIZE)
            if (cursor.moveToFirst()) {
                if (nameIndex >= 0 && !cursor.isNull(nameIndex)) {
                    displayName = cursor.getString(nameIndex)
                }
                if (sizeIndex >= 0 && !cursor.isNull(sizeIndex)) {
                    size = cursor.getLong(sizeIndex)
                }
            }
        }
        pending.success(
            mapOf(
                "uri" to uri.toString(),
                "displayName" to displayName,
                "size" to size,
            ),
        )
    }

    private fun handleCreateGgufResult(resultCode: Int, data: Intent?) {
        val pending = createGgufResult
        createGgufResult = null
        if (pending == null) return
        if (resultCode != RESULT_OK || data?.data == null) {
            pending.success(null)
            return
        }
        val uri = data.data!!
        try {
            contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION,
            )
        } catch (_: Exception) {
            // Temporary grant from CREATE_DOCUMENT is enough for the copy.
        }
        pending.success(uri.toString())
    }

    private fun getDeviceCapability(): Map<String, Any> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)

        val totalRam = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            memoryInfo.totalMem
        } else {
            // Fallback for older Android versions
            4L * 1024 * 1024 * 1024 // 4GB fallback
        }

        val availableRam = memoryInfo.availMem

        val abi = Build.SUPPORTED_ABIS.firstOrNull() ?: "unknown"

        return mapOf(
            "totalRamBytes" to totalRam,
            "availableRamBytes" to availableRam,
            "processorAbi" to abi
        )
    }

    private fun isModelTransferRunning(): Boolean {
        return try {
            val wm = WorkManager.getInstance(this)
            uniqueWorkRunning(wm, ModelTransferWorker.UNIQUE_DOWNLOAD) ||
                uniqueWorkRunning(wm, ModelTransferWorker.UNIQUE_COPY) ||
                uniqueWorkRunning(wm, ModelTransferWorker.UNIQUE_EXPORT)
        } catch (_: Exception) {
            false
        }
    }

    private fun uniqueWorkRunning(
        wm: WorkManager,
        name: String,
    ): Boolean {
        return try {
            wm.getWorkInfosForUniqueWork(name).get().any { !it.state.isFinished }
        } catch (_: Exception) {
            false
        }
    }
}

private fun String?.orFallback(fallback: String): String {
    return if (this.isNullOrBlank()) fallback else this
}
