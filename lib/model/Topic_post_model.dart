import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:nga_open_source/main.dart';

class TopicPostModel {
  Dio dio = new Dio();

  String url = "https://bbs.nga.cn/post.php?";

  int length;

  Future<bool> post(TopicPostEntity postEntity) async {
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

  Map<String, String> _buildHeader(TopicPostEntity postEntity) {
    Map<String, String> header = Map();
    header["Cookie"] = ReduxApp.store.state.userState.getCookie();//UserModel.getInstance().getCookie();
    header["Accept-Charset"] = "GBK";
    header["Content-Type"] = "application/x-www-form-urlencode";
    header["User-Agent"] =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36";
    return header;
  }
}

class TopicPostEntity {
  String postContent;

  int tid;

  int pid;

  String action;

  String subject;

  bool anonymous = false;

  TopicPostEntity(this.tid, this.action,
      {this.pid, this.subject, this.anonymous, this.postContent});

  String toUrlString() {
    String gbkContent = Uri.encodeQueryComponent(postContent, encoding: gbk);
    StringBuffer buffer =
        new StringBuffer("step=2&post_content=$gbkContent&action=$action");

    buffer.write(subject != null ? "&subject=$subject" : "");
    buffer.write(tid != null ? "&tid=$tid" : "");
    buffer.write(pid != null ? "&pid=$pid" : "");
    return buffer.toString();
  }
}
