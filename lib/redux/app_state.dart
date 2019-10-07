import 'package:flutter/widgets.dart';
import 'package:nga_open_source/redux/board/board_state.dart';

import 'user/user_state.dart';

@immutable
class AppState {
  final UserState userState;
  final BoardState boardState;

  AppState({this.userState, this.boardState});

  factory AppState.initial() => AppState(
      userState: UserState.initial(), boardState: BoardState.initial());
}
