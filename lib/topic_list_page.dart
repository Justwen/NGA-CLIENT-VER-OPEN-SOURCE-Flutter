import 'package:flutter/material.dart';
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/topic_content_page.dart';

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
  List<TopicEntity> list;

  TopicModel topicModel = new TopicModel();

  @override
  Widget build(BuildContext context) {
    return list == null || list.isEmpty ? ProgressBarEx() : _buildTopicList();
  }

  Widget _buildTopicList() {
    return new RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: ListView.builder(
            itemCount: list.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return _buildTopicListItem(list[i]);
            }));
  }

  Future<Null> _handleRefresh() async {
    List data = await topicModel.loadPage(widget.board, 1);
      setState(() {
        list = data;
      });
    return null;
  }

  Widget _buildTopicListItem(TopicEntity entity) {
    return InkWell(
        onTap: () {
          _showTopicContentPage(entity.tid);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            entity.title,
            style: TextStyle(fontSize: 17),
          ),
        ));
  }

  void _showTopicContentPage(int tid) {
    Widget nextWidget = TopicContentWidget(tid);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => nextWidget));
  }

  @override
  void initState() {
    _handleRefresh();
    super.initState();
  }
}
