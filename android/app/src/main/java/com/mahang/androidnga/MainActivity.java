package com.mahang.androidnga;

import android.os.Bundle;

import androidx.annotation.NonNull;

import com.mahang.androidnga.plugin.WebViewPlugin;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        WebViewPlugin.registerWith(flutterEngine);
    }
}
