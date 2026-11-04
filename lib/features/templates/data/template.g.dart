// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Template _$TemplateFromJson(Map<String, dynamic> json) => _Template(
  id: json['id'] as String,
  name: json['name'] as String,
  version: (json['version'] as num).toInt(),
  rooms: (json['rooms'] as List<dynamic>)
      .map((e) => TemplateRoom.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TemplateToJson(_Template instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'version': instance.version,
  'rooms': instance.rooms.map((e) => e.toJson()).toList(),
};

_TemplateRoom _$TemplateRoomFromJson(Map<String, dynamic> json) =>
    _TemplateRoom(
      key: json['key'] as String,
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => TemplateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TemplateRoomToJson(_TemplateRoom instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_TemplateItem _$TemplateItemFromJson(Map<String, dynamic> json) =>
    _TemplateItem(key: json['key'] as String, name: json['name'] as String);

Map<String, dynamic> _$TemplateItemToJson(_TemplateItem instance) =>
    <String, dynamic>{'key': instance.key, 'name': instance.name};
