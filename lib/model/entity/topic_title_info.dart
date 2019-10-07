class TopicTitleInfo {
  String title;

  int tid;

  String author;

  int replyCount;

  String lastReplyTime;

  Map toJson() {
    Map map = new Map();
    map["title"] = this.title;
    map["tid"] = this.tid;
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class TopicTitleWrapper {
  List<TopicTitleInfo> _topicTitleList = new List();

  List<TopicTitleInfo> get data => _topicTitleList;

  int pageIndex = 0;

  bool hasNextPage = true;

  void add({
    TopicTitleWrapper wrapper,
    List<TopicTitleInfo> list,
    TopicTitleInfo info,
  }) {
    if (wrapper != null) {
      _topicTitleList.addAll(wrapper.data);
      pageIndex = wrapper.pageIndex;
    }

    if (list != null) {
      _topicTitleList.addAll(list);
    }

    if (info != null) {
      _topicTitleList.add(info);
    }
  }

  bool get isEmpty => _topicTitleList.isEmpty;

  int get length => _topicTitleList.length;
}
