// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardBean _$BoardBeanFromJson(Map<String, dynamic> json) {
  return BoardBean(
      json['name'] as String,
      (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Content.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$BoardBeanToJson(BoardBean instance) =>
    <String, dynamic>{'name': instance.name, 'content': instance.content};

Content _$ContentFromJson(Map<String, dynamic> json) {
  return Content(json['fid'] as int, json['name'] as String,
      json['info'] as String, json['nameS'] as String, json['stid'] as int);
}

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'fid': instance.fid,
      'name': instance.name,
      'info': instance.info,
      'nameS': instance.nameS,
      'stid': instance.stid
    };
