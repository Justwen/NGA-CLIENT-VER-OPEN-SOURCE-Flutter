import 'package:flutter/material.dart';
import 'package:nga_open_source/model/topic_content_model.dart';
import 'package:nga_open_source/model/topic_post_model.dart';
import 'package:nga_open_source/page/post_page.dart';

abstract class BaseTask {

}

void reply(BuildContext context, int tid, {TopicRowEntity entity}) {
  String shortContent = entity == null ? "" : entity.content;
  if (shortContent.length > 100) {
    shortContent = shortContent.substring(0, 99);
  }

  String content = entity == null
      ? ""
      : "[quote][pid=${entity.pid},$tid,${entity.page}]Reply[/pid] [b]Post by [uid=${entity.author.uid}]${entity.author.userName}[/uid] (${entity.postDate}):[/b]\n$shortContent[/quote]\n\n";
  Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => PostWidget(
                TopicPostParam.TOPIC_POST_ACTION_REPLY,
                content: content,
                tid: tid,
              )));
}
