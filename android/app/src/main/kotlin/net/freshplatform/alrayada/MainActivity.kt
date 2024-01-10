package net.freshplatform.alrayada

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "App"
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "setWindowPrivate" -> {
                    val secureWindow = call.arguments as Boolean?
                    if (secureWindow == null) {
                        result.error("NULL", "Secure argument is null", null)
                        return@setMethodCallHandler
                    }
                    if (secureWindow) {
                        window.setFlags(
                            WindowManager.LayoutParams.FLAG_SECURE,
                            WindowManager.LayoutParams.FLAG_SECURE
                        )
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }


                else -> result.notImplemented()
            }
        }
    }
}
