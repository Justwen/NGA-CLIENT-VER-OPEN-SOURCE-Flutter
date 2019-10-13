import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nga_open_source/bloc/topic_title_bloc.dart';
import 'package:nga_open_source/model/entity/topic_title_info.dart';
import 'package:nga_open_source/redux/app_redux.dart';
import 'package:nga_open_source/utils/utils.dart';
import 'package:nga_open_source/widget/flutter_widget_ex.dart';
import 'package:toast/toast.dart';

import 'bean/entity_factory.dart';
import 'bean/topic_title_bean.dart';
import 'entity/board_info.dart';

class TopicTitleModel {
  static const int MASK_FONT_RED = 1;

  static const int MASK_FONT_BLUE = 2;

  static const int MASK_FONT_GREEN = 4;

  static const int MASK_FONT_ORANGE = 8;

  static const int MASK_FONT_SILVER = 16;

  static const int MASK_FONT_BOLD = 32;

  static const int MASK_FONT_ITALIC = 64;

  static const int MASK_FONT_UNDERLINE = 128;

  // 主题被锁定 2^10
  static const int MASK_TYPE_LOCK = 1024;

  // 主题中有附件 2^13
  static const int MASK_TYPE_ATTACHMENT = 8192;

  // 合集 2^15
  static const int MASK_TYPE_ASSEMBLE = 32768;

  TopicTitleBloc _bloc = TopicTitleBloc();

  TopicTitleBloc get bloc => _bloc;

  Dio dio = new Dio();

  Future<Null> loadPage(Board board, int page, {bool reset = false}) async {
    print("page = " + page.toString());
    String url = _buildUrl(board, page);
    print(url);
    Options options = new Options();
    options.headers = _buildHeader();
    options.responseType = ResponseType.plain;
    TopicTitleWrapper wrapper = TopicTitleWrapper();
    try {
      Response response = await dio.get(url,
          options: options, queryParameters: _buildParam(board, page));

      TopicListBeanEntity bean = EntityFactory.generateOBJ<TopicListBeanEntity>(
          jsonDecode(response.data));
      if (bean.code == 1) {
        wrapper.errorMsg = bean.msg;
        bloc.showErrorMsg(wrapper);
      } else {
        bean.result.lT.forEach((bean) {
          TopicTitleInfo topicEntity = _convertToTopicTitleInfo(bean);
          wrapper.add(info: topicEntity);
        });
        wrapper.pageIndex = page;
        wrapper.hasNextPage = bean.result.iTRowsPage > page;
        bloc.addTopicTitles(wrapper, reset: reset);
      }
    } catch (e) {
      print(e);
    }
  }

  TopicTitleInfo _convertToTopicTitleInfo(TopicListBeanResultT bean) {
    TopicTitleInfo topicEntity = TopicTitleInfo();
    topicEntity.title = bean.subject;
    topicEntity.tid = bean.tid;
    topicEntity.isAnonymous = bean.author.startsWith("#anony_");
    topicEntity.author = topicEntity.isAnonymous
        ? StringUtils.convertAnonymousName(bean.author)
        : bean.author;
    topicEntity.replyCount = bean.replies;
    topicEntity.lastReplyTime = _buildDate(bean.lastpost);
    var parentBoardInfo = bean?.parent?.data;
    if (parentBoardInfo is Map) {
      topicEntity.parentBoard =
          parentBoardInfo != null ? parentBoardInfo["2"] : "";
    } else {
      topicEntity.parentBoard =
          parentBoardInfo != null ? parentBoardInfo[2] : "";
    }
    int type = bean.type;
    topicEntity.isLocked = (type & MASK_TYPE_LOCK) == MASK_TYPE_LOCK;
    topicEntity.isAssemble = (type & MASK_TYPE_ASSEMBLE) == MASK_TYPE_ASSEMBLE;

    String topicMisc = bean.topicMisc;
    topicEntity.titleStyle = _convertTextStyle(topicMisc);

    return topicEntity;
  }

  TextStyle _convertTextStyle(String misc) {
    if (misc == null) {
      return TextStyleEx(fontSize: 17);
    }

    while (misc.length % 4 != 0) {
      misc = misc + "=";
    }
    Uint8List bytes = base64Decode(misc);
    if (bytes != null) {
      int pos = 0;
      String value = StringUtils.toBinaryArray(bytes);
      FontWeight fontWeight = FontWeight.normal;
      TextDecoration decoration = TextDecoration.none;
      Color color = Colors.black;
      FontStyle fontStyle = FontStyle.normal;
      if (pos < bytes.length && bytes[pos] == 1) {
        var data = BigInt.parse(value.substring(8), radix: 2).toInt();
        if ((data & MASK_FONT_GREEN) == MASK_FONT_GREEN) {
          color = Colors.green;
        } else if ((data & MASK_FONT_BLUE) == MASK_FONT_BLUE) {
          color = Colors.blue;
        } else if ((data & MASK_FONT_RED) == MASK_FONT_RED) {
          color = Colors.red;
        } else if ((data & MASK_FONT_ORANGE) == MASK_FONT_ORANGE) {
          color = Colors.orange;
        } else if ((data & MASK_FONT_SILVER) == MASK_FONT_SILVER) {
          color = Color(0xFFE6E8FA);
        }
        if ((data & MASK_FONT_BOLD) == MASK_FONT_BOLD) {
          fontWeight = FontWeight.bold;
        } else if ((data & MASK_FONT_UNDERLINE) == MASK_FONT_UNDERLINE) {
          decoration = TextDecoration.underline;
        } else if ((data & MASK_FONT_ITALIC) == MASK_FONT_ITALIC) {
          fontStyle = FontStyle.italic;
        }
        pos += 4;
      }
      return TextStyle(
          fontSize: 17,
          color: color,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: decoration);
    }
    return TextStyleEx(fontSize: 17);
  }

  Future<Null> loadAgain(Board board, int page) async {
    bloc.reset();
    await loadPage(board, page);
  }

  bool hasNextPage() {
    return bloc.bean.hasNextPage;
  }

  Future<Null> loadNextPage(Board board) async {
    await loadPage(board, bloc.bean.pageIndex + 1);
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
