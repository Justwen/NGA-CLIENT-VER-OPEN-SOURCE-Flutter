package com.mahang.androidnga;

import android.os.Bundle;

import com.mahang.androidnga.plugin.WebViewPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        WebViewPlugin.registerWith(this);
    }
}
