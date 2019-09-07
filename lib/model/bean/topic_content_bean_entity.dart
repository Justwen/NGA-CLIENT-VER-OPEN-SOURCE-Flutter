class TopicContentBeanEntity {
	String encode;
	TopicContentBeanData data;
	int time;

	TopicContentBeanEntity({this.encode, this.data, this.time});

	TopicContentBeanEntity.fromJson(Map<String, dynamic> json) {
		encode = json['encode'];
		data = json['data'] != null ? new TopicContentBeanData.fromJson(json['data']) : null;
		time = json['time'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['encode'] = this.encode;
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['time'] = this.time;
		return data;
	}
}

class TopicContentBeanData {
	TopicContentBeanDataR tR;
	int iPage;
	TopicContentBeanDataU tU;
	int iRows;
	TopicContentBeanDataT tT;
	TopicContentBeanDataF tF;
	TopicContentBeanDataGlobal tGlobal;
	int iRRows;
	TopicContentBeanDataCu tCu;
	int iRRowsPage;

	TopicContentBeanData({this.tR, this.iPage, this.tU, this.iRows, this.tT, this.tF, this.tGlobal, this.iRRows, this.tCu, this.iRRowsPage});

	TopicContentBeanData.fromJson(Map<String, dynamic> json) {
		tR = json['__R'] != null ? new TopicContentBeanDataR.fromJson(json['__R']) : null;
		iPage = json['__PAGE'];
		tU = json['__U'] != null ? new TopicContentBeanDataU.fromJson(json['__U']) : null;
		iRows = json['__ROWS'];
		tT = json['__T'] != null ? new TopicContentBeanDataT.fromJson(json['__T']) : null;
		tF = json['__F'] != null ? new TopicContentBeanDataF.fromJson(json['__F']) : null;
		tGlobal = json['__GLOBAL'] != null ? new TopicContentBeanDataGlobal.fromJson(json['__GLOBAL']) : null;
		iRRows = json['__R__ROWS'];
		tCu = json['__CU'] != null ? new TopicContentBeanDataCu.fromJson(json['__CU']) : null;
		iRRowsPage = json['__R__ROWS_PAGE'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.tR != null) {
      data['__R'] = this.tR.toJson();
    }
		data['__PAGE'] = this.iPage;
		if (this.tU != null) {
      data['__U'] = this.tU.toJson();
    }
		data['__ROWS'] = this.iRows;
		if (this.tT != null) {
      data['__T'] = this.tT.toJson();
    }
		if (this.tF != null) {
      data['__F'] = this.tF.toJson();
    }
		if (this.tGlobal != null) {
      data['__GLOBAL'] = this.tGlobal.toJson();
    }
		data['__R__ROWS'] = this.iRRows;
		if (this.tCu != null) {
      data['__CU'] = this.tCu.toJson();
    }
		data['__R__ROWS_PAGE'] = this.iRRowsPage;
		return data;
	}
}

class TopicContentBeanDataR {

	List<TopicContentBeanDataRR> listData;

	TopicContentBeanDataR({this.listData});

	TopicContentBeanDataR.fromJson(Map<String, dynamic> json) {
		int index = 0;
		listData = new List();
		while (listData.length < json.length) {
			if (json['$index'] != null) {
				listData.add(new TopicContentBeanDataRR.fromJson(json['$index']));
			}
			index ++;

		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		listData.forEach((dataBean) {
			data["${dataBean.lou}"] = dataBean.toJson();
		});
		return data;
	}
}

class TopicContentBeanDataRR {
	int fid;
	String fromClient;
	String subject;
	int score2;
	String postdate;
	int pid;
	int recommend;
	int postdatetimestamp;
	String authorid;
	int type;
	int tid;
	String content;
	int score;
	int lou;
	String alterinfo;
	int contentLength;

	TopicContentBeanDataRR({this.fid, this.fromClient, this.subject, this.score2, this.postdate, this.pid, this.recommend, this.postdatetimestamp, this.authorid, this.type, this.tid, this.content, this.score, this.lou, this.alterinfo, this.contentLength});

	TopicContentBeanDataRR.fromJson(Map<String, dynamic> json) {
		fid = json['fid'];
		fromClient = json['from_client'];
		subject = json['subject'];
		score2 = json['score_2'];
		postdate = json['postdate'];
		pid = json['pid'];
		recommend = json['recommend'];
		postdatetimestamp = json['postdatetimestamp'];
		authorid = json['authorid'].toString();
		type = json['type'];
		tid = json['tid'];
		content = json['content'].toString();
		score = json['score'];
		lou = json['lou'];
		alterinfo = json['alterinfo'];
		contentLength = json['content_length'] == "" ? 0 : json['content_length'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['fid'] = this.fid;
		data['from_client'] = this.fromClient;
		data['subject'] = this.subject;
		data['score_2'] = this.score2;
		data['postdate'] = this.postdate;
		data['pid'] = this.pid;
		data['recommend'] = this.recommend;
		data['postdatetimestamp'] = this.postdatetimestamp;
		data['authorid'] = this.authorid;
		data['type'] = this.type;
		data['tid'] = this.tid;
		data['content'] = this.content;
		data['score'] = this.score;
		data['lou'] = this.lou;
		data['alterinfo'] = this.alterinfo;
		data['content_length'] = this.contentLength;
		return data;
	}
}

class TopicContentBeanDataU {
	TopicContentBeanDataUGroups tGroups;
	TopicContentBeanDataUMedals tMedals;
	TopicContentBeanDataUReputations tReputations;

	Map<dynamic,TopicContentBeanDataUid> dataMap;

	TopicContentBeanDataU({this.dataMap, this.tGroups,this.tMedals, this.tReputations});

	TopicContentBeanDataU.fromJson(Map<String, dynamic> json) {
		dataMap = new Map();
		tGroups = json['__GROUPS'] != null ? new TopicContentBeanDataUGroups.fromJson(json['__GROUPS']) : null;
		tMedals = json['__MEDALS'] != null ? new TopicContentBeanDataUMedals.fromJson(json['__MEDALS']) : null;
		tReputations = json['__REPUTATIONS'] != null ? new TopicContentBeanDataUReputations.fromJson(json['__REPUTATIONS']) : null;

		json.entries.forEach((entry) {
			if (entry.key != '__GROUPS' && entry.key != '__MEDALS' && entry.key != '__REPUTATIONS') {
				dataMap[entry.key.toString()] =
				new TopicContentBeanDataUid.fromJson(entry.value);
			}
		});
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map.from(dataMap);
		if (this.tGroups != null) {
      data['__GROUPS'] = this.tGroups.toJson();
    }
		if (this.tMedals != null) {
      data['__MEDALS'] = this.tMedals.toJson();
    }
		if (this.tReputations != null) {
      data['__REPUTATIONS'] = this.tReputations.toJson();
    }
		return data;
	}
}

class TopicContentBeanDataUid {
	int rvrc;
	int yz;
	int bitData;
	String signature;
	int groupid;
	String honor;
	int postnum;
	String reputation;
	String avatar;
	int uid;
	String site;
	int money;
	int thisvisit;
	String medal;
	int regdate;
	String nickname;
	String muteTime;
	int credit;
	String username;
	int memberid;

	TopicContentBeanDataUid({this.rvrc, this.yz, this.bitData, this.signature, this.groupid, this.honor, this.postnum, this.reputation, this.avatar, this.uid, this.site, this.money, this.thisvisit, this.medal, this.regdate, this.nickname, this.muteTime, this.credit, this.username, this.memberid});

	TopicContentBeanDataUid.fromJson(Map<String, dynamic> json) {
		rvrc = json['rvrc'];
		yz = json['yz'];
		bitData = json['bit_data'];
		signature = json['signature'].toString();
		groupid = json['groupid'];
		honor = json['honor'];
		postnum = json['postnum'];
		reputation = json['reputation'];
		avatar = json['avatar'].toString();
		uid = json['uid'];
		site = json['site'];
		money = json['money'];
		thisvisit = json['thisvisit'];
		medal = json['medal'].toString();
		regdate = json['regdate'];
		nickname = json['nickname'];
		muteTime = json['mute_time'];
		credit = json['credit'];
		username = json['username'].toString();
		memberid = json['memberid'];
	}

	String toString() {
		return toJson().toString();
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['rvrc'] = this.rvrc;
		data['yz'] = this.yz;
		data['bit_data'] = this.bitData;
		data['signature'] = this.signature;
		data['groupid'] = this.groupid;
		data['honor'] = this.honor;
		data['postnum'] = this.postnum;
		data['reputation'] = this.reputation;
		data['avatar'] = this.avatar;
		data['uid'] = this.uid;
		data['site'] = this.site;
		data['money'] = this.money;
		data['thisvisit'] = this.thisvisit;
		data['medal'] = this.medal;
		data['regdate'] = this.regdate;
		data['nickname'] = this.nickname;
		data['mute_time'] = this.muteTime;
		data['credit'] = this.credit;
		data['username'] = this.username;
		data['memberid'] = this.memberid;
		return data;
	}
}


class TopicContentBeanDataUGroups {

	Map<int,TopicContentBeanDataUGroupsBean> dataMap;

	TopicContentBeanDataUGroups({this.dataMap});

	TopicContentBeanDataUGroups.fromJson(Map<String, dynamic> json) {
		dataMap = new Map();
		json.entries.forEach((entry) {
			dataMap[int.parse(entry.key)] = new TopicContentBeanDataUGroupsBean.fromJson(entry.value);
		});
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map.from(dataMap);
		return data;
	}
}

class TopicContentBeanDataUGroupsBean {

	String level;

	TopicContentBeanDataUGroupsBean({this.level});

	TopicContentBeanDataUGroupsBean.fromJson(Map<String, dynamic> json) {
		level = json['0'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['0'] = level;
		return data;
	}
}

class TopicContentBeanDataUMedals {

	Map<int,TopicContentBeanDataUMedalsBean> dataMap;

	TopicContentBeanDataUMedals({this.dataMap});

	TopicContentBeanDataUMedals.fromJson(Map<String, dynamic> json) {
		dataMap = new Map();
		json.entries.forEach((entry) {
			dataMap[int.parse(entry.key)] = new TopicContentBeanDataUMedalsBean.fromJson(entry.value);
		});
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map.from(dataMap);
		return data;
	}
}

class TopicContentBeanDataUMedalsBean {

	Map<String, dynamic> dataMap;

	TopicContentBeanDataUMedalsBean({this.dataMap});

	TopicContentBeanDataUMedalsBean.fromJson(Map<String, dynamic> json) {
		dataMap = json;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = dataMap;
		return data;
	}
}

class TopicContentBeanDataUReputations {

	Map<int,TopicContentBeanDataUReputationsBean> dataMap;

	TopicContentBeanDataUReputations({this.dataMap});

	TopicContentBeanDataUReputations.fromJson(Map<String, dynamic> json) {
		dataMap = new Map();
		json.entries.forEach((entry) {
			dataMap[int.parse(entry.key)] = new TopicContentBeanDataUReputationsBean.fromJson(entry.value);
		});
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map.from(dataMap);
		return data;
	}
}

class TopicContentBeanDataUReputationsBean {

	Map<String, dynamic> dataMap;

	TopicContentBeanDataUReputationsBean({this.dataMap});

	TopicContentBeanDataUReputationsBean.fromJson(Map<String, dynamic> json) {
		dataMap = json;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map.from(dataMap);
		return data;
	}
}

class TopicContentBeanDataUidBuffs {

	Map<String, dynamic> dataMap;


	TopicContentBeanDataUidBuffs({this.dataMap});

	TopicContentBeanDataUidBuffs.fromJson(Map<String, dynamic> json) {
		dataMap = json;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map.from(dataMap);
		return data;
	}
}

class TopicContentBeanDataT {
	int fid;
	int tpid;
	String subject;
	int quoteFrom;
	String author;
	String quoteTo;
	int postdate;
	int recommend;
	int type;
	int authorid;
	int tid;
	int replies;
	String lastposter;
	int digest;
	int lastpost;
	int locked;
	int thisVisitRows;
	TopicContentBeanDataTPostMiscVar postMiscVar;
	String topicMisc;
	int lastmodify;

	TopicContentBeanDataT({this.fid, this.tpid, this.subject, this.quoteFrom, this.author, this.quoteTo, this.postdate, this.recommend, this.type, this.authorid, this.tid, this.replies, this.lastposter, this.digest, this.lastpost, this.locked, this.thisVisitRows, this.postMiscVar, this.topicMisc, this.lastmodify});

	TopicContentBeanDataT.fromJson(Map<String, dynamic> json) {
		fid = json['fid'];
		tpid = json['tpid'];
		subject = json['subject'];
		quoteFrom = json['quote_from'];
		author = json['author'];
		quoteTo = json['quote_to'].toString();
		postdate = json['postdate'];
		recommend = json['recommend'];
		type = json['type'];
		authorid = json['authorid'];
		tid = json['tid'];
		replies = json['replies'];
		lastposter = json['lastposter'];
		digest = json['digest'];
		lastpost = json['lastpost'];
		locked = json['locked'];
		thisVisitRows = json['this_visit_rows'];
		postMiscVar = json['post_misc_var'] != null ? new TopicContentBeanDataTPostMiscVar.fromJson(json['post_misc_var']) : null;
		topicMisc = json['topic_misc'];
		lastmodify = json['lastmodify'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['fid'] = this.fid;
		data['tpid'] = this.tpid;
		data['subject'] = this.subject;
		data['quote_from'] = this.quoteFrom;
		data['author'] = this.author;
		data['quote_to'] = this.quoteTo;
		data['postdate'] = this.postdate;
		data['recommend'] = this.recommend;
		data['type'] = this.type;
		data['authorid'] = this.authorid;
		data['tid'] = this.tid;
		data['replies'] = this.replies;
		data['lastposter'] = this.lastposter;
		data['digest'] = this.digest;
		data['lastpost'] = this.lastpost;
		data['locked'] = this.locked;
		data['this_visit_rows'] = this.thisVisitRows;
		if (this.postMiscVar != null) {
      data['post_misc_var'] = this.postMiscVar.toJson();
    }
		data['topic_misc'] = this.topicMisc;
		data['lastmodify'] = this.lastmodify;
		return data;
	}
}

class TopicContentBeanDataTPostMiscVar {
	int fid;
	String fromClient;
	int contentLength;

	TopicContentBeanDataTPostMiscVar({this.fid, this.fromClient, this.contentLength});

	TopicContentBeanDataTPostMiscVar.fromJson(Map<String, dynamic> json) {
		fid = json['fid'];
		fromClient = json['from_client'];
		contentLength = json['content_length'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['fid'] = this.fid;
		data['from_client'] = this.fromClient;
		data['content_length'] = this.contentLength;
		return data;
	}
}

class TopicContentBeanDataF {
	String name;

	TopicContentBeanDataF({this.name});

	TopicContentBeanDataF.fromJson(Map<String, dynamic> json) {
		name = json['name'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		return data;
	}
}

class TopicContentBeanDataGlobal {
	String sAttachBaseView;

	TopicContentBeanDataGlobal({this.sAttachBaseView});

	TopicContentBeanDataGlobal.fromJson(Map<String, dynamic> json) {
		sAttachBaseView = json['_ATTACH_BASE_VIEW'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['_ATTACH_BASE_VIEW'] = this.sAttachBaseView;
		return data;
	}
}

class TopicContentBeanDataCu {
	int rvrc;
	int uid;
	int groupBit;
	String admincheck;

	TopicContentBeanDataCu({this.rvrc, this.uid, this.groupBit, this.admincheck});

	TopicContentBeanDataCu.fromJson(Map<String, dynamic> json) {
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
