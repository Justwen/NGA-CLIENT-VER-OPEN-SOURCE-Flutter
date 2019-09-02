import 'dart:core';

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

  static const Map<String, String> BASIC_REGEX_MAP = {
    "\\[h](.+?)\\[/h]": "<b>%s</b>",
    "\\[b](.+?)\\[/b]": "<b>%s</b>",
    "\\[i](.+?)\\[/i]": "<i style='font-style:italic'>%s</i>",
    "\\[list](.+?)\\[/list]": "<li>%s</li>",
    "\\[del](.+?)\\[/del]": "<del>%s</del>",
    "\\[u](.+?)\\[/u]":"<u>%s</u>",
    "\\[item](.+?)\\[/item]":"<item>%s</item>",
    "\\[table](.*?)\\[/table]":"<div><table cellspacing='0px'><tbody>%s</tbody></table></div>",
    "\\[tr](.*?)\\[/tr]":"<tr>%s</tr>",
    "\\[l](.*?)\\[/l]":"<div style='float:left' >%s</div>",
    "\\[r](.*?)\\[/r]":"<div style='float:right' >%s</div>",
    "\\[flash=video](.*?)\\[/flash]":"<video src='http://img.ngacn.cc/attachments%s' controls='controls'></video>",
    "\\[flash=audio](.*?)\\[/flash]":"<audio src='http://img.ngacn.cc/attachments%s&filename=nga_audio.mp3' controls='controls'></audio>",
  };

  static const Map<String, String> BASIC_REPLACE_MAP = {
    "[align=right]": "<div style='text-align:right' >",
    "[align=left]": "<div style='text-align:left' >",
    "[align=center]": "<div style='text-align:right' >",
    "[/align]": "</div>",
    "&amp;":"&",
  };

  @override
  String decode(String data) {
    RegExp(REGEX_URL_WITH_HTTP).allMatches(data).forEach((regExpMatch) {
      data = data.replaceAll(
        regExpMatch[0],
        sprintf(REPLACE_URL_WITH_HTTP, [regExpMatch[1], regExpMatch[1]]),
      );
    });

    BASIC_REPLACE_MAP.forEach((key, replace) {
      data = data.replaceAll(key, replace);
    });

    BASIC_REGEX_MAP.forEach((key, value) {
      RegExp(key).allMatches(data).forEach((regExpMatch) {
        data = data.replaceAll(
          regExpMatch[0],
          sprintf(value, [regExpMatch[1]]),
        );
      });
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
        sprintf(
            "<img src='file:///android_asset/flutter_assets/assets/emoticon/$emoticon/%s'>",
            [image]),
      );
    });
    return data;
  }
}
