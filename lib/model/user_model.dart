import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static UserModel _sInstance;

  List<UserInfo> userList;

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
    SharedPreferences sp = await SharedPreferences.getInstance();
    String data = sp.getString("user");
    List<dynamic> list = jsonDecode(data);
    userList = new List();
    list.forEach((item) {
      userList.add(UserInfo.fromJson(item));
    });
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

  void _save() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String data = jsonEncode(userList);
    print(data);
    sp.setString("user", data);
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
    map["value"] = this.cid;
    map["cid"] = this.cid;
    return map;
  }

  factory UserInfo.fromJson(Map<String, dynamic> srcJson) {
    UserInfo userInfo =
        new UserInfo(srcJson["uName"], srcJson["value"], srcJson["cid"]);
    return userInfo;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
