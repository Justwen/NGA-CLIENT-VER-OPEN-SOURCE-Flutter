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

  @override
  bool operator ==(other) {
    return other is UserInfo && uName == other.uName && uid == other.uid;
  }

  @override
  int get hashCode => int.parse(uid);
}
