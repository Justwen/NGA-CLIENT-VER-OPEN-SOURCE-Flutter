import 'dart:convert';

import 'package:nga_open_source/model/user_model.dart';
import 'package:nga_open_source/redux/user/user_action.dart';
import 'package:nga_open_source/redux/user/user_state.dart';
import 'package:nga_open_source/utils/sp_utils.dart';
import 'package:redux/redux.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UserAddAction>(_addUser),
  TypedReducer<UserState, UserSwitchAction>(_switchUser),
  TypedReducer<UserState, UserInitAction>(_initUser),
]);

UserState _addUser(UserState state, action) {
  action.userList.forEach((userInfo) {
    if (!state.userList.contains(userInfo)) {
      state.userList.add(userInfo);
    }
  });
  UserState newState = state.copyWith(
    userList: state.userList,
  );
  String data = jsonEncode(newState.userList);
  PreferenceUtils.setString("user", data);
  return newState;
}

UserState _switchUser(UserState state, action) {
  UserState newState =
      state.copyWith(userList: state.userList, currentUserIndex: action.index);
  PreferenceUtils.setInt("user_index", newState.currentUserIndex);
  return newState;
}

UserState _initUser(UserState state, action) {
  String data = PreferenceUtils.getString("user", null);
  int index;
  print(data);
  List<UserInfo> userList;
  if (data != null) {
    List<dynamic> list = jsonDecode(data);
    if (list != null) {
      userList = new List();
      list.forEach((item) {
        userList.add(UserInfo.fromJson(item));
      });
      print(userList.toString());
      index = PreferenceUtils.getInt("user_index", null);
    }
  }
  return state.copyWith(
      userList: userList ?? state.userList,
      currentUserIndex: index ?? state.currentUserIndex);
}
