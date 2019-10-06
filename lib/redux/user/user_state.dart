import 'package:flutter/widgets.dart';
import 'package:nga_open_source/model/user_model.dart';

@immutable
class UserState {
  final List<UserInfo> userList;

  final int currentUserIndex;

  UserState({this.userList, this.currentUserIndex});

  factory UserState.initial() {
    return UserState(userList: List(), currentUserIndex: 0);
  }

  UserState copyWith({List<UserInfo> userList, int currentUserIndex}) {
    return UserState(userList: userList, currentUserIndex: currentUserIndex);
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
}
