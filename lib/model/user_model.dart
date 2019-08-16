class UserModel {
  static UserModel _sInstance;

  List<UserInfo> userList = new List();

  static UserModel getInstance() {
    if (_sInstance == null) {
      _sInstance = new UserModel();
    }
    return _sInstance;
  }

  UserModel() {
    _initialize();
  }

  _initialize() {}

  void addUser(String uName, String uid, String cid) {
    for (UserInfo user in userList) {
      if (user.uid == uid && user.uName == uName) {
        return;
      }
    }
    userList.add(new UserInfo(uName, uid, cid));
  }

  bool isEmpty() {
    return userList.isEmpty;
  }

  String getCookie() {
    if (!isEmpty()) {
      return "ngaPassportUid=${userList[0].uid}";
    } else {
      return "";
    }
  }
}

class UserInfo {
  UserInfo(this.uName, this.uid, this.cid);

  String uName;

  String uid;

  String cid;
}
