import 'package:flutter/services.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:sprintf/sprintf.dart';

class HtmlBuilder {
  static String sHtmlTemplate;

  Future<String> build(String body) async {
    if (sHtmlTemplate == null) {
      sHtmlTemplate =
          await rootBundle.loadString('assets/template/content_template.html');
    }
    String html = sprintf(sHtmlTemplate, [18, body]);
    return html;
  }
}
