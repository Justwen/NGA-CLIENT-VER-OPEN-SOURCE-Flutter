import 'package:nga_open_source/bloc/base_bloc.dart';
import 'package:nga_open_source/model/topic_content_model.dart';

class TopicContentBloc extends BaseBloc<TopicContentWrapper> {

  void updateTopicContent(TopicContentWrapper data) {
    bean = data;
    notifyDataChanged();
  }

}