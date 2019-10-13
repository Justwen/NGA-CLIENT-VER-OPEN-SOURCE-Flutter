import 'package:redux/redux.dart';

import 'board_action.dart';
import 'board_state.dart';

final boardReducer = combineReducers<BoardState>([
  TypedReducer<BoardState, BoardInitAction>(_initBoards),
  TypedReducer<BoardState, BoardAddAction>(_addBookmark),
  TypedReducer<BoardState, BoardRemoveAction>(_removeBookmark),
]);

BoardState _initBoards(BoardState state, action) => state.copyWith(
    boardCategoryList: action.boardCategoryList,
    bookmarkCategory: action.boardCategoryList[0]);

BoardState _addBookmark(BoardState state, action) =>
    state.addBookmark(action.board);

BoardState _removeBookmark(BoardState state, action) =>
    state.removeBookmark(action.board);
