package com.edfapay.fplugin

import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger

/**
 * Flutter plugin entry point.
 * Thin glue — all channel logic lives in [SdkBridge].
 */
class FlutterEdfapayPlugin : FlutterPlugin, ActivityAware {

    private lateinit var messenger: BinaryMessenger
    private var bridge: SdkBridge? = null

    // ── FlutterPlugin ─────────────────────────────────────────────────────

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        messenger = binding.binaryMessenger
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        bridge?.teardown()
        bridge = null
    }

    // ── ActivityAware ─────────────────────────────────────────────────────

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val activity = binding.activity as? FragmentActivity
            ?: throw IllegalStateException(
                "Use FlutterFragmentActivity instead of FlutterActivity in your MainActivity"
            )
        bridge = SdkBridge(messenger, activity).also { it.setup() }
    }

    override fun onDetachedFromActivity() {
        bridge?.teardown()
        bridge = null
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)
}
