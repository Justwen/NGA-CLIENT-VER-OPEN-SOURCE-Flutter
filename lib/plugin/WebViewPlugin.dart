import 'package:flutter/services.dart';

class WebViewPlugin {
  static const MethodChannel CHANNEL = MethodChannel("webview_plugin");

  Future<String> getCookie(String url) async {
    print(url);
    Map<String, dynamic> args = {
      "url": url,
    };
    String cookie = await CHANNEL.invokeMethod("getCookie", args);
    return cookie;
  }
}
