import 'html_builder.dart';
import 'html_decoder.dart';

class HtmlConvertFactory {
  static HtmlBuilder sHtmlBuilder = new HtmlBuilder();

  static HtmlDecoder sHtmlDecoder = new HtmlDecoder();

  static Future<String> convert2Html(String data) async {
    String body = sHtmlDecoder.decode(data);
    String html = await sHtmlBuilder.build(body);
    return html;
  }

  static Future<String> convertList2Html(List<String> dataList) async {
    StringBuffer buffer = new StringBuffer();

    dataList.forEach((data) {
      buffer.write(sHtmlDecoder.decode(data));
      buffer.write("</br></br>");
    });

    String html = await sHtmlBuilder.build(buffer.toString());
    return html;
  }
}
