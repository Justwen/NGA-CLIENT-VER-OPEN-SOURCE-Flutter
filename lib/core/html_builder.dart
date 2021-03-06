import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nga_open_source/core/image_contants.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:nga_open_source/utils/utils.dart';
import 'package:sprintf/sprintf.dart';

import 'html_decoder.dart';

class HtmlBuilder {
  static String sHtmlTemplate;

  static String sHtmlAuthorTemplate;

  static String sHtmlCommentTemplate;

  static String sHtmlBottomTemplate;

  static HtmlDecoder sHtmlDecoder = new HtmlDecoder();

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
    return buffer;
  }

  StringBuffer buildComment(StringBuffer buffer, TopicRowEntity entity) {
    StringBuffer commentBuffer;
    entity.commentList?.forEach((comment) {
      commentBuffer ??= new StringBuffer(
          "<br/><br/>评论<hr/><br/>\n<table border='1'  class='comment'>");
      String author = comment.authorEntity.userName;
      String avatarUrl = comment.authorEntity.avatarUrl ?? DEFAULT_AVATAR_URL;
      String content = comment.content;
      int end = content.indexOf("[/b]");
      String time = '(' + comment.postDate + ')';
      content = content.substring(end + 4);
      content = sHtmlDecoder.decode(content);
      commentBuffer.write(
          "<tr><td class='comment'><img class='comment_circle' src='$avatarUrl' /><span style='font-weight:bold'> $author $time</span>$content</td></tr>");
    });

    if (commentBuffer != null) {
      commentBuffer.write("</table>");
      buffer.write(commentBuffer.toString());
    }

    return buffer;
  }

  StringBuffer buildAttachment(StringBuffer buffer, TopicRowEntity entity) {
    StringBuffer attachBuffer;
    String index = entity.floor.substring(1, entity.floor.length - 2);
    entity.attachList?.forEach((attach) {
      attachBuffer ??= new StringBuffer(
          "<br/><br/>附件<hr/><br/>\n<table border='1'  class='attach'><tr><td><button  id='attach_btn_$index' type='button' onclick='showAttachment($index)'>点击显示附件</button><div id='attach_$index' style='display:none'>");
      String url = attach.attachUrl;
      if (url.endsWith("mp4")) {
        attachBuffer.write("<video src='$url' controls='controls'></video>");
      } else if (url.endsWith("mp3")) {
        attachBuffer.write("<audio src='$url' controls='controls'></audio>");
      } else {
        attachBuffer.write("<a href='$url'><img class='attach' src='$url' />");
      }
    });
    if (attachBuffer != null) {
      attachBuffer.write("</div></td></tr></table>");
      buffer.write(attachBuffer.toString());
    }
    return buffer;
  }

  StringBuffer buildAuthor(StringBuffer buffer, TopicRowEntity entity) {
    String avatarUrl = StringUtils.isEmpty(entity.author.avatarUrl) ||
            entity.author.isAnonymous
        ? DEFAULT_AVATAR_URL
        : entity.author.avatarUrl;
    buffer.write(sprintf(sHtmlAuthorTemplate, [
      avatarUrl,
      entity.author.isAnonymous
          ? "${entity.author.userName}<span style='color:red'>(匿名)</span>"
          : entity.author.userName,
      entity.postDate,
      _getDeviceTypeImage(entity.deviceType),
      entity.deviceType == null ? "" : entity.deviceType[1],
      entity.floor,
      entity.author.toDescriptionString(),
    ]));
    return buffer;
  }

  StringBuffer buildBottomBar(StringBuffer buffer, TopicRowEntity entity) {
    buffer.write(sHtmlBottomTemplate);
    return buffer;
  }

  String _getDeviceTypeImage(List<dynamic> typeInfo) {
    int type = typeInfo == null ? 0 : typeInfo[0];
    switch (type) {
      case 7:
        return Base64ImageConstants.DEVICE_TYPE_IOS;
        break;
      case 8:
        return Base64ImageConstants.DEVICE_TYPE_ANDROID;
        break;
      case 9:
        return Base64ImageConstants.DEVICE_TYPE_WINDOWS_PHONE;
      case 100:
        break;
      case 101:
        break;
      case 103:
        break;
    }
    return "";
  }

  Future init() async {
    sHtmlTemplate ??=
        await rootBundle.loadString('assets/template/html_template.html');
    sHtmlAuthorTemplate ??= await rootBundle
        .loadString('assets/template/html_author_template.html');
    sHtmlBottomTemplate ??= await rootBundle
        .loadString('assets/template/html_template_bottom.html');
  }
}
