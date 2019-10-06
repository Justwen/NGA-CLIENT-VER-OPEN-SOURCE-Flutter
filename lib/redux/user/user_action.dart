import 'package:nga_open_source/model/entity/user_info.dart';

class UserAddAction {
  UserInfo userInfo;

  UserAddAction(this.userInfo);
}

class UserSwitchAction {
  int index;

  UserSwitchAction(this.index);
}

class UserInitAction {
  List<UserInfo> userList;

  int index;

}
