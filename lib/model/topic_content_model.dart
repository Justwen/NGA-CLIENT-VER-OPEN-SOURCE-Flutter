import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nga_open_source/core/html_convert_factory.dart';
import 'package:nga_open_source/model/bean/entity_factory.dart';
import 'package:nga_open_source/model/user_model.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:nga_open_source/plugin/WebViewPlugin.dart';
import 'package:path_provider/path_provider.dart';

import 'bean/topic_content_bean_entity.dart';

class TopicContentModel {
  Dio dio = new Dio();

  WebViewPlugin webViewPlugin = new WebViewPlugin();

  void loadContent(int tid, int page, Function callback) async {
    //tid = 18335755;
    String url = _buildUrl();
    print(url + "&page=1&tid=$tid");
    Options options = new Options();
    options.headers = _buildHeader();
    options.responseType = ResponseType.bytes;
    try {
      Response response = await dio.get(url,
          options: options, queryParameters: _buildParam(tid, page));

      String result = _correct(gbk.decode(response.data));

      TopicContentBeanEntity bean = EntityFactory.generateOBJ<TopicContentBeanEntity>(jsonDecode(result));

      TopicContentEntity entity = new TopicContentEntity();

      bean.data.tR.listData.forEach((dataBean) async {
        entity.contentList.add(dataBean.content);
      });

      entity.subject = bean.data.tR.listData[0].subject;

      entity.content = await HtmlConvertFactory.convert2Html(entity: entity);
      callback(entity);

    } catch (e,s) {
      print(e);
      print(s);
    }
  }

  void printLog(String log) async {
      Directory tempDir = await getTemporaryDirectory();
      var file = File('${tempDir.path}/counter.txt');
      file.writeAsString(log);
  }

  String _correct(String data) {
    // 处理全角空格
    // 处理空字符
    return data.replaceAll("	", " ").replaceAll(String.fromCharCode(0), " ");
  }

  String _buildUrl() {
    StringBuffer buffer = new StringBuffer();
    buffer.write("https://bbs.nga.cn/read.php?");
    return buffer.toString();
  }

  Map<String, dynamic> _buildParam(int tid, int page) {
    Map<String, dynamic> param = Map();
    param["__output"] = "8";
    param["page"] = page;
    param["tid"] = tid;
    return param;
  }

  Map<String, String> _buildHeader() {
    Map<String, String> header = Map();
    header["Cookie"] = UserModel.getInstance().getCookie();
    return header;
  }
}

class TopicContentEntity{

  String content;

  String author;

  String subject;

  List<String> contentList = new List();

}
