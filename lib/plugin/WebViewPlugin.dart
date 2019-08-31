import 'package:flutter/services.dart';

class WebViewPlugin {
  static const MethodChannel CHANNEL = MethodChannel("webview_plugin");

  Future<String> getCookie(String url) async {
    Map<String, dynamic> args = {
      "url": url,
    };
    String cookie = await CHANNEL.invokeMethod("getCookie", args);
    return cookie;
  }

  Future<List<String>> convertHtml(List<String> data) async {
    List<String> htmls = await CHANNEL.invokeMethod("convertHtml", data);
    return htmls;
  }

}
