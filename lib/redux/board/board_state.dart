import 'package:flutter/widgets.dart';
import 'package:nga_open_source/model/entity/board_info.dart';

@immutable
class BoardState {
  final List<Category> categoryList;

  BoardState({this.categoryList});

  factory BoardState.initial() => BoardState(categoryList: new List());

  BoardState copyWith({List<Category> categoryList}) =>
      BoardState(categoryList: categoryList ?? new List());
}
