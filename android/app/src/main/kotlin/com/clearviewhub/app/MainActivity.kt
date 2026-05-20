package com.clearviewhub.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.clearviewhub.app/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBlinkData" -> {
                    // Placeholder for BlinkEngine integration
                    result.success(mapOf("blinkCount" to 15, "perclos" to 0.05))
                }
                "updateFontScale" -> {
                    val scale = call.argument<Double>("scale")?.toFloat() ?: 1.0f
                    val success = SystemWriteChannel.updateFontScale(this, scale)
                    if (success) result.success(true) else result.error("UNAVAILABLE", "Cannot write settings", null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
