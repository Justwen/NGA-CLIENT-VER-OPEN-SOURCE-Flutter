import 'package:nga_open_source/bloc/base_bloc.dart';

enum ScrollState {
  SCROLL_DOWN,
  SCROLL_UP,
}

class ListViewBloc extends BaseBloc<ScrollState> {
  void scrollDown() {
    bean = ScrollState.SCROLL_DOWN;
    notifyDataChanged();
  }

  void scrollUp() {
    bean = ScrollState.SCROLL_UP;
    notifyDataChanged();
  }
}
