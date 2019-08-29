import "package:flutter/material.dart";
import 'package:nga_open_source/common/component_index.dart';
import 'package:nga_open_source/model/topic_content_model.dart';

class TopicContentWidget extends StatelessWidget {

  final int tid;

  TopicContentWidget(this.tid);

  @override
  Widget build(BuildContext context) {

    new TopicContentModel().loadContent(tid, 1,() {

    });

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("测试"),
        ),
        body: _buildContentWidget());
  }

  Widget _buildContentWidget() {
    return ProgressBarEx();
  }

}