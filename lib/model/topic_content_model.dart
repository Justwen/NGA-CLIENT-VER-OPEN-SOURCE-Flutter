import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:nga_open_source/bloc/topic_content_bloc.dart';
import 'package:nga_open_source/core/html_convert_factory.dart';
import 'package:nga_open_source/model/bean/entity_factory.dart';
import 'package:nga_open_source/plugin/WebViewPlugin.dart';
import 'package:nga_open_source/redux/app_redux.dart';
import 'package:nga_open_source/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

import 'bean/topic_content_bean_entity.dart';

class TopicContentModel {
  TopicContentBloc bloc = new TopicContentBloc();

  Dio dio = new Dio();

  WebViewPlugin webViewPlugin = new WebViewPlugin();

  void loadContent(int tid, int page) async {
    //tid = 18335755;
    String url = _buildUrl();
    print(url + "&page=$page&tid=$tid");
    Options options = new Options();
    options.headers = _buildHeader();
    options.responseType = ResponseType.bytes;
    try {
      Response response = await dio.get(url,
          options: options, queryParameters: _buildParam(tid, page));

      String result = _correct(gbk.decode(response.data));

      TopicContentBeanEntity bean =
          EntityFactory.generateOBJ<TopicContentBeanEntity>(jsonDecode(result));

      TopicContentEntity entity = new TopicContentEntity();

      bean.data.tR.listData.forEach((dataBean) {
        TopicRowEntity rowEntity = new TopicRowEntity();
        rowEntity.content = dataBean.content;
        rowEntity.subject = dataBean.subject;
        rowEntity.postDate = dataBean.postdate;
        rowEntity.floor = "[${dataBean.lou}楼]";

        String uid = dataBean.authorid;
        TopicContentBeanDataUid uidBeanData = bean.data.tU.dataMap[uid];
        String userName = uidBeanData.username;
        String avatarUrl = uidBeanData.avatar;
        rowEntity.author = new TopicAuthorEntity(
            userName: userName, avatarUrl: avatarUrl, uid: uid);
        rowEntity.author.postCount = uidBeanData.postnum;
        if (uidBeanData.rvrc != null) {
          rowEntity.author.reputation = uidBeanData.rvrc / 10.0;
        }

        int memberId = uidBeanData.memberid;
        rowEntity.author.level = bean.data.tU.tGroups.dataMap[memberId].level;
        rowEntity.isHidden =
            rowEntity.content == "" && dataBean.alterinfo == "";

        entity.contentList.add(rowEntity);
      });

      entity.totalPage = bean.data.iRows ~/ 20;
      if (bean.data.iRows % 20 != 0) {
        entity.totalPage++;
      }
      entity.htmlContent =
          await HtmlConvertFactory.convert2Html(entity: entity);

      TopicContentWrapper wrapper = new TopicContentWrapper();
      wrapper.current = entity;
      wrapper.totalPage = entity.totalPage;

      bloc.updateTopicContent(wrapper);
    } catch (e, s) {
      TopicContentWrapper wrapper = new TopicContentWrapper();
      wrapper.errorMsg = e.message;
      bloc.updateTopicContent(wrapper);
      ToastUtils.showToast(wrapper.errorMsg);
      if (!(s is DioError)) {
        print(s);
      }
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
    header["Cookie"] =
        AppRedux.userState.getCookie();
    return header;
  }
}

class TopicContentWrapper {
  TopicContentEntity current;

  TopicContentEntity next;

  int totalPage;

  int currentPage;

  String errorMsg;
}

class TopicContentEntity {
  List<TopicRowEntity> contentList = new List();

  String htmlContent;

  int totalPage;
}

class TopicRowEntity {
  String content;

  TopicAuthorEntity author;

  String floor;

  int deviceType;

  String postDate;

  String subject;

  bool isHidden;
}

class TopicAuthorEntity {
  String userName;

  bool isAnonymous;

  String uid;

  String avatarUrl;

  String level;

  int postCount;

  double reputation;

  TopicAuthorEntity({
    this.userName,
    this.uid,
    this.avatarUrl,
  }) {
    if (userName.startsWith("#anony_")) {
      isAnonymous = true;
      userName = StringUtils.convertAnonymousName(userName);
    } else {
      isAnonymous = false;
    }
  }

  String toDescriptionString() {
    return "级别: $level 威望: $reputation 发帖: $postCount";
  }
}
