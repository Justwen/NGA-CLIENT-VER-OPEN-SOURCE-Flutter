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
    //tid = 19353310;
    String url = _buildUrl();
    print(url + "&page=$page&tid=$tid");
    Options options = new Options();
    options.headers = _buildHeader();
    options.responseType = ResponseType.bytes;
    try {
      Response response = await dio.get(url,
          options: options, queryParameters: _buildParam(tid, page));

      String result = await StringUtils.convertGBK(response.data);

      TopicContentBeanEntity bean =
          EntityFactory.generateOBJ<TopicContentBeanEntity>(jsonDecode(result));

      TopicContentEntity entity = new TopicContentEntity();

      _convertAuthorMap(bean, entity);

      bean.data.tR.listData.forEach((dataBean) {
        TopicRowEntity rowEntity = new TopicRowEntity();
        rowEntity.content = dataBean.content;
        rowEntity.subject = dataBean.subject;
        rowEntity.postDate = dataBean.postdate;
        rowEntity.floor = "[${dataBean.lou}楼]";

        String uid = dataBean.authorid;
        rowEntity.author = entity.authorMap[uid];
        rowEntity.isHidden =
            rowEntity.content == "" && dataBean.alterinfo == "";

        _convertDeviceType(dataBean, rowEntity);
        _convertComment(dataBean, entity, rowEntity);

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
      wrapper.errorMsg = e.toString();
      bloc.updateTopicContent(wrapper);
      ToastUtils.showToast(wrapper.errorMsg);
      if (!(s is DioError)) {
        print(e);
        print(s);
      }
    }
  }

  void _convertDeviceType(
      TopicContentBeanDataRR dataBean, TopicRowEntity entity) {
    String fromClient = dataBean.fromClient;
    if (fromClient == null) {
      return;
    }
    int splitIndex = fromClient.indexOf(" ");
    int clientAppCode = int.parse(fromClient.substring(0, splitIndex));
    String clientInfo = fromClient.substring(splitIndex + 1);
    entity.deviceType = [clientAppCode, clientInfo];
  }

  void _convertAuthorMap(
      TopicContentBeanEntity dataBean, TopicContentEntity entity) {
    dataBean.data.tU.dataMap.forEach((uid, uidBeanData) {
      String userName = uidBeanData.username;
      String avatarUrl = uidBeanData.avatar;
      TopicAuthorEntity authorEntity = new TopicAuthorEntity(
          userName: userName, avatarUrl: avatarUrl, uid: uid);
      authorEntity.postCount = uidBeanData.postnum;
      if (uidBeanData.rvrc != null) {
        authorEntity.reputation = uidBeanData.rvrc / 10.0;
      }
      int memberId = uidBeanData.memberid;
      authorEntity.level = dataBean.data.tU.tGroups.dataMap[memberId].level;
      entity.authorMap[uid] = authorEntity;
    });
  }

  void _convertComment(TopicContentBeanDataRR dataBean,
      TopicContentEntity contentEntity, TopicRowEntity entity) {
    dataBean.comments?.forEach((bean) {
      entity.commentList ??= new List();
      CommentEntity commentEntity = new CommentEntity();
      commentEntity.content = bean.content;
      commentEntity.postDate = bean.postDate;
      commentEntity.authorEntity =
          contentEntity.authorMap[bean.authorId.toString()];
      entity.commentList.add(commentEntity);
    });
  }

  void printLog(String log) async {
    Directory tempDir = await getTemporaryDirectory();
    var file = File('${tempDir.path}/counter.txt');
    file.writeAsString(log);
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
    header["Cookie"] = AppRedux.userState.getCookie();
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

  Map<String, TopicAuthorEntity> authorMap = new Map();

  String htmlContent;

  int totalPage;
}

class TopicRowEntity {
  String content;

  TopicAuthorEntity author;

  String floor;

  List<dynamic> deviceType;

  String postDate;

  String subject;

  bool isHidden;

  List<CommentEntity> commentList;
}

class CommentEntity {
  String content;

  String postDate;

  TopicAuthorEntity authorEntity;
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
