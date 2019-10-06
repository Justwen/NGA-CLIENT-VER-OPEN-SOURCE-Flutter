import 'dart:convert';

import 'package:nga_open_source/model/user_model.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAddAction {
  List<UserInfo> userList;

  UserAddAction(this.userList);
}

class UserSwitchAction {
  int index;

  UserSwitchAction(this.index);
}

class UserInitAction {
//  List<UserInfo> userList;
//
//  int index;
//
//  UserInitAction(this.userList, this.index);

//  static final void Function(Store store) action = userInitAction;
//
//  static void userInitAction(Store store) async {
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    String data = sp.getString("user");
//    if (data != null) {
//      List<dynamic> list = jsonDecode(data);
//      if (list != null) {
//        List<UserInfo> userList = new List();
//        list.forEach((item) {
//          userList.add(UserInfo.fromJson(item));
//        });
//        print(userList.toString());
//        int index = sp.getInt("user_index") ?? 0;
//        store.dispatch(UserInitAction(userList, index));
//      }
//    }
//  }
}
