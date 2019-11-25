import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:nga_open_source/model/topic_post_model.dart';
import 'package:nga_open_source/res/app_colors.dart';
import 'package:nga_open_source/utils/utils.dart';
import 'package:nga_open_source/widget/webview_widget.dart';

import 'post_page.dart';

class TopicContentWidget extends StatefulWidget {
  final int tid;

  TopicContentWidget(this.tid);

  @override
  State<StatefulWidget> createState() {
    return new TopicContentState();
  }
}

class TopicContentState extends State<TopicContentWidget>
    with TickerProviderStateMixin {
  TopicContentModel _topicContentModel = new TopicContentModel();

  TabController tabController;

  TabBar tabBar;

  WebViewEx webView;

  int pageIndex = 1;

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
            actions: _buildActionWidget()),
        body: _buildWebView(data));
  }

  List<Widget> _buildActionWidget() {
    return <Widget>[
      InkWell(
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => PostWidget(
                          TopicPostParam.TOPIC_POST_ACTION_REPLY,
                          tid: widget.tid,
                        )));
          },
          child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  "回帖",
                  style: TextStyle(fontSize: 18),
                ),
              ))),
    ];
  }

  Widget _buildWebView(TopicContentWrapper data) {
    if (webView == null) {
      webView = WebViewEx(
        initialHtml: data.current.htmlContent,
       // useFlutterWebView: true,
      );
    } else {
      webView.loadUrl(html: data.current.htmlContent);
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
          onTap: () => _topicContentModel.loadContent(widget.tid, pageIndex),
          child: Center(child: Text("加载失败,请点击重试")),
        ));
  }

  @override
  void initState() {
    super.initState();
    _topicContentModel.loadContent(widget.tid, pageIndex);
  }

  @override
  Widget build(BuildContext context) {
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
    if (tabBar != null) {
      return tabBar;
    }
    tabController = new TabController(length: data.totalPage, vsync: this);
    var tabs = new List<Container>();
    for (int i = 0; i < data.totalPage; i++) {
      tabs.add(new Container(
        height: 36.0,
        width: 36,
        alignment: Alignment.center,
        child: Text((i + 1).toString()),
      ));
    }
    tabBar = TabBar(
        isScrollable: true,
        onTap: (index) {
          pageIndex = index + 1;
          _topicContentModel.loadContent(widget.tid, pageIndex);
        },
        controller: tabController,
        tabs: tabs);
    return tabBar;
  }
}
