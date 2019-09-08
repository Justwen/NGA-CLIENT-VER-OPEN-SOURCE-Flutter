import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nga_open_source/plugin/UtilsPlugin.dart';

import 'bean/entity_factory.dart';
import 'bean/topic_list_bean_entity.dart';
import 'board_model.dart';
import 'user_model.dart';

class TopicModel {
  Dio dio = new Dio();

  Future<List<TopicEntity>> loadPage(Board board, int page) async {
    String url = _buildUrl(board, page);
    print(url);
    Options options = new Options();
    options.headers = _buildHeader();
    options.responseType = ResponseType.plain;
    List<TopicEntity> topicList = new List();
    try {
      Response response = await dio.get(url,
          options: options, queryParameters: _buildParam(board, page));

      String result = await UtilsPlugin().unicodeDecoding(response.data);
      TopicListBeanEntity bean =
      EntityFactory.generateOBJ<TopicListBeanEntity>(jsonDecode(result));
      bean.result.lT.forEach((bean) {
        TopicEntity topicEntity = new TopicEntity();
        topicEntity.title = bean.subject;
        topicEntity.tid = bean.tid;
        topicList.add(topicEntity);
      });
    } catch (e) {
      print(e);
    }
    return topicList;
  }

  String _buildUrl(Board board, int page) {
    StringBuffer buffer = new StringBuffer();
    buffer.write("https://bbs.nga.cn/thread.php?");
    return buffer.toString();
  }

  Map<String, dynamic> _buildParam(Board board, int page) {
    Map<String, dynamic> param = Map();
    param["__output"] = "14";
    param["page"] = page;
    if (board.stid != 0) {
      param["stid"] = board.stid;
    } else if (board.fid != 0) {
      param["fid"] = board.fid;
    }
    return param;
  }

  Map<String, String> _buildHeader() {
    Map<String, String> header = Map();
    header["Cookie"] = UserModel.getInstance().getCookie();
    return header;
  }
}

class TopicEntity {
  String title;

  int tid;

  Map toJson() {
    Map map = new Map();
    map["title"] = this.title;
    map["tid"] = this.tid;
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
