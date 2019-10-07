import 'package:flutter/widgets.dart';

class Board {
  int fid = 0;

  int stid = 0;

  String name;

  Board({this.fid, this.stid, @required this.name});
}

class Category {
  List<Board> boards;

  String name;

  Category(this.name) {
    boards = new List();
  }
}