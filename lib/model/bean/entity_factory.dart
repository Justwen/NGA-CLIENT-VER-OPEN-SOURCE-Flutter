import 'topic_title_bean.dart';
import 'topic_content_bean_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "TopicListBeanEntity") {
      return TopicListBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "TopicContentBeanEntity") {
      return TopicContentBeanEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
