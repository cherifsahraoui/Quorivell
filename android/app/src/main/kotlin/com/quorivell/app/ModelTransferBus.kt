package com.quorivell.app

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

/** Forwards native transfer ticks to Flutter while the engine is alive. */
object ModelTransferBus {
    private val main = Handler(Looper.getMainLooper())

    @Volatile
    var sink: EventChannel.EventSink? = null

    fun emit(payload: Map<String, Any?>) {
        main.post {
            sink?.success(payload)
        }
    }
}
