// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Layout _$LayoutFromJson(Map<String, dynamic> json) => _Layout(
  templateId: json['templateId'] as String,
  templateVersion: (json['templateVersion'] as num).toInt(),
  rooms: (json['rooms'] as List<dynamic>)
      .map((e) => LayoutRoom.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LayoutToJson(_Layout instance) => <String, dynamic>{
  'templateId': instance.templateId,
  'templateVersion': instance.templateVersion,
  'rooms': instance.rooms.map((e) => e.toJson()).toList(),
};

_LayoutRoom _$LayoutRoomFromJson(Map<String, dynamic> json) => _LayoutRoom(
  key: json['key'] as String,
  typeKey: json['typeKey'] as String,
  name: json['name'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => LayoutItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LayoutRoomToJson(_LayoutRoom instance) =>
    <String, dynamic>{
      'key': instance.key,
      'typeKey': instance.typeKey,
      'name': instance.name,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_LayoutItem _$LayoutItemFromJson(Map<String, dynamic> json) =>
    _LayoutItem(key: json['key'] as String, name: json['name'] as String);

Map<String, dynamic> _$LayoutItemToJson(_LayoutItem instance) =>
    <String, dynamic>{'key': instance.key, 'name': instance.name};
