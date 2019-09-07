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
        print(uidBeanData.rvrc);
        if (uidBeanData.rvrc != null) {
          rowEntity.author.reputation = uidBeanData.rvrc / 10.0;
        }

        int memberId = uidBeanData.memberid;
        rowEntity.author.level = bean.data.tU.tGroups.dataMap[memberId].level;

        entity.contentList.add(rowEntity);
      });

      entity.htmlContent =
          await HtmlConvertFactory.convert2Html(entity: entity);
      callback(entity);
    } catch (e, s) {
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

class TopicContentEntity {
  List<TopicRowEntity> contentList = new List();

  String htmlContent;

  bool isHidden;
}

class TopicRowEntity {
  String content;

  TopicAuthorEntity author;

  String floor;

  int deviceType;

  String postDate;

  String subject;
}

class TopicAuthorEntity {
  static const String ANONYMOUS_PART_1 = "甲乙丙丁戊己庚辛壬癸子丑寅卯辰巳午未申酉戌亥";

  static const String ANONYMOUS_PART_2 =
      "王李张刘陈杨黄吴赵周徐孙马朱胡林郭何高罗郑梁谢宋唐许邓冯韩曹曾彭萧蔡潘田董袁于余叶蒋杜苏魏程吕丁沈任姚卢傅钟姜崔谭廖范汪陆金石戴贾韦夏邱方侯邹熊孟秦白江阎薛尹段雷黎史龙陶贺顾毛郝龚邵万钱严赖覃洪武莫孔汤向常温康施文牛樊葛邢安齐易乔伍庞颜倪庄聂章鲁岳翟殷詹申欧耿关兰焦俞左柳甘祝包宁尚符舒阮柯纪梅童凌毕单季裴霍涂成苗谷盛曲翁冉骆蓝路游辛靳管柴蒙鲍华喻祁蒲房滕屈饶解牟艾尤阳时穆农司卓古吉缪简车项连芦麦褚娄窦戚岑景党宫费卜冷晏席卫米柏宗瞿桂全佟应臧闵苟邬边卞姬师和仇栾隋商刁沙荣巫寇桑郎甄丛仲虞敖巩明佘池查麻苑迟邝 ";

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
      userName = convertAnonymousName(userName);
    } else {
      isAnonymous = false;
    }
  }

  String toDescriptionString() {
    return "级别: $level 威望: $reputation 发帖: $postCount";
  }

  String convertAnonymousName(String userName) {
    StringBuffer buffer = new StringBuffer();
    int i = 6;
    for (int j = 0; j < 6; j++) {
      int pos;
      if (j == 0 || j == 3) {
        pos = int.tryParse(userName.substring(i + 1, i + 2), radix: 16);
        buffer.write(ANONYMOUS_PART_1[pos]);
      } else {
        pos = int.tryParse(userName.substring(i, i + 2), radix: 16);
        buffer.write(ANONYMOUS_PART_2[pos]);
      }
      i += 2;
    }
    return buffer.toString();
  }
}
