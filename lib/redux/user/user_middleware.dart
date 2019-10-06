import 'dart:convert';
import 'dart:core';

import 'package:nga_open_source/model/entity/user_info.dart';
import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/user/user_action.dart';
import 'package:nga_open_source/utils/sp_utils.dart';
import 'package:redux/redux.dart';

class UserMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is UserInitAction) {
      _initUsers(store, action, next);
    } else if (action is UserAddAction) {
      _addUser(store, action, next);
    } else if (action is UserSwitchAction) {
      _switchUser(store, action, next);
    } else {
      next(action);
    }
  }

  void _switchUser(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    PreferenceUtils.setInt("user_index", store.state.userState.currentUserIndex);
  }

  void _addUser(Store<AppState> store, action, NextDispatcher next) {
    var state = store.state.userState;
    if (!state.userList.contains(action.userInfo)) {
      next(action);
      String data = jsonEncode(store.state.userState.userList);
      PreferenceUtils.setString("user", data);
    }
  }

  Future<Null> _initUsers(Store<AppState> store, action, NextDispatcher next) async {
    await PreferenceUtils.init();
    String data = PreferenceUtils.getString("user", null);
    if (data != null) {
      List<dynamic> list = jsonDecode(data);
      if (list != null && list.isNotEmpty) {
        List<UserInfo> userList = new List();
        list.forEach((item) {
          userList.add(UserInfo.fromJson(item));
        });
        print(userList.toString());
        int index = PreferenceUtils.getInt("user_index", 0);
        action.userList = userList;
        action.index = index;
        next(action);
      }
    }
  }

}