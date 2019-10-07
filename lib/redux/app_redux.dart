import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/board/board_middleware.dart';
import 'package:redux/redux.dart';

import 'app_reducer.dart';
import 'board/board_state.dart';
import 'user/user_middleware.dart';
import 'user/user_state.dart';

class AppRedux {
  static final Store<AppState> store = Store<AppState>(reducer,
      initialState: AppState.initial(), middleware: [UserMiddleware(),BoardMiddleware()]);

  static AppState get appState => store.state;

  static UserState get userState => appState.userState;

  static BoardState get boardState => appState.boardState;

  static void dispatch(action) => store.dispatch(action);
}
