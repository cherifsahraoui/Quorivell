package com.quorivell.app

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import java.util.Locale

internal object BackgroundWorkConstraintsHelper {
    fun read(context: Context): Map<String, Boolean> {
        val activityManager =
            context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val powerManager =
            context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val aospRestricted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            activityManager.isBackgroundRestricted
        } else {
            false
        }
        val ignoring = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            powerManager.isIgnoringBatteryOptimizations(context.packageName)
        } else {
            true
        }
        // Xiaomi "No restrictions" / stock Unrestricted set the allowlist. Some
        // OEMs still report AOSP Restricted in that state.
        // isOemAggressiveBattery: MIUI/HyperOS "Battery saver (recommended)" is
        // not AOSP Restricted but still kills FGS / WorkManager.
        return mapOf(
            "isBackgroundRestricted" to aospRestricted,
            "isPowerSaveMode" to powerManager.isPowerSaveMode,
            "isIgnoringBatteryOptimizations" to ignoring,
            "isOemAggressiveBattery" to isMiuiFamily(),
        )
    }

    fun openSettings(context: Context) {
        val label = context.applicationInfo.loadLabel(context.packageManager).toString()
        if (isMiuiFamily() && tryStart(context, xiaomiBatterySaverIntent(context, label))) {
            return
        }
        val battery = Intent("android.settings.APP_BATTERY_SETTINGS").apply {
            data = Uri.fromParts("package", context.packageName, null)
        }
        if (tryStart(context, battery)) return
        val details = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.fromParts("package", context.packageName, null)
        }
        tryStart(context, details)
    }

    internal fun isMiuiFamily(
        manufacturer: String = Build.MANUFACTURER,
        brand: String = Build.BRAND,
        miuiVersion: String? = systemProperty("ro.miui.ui.version.name"),
        hyperOsVersion: String? = systemProperty("ro.mi.os.version.name"),
    ): Boolean {
        val maker = manufacturer.lowercase(Locale.US)
        val make = brand.lowercase(Locale.US)
        if (maker.contains("xiaomi") ||
            maker.contains("redmi") ||
            make.contains("xiaomi") ||
            make.contains("redmi") ||
            make.contains("poco") ||
            make.contains("blackshark")
        ) {
            return true
        }
        return !miuiVersion.isNullOrBlank() || !hyperOsVersion.isNullOrBlank()
    }

    private fun xiaomiBatterySaverIntent(context: Context, label: String): Intent {
        return Intent("miui.intent.action.HIDDEN_APPS_CONFIG_ACTIVITY").apply {
            setClassName(
                "com.miui.powerkeeper",
                "com.miui.powerkeeper.ui.HiddenAppsConfigActivity",
            )
            putExtra("package_name", context.packageName)
            putExtra("package_label", label)
        }
    }

    private fun tryStart(context: Context, intent: Intent): Boolean {
        return try {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun systemProperty(key: String): String? {
        return try {
            val clazz = Class.forName("android.os.SystemProperties")
            val get = clazz.getMethod("get", String::class.java)
            (get.invoke(null, key) as? String)?.takeIf { it.isNotBlank() }
        } catch (_: Exception) {
            null
        }
    }
}
