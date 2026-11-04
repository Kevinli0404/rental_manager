import 'package:freezed_annotation/freezed_annotation.dart';

part 'template.freezed.dart';
part 'template.g.dart';

/// 範本：定義有哪些空間類型、每類空間要檢查哪些項目。
///
/// 只用來產生空間配置；點交紀錄建立之後就不再回頭讀範本（見 D-004）。
@freezed
abstract class Template with _$Template {
  const factory Template({
    required String id,
    required String name,
    required int version,
    required List<TemplateRoom> rooms,
  }) = _Template;

  factory Template.fromJson(Map<String, Object?> json) =>
      _$TemplateFromJson(json);
}

/// 範本裡的一類空間，例如「臥室」。
@freezed
abstract class TemplateRoom with _$TemplateRoom {
  const factory TemplateRoom({
    required String key,
    required String name,
    required List<TemplateItem> items,
  }) = _TemplateRoom;

  factory TemplateRoom.fromJson(Map<String, Object?> json) =>
      _$TemplateRoomFromJson(json);
}

/// 範本裡的檢查項目，例如「牆面」。
@freezed
abstract class TemplateItem with _$TemplateItem {
  const factory TemplateItem({required String key, required String name}) =
      _TemplateItem;

  factory TemplateItem.fromJson(Map<String, Object?> json) =>
      _$TemplateItemFromJson(json);
}
