import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:nga_open_source/utils/utils.dart';
import 'package:sprintf/sprintf.dart';

class HtmlBuilder {
  static String sHtmlTemplate;

  static String sHtmlAuthorTemplate;

  static const String DEFAULT_AVATAR_URL =
      "https://img.nga.178.com/attachments/mon_201909/21/9bQ5-5i2kKyToS5b-5b.png.thumb_s.jpg";

  String complete(String body) {
    String html = sprintf(sHtmlTemplate, [18, body]);
    if (Platform.isIOS) {
      html = html.replaceAll("http:", "https:");
    }
    return html;
  }

  StringBuffer buildSubject(StringBuffer buffer, String subject) {
    buffer.write("</br>");
    buffer.write("<div class='title'>$subject</div>");

    return buffer;
  }

  StringBuffer buildBody(StringBuffer buffer, String body,
      {bool isHidden = false}) {
    buffer.write("</br>");
    if (isHidden) {
      buffer.write("<h5>隐藏</h5>");
    } else if (body != null && body != "null") {
      buffer.write(body);
    }

    if (body != null && body != "null") {
      buffer.write("</br></br><hr>");
    } else {
      buffer.write("<hr>");
    }
    return buffer;
  }

  StringBuffer buildAuthor(StringBuffer buffer, TopicRowEntity entity) {
    String avatarUrl = StringUtils.isEmpty(entity.author.avatarUrl) || entity.author.isAnonymous
        ? DEFAULT_AVATAR_URL
        : entity.author.avatarUrl;
    buffer.write(sprintf(sHtmlAuthorTemplate, [
      avatarUrl,
      entity.author.isAnonymous
          ? "${entity.author.userName}<span style='color:red'>(匿名)</span>"
          : entity.author.userName,
      entity.postDate,
      entity.author.toDescriptionString(),
      _getDeviceTypeImage(entity.deviceType),
      entity.floor
    ]));
    return buffer;
  }

  String _getDeviceTypeImage(int type) {
    return "";
  }

  Future init() async {
    if (sHtmlTemplate == null) {
      sHtmlTemplate =
          await rootBundle.loadString('assets/template/html_template.html');
      sHtmlAuthorTemplate = await rootBundle
          .loadString('assets/template/html_author_template.html');
    }

//    sHtmlAuthorTemplate =
//    "<table width='100%%'>"
//        "<tr>"
//        "  <td rowspan='2' width='48px   '><img style='float:left;width:48px;height:48px;border-radius:48px;' src='%s' /></td>"
//        "  <td>"
//        "  </td>"
//        "<td style='font-size:16px'>%s</td>"
//        " <td style='font-size:14px;color:#C4BEAE;text-align:right;'>%s</td>"
//        " </tr>"
//        "<tr>"
//        "<td style='font-size:15px;color:#C4BEAE;'>%s</td>"
//        "<td style='text-align:right;font-size:14px;color:#C4BEAE;'><img class=author_device src='%s'>%s</img></td>"
//        "</tr>"
//        "</table>";

//    sHtmlAuthorTemplate = "<table width='100%%'>"
//        "<tr>"
//        "  <td  width='48px   '><img style='float:left;width:48px;height:48px;border-radius:48px;' src='%s' /></td>"
//        "  <td style='padding-left:8px'>"
//        "  <span style='font-size:16px'>%s</span>"
//        "  <span style='font-size:15px;color:#C4BEAE;float:right'>%s</span>"
//        "  <br>"
//        "  <span style='font-size:15px;color:#C4BEAE;'>%s</span>"
//        "  <span style='font-size:15px;color:#C4BEAE;float:right'><img class=author_device src='%s'/>%s</span>"
//        "  </td>"
//        "</tr>"
//        "</table>";
  }
}
