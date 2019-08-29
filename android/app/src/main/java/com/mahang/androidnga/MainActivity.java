package com.mahang.androidnga;

import android.os.Bundle;

import com.mahang.androidnga.plugin.UtilsPlugin;
import com.mahang.androidnga.plugin.WebViewPlugin;
import com.mahang.androidnga.plugin.core.CorePlugin;
import com.mahang.androidnga.utils.ContextUtils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ContextUtils.setContext(getApplicationContext());
        GeneratedPluginRegistrant.registerWith(this);
        WebViewPlugin.registerWith(this);
        UtilsPlugin.registerWith(this);
        CorePlugin.registerWith(this);
    }
}
