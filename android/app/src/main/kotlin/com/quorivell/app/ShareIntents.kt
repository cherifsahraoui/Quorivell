package com.quorivell.app

import android.content.Intent

/**
 * Reads one ACTION_SEND or ACTION_PROCESS_TEXT plain-text payload.
 *
 * Marks the intent consumed so cold-start [onCreate] plus Flutter
 * [consumePendingShare] (or a configuration change) cannot persist the same
 * share twice. Does not log the text.
 */
object ShareIntents {
    const val EXTRA_CONSUMED = "com.quorivell.app.SHARE_CONSUMED"
    const val EXTRA_KIND = "com.quorivell.app.INCOMING_KIND"
    const val KIND_SHARE = "share"
    const val KIND_PROCESS_TEXT = "processText"

    private var nextId = 1

    fun take(intent: Intent?): Map<String, Any>? {
        if (intent == null) return null
        if (intent.getBooleanExtra(EXTRA_CONSUMED, false)) return null

        val kind: String
        val text = when {
            intent.getStringExtra(EXTRA_KIND) == KIND_PROCESS_TEXT ||
                intent.action == Intent.ACTION_PROCESS_TEXT -> {
                kind = KIND_PROCESS_TEXT
                intent.getCharSequenceExtra(Intent.EXTRA_PROCESS_TEXT)
                    ?.toString()
                    ?.trim()
            }
            intent.action == Intent.ACTION_SEND -> {
                kind = KIND_SHARE
                val mime = intent.type ?: return null
                if (mime != "text/plain" && !mime.startsWith("text/")) return null
                plainTextFrom(intent)?.trim()
            }
            else -> return null
        }
        if (text.isNullOrEmpty()) {
            intent.putExtra(EXTRA_CONSUMED, true)
            return null
        }

        intent.putExtra(EXTRA_CONSUMED, true)
        val id = nextId++
        return mapOf(
            "id" to id,
            "text" to text,
            "kind" to kind,
        )
    }

    private fun plainTextFrom(intent: Intent): String? {
        val extra = intent.getCharSequenceExtra(Intent.EXTRA_TEXT)?.toString()
            ?: intent.getStringExtra(Intent.EXTRA_TEXT)
        if (!extra.isNullOrBlank()) return extra
        val clip = intent.clipData ?: return null
        if (clip.itemCount < 1) return null
        return clip.getItemAt(0).text?.toString()
    }
}
