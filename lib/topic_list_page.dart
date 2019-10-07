import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/res/app_colors.dart';
import 'package:nga_open_source/topic_content_page.dart';

import 'model/entity/board_info.dart';
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
        backgroundColor: AppColors.BACKGROUND_COLOR,
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
          padding: EdgeInsets.only(left: 14, right: 14, top: 16, bottom: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  entity.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17),
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Image.asset(
                      ResourceUtils.getDrawable("ic_persion"),
                      width: 15,
                      height: 15,
                    )),
                Text(
                  entity.author,
                  style: TextStyle(fontSize: 12),
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Image.asset(
                      ResourceUtils.getDrawable("ic_time"),
                      width: 15,
                      height: 15,
                    )),
                Text(
                  entity.lastReplyTime,
                  style: TextStyle(fontSize: 12),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    child: Image.asset(
                      ResourceUtils.getDrawable("ic_reply_count"),
                      width: 15,
                      height: 15,
                    )),
                Text(
                  entity.replyCount.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            )
          ]),
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
