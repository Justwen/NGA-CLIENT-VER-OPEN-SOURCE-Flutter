import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:nga_open_source/model/user_model.dart';
import 'package:nga_open_source/plugin/StringPlugins.dart';
import 'package:nga_open_source/utils/utils.dart';

class TopicPostModel {
  Dio dio = new Dio();

  String url = "http://bbs.nga.cn/post.php?";

  Future<bool> post(TopicPostEntity postEntity) async {
    Options options = new Options();
    options.headers = _buildHeader(postEntity);
    options.followRedirects = false;
    options.responseType = ResponseType.bytes;
    options.method = "post";

    postEntity.postContent = await StringUtils.uriEncode(postEntity.postContent, "GBK");
    print(postEntity.postContent);
    Response response = await dio.post(url,
        data: _buildData(postEntity),
        options: options);

    String result = gbk.decode(response.data);
    print(result);

    return new Future.value(true);
  }

  FormData _buildData(TopicPostEntity postEntity) {
    Map<String, dynamic> param = Map();
    //param["__output"] = "8";
    param["action"] = postEntity.action;
    param["tid"] = postEntity.tid;
    param['step'] = "2";

  //  param['pid'] =  "363767304";
    param['post_content'] = postEntity.postContent;
    return new FormData.from(param);
  }

  Map<String, String> _buildHeader(TopicPostEntity postEntity) {
    Map<String, String> header = Map();
    header["Cookie"] = UserModel.getInstance().getCookie();
    header["Accept-Charset"] = "GBK";
    header["Content-Type"] = "application/x-www-form-urlencode";
    header["User-Agent"] =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36";
    header["Content-Length"] = postEntity.postContent.length.toString();
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
    return "tid=$tid&action=$action";
  }
}
