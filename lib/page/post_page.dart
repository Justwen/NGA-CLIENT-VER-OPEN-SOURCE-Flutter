import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nga_open_source/model/topic_post_model.dart';
import 'package:nga_open_source/utils/utils.dart';

class PostWidget extends StatefulWidget {
  final int tid;

  final String action;

  final int fid;

  PostWidget(this.action, {this.tid, this.fid});

  State<StatefulWidget> createState() {
    return new _PostState();
  }
}

class _PostState extends State<PostWidget> {
  TopicPostModel topicModel = new TopicPostModel();

  TextEditingController controller = new TextEditingController();

  TopicPostParam postEntity;

  _PostState() {
    postEntity =
        new TopicPostParam(widget.action, tid: widget.tid, fid: widget.fid);
  }

  @override
  void initState() {
    if (!_isActionNew()) {
      WebViewUtils.hideWebView();
    }
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
                if (controller.text.isNotEmpty) {
                  postEntity.postContent = controller.text;
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
    return Container(
      child: TextField(
        controller: controller,
        maxLines: 30,
//        decoration: InputDecoration(
//          contentPadding: const EdgeInsets.symmetric(vertical: 500.0),
//        ),
      ),
    );
  }
}
