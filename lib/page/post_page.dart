import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nga_open_source/model/topic_post_model.dart';
import 'package:nga_open_source/utils/utils.dart';

class PostWidget extends StatefulWidget {
  final int tid;

  final String action;

  final int fid;

  final String content;

  PostWidget(this.action, {this.tid, this.fid, this.content});

  State<StatefulWidget> createState() {
    return new _PostState();
  }
}

class _PostState extends State<PostWidget> {
  TopicPostModel topicModel = new TopicPostModel();

  TextEditingController subjectController = new TextEditingController();

  TextEditingController bodyController = new TextEditingController();

  TopicPostParam postEntity;

  bool isChecked = false;

  @override
  void initState() {
    postEntity =
        new TopicPostParam(widget.action, tid: widget.tid, fid: widget.fid);
    if (!_isActionNew()) {
      WebViewUtils.hideWebView();
    }

    bodyController.text = widget.content;
    super.initState();
  }

  @override
  void dispose() {
    if (!_isActionNew()) {
      WebViewUtils.showWebView();
    }
    super.dispose();
  }

  bool _isActionNew() {
    return postEntity.action == TopicPostParam.TOPIC_POST_ACTION_NEW;
  }

  Widget _buildTitleWidget() {
    return Text(_isActionNew() ? "发帖" : "回帖");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: _buildTitleWidget(),
        actions: <Widget>[
          InkWell(
              onTap: () {
                if (bodyController.text.isNotEmpty) {
                  postEntity.postContent = bodyController.text;
                  postEntity.subject = subjectController.text;
                  topicModel.post(postEntity).then((bool) {
                    Navigator.pop(context);
                  });
                }
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: Text(
                      "发送",
                      style: TextStyle(fontSize: 18),
                    ),
                  ))),
        ],
      ),
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    return Column(children: [
      _buildSubjectWidget(),
      Container(
        padding: EdgeInsets.only(left: 16, top: 8, right: 16),
        child: TextField(
          controller: bodyController,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "这里可以填引喷的内容",
          ),
        ),
      )
    ]);
  }

  Widget _buildSubjectWidget() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: subjectController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "这里可以填引喷的标题",
                    ),
                  ))),
          Text("匿名"),
          Container(
              width: 40,
              child: Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    postEntity.anonymous = value;
                    isChecked = value;
                  });
                },
              ))
        ],
      ),
    );
  }
}
