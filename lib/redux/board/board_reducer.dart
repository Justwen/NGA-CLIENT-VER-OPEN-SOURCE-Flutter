import 'package:redux/redux.dart';

import 'board_action.dart';
import 'board_state.dart';

final boardReducer = combineReducers<BoardState>([
  TypedReducer<BoardState, BoardInitAction>(_initBoards),
]);

BoardState _initBoards(BoardState state, action) =>
    state.copyWith(categoryList: action.categoryList);
