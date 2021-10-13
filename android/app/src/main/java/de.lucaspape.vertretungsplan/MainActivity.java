package de.lucaspape.vertretungsplan;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import android.os.Build;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "de.lucaspape.vertretungsplan/native";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("disableSSLCertificateChecking")) {
                        boolean sslResult = disableSSLCertificateChecking();
                        result.success(sslResult);
                    }
                });
    }

    private static boolean disableSSLCertificateChecking() {
        return Build.VERSION.SDK_INT <= 19;
    }
}
