import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nga_open_source/model/bean/board_bean.dart';
import 'package:nga_open_source/model/entity/board_info.dart';
import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/board/board_action.dart';
import 'package:redux/redux.dart';

class BoardMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is BoardInitAction) {
      _initBoards(store, action, next);
    } else {
      next(action);
    }
  }

  Future<Null> _initBoards(
      Store<AppState> store, action, NextDispatcher next) async {
    String value = await rootBundle.loadString('assets/data/category_old.json');
    List list = json.decode(value);
    List<BoardBean> boardBean = getBoardBeanList(list);
    List<Category> categoryList = new List();
    for (BoardBean bean in boardBean) {
      Category category = new Category(bean.name);
      for (Content content in bean.content) {
        Board board = new Board(
            fid: content.fid != null ? content.fid : 0,
            stid: content.stid != null ? content.stid : 0,
            name: content.nameS != null ? content.nameS : content.name);
        category.boards.add(board);
      }
      categoryList.add(category);
    }
    print("cLength = " + categoryList.length.toString());
    action.categoryList = categoryList;
    next(action);
  }
}
