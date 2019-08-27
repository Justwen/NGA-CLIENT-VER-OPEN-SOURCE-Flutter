import 'package:flutter/material.dart';
import 'package:nga_open_source/common/component_index.dart';

import 'model/board_model.dart';
import 'model/topic_model.dart';

class TopicListWidget extends StatelessWidget {
  final Board board;

  TopicListWidget(this.board);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(board.name),
        ),
        body: _TopicListContentWidget(board));
  }
}

class _TopicListContentWidget extends StatefulWidget {
  final Board board;

  _TopicListContentWidget(this.board);

  @override
  State<StatefulWidget> createState() {
    return _TopicListContentState();
  }
}

class _TopicListContentState extends State<_TopicListContentWidget> {
  @override
  Widget build(BuildContext context) {
    return ProgressBarEx();
  }

  @override
  void initState() {
    TopicModel().loadPage(widget.board, 1, () {});
    super.initState();
  }
}
