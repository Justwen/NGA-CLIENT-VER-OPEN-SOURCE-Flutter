import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:nga_open_source/redux/app_redux.dart';

class TopicPostModel {
  Dio dio = new Dio();

  String url = "https://bbs.nga.cn/post.php?";

  int length;

  Future<bool> post(TopicPostParam postEntity) async {
    RequestOptions options = new RequestOptions();
    options.headers = _buildHeader(postEntity);
    options.followRedirects = false;
    options.responseType = ResponseType.bytes;
    options.contentType = ContentType("application", "x-www-form-urlencode");

    String path = "$url${postEntity.toUrlString()}";
    dio.interceptors
        .add(LogInterceptor(requestBody: true, responseHeader: false));
    Response response = await dio.post(path, options: options);

    String result = gbk.decode(response.data);
    print(result);

    return new Future.value(true);
  }

  Map<String, String> _buildHeader(TopicPostParam postEntity) {
    Map<String, String> header = Map();
    header["Cookie"] = AppRedux.userState.getCookie();
    header["Accept-Charset"] = "GBK";
    header["Content-Type"] = "application/x-www-form-urlencode";
    header["User-Agent"] =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36";
    return header;
  }
}

class TopicPostParam {
  static const TOPIC_POST_ACTION_NEW = "new";

  static const TOPIC_POST_ACTION_REPLY = "reply";

  static const TOPIC_POST_ACTION_MODIFY = "modify";

  String postContent;

  int tid;

  int pid;

  int fid;

  String action;

  String subject;

  bool anonymous = false;

  TopicPostParam(this.action,
      {this.pid,
      this.subject,
      this.anonymous,
      this.postContent,
      this.tid,
      this.fid});

  String toUrlString() {
    String gbkContent = Uri.encodeQueryComponent(postContent, encoding: gbk);
    StringBuffer buffer = new StringBuffer("step=2&&__output=14");

    buffer
      ..write("&post_content=$gbkContent")
      ..write("&action=$action")
      ..write("&subject=${subject ?? ""}")
      ..write("&tid=${tid ?? ""}")
      ..write("&fid=${fid ?? ""}")
      ..write("&pid=${pid ?? ""}");
    return buffer.toString();
  }
}
