import 'package:drift/drift.dart';

import 'inspections.dart';
import 'sync_columns.dart';

/// 項目的照片。檔案存在 Documents 目錄，這裡只記相對路徑（D-005）。
class Photos extends Table with SyncColumns {
  TextColumn get inspectionId => text().references(Inspections, #id)();
  TextColumn get roomKey => text()();
  TextColumn get itemKey => text()();
  TextColumn get relativePath => text()();
}
