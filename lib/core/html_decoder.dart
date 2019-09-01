import 'package:sprintf/sprintf.dart';

class HtmlDecoder {
  static List<HtmlDecoder> sHtmlDecoders = [
    new _BasicHtmlDecoder(),
    new _ImageHtmlDecoder()
  ];

  String decode(String data) {
    sHtmlDecoders.forEach((decoder) {
      data = decoder.decode(data);
    });
    return data;
  }
}

class _BasicHtmlDecoder implements HtmlDecoder {
  @override
  String decode(String data) {
    // TODO: implement decode
    return data;
  }
}

class _ImageHtmlDecoder implements HtmlDecoder {
  static const String REGEX_IMG_WITH_HTTP =
      "\\[img]\\s*(http[^\\[|\\]]+)\\s*\\[/img]";

  static const String REPLACE_IMG_WITH_HTTP = "<a href='%s'><img src='%s'></a>";

  static const String REGEX_IMG_NO_HTTP =
      "\\[img]\\s*\\.(/[^\\[|\\]]+)\\s*\\[/img]";

  static const String REPLACE_IMG_NO_HTTP =
      "<a href='http://img.nga.178.com/attachments%s'><img src='http://img.nga.178.com/attachments%s'></a>";

  @override
  String decode(String data) {
    RegExp(REGEX_IMG_WITH_HTTP).allMatches(data).forEach((regExpMatch) {
      data = data.replaceAll(
        regExpMatch[0],
        sprintf(REPLACE_IMG_WITH_HTTP, [regExpMatch[1], regExpMatch[1]]),
      );
    });

    RegExp(REGEX_IMG_NO_HTTP).allMatches(data).forEach((regExpMatch) {
      data = data.replaceAll(
        regExpMatch[0],
        sprintf(REPLACE_IMG_NO_HTTP, [regExpMatch[1], regExpMatch[1]]),
      );
    });
    return data;
  }
}
