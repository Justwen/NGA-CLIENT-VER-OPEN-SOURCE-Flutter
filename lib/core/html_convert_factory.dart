import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:nga_open_source/utils/utils.dart';

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
      html = sHtmlBuilder.complete(body);
    } else {
      StringBuffer buffer = new StringBuffer();

      entity.contentList.forEach((contentEntity) {
        sHtmlBuilder.buildAuthor(buffer, contentEntity);
        if (!StringUtils.isEmpty(contentEntity.subject)) {
          sHtmlBuilder.buildSubject(buffer, contentEntity.subject);
        }
        sHtmlBuilder.buildBody(
            buffer, sHtmlDecoder.decode(contentEntity.content),
            isHidden: contentEntity.isHidden);
        sHtmlBuilder.buildComment(buffer, contentEntity);
      });

      html = sHtmlBuilder.complete(buffer.toString());
    }
    return html;
  }
}
