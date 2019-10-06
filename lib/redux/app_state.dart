import 'package:flutter/widgets.dart';

import 'user/user_state.dart';

@immutable
class AppState {
  final UserState userState;

  AppState({this.userState});

  factory AppState.initial() => AppState(userState: UserState.initial());
}
