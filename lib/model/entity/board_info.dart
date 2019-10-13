import 'package:flutter/widgets.dart';

class Board {
  int fid = 0;

  int stid = 0;

  String name;

  Board({this.fid, this.stid, @required this.name});

  factory Board.fromJson(Map<String, dynamic> srcJson) {
    return Board(fid: srcJson["fid"], stid : srcJson["stid"], name : srcJson["name"]);
  }
}

class BoardCategory {
  List<Board> boards;

  String name;

  BoardCategory(this.name) {
    boards = new List();
  }

  bool contains(Board board) {
    return boards.contains(board);
  }

  BoardCategory add(Board board) {
    if (!contains(board)) {
      boards.add(board);
    }
    return this;
  }

  BoardCategory remove(Board board) {
    if (contains(board)) {
      boards.remove(board);
    }
    return this;
  }
}
