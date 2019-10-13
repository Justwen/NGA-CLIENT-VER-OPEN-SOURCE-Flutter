import 'package:flutter/widgets.dart';
import 'package:nga_open_source/model/entity/board_info.dart';

@immutable
class BoardState {
  final List<BoardCategory> boardCategoryList;

  final BoardCategory bookmarkCategory;

  BoardState({this.boardCategoryList, this.bookmarkCategory});

  factory BoardState.initial() => BoardState(boardCategoryList: new List());

  BoardState copyWith(
          {List<BoardCategory> boardCategoryList,
          BoardCategory bookmarkCategory}) =>
      BoardState(
          boardCategoryList: boardCategoryList ?? new List(),
          bookmarkCategory: bookmarkCategory);

  BoardState addBookmark(Board board) => copyWith(
      boardCategoryList: boardCategoryList,
      bookmarkCategory: bookmarkCategory.add(board));

  BoardState removeBookmark(Board board) => copyWith(
      boardCategoryList: boardCategoryList,
      bookmarkCategory: bookmarkCategory.remove(board));

  bool isBookmarkBoard(Board board) => bookmarkCategory.contains(board);

  BoardCategory getBookmarkBoards() => bookmarkCategory;
}
