import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nga_open_source/model/bean/board_bean.dart';
import 'package:nga_open_source/model/entity/board_info.dart';
import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/board/board_action.dart';
import 'package:nga_open_source/redux/board/board_state.dart';
import 'package:nga_open_source/utils/sp_utils.dart';
import 'package:redux/redux.dart';

class BoardMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is BoardInitAction) {
      _initBoards(store, action, next);
    } else if (action is BoardAddAction || action is BoardRemoveAction) {
      next(action);
      _saveBookmarkBoards(store);
    } else {
      next(action);
    }
  }

  void _saveBookmarkBoards(Store<AppState> store) {
    BoardState state = store.state.boardState;
    BoardCategory boardCategory = state.getBookmarkBoards();
    PreferenceUtils.setString("board_bookmark", boardCategory.toString());
  }

  Future<Null> _initBoards(
      Store<AppState> store, action, NextDispatcher next) async {
    String value = await rootBundle.loadString('assets/data/category_old.json');
    List list = json.decode(value);
    List<BoardBean> boardBean = getBoardBeanList(list);
    List<BoardCategory> categoryList = new List();

    categoryList.add(_getBookmarkCategory());

    for (BoardBean bean in boardBean) {
      BoardCategory category = new BoardCategory(bean.name);
      for (Content content in bean.content) {
        Board board = new Board(
            fid: content.fid != null ? content.fid : 0,
            stid: content.stid != null ? content.stid : 0,
            name: content.nameS != null ? content.nameS : content.name);
        category.boards.add(board);
      }
      categoryList.add(category);
    }
    action.boardCategoryList = categoryList;
    next(action);
  }

  BoardCategory _getBookmarkCategory() {
    BoardCategory bookmarkCategory = BoardCategory("我的收藏");
    String boardStr = PreferenceUtils.getString("board_bookmark", null);
    print(boardStr);
    if (boardStr != null) {
      List<dynamic> list = json.decode(boardStr);
      if (list != null && list.isNotEmpty) {
        list.forEach((item) {
          bookmarkCategory.add(Board.fromJson(item));
        });
      }
    }
    return bookmarkCategory;
  }
}
