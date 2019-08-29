package com.mahang.androidnga.plugin.core;

import com.mahang.androidnga.plugin.core.convert.builder.HtmlBuilder;
import com.mahang.androidnga.plugin.core.convert.decoder.ForumDecoder;

import java.util.ArrayList;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class CorePlugin implements MethodChannel.MethodCallHandler {

    private static final String PLUGIN_NAME = "cor_plugin";

    public static void registerWith(PluginRegistry registrar) {
        final MethodChannel channel = new MethodChannel(registrar.registrarFor(PLUGIN_NAME).messenger(), PLUGIN_NAME);
        channel.setMethodCallHandler(new CorePlugin());
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "convertTopicContent":
                String data = methodCall.argument("data");
                boolean isNightMode = methodCall.argument("night");

                String ngaHtml = new ForumDecoder(true).decode(data, new ArrayList<>());
                ngaHtml = HtmlBuilder.build(ngaHtml, isNightMode, null);
                result.success(ngaHtml);
                break;
            default:
                result.notImplemented();

                break;

        }
    }
}
