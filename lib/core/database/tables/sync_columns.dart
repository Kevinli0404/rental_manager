import 'package:drift/drift.dart';

/// 每張表都有的欄位（見 architecture.md「資料表」、D-003）。
///
/// 時間一律存 UTC；[deletedAt] 不是 null 代表已軟刪除。
mixin SyncColumns on Table {
  /// UUID 字串。
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
