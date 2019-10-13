import 'package:nga_open_source/model/entity/board_info.dart';

class BoardInitAction {
  List<BoardCategory> boardCategoryList;
}

class BoardAddAction {
  Board board;

  BoardAddAction(this.board);
}

class BoardRemoveAction {
  Board board;

  BoardRemoveAction(this.board);
}
