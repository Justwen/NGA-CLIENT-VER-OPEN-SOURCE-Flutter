package io.flutter.plugins;

import android.webkit.CookieManager;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class WebViewPlugin implements MethodChannel.MethodCallHandler {

    private static final String PLUGIN_NAME = "webview_plugin";

    public static void registerWith(PluginRegistry registrar) {
        final MethodChannel channel = new MethodChannel(registrar.registrarFor(PLUGIN_NAME).messenger(), PLUGIN_NAME);
        channel.setMethodCallHandler(new WebViewPlugin());
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "getCookie":
                CookieManager cookieManager = CookieManager.getInstance();
                String cookie = cookieManager.getCookie(methodCall.argument("url"));
                result.success(cookie);
                break;
            default:
                result.notImplemented();
                break;

        }

    }
}
