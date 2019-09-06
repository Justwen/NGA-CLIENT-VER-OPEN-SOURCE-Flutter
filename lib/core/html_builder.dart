import 'package:flutter/services.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:sprintf/sprintf.dart';

class HtmlBuilder {
  static String sHtmlTemplate;

  static String sHtmlAuthorTemplate;

  String complete(String body) {
    String html = sprintf(sHtmlTemplate, [18, body]);
    return html;
  }

  StringBuffer buildSubject(StringBuffer buffer, String subject) {
    buffer.write("</br>");
    buffer.write("<div class='title'>$subject</div><br>");

    return buffer;
  }

  StringBuffer buildBody(StringBuffer buffer, String body) {
    buffer.write("</br>");
    buffer.write(body);
    buffer.write("</br></br><hr>");
    return buffer;
  }

  StringBuffer buildAuthor(StringBuffer buffer, TopicRowEntity entity) {
    buffer.write(sprintf(sHtmlAuthorTemplate, [
      entity.author.avatarUrl,
      entity.author.userName,
      entity.postDate,
      entity.author.userName,
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
  }
}
