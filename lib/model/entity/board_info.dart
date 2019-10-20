import 'dart:convert';

import 'package:flutter/widgets.dart';

class Board {
  int fid = 0;

  int stid = 0;

  String name;

  Board({this.fid, this.stid, @required this.name});

  factory Board.fromJson(Map<String, dynamic> srcJson) {
    return Board(fid: srcJson["fid"], stid : srcJson["stid"], name : srcJson["name"]);
  }

  Map toJson() {
    Map map = new Map();
    map["fid"] = this.fid;
    map["stid"] = this.stid;
    map["name"] = this.name;
    return map;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  @override
  bool operator ==(other) {
    return other is Board && fid == other.fid && stid == other.stid;
  }

  @override
  int get hashCode => _getHashCode();

  int _getHashCode() {
    if (stid != 0) {
      return "stid=$stid".hashCode;
    } else {
      return "fid=$fid".hashCode;
    }
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

  Map toJson() {
    Map map = new Map();
    map["name"] = name;
    map["boards"] = boards.toString();
    return map;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory BoardCategory.fromJson(Map srcJson) {

    BoardCategory category = new BoardCategory(srcJson["name"]);

    List list = jsonDecode(srcJson["boards"]);

    list.forEach((data) {
      category.add(Board.fromJson(data));
    });

    return category;

  }
}
