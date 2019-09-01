import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

class HtmlBuilder {
  static String sHtmlTemplate;

  Future<String> build(String body) async {
    if (sHtmlTemplate == null) {
      sHtmlTemplate =
          await rootBundle.loadString('assets/template/content_template.html');
    }
    String html = sprintf(sHtmlTemplate, [19, body]);
    return html;
  }
}
