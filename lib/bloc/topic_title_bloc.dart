import 'package:nga_open_source/bloc/base_bloc.dart';
import 'package:nga_open_source/model/entity/topic_title_info.dart';
import 'package:nga_open_source/utils/utils.dart';

class TopicTitleBloc extends BaseBloc<TopicTitleWrapper> {

  void addTopicTitles(TopicTitleWrapper wrapper, {bool reset = false}) {
    if (bean == null || reset) {
      bean = wrapper;
    } else {
      bean.add(wrapper: wrapper);
    }
    notifyDataChanged();
  }

  void showErrorMsg(TopicTitleWrapper wrapper) {
    ToastUtils.showToast(wrapper.errorMsg);
    bean = wrapper;
    notifyDataChanged();
  }

}
