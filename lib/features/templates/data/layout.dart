import 'package:freezed_annotation/freezed_annotation.dart';

import 'template.dart';

part 'layout.freezed.dart';
part 'layout.g.dart';

/// 空間配置：某筆點交紀錄實際有哪些空間和項目。
///
/// 建立點交時從範本或入住紀錄複製一份，存進 `inspections.layout_json`（見 D-004）。
@freezed
abstract class Layout with _$Layout {
  const factory Layout({
    required String templateId,
    required int templateVersion,
    required List<LayoutRoom> rooms,
  }) = _Layout;

  /// 依範本產生空間配置：每類空間各一個，順序同範本，空間 key 沿用範本的 key。
  factory Layout.fromTemplate(Template template) => Layout(
    templateId: template.id,
    templateVersion: template.version,
    rooms: [
      for (final room in template.rooms)
        LayoutRoom(
          key: room.key,
          typeKey: room.key,
          name: room.name,
          items: [
            for (final item in room.items)
              LayoutItem(key: item.key, name: item.name),
          ],
        ),
    ],
  );

  factory Layout.fromJson(Map<String, Object?> json) => _$LayoutFromJson(json);
}

/// 配置裡的一個空間，例如「臥室 2」。
///
/// [key] 在同一筆點交裡不重複、建立後不改；[typeKey] 是範本的空間類型。
@freezed
abstract class LayoutRoom with _$LayoutRoom {
  const factory LayoutRoom({
    required String key,
    required String typeKey,
    required String name,
    required List<LayoutItem> items,
  }) = _LayoutRoom;

  factory LayoutRoom.fromJson(Map<String, Object?> json) =>
      _$LayoutRoomFromJson(json);
}

/// 配置裡的檢查項目；[key] 沿用範本的項目 key。
@freezed
abstract class LayoutItem with _$LayoutItem {
  const factory LayoutItem({required String key, required String name}) =
      _LayoutItem;

  factory LayoutItem.fromJson(Map<String, Object?> json) =>
      _$LayoutItemFromJson(json);
}
