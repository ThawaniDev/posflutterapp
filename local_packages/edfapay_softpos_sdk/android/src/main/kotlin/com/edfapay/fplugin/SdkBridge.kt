package com.edfapay.fplugin

import android.os.Handler
import android.os.Looper
import androidx.fragment.app.FragmentActivity
import com.edfapay.paymentcard.bridge.EdfaPayHybridBridge
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Single Kotlin source for all Flutter ↔ Native channel communication.
 *
 *  Invoke channel   com.edfapay.invoke    Flutter → Native
 *  Callback channel com.edfapay.callback  Native  → Flutter
 *
 * Method names must exactly match the Dart EdfaPayPlugin method names.
 */
class SdkBridge(
    messenger: BinaryMessenger,
    private val activity: FragmentActivity,
) : MethodChannel.MethodCallHandler {

    private val sdk = EdfaPayHybridBridge(activity)
    private val invokeChannel = MethodChannel(messenger, "com.edfapay.invoke")
    private val callbackChannel= MethodChannel(messenger, "com.edfapay.callback")
    private val mainThread = Handler(Looper.getMainLooper())

    fun setup()    { invokeChannel.setMethodCallHandler(this) }
    fun teardown() { invokeChannel.setMethodCallHandler(null) }

    // ─────────────────────────────────────────────────────────────────────────
    // Flutter → Native dispatch
    // ─────────────────────────────────────────────────────────────────────────

    @Suppress("UNCHECKED_CAST")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val args = call.arguments as? Map<String, Any?> ?: emptyMap()
        android.util.Log.d("EdfaBridge", ">>> invoke: ${call.method}")
        try {
            val res = sdk.call(call.method, args, ::sendCallback)
            android.util.Log.d("EdfaBridge", ">>> invoke result for ${call.method}: $res (type=${res?.javaClass?.simpleName})")
            when (res) {
                is Unit -> result.success(true)
                else -> result.success(res)
            }
        } catch (e: Throwable) {
            android.util.Log.e("EdfaBridge", ">>> invoke ERROR for ${call.method}: ${e.message}\n${e.stackTraceToString()}")
            result.error(
                "SDK_ERROR",
                e.message,
                e.stackTraceToString()
            )
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Native → Flutter
    // ─────────────────────────────────────────────────────────────────────────

    fun sendCallback(name: String, arguments: Any?) {
        android.util.Log.d("EdfaBridge", ">>> sendCallback: $name")
        mainThread.post { callbackChannel.invokeMethod(name, arguments) }
    }
}
