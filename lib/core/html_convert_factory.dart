import 'package:nga_open_source/model/topic_content_model.dart';

import 'html_builder.dart';
import 'html_decoder.dart';

class HtmlConvertFactory {
  static HtmlBuilder sHtmlBuilder = new HtmlBuilder();

  static HtmlDecoder sHtmlDecoder = new HtmlDecoder();

  static Future<String> convert2Html(
      {String data, TopicContentEntity entity}) async {
    await sHtmlBuilder.init();

    String html;
    if (data != null) {
      String body = sHtmlDecoder.decode(data);
      html = sHtmlBuilder.build(body);
    } else {
      StringBuffer buffer = new StringBuffer();

      if (entity.subject != null && entity.subject.isNotEmpty) {
        sHtmlBuilder.buildSubject(buffer, entity.subject);
      }
      entity.contentList.forEach((data) {
        sHtmlBuilder.buildBody(buffer, sHtmlDecoder.decode(data));
      });
      html = sHtmlBuilder.build(buffer.toString());
    }
    return html;
  }
}
