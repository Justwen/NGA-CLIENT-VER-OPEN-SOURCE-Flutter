import 'package:nga_open_source/model/topic_content_model.dart';

import 'html_builder.dart';
import 'html_decoder.dart';

class HtmlConvertFactory {
  static HtmlBuilder sHtmlBuilder = new HtmlBuilder();

  static HtmlDecoder sHtmlDecoder = new HtmlDecoder();

  static Future<String> convert2Html(
      {String data, TopicContentEntity entity}) async {
    String html;
    if (data != null) {
      String body = sHtmlDecoder.decode(data);
      html = await sHtmlBuilder.build(body);
    } else {
      StringBuffer buffer = new StringBuffer();
      buffer.write("<div class='title'>${entity.subject}</div><br>");
      entity.contentList.forEach((data) {
        buffer.write(sHtmlDecoder.decode(data));
        buffer.write("</br></br><hr>");
      });
      html = await sHtmlBuilder.build(buffer.toString());
    }
    return html;
  }
}
