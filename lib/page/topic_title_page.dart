import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nga_open_source/bloc/list_view_bloc.dart';
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/model/entity/topic_title_info.dart';
import 'package:nga_open_source/model/topic_post_model.dart';
import 'package:nga_open_source/page/post_page.dart';
import 'package:nga_open_source/redux/app_redux.dart';
import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/board/board_action.dart';
import 'package:nga_open_source/res/app_colors.dart';
import 'package:nga_open_source/res/app_theme.dart';
import 'package:nga_open_source/utils/utils.dart';
import 'package:nga_open_source/widget/empty_widget.dart';
import 'package:nga_open_source/widget/floating_action_button.dart';
import 'package:nga_open_source/widget/flutter_widget_ex.dart';
import 'package:nga_open_source/widget/popup_menu.dart';
import 'package:nga_open_source/widget/pull_to_refresh.dart';

import '../model/entity/board_info.dart';
import '../model/topic_title_model.dart';
import 'topic_content_page.dart';

class TopicTitleWidget extends StatelessWidget {
  final Board board;

  final ListViewBloc _bloc = new ListViewBloc();

  final ScrollController scrollController = new ScrollController();

  TopicTitleWidget(this.board);

  @override
  Widget build(BuildContext context) {
    ContextUtils.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: _buildTitleWidget(board),
        actions: _buildActionMenu(),
      ),
      backgroundColor: AppColors.BACKGROUND_COLOR,
      body: _buildBodyWidget(),
      floatingActionButton: _buildFabWidget(context),
    );
  }

  Widget _buildBodyWidget() {
    return _TopicTitleContainer(
      board,
      bloc: _bloc,
      scrollController: scrollController,
    );
  }

  Widget _buildTitleWidget(Board board) {
    return Text(board.recommend ? "${board.name} - 精华区" : board.name);
  }

  Widget _buildFabWidget(BuildContext context) {
    return AnimationFab(
      bloc: _bloc,
      icons: <Widget>[Icon(Icons.refresh), Icon(Icons.add)],
      callbacks: [
        () => scrollController.jumpTo(-1),
        () => Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => PostWidget(
                      TopicPostParam.TOPIC_POST_ACTION_NEW,
                      fid: board.fid,
                    ))),
      ],
    );
  }

  List<Widget> _buildActionMenu() {
    return <Widget>[
      _buildBookmarkIcon(board),
      _buildPopupMenu(ContextUtils.buildContext),
    ];
  }

  Widget _buildBookmarkIcon(Board board) {
    return StoreConnector<AppState, bool>(
      converter: (store) => store.state.boardState.isBookmarkBoard(board),
      builder: (context, isBookmark) {
        return GestureDetector(
          onTap: () {
            AppRedux.dispatch(
                isBookmark ? BoardRemoveAction(board) : BoardAddAction(board));
          },
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(
              ResourceUtils.getDrawable(
                  isBookmark ? "ic_star_on" : "ic_star_off"),
              width: 24,
              height: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
        onSelected: (String value) {
          switch (value) {
            case "menu_recommend":
              _navigateRecommendTopicList(context);
              break;
            case "menu_favor":
              _navigateFavorTopicList(context);
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItemEx.create("menu_recommend", '精华区'),
              new PopupMenuItemEx.create("menu_favor", '收藏夹'),
            ]);
  }

  void _navigateRecommendTopicList(BuildContext context) {
    Board nextParam = board.copyWith(recommend: true);
    Widget nextWidget = new TopicTitleWidget(nextParam);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => nextWidget));
  }

  void _navigateFavorTopicList(BuildContext context) {
    Board nextParam = board.copyWith(favor: true);
    Widget nextWidget = new TopicTitleWidget(nextParam);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => nextWidget));
  }
}

class _TopicTitleContainer extends StatelessWidget {
  final Board board;

  final TopicTitleModel topicModel = new TopicTitleModel();

  final ListViewBloc bloc;

  PullToRefreshWidget pullToRefreshWidget;

  final ScrollController scrollController;

  _TopicTitleContainer(this.board, {this.bloc, this.scrollController}) {
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
    pullToRefreshWidget = PullToRefreshWidget(
      wrapper.data,
      (context, i) {
        return _buildTopicListItem(context, wrapper.data[i]);
      },
      refresh: () => _handleRefresh(),
      loadMore: () => _handleLoadMore(),
      bloc: bloc,
      scrollController: scrollController,
    );
    return pullToRefreshWidget;
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
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0.5, color: Color(0xAA9E9E9E)))),
          padding: EdgeInsets.only(left: 14, right: 14, top: 16, bottom: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildTitleRichText(entity),
            ),
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
                _buildAuthorName(entity),
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
                  style: CommonTextStyle.TOPIC_SUB_TITLE,
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
                  style: CommonTextStyle.TOPIC_SUB_TITLE,
                ),
              ],
            )
          ]),
        ));
  }

  static List<Function> _buildRichTitleMethods = [
    _buildTitleLocked,
    _buildTitleAssemble,
    _buildTitleParentBoard,
    _buildTitleComplete,
  ];

  Widget _buildTitleRichText(TopicTitleInfo info) {
    return RichText(
        text: TextSpan(
      text: info.title,
      style: info.titleStyle,
      children: [_buildRichTitleMethods[0](info, 0)],
    ));
  }

  static TextSpan _buildTitleParentBoard(TopicTitleInfo info, int index) {
    String text =
        StringUtils.isEmpty(info.parentBoard) ? null : " [${info.parentBoard}]";
    var next = _buildRichTitleMethods[index + 1];
    return StringUtils.isEmpty(text)
        ? next(info, index + 1)
        : TextSpan(
            text: text,
            style: TextStyleEx(
                color: Color(0xFFC4BEAE), decoration: TextDecoration.none),
            children: [next(info, index + 1)]);
  }

  static TextSpan _buildTitleLocked(TopicTitleInfo info, int index) {
    String text = info.isLocked ? " [锁定]" : null;
    var next = _buildRichTitleMethods[index + 1];
    return StringUtils.isEmpty(text)
        ? next(info, index + 1)
        : TextSpan(
            text: text,
            style: TextStyleEx(color: Colors.red),
            children: [next(info, index + 1)]);
  }

  static TextSpan _buildTitleAssemble(TopicTitleInfo info, int index) {
    String text = info.isAssemble ? " [合集]" : null;
    var next = _buildRichTitleMethods[index + 1];
    return StringUtils.isEmpty(text)
        ? next(info, index + 1)
        : TextSpan(
            text: text,
            style: TextStyleEx(color: Colors.blue),
            children: [next(info, index + 1)]);
  }

  static TextSpan _buildTitleComplete(TopicTitleInfo info, int index) {
    return TextSpan(text: "");
  }

  void _showTopicContentPage(BuildContext context, int tid) {
    Widget nextWidget = TopicContentWidget(tid);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => nextWidget));
  }

  Widget _buildAuthorName(TopicTitleInfo info) {
    return RichText(
        text: TextSpan(
      text: info.author,
      style: CommonTextStyle.TOPIC_SUB_TITLE,
      children: [_buildAnonyName(info)],
    ));
  }

  TextSpan _buildAnonyName(TopicTitleInfo info) {
    String text = info.isAnonymous ? " (匿名)" : "";
    return TextSpan(
        text: text, style: TextStyle(color: Colors.red, fontSize: 12));
  }
}
