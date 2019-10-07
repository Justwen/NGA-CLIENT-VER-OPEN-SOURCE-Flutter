import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nga_open_source/redux/app_redux.dart';

import 'bean/entity_factory.dart';
import 'bean/topic_list_bean_entity.dart';
import 'entity/board_info.dart';

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

      TopicListBeanEntity bean =
          EntityFactory.generateOBJ<TopicListBeanEntity>(jsonDecode(response.data));
      bean.result.lT.forEach((bean) {
        TopicEntity topicEntity = new TopicEntity();
        topicEntity.title = bean.subject;
        topicEntity.tid = bean.tid;
        topicEntity.author = bean.author;
        topicEntity.replyCount = bean.replies;
        topicEntity.lastReplyTime = _buildDate(bean.lastpost);
        topicList.add(topicEntity);
      });
    } catch (e) {
      print(e);
    }
    return topicList;
  }

  String _buildDate(int milliseconds) {
    var now = DateTime.now();
    var postDate = DateTime.fromMillisecondsSinceEpoch(milliseconds * 1000);

    Duration diff = now.difference(postDate);

    if (diff.inDays >= 365) {
      String month =
          postDate.month < 10 ? "0${postDate.month}" : "${postDate.month}";
      String day = postDate.day < 10 ? "0${postDate.day}" : "${postDate.day}";
      return "${postDate.year}-$month-$day";
    } else if (diff.inDays >= 1) {
      String month =
          postDate.month < 10 ? "0${postDate.month}" : "${postDate.month}";
      String day = postDate.day < 10 ? "0${postDate.day}" : "${postDate.day}";
      return "$month-$day";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours}小时前";
    } else if (diff.inMinutes >= 1) {
      return "${diff.inMinutes}分钟前";
    } else {
      return "刚刚";
    }
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
    header["Cookie"] = AppRedux.userState.getCookie();
    return header;
  }
}

class TopicEntity {
  String title;

  int tid;

  String author;

  int replyCount;

  String lastReplyTime;

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
