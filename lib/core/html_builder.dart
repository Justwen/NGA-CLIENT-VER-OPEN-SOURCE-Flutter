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

    sHtmlAuthorTemplate = "<table width='100%%'>"
        "<tr>"
        "  <td  width='48px   '><img style='float:left;width:48px;height:48px;border-radius:48px;' src='%s' /></td>"
        "  <td style='padding-left:8px'>"
        "  <span style='font-size:16px'>%s</span>"
        "  <span style='font-size:15px;color:#C4BEAE;float:right'>%s</span>"
        "  <br>"
        "  <span style='font-size:15px;color:#C4BEAE;'>%s</span>"
        "  <span style='font-size:15px;color:#C4BEAE;float:right'><img class=author_device src='%s'/>%s</span>"
        "  </td>"
        "</tr>"
        "</table>";
  }
}
