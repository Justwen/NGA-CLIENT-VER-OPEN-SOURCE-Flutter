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

  void addUser(String uName, String uid) {
    for (UserInfo user in userList) {
       if (user.uid == uid && user.uName == uName) {
         return;
       }

    }
    userList.add(new UserInfo(uName,uid));
  }

  bool isEmpty() {
    return userList.isEmpty;
  }
}

class UserInfo {

  UserInfo(this.uName, this.uid);

  String uName;

  String uid;
}
