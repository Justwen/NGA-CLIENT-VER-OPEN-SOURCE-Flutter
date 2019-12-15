import "package:flutter/material.dart";
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:nga_open_source/model/topic_post_model.dart';
import 'package:nga_open_source/res/app_colors.dart';
import 'package:nga_open_source/model/BaseForumTask.dart';
import 'package:nga_open_source/utils/utils.dart';
import 'package:nga_open_source/widget/action_menu_widget.dart';
import 'package:nga_open_source/widget/tab_widget.dart';
import 'package:nga_open_source/widget/webview_widget.dart';

class TopicContentWidget extends StatelessWidget {
  final int tid;

  BuildContext context;

  TopicContentModel _topicContentModel = new TopicContentModel();

  TabController tabController;

  TabBar tabBar;

  WebViewEx webView;

  int pageIndex = 1;

  Map<String, Function> _jsMap = new Map();

  TopicContentWidget(this.tid);

  Widget _buildProgressWidget() {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("主题详情"),
        ),
        backgroundColor: AppColors.BACKGROUND_COLOR,
        body: ProgressBarEx());
  }

  Widget _buildContentWidget(TopicContentWrapper data) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("主题详情"),
            bottom: _buildTabBar(data),
            actions: _buildActionMenu()),
        body: _buildWebView(data));
  }

  List<Widget> _buildActionMenu() {
    return <Widget>[
      _buildReplyMenu(ContextUtils.buildContext),
      _buildPopupMenu(ContextUtils.buildContext),
    ];
  }

  Widget _buildReplyMenu(BuildContext context) {
    return ActionMenuIcon(
      onClick: () {
        reply(context, tid);
      },
      text: "回帖",
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
        onSelected: (String value) {
          switch (value) {
            case "menu_favor":
              _topicContentModel.addFavorite(tid, context);
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItemEx.create("menu_favor", '收藏本帖'),
            ]);
  }

  Widget _buildWebView(TopicContentWrapper data) {
    if (webView == null) {
      webView = WebViewEx(
        initialHtml: data.current.htmlContent,
        jsMap: _jsMap,
      );
    } else {
      webView.loadHtml(data.current.htmlContent);
    }
    return webView;
  }

  Widget _buildErrorWidget() {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("主题详情"),
        ),
        backgroundColor: AppColors.BACKGROUND_COLOR,
        body: GestureDetector(
          onTap: () => _topicContentModel.loadContent(tid, pageIndex),
          child: Center(child: Text("加载失败,请点击重试")),
        ));
  }

  void initState() {
    _topicContentModel.loadContent(tid, pageIndex);
    _jsMap["flutterShowToast"] = ToastUtils.showToast;
    _jsMap["flutterReply"] = flutterReply;
  }

  void flutterReply(String index) {
    reply(context, tid,
        entity:
            _topicContentModel.bloc.bean.current.contentList[int.parse(index)]);
  }

  @override
  Widget build(BuildContext context) {
    ContextUtils.buildContext = context;
    if (this.context == null) {
      this.context = context;
      initState();
    }
    print("build!!!!");
    return StreamBuilder<TopicContentWrapper>(
        stream: _topicContentModel.bloc.data,
        initialData: null,
        builder: (BuildContext context,
            AsyncSnapshot<TopicContentWrapper> snapshot) {
          return snapshot.data == null
              ? _buildProgressWidget()
              : snapshot.data.errorMsg != null
                  ? _buildErrorWidget()
                  : _buildContentWidget(snapshot.data);
        });
  }

  Widget _buildTabBar(TopicContentWrapper data) {
    return TabWidget(
      isScrollable: true,
      onTap: (index) {
        pageIndex = index + 1;
        _topicContentModel.loadContent(tid, pageIndex);
      },
      tabCount: data.totalPage,
      tabBuilder: (context, i) {
        return new Container(
            height: 36.0,
            width: 36,
            alignment: Alignment.center,
            child: Text((i + 1).toString()));
      },
    );
  }
}
