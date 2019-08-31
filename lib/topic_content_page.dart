import "package:flutter/material.dart";
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  List<TopicContentEntity> dataList;

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
    return widget.dataList == null ? ProgressBarEx() : _buildContentWidget();
  }

  @override
  void initState() {
    new TopicContentModel().loadContent(widget.tid, 1, (List data) {
      setState(() {
        widget.dataList = data;
      });
    });
    super.initState();
  }

  Widget _buildContentWidget() {
    return ListView.builder(
        itemCount: widget.dataList.length,
        itemBuilder: (context, i) {
          return _buildTopicContentItem(widget.dataList[i]);
        });
  }

  Widget _buildTopicContentItem(TopicContentEntity entity) {
    return Container(
          width: double.infinity,
          height: 100,
          padding: EdgeInsets.all(16),
          child: WebView(
            initialUrl:new Uri.dataFromString(entity.content,mimeType: 'text/html').toString() ,
          ),
        );
  }
}
