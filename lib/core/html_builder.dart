import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

class HtmlBuilder {
  static String sHtmlTemplate;

  String build(String body) {
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

  Future init() async {
    if (sHtmlTemplate == null) {
      sHtmlTemplate =
          await rootBundle.loadString('assets/template/html_template.html');
    }
  }
}
