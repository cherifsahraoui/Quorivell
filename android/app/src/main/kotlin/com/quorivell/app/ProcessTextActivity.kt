package com.quorivell.app

import android.app.Activity
import android.content.Intent
import android.os.Bundle

/**
 * Trampoline for [Intent.ACTION_PROCESS_TEXT] (the system text-selection menu).
 *
 * Forwards selected plain text into [MainActivity] as PROCESS_TEXT so chat
 * can summarize without using the share-to-capture path. Does not log the
 * text. Does not replace the selection in the source app.
 */
class ProcessTextActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            val text = intent.getCharSequenceExtra(Intent.EXTRA_PROCESS_TEXT)
                ?.toString()
                ?.trim()
            if (!text.isNullOrEmpty()) {
                startActivity(
                    Intent(this, MainActivity::class.java).apply {
                        action = Intent.ACTION_PROCESS_TEXT
                        type = "text/plain"
                        putExtra(Intent.EXTRA_PROCESS_TEXT, text)
                        putExtra(
                            ShareIntents.EXTRA_KIND,
                            ShareIntents.KIND_PROCESS_TEXT,
                        )
                        addFlags(
                            Intent.FLAG_ACTIVITY_SINGLE_TOP or
                                Intent.FLAG_ACTIVITY_CLEAR_TOP,
                        )
                    },
                )
            }
        } finally {
            finish()
        }
    }
}
