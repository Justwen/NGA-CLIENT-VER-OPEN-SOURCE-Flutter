import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/model/entity/topic_title_info.dart';
import 'package:nga_open_source/res/app_colors.dart';
import 'package:nga_open_source/utils/utils.dart';
import 'package:nga_open_source/widget/empty_widget.dart';
import 'package:nga_open_source/widget/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import 'package:toast/toast.dart' as prefix0;

import '../model/entity/board_info.dart';
import '../model/topic_title_model.dart';
import 'topic_content_page.dart';

class TopicTitleWidget extends StatelessWidget {
  final Board board;

  TopicTitleWidget(this.board);

  @override
  Widget build(BuildContext context) {
    ContextUtils.buildContext = context;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(board.name),
        ),
        backgroundColor: AppColors.BACKGROUND_COLOR,
        body: _TopicTitleContainer(board));
  }
}

class _TopicTitleContainer extends StatelessWidget {
  final Board board;

  final TopicTitleModel topicModel = new TopicTitleModel();

  _TopicTitleContainer(this.board) {
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TopicTitleWrapper>(
        stream: topicModel.bloc.data,
        initialData: null,
        builder:
            (BuildContext context, AsyncSnapshot<TopicTitleWrapper> snapshot) {
          return _buildTopicTitleContainer(context, snapshot.data);
        });
  }

  Widget _buildTopicTitleContainer(
      BuildContext context, TopicTitleWrapper wrapper) {
    if (wrapper == null) {
      return ProgressBarEx();
    } else if (wrapper.data.isNotEmpty) {
      return _buildTopicList(context, wrapper);
    } else {
      return EmptyWidget(() {
        topicModel.loadAgain(board, 1);
      });
    }
  }

  Widget _buildTopicList(BuildContext context, TopicTitleWrapper wrapper) {
    return PullToRefreshWidget(wrapper.data, (context, i) {
      return _buildTopicListItem(context, wrapper.data[i]);
    }, refresh: () => _handleRefresh(), loadMore: () => _handleLoadMore());
  }

  Future<Null> _handleRefresh() async {
    topicModel.loadPage(board, 1, reset: true);
  }

  bool _handleLoadMore() {
    if (topicModel.hasNextPage()) {
      topicModel.loadNextPage(board);
      return true;
    } else {
      return false;
    }
  }

  Widget _buildTopicListItem(BuildContext context, TopicTitleInfo entity) {
    return InkWell(
        onTap: () {
          _showTopicContentPage(context, entity.tid);
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

  void _showTopicContentPage(BuildContext context, int tid) {
    Widget nextWidget = TopicContentWidget(tid);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => nextWidget));
  }
}
