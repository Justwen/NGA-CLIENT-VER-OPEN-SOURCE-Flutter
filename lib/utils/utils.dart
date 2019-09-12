import 'package:nga_open_source/plugin/StringPlugins.dart';

class StringUtils {

  static bool isEmpty(String data) => data == null || data == "";

  static Future<String> uriEncode(String data, String charset) async {
    return await UtilsPlugin.uriEncode(data, charset);
  }
}