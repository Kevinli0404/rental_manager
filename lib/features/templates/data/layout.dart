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

/// 管理空間（product.md「空間」）：新增、複製、改名稱、刪除。
///
/// 都回傳新的空間配置，不改原本的。找不到 `roomKey` 的空間時丟出 [StateError]。
extension LayoutRoomEditing on Layout {
  /// 新增一個 [type] 類型的空間，key 是 [key]（新的 UUID，D-011）。
  ///
  /// 項目照範本；名稱自動編號（見 [_nextRoomName]）；位置見 [_insertRoom]。
  Layout addRoom(TemplateRoom type, {required String key}) {
    return _insertRoom(
      LayoutRoom(
        key: key,
        typeKey: type.key,
        name: _nextRoomName(type.name),
        items: [
          for (final item in type.items)
            LayoutItem(key: item.key, name: item.name),
        ],
      ),
    );
  }

  /// 複製 [roomKey] 的空間，新空間的 key 是 [key]（新的 UUID，D-011）。
  ///
  /// 只複製項目；狀況、備註、照片不在空間配置裡，不會跟著複製。名稱用這類空間的
  /// 類型名稱 [typeName] 自動編號，位置同 [addRoom]。
  Layout copyRoom(
    String roomKey, {
    required String key,
    required String typeName,
  }) {
    final source = _room(roomKey);
    return _insertRoom(
      source.copyWith(key: key, name: _nextRoomName(typeName)),
    );
  }

  /// [roomKey] 的空間能不能改名成 [name]：可以時回傳 null，不行時回傳原因。
  ///
  /// 前後空白不算；不能空白，也不能跟其他空間同名。
  String? roomNameError(String roomKey, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '請輸入名稱';
    if (rooms.any((room) => room.key != roomKey && room.name == trimmed)) {
      return '已經有叫「$trimmed」的空間';
    }
    return null;
  }

  /// 把 [roomKey] 的空間改名成 [name]（去掉前後空白）。
  ///
  /// 名稱不能用時丟出 [ArgumentError]，原因同 [roomNameError]。
  Layout renameRoom(String roomKey, String name) {
    _room(roomKey);
    final error = roomNameError(roomKey, name);
    if (error != null) throw ArgumentError.value(name, 'name', error);
    return copyWith(
      rooms: [
        for (final room in rooms)
          room.key == roomKey ? room.copyWith(name: name.trim()) : room,
      ],
    );
  }

  /// 刪除 [roomKey] 的空間。至少要保留一個空間，只剩一個時丟出 [StateError]。
  Layout removeRoom(String roomKey) {
    _room(roomKey);
    if (rooms.length == 1) throw StateError('至少要保留一個空間');
    return copyWith(
      rooms: [
        for (final room in rooms)
          if (room.key != roomKey) room,
      ],
    );
  }

  LayoutRoom _room(String roomKey) {
    return rooms.firstWhere(
      (room) => room.key == roomKey,
      orElse: () => throw StateError('空間不存在：$roomKey'),
    );
  }

  /// 加入 [room]：排在同類空間的最後一間後面，同一類的空間排在一起；
  /// 沒有同類空間時排最後。
  Layout _insertRoom(LayoutRoom room) {
    final lastOfType = rooms.lastIndexWhere((r) => r.typeKey == room.typeKey);
    final index = lastOfType == -1 ? rooms.length : lastOfType + 1;
    return copyWith(rooms: [...rooms]..insert(index, room));
  }

  /// 同類空間的下一個名稱：臥室、臥室 2、臥室 3（product.md「空間」）。
  ///
  /// 名稱是「[baseName]」（算 1）或「[baseName] 數字」的空間裡，取最大的數字加 1；
  /// 一個都沒有就用 [baseName]。
  ///
  /// 推論：用最大的數字加 1，不補中間的空號。例如有「臥室」「臥室 3」時，新增的是
  /// 「臥室 4」而不是「臥室 2」；新空間排在同類的最後面，編號也是最大的，跟分頁順序
  /// 一致。改過名、不符合這個格式的空間（例如「主臥室」）不算。
  String _nextRoomName(String baseName) {
    final numbered = RegExp('^${RegExp.escape(baseName)} ([0-9]+)\$');
    int? largest;
    for (final room in rooms) {
      final number = room.name == baseName
          ? 1
          : switch (numbered.firstMatch(room.name)) {
              final match? => int.parse(match.group(1)!),
              null => null,
            };
      if (number != null && (largest == null || number > largest)) {
        largest = number;
      }
    }
    return largest == null ? baseName : '$baseName ${largest + 1}';
  }
}
