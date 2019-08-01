import 'package:json_annotation/json_annotation.dart';

part 'board_bean.g.dart';

List<BoardBean> getBoardBeanList(List<dynamic> list) {
  List<BoardBean> result = [];
  list.forEach((item) {
    result.add(BoardBean.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class BoardBean extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'content')
  List<Content> content;

  BoardBean(
    this.name,
    this.content,
  );

  factory BoardBean.fromJson(Map<String, dynamic> srcJson) =>
      _$BoardBeanFromJson(srcJson);
}

@JsonSerializable()
class Content extends Object {
  @JsonKey(name: 'fid')
  int fid;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'info')
  String info;

  @JsonKey(name: 'nameS')
  String nameS;

  @JsonKey(name: 'stid')
  int stid;

  Content(
    this.fid,
    this.name,
    this.info,
    this.nameS,
    this.stid,
  );

  factory Content.fromJson(Map<String, dynamic> srcJson) =>
      _$ContentFromJson(srcJson);
}
