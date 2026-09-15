package com.example.glasswing_smoke

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "glasswing.smoke"
        ).setMethodCallHandler { call, result ->
            if (call.method == "writeLog") {
                val value = call.argument<String>("value") ?: ""
                Log.i("GlassWingSmoke", value)
                result.success(value.length)
            } else {
                result.notImplemented()
            }
        }
    }
}
