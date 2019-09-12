import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nga_open_source/model/Topic_post_model.dart';
import 'package:nga_open_source/model/topic_model.dart';

class PostWidget extends StatefulWidget {

  int tid;

  String action;

  PostWidget(this.tid, this.action);

  State<StatefulWidget> createState() {
    return new _PostState();
  }
}

class _PostState extends State<PostWidget> {

  FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();

  TopicPostModel topicModel = new TopicPostModel();

  TextEditingController controller = new TextEditingController();

  TopicPostEntity postEntity;

  @override
  void initState() {
    postEntity = new TopicPostEntity(widget.tid, widget.action);
    webviewPlugin.hide();
    super.initState();
  }

  @override
  void dispose() {
    webviewPlugin.show();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("回帖"),
        actions: <Widget>[
          InkWell(
              onTap: () {
                if (controller.text.isNotEmpty) {
                  postEntity.postContent = controller.text;
                  topicModel.post(postEntity);
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
