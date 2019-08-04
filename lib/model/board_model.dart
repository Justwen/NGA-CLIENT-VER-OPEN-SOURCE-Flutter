import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bean/board_bean.dart';

class BoardManager {
  static BoardManager _sInstance;

  List<Category> _categoryList = List();

  static BoardManager getInstance() {
    if (_sInstance == null) {
      _sInstance = new BoardManager();
    }
    return _sInstance;
  }

  List<Category> initData(Function callback) {
    _categoryList.clear();
    rootBundle.loadString('assets/data/category_old.json').then((value) {
      List list = json.decode(value);
      List<BoardBean> boardBean = getBoardBeanList(list);
      for (BoardBean bean in boardBean) {
        Category category = new Category(bean.name);

        for (Content content in bean.content) {
          Board board = new Board(content.fid,
              content.nameS != null ? content.nameS : content.name);
          board.stid = content.stid;
          category.boards.add(board);
        }
        _categoryList.add(category);
      }
      callback();
    });
    return _categoryList;
  }

  List<Category> getBoardCategory() {
    return _categoryList;
  }
}

class Category {
  List<Board> boards;

  String name;

  Category(this.name) {
    boards = new List();
  }
}

class Board {
  int fid;

  int stid;

  String name;

  Board(this.fid, this.name);
}
