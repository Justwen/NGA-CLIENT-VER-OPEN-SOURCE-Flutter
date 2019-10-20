import 'package:nga_open_source/model/entity/board_info.dart';

class TopicListBeanEntity {
  TopicListBeanResult result;
  int code;
  String msg;

  TopicListBeanEntity({this.result, this.code});

  TopicListBeanEntity.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new TopicListBeanResult.fromJson(json['result'])
        : null;
    code = json['code'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class TopicListBeanResult {
  int iTRows;
  int iRows;
  List<TopicListBeanResultT> lT;
  TopicListBeanResultF tF;
  TopicListBeanResultGlobal tGlobal;
  TopicListBeanResultCu tCu;
  int iTRowsPage;
  int iRRowsPage;

  TopicListBeanResult({this.iTRows,
    this.iRows,
    this.lT,
    this.tF,
    this.tGlobal,
    this.tCu,
    this.iTRowsPage,
    this.iRRowsPage});

  TopicListBeanResult.fromJson(Map<String, dynamic> json) {
    iTRows = json['__T__ROWS'];
    iRows = int.parse(json['__ROWS'].toString());
    if (json['__T'] != null) {
      String type = json['__T'].runtimeType.toString();
      if (type.contains("List")) {
        lT = new List<TopicListBeanResultT>();
        (json['__T'] as List).forEach((v) {
          lT.add(new TopicListBeanResultT.fromJson(
              new Map<String, dynamic>.from(v)));
        });
      } else {
        lT = new List<TopicListBeanResultT>();
        (json['__T'] as Map).forEach((k, v) {
          lT.add(new TopicListBeanResultT.fromJson(
              new Map<String, dynamic>.from(v)));
        });
      }
    }
    tF = json['__F'] != null
        ? new TopicListBeanResultF.fromJson(json['__F'])
        : null;
    tGlobal = json['__GLOBAL'] != null
        ? new TopicListBeanResultGlobal.fromJson(json['__GLOBAL'])
        : null;
    tCu = json['__CU'] != null
        ? new TopicListBeanResultCu.fromJson(json['__CU'])
        : null;
    iTRowsPage = json['__T__ROWS_PAGE'];
    iRRowsPage = json['__R__ROWS_PAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__T__ROWS'] = this.iTRows;
    data['__ROWS'] = this.iRows;
    if (this.lT != null) {
      data['__T'] = this.lT.map((v) => v.toJson()).toList();
    }
    if (this.tF != null) {
      data['__F'] = this.tF.toJson();
    }
    if (this.tGlobal != null) {
      data['__GLOBAL'] = this.tGlobal.toJson();
    }
    if (this.tCu != null) {
      data['__CU'] = this.tCu.toJson();
    }
    data['__T__ROWS_PAGE'] = this.iTRowsPage;
    data['__R__ROWS_PAGE'] = this.iRRowsPage;
    return data;
  }
}

class TopicListBeanResultT {
  int fid;
  TopicListBeanResultTParent parent;
  String tpcurl;
  int quoteFrom;
  String author;
  String subject;
  dynamic quoteTo;
  int icon;
  int postdate;
  TopicListBeanResultTTopicMiscVar topicMiscVar;
  int recommend;
  int authorid;
  int type;
  int tid;
  int replies;
  String lastposter;
  int lastpost;
  String titlefont;
  String topicMisc;
  int lastmodify;

  TopicListBeanResultT({this.fid,
    this.parent,
    this.tpcurl,
    this.quoteFrom,
    this.author,
    this.subject,
    this.quoteTo,
    this.icon,
    this.postdate,
    this.topicMiscVar,
    this.recommend,
    this.authorid,
    this.type,
    this.tid,
    this.replies,
    this.lastposter,
    this.lastpost,
    this.titlefont,
    this.topicMisc,
    this.lastmodify});

  TopicListBeanResultT.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    parent = json['parent'] != null
        ? new TopicListBeanResultTParent.fromJson(json['parent'])
        : null;
    tpcurl = json['tpcurl'];
    quoteFrom = json['quote_from'];
    if (json['author'] is bool) {
      author = "";
    } else {
      author = json['author'] ?? "";
    }
    subject = json['subject'];
    quoteTo = json['quote_to'];
    icon = json['icon'];
    postdate = json['postdate'];
    topicMiscVar = json['topic_misc_var'] != null
        ? new TopicListBeanResultTTopicMiscVar.fromJson(json['topic_misc_var'])
        : null;
    recommend = json['recommend'];
    authorid = int.tryParse(json['authorid'].toString());
    type = json['type'];
    tid = json['tid'];
    replies = json['replies'];
    if (json['lastposter'] is bool) {
      lastposter = "";
    } else {
      lastposter = json['lastposter'];
    }
    lastpost = json['lastpost'];
    titlefont = json['titlefont'];
    topicMisc = json['topic_misc'];
    lastmodify = json['lastmodify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fid'] = this.fid;
    if (this.parent != null) {
      data['parent'] = this.parent.toJson();
    }
    data['tpcurl'] = this.tpcurl;
    data['quote_from'] = this.quoteFrom;
    data['author'] = this.author;
    data['subject'] = this.subject;
    data['quote_to'] = this.quoteTo;
    data['icon'] = this.icon;
    data['postdate'] = this.postdate;
    if (this.topicMiscVar != null) {
      data['topic_misc_var'] = this.topicMiscVar.toJson();
    }
    data['recommend'] = this.recommend;
    data['authorid'] = this.authorid;
    data['type'] = this.type;
    data['tid'] = this.tid;
    data['replies'] = this.replies;
    data['lastposter'] = this.lastposter;
    data['lastpost'] = this.lastpost;
    data['titlefont'] = this.titlefont;
    data['topic_misc'] = this.topicMisc;
    data['lastmodify'] = this.lastmodify;
    return data;
  }
}

class TopicListBeanResultTParent {
  dynamic data;

  TopicListBeanResultTParent({this.data});

  TopicListBeanResultTParent.fromJson(dynamic json) {
    data = json;
  }

  Map<String, dynamic> toJson() {
    return data;
  }
}

class TopicListBeanResultTTopicMiscVar {
  dynamic data;

  TopicListBeanResultTTopicMiscVar(this.data);

  TopicListBeanResultTTopicMiscVar.fromJson(dynamic json) {
    data = json;
  }

  Map<String, dynamic> toJson() {
    return data;
  }
}

class TopicListBeanResultF {
  int fid;
  dynamic nSelectedForum;
  TopicListBeanResultFSubForums subForums;
  int toppedTopic;

  TopicListBeanResultF(
      {this.fid, this.nSelectedForum, this.subForums, this.toppedTopic});

  TopicListBeanResultF.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    nSelectedForum = json['__SELECTED_FORUM'];
    subForums = json['sub_forums'] != null
        ? new TopicListBeanResultFSubForums.fromJson(json['sub_forums'])
        : null;
    toppedTopic = json['topped_topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fid'] = this.fid;
    data['__SELECTED_FORUM'] = this.nSelectedForum;
    if (this.subForums != null) {
      data['sub_forums'] = this.subForums.toJson();
    }
    data['topped_topic'] = this.toppedTopic;
    return data;
  }
}

class TopicListBeanResultFSubForums {
  List<Board> subBoards;

  TopicListBeanResultFSubForums({this.subBoards});

  TopicListBeanResultFSubForums.fromJson(Map<String, dynamic> json) {
    subBoards = new List();
    json.forEach((key, value) {
      subBoards.add(new Board(fid: value[0], name: value[1]));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class TopicListBeanResultGlobal {
  String sAttachBaseView;

  TopicListBeanResultGlobal({this.sAttachBaseView});

  TopicListBeanResultGlobal.fromJson(Map<String, dynamic> json) {
    sAttachBaseView = json['_ATTACH_BASE_VIEW'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_ATTACH_BASE_VIEW'] = this.sAttachBaseView;
    return data;
  }
}

class TopicListBeanResultCu {
  int rvrc;
  int uid;
  int groupBit;
  int admincheck;

  TopicListBeanResultCu({this.rvrc, this.uid, this.groupBit, this.admincheck});

  TopicListBeanResultCu.fromJson(Map<String, dynamic> json) {
    rvrc = json['rvrc'];
    uid = json['uid'];
    groupBit = json['group_bit'];
    admincheck = json['admincheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rvrc'] = this.rvrc;
    data['uid'] = this.uid;
    data['group_bit'] = this.groupBit;
    data['admincheck'] = this.admincheck;
    return data;
  }
}
