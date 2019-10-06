import 'package:nga_open_source/redux/user/user_action.dart';
import 'package:nga_open_source/redux/user/user_state.dart';
import 'package:redux/redux.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UserAddAction>(_addUser),
  TypedReducer<UserState, UserSwitchAction>(_switchUser),
  TypedReducer<UserState, UserInitAction>(_initUser),
]);

UserState _addUser(UserState state, action) {
  state.userList.add(action.userInfo);
  return state.copyWith(
      userList: state.userList);
}

UserState _switchUser(UserState state, action) {
  return  state.copyWith(userList: state.userList, currentUserIndex: action.index);
}

UserState _initUser(UserState state, action) {
  return state.copyWith(
      userList: action.userList ?? state.userList,
      currentUserIndex: action.index ?? state.currentUserIndex);
}
