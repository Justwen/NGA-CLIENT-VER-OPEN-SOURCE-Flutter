import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/model/topic_content_model.dart';

class TopicContentWidget extends StatelessWidget {
  final int tid;

  TopicContentWidget(this.tid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("主题详情"),
      ),
      body: _TopicContentWidget(tid),
    );
  }
}

class _TopicContentWidget extends StatefulWidget {
  TopicContentEntity topicContentEntity;

  int tid;

  _TopicContentWidget(this.tid);

  @override
  State<StatefulWidget> createState() {
    return new _TopicContentState();
  }
}

class _TopicContentState extends State<_TopicContentWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.topicContentEntity == null) {
      new TopicContentModel().loadContent(widget.tid, 1, (data) {
        setState(() {
          widget.topicContentEntity = data;
        });
      });
    }
    return widget.topicContentEntity == null
        ? ProgressBarEx()
        : _buildContentWidget();
  }

  Widget _buildContentWidget() {
    return WebviewScaffold(
      url: new Uri.dataFromString(widget.topicContentEntity.htmlContent,
              mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
          .toString(),
      withJavascript: true,
      withLocalUrl: true,
    );
  }
}
