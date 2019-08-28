package io.flutter.plugins;

import java.io.UnsupportedEncodingException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class UtilsPlugin implements MethodChannel.MethodCallHandler {

    private static final String PLUGIN_NAME = "util_plugin";

    public static void registerWith(PluginRegistry registrar) {
        final MethodChannel channel = new MethodChannel(registrar.registrarFor(PLUGIN_NAME).messenger(), PLUGIN_NAME);
        channel.setMethodCallHandler(new UtilsPlugin());
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "toCharsetString":
                String data = methodCall.argument("data");
                String charset = methodCall.argument("charset");
                try {
                    result.success(new String(data.getBytes(), charset));
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                break;
            case "unicodeDecoding":
                result.success(ascii2native(methodCall.argument("data")));
                break;
            default:
                result.notImplemented();
                break;

        }
    }

    private String ascii2native(String asciicode) {
        if (asciicode == null) {
            return "";
        }
        String[] asciis = asciicode.split("\\\\u");
        StringBuilder nativeValueBuilder = new StringBuilder(asciis[0]);
        try {
            for (int i = 1; i < asciis.length; i++) {
                String code = asciis[i];
                nativeValueBuilder.append((char) Integer.parseInt(code.substring(0, 4), 16));
                if (code.length() > 4) {
                    nativeValueBuilder.append(code.substring(4));
                }
            }
        } catch (NumberFormatException e) {
            return asciicode;
        }
        return nativeValueBuilder.toString();
    }
}
