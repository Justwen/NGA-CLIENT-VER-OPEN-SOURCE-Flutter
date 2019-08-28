import 'package:flutter/services.dart';

class UtilsPlugin {
  static const MethodChannel CHANNEL = MethodChannel("util_plugin");

  Future<String> toCharsetString(String data, String charset) async {
    Map<String, dynamic> args = {"data": data, "charset": charset};
    String result = await CHANNEL.invokeMethod("toCharsetString", args);
    return result;
  }

  Future<String> unicodeDecoding(String data) async {
    Map<String, dynamic> args = {
      "data": data,
    };
    String result = await CHANNEL.invokeMethod("unicodeDecoding", args);
    return result;
  }
}
