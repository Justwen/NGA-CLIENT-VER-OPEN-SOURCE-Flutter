import 'dart:convert';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:nga_open_source/plugin/WebViewPlugin.dart';
import 'package:nga_open_source/post_page.dart';
import 'package:nga_open_source/res/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TopicContentWidget extends StatefulWidget {
  final int tid;

  TopicContentEntity entity;

  TabController tabController;

  PageController pageController;

  _TopicContentWidget _topicContentWidget;

  TopicContentWidget(this.tid);

  @override
  State<StatefulWidget> createState() {
    return new TopicContentState();
  }
}

class TopicContentState extends State<TopicContentWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.entity == null) {
      new TopicContentModel().loadContent(widget.tid, 1, (data) {
        setState(() {
          widget.entity = data;
        });
      });
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("主题详情"),
          ),
          backgroundColor: AppColors.BACKGROUND_COLOR,
          body: ProgressBarEx());
    } else {
      widget.pageController = new PageController(keepPage: false);
      widget._topicContentWidget = new _TopicContentWidget(widget.tid, 1,
          topicContentEntity: widget.entity);
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("主题详情"),
            bottom: _buildTabBar(),
            actions: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context, new MaterialPageRoute(builder: (context) => PostWidget(widget.tid,"reply")));
                  },
                  child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(
                        child: Text(
                          "回帖",
                          style: TextStyle(fontSize: 18),
                        ),
                      ))),
            ],
          ),
          body: widget._topicContentWidget);
    }
  }

  Widget _buildTabBar() {
    widget.tabController =
        new TabController(length: widget.entity.totalPage, vsync: this);
    var tabs = new List<Container>();
    for (int i = 0; i < widget.entity.totalPage; i++) {
      tabs.add(new Container(
        height: 36.0,
        width: 36,
        alignment: Alignment.center,
        child: Text((i + 1).toString()),
      ));
    }

    Widget tabBar = TabBar(
        isScrollable: true,
        onTap: (index) {
          //widget.pageController.jumpToPage(index);
          if (widget._topicContentWidget != null) {
            widget._topicContentWidget.loadPage(index + 1);
          }
        },
        controller: widget.tabController,
        tabs: tabs);
    return tabBar;
  }
}

class _TopicContentWidget extends StatefulWidget {
  TopicContentEntity topicContentEntity;

  int tid;

  int page;

  _TopicContentState topicContentState;

  _TopicContentWidget(this.tid, this.page, {this.topicContentEntity});

  @override
  State<StatefulWidget> createState() {
    topicContentState = new _TopicContentState();
    return topicContentState;
  }

  void loadPage(int page) {
    this.page = page;
    topicContentState?.loadPage();
  }
}

class _TopicContentState extends State<_TopicContentWidget> {
  TabController tabController;

  TopicContentModel model = new TopicContentModel();

  FlutterWebviewPlugin plugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    if (widget.topicContentEntity == null) {
      loadPage();
    }
    return widget.topicContentEntity == null
        ? ProgressBarEx()
        : _buildContentWidget();
  }

  void loadPage() {
    model.loadContent(widget.tid, widget.page, (data) {
      if (plugin == null) {
        setState(() {
          widget.topicContentEntity = data;
        });
      } else {
        widget.topicContentEntity = data;
        plugin.reloadUrl(new Uri.dataFromString(
                widget.topicContentEntity.htmlContent,
                mimeType: 'text/html',
                encoding: Encoding.getByName("utf-8"))
            .toString());
      }
    });
  }

  Widget _buildContentWidget() {
    return WebviewScaffold(
      url: new Uri.dataFromString(widget.topicContentEntity.htmlContent,
              mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
          .toString(),
      withJavascript: true,
    );
  }
}
