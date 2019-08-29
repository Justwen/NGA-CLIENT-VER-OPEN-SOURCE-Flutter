import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static UserModel _sInstance;

  List<UserInfo> userList;

  SharedPreferences preferences;

  static UserModel getInstance() {
    if (_sInstance == null) {
      _sInstance = new UserModel();
    }
    return _sInstance;
  }

  UserModel() {
    _initialize();
  }

  _initialize() async {
    preferences = await SharedPreferences.getInstance();
    userList = new List();
    String data = preferences.getString("user");
    if (data != null) {
      List<dynamic> list = jsonDecode(data);
      if (list != null) {
        list.forEach((item) {
          userList.add(UserInfo.fromJson(item));
        });
      }
    }
    print(userList.toString());
  }

  void addUser(String uName, String uid, String cid) {
    for (UserInfo user in userList) {
      if (user.uid == uid && user.uName == uName) {
        return;
      }
    }
    userList.add(new UserInfo(uName, uid, cid));
    _save();
  }

  bool isEmpty() {
    return userList.isEmpty;
  }

  String getCookie() {
    if (!isEmpty()) {
      return "ngaPassportUid=${userList[0].uid}; ngaPassportCid=${userList[0].cid}";
    } else {
      return "";
    }
  }

  void _save() {
    String data = jsonEncode(userList);
    print(data);
    preferences.setString("user", data);
  }
}

class UserInfo {
  UserInfo(this.uName, this.uid, this.cid);

  String uName;

  String uid;

  String cid;

  Map toJson() {
    Map map = new Map();
    map["uName"] = this.uName;
    map["uid"] = this.uid;
    map["cid"] = this.cid;
    return map;
  }

  factory UserInfo.fromJson(Map<String, dynamic> srcJson) {
    UserInfo userInfo =
        new UserInfo(srcJson["uName"], srcJson["uid"], srcJson["cid"]);
    return userInfo;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
