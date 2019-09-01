import 'package:nga_open_source/core/emoticon_constants.dart';
import 'package:sprintf/sprintf.dart';

class HtmlDecoder {
  static List<HtmlDecoder> sHtmlDecoders = [
    new _BasicHtmlDecoder(),
    new _ImageHtmlDecoder(),
    new _EmoticonHtmlDecoder(),
  ];

  String decode(String data) {
    sHtmlDecoders.forEach((decoder) {
      data = decoder.decode(data);
    });
    return data;
  }
}

class _BasicHtmlDecoder implements HtmlDecoder {
  static const String REGEX_URL_WITH_HTTP = "\\[url\\]([^\\[|\\]]+)\\[/url\\]";

  static const String REPLACE_URL_WITH_HTTP = "<a href='%s'>%s</a>";

  @override
  String decode(String data) {
    RegExp(REGEX_URL_WITH_HTTP).allMatches(data).forEach((regExpMatch) {
      data = data.replaceAll(
        regExpMatch[0],
        sprintf(REPLACE_URL_WITH_HTTP, [regExpMatch[1], regExpMatch[1]]),
      );
    });

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

class _EmoticonHtmlDecoder implements HtmlDecoder {
  @override
  String decode(String data) {
    data = _decodeEmoticon(data, "pg", EmoticonConstants.UBB_CODE_PENGUIN,
        EmoticonConstants.UBB_IMAGE_PENGUIN);
    print(data);
    return data;
  }

  String _decodeEmoticon(String data, String emoticon, List<String> uddCodes,
      List<String> images) {
    RegExp("\\[s:$emoticon:(.*?)]").allMatches(data).forEach((regExpMatch) {
      String code = regExpMatch[1];
      String image;
      for (int i = 0; i < uddCodes.length; i++) {
        if (uddCodes[i] == code) {
          image = images[i];
          break;
        }
      }
      data = data.replaceAll(
        regExpMatch[0],
        sprintf("<img src='file:///asset/emoticon/$emoticon/%s'>", [image]),
      );
    });
    return data;
  }
}
