import 'topic_list_bean_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "TopicListBeanEntity") {
      return TopicListBeanEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
