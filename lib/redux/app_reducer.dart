import 'package:nga_open_source/redux/app_state.dart';

import 'user/user_reducer.dart';

AppState reducer(AppState state, action) {
  return AppState(userState: userReducer(state.userState, action));
}
