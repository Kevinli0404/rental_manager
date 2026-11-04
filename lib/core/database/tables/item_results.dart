import 'package:drift/drift.dart';

import 'inspections.dart';
import 'sync_columns.dart';

/// 項目狀況；嚴重程度 good < damaged < missing，notApplicable 不參與比較。
enum ItemCondition { good, damaged, missing, notApplicable }

/// 某筆點交裡，某個空間的某個項目的檢查結果。
class ItemResults extends Table with SyncColumns {
  TextColumn get inspectionId => text().references(Inspections, #id)();
  TextColumn get roomKey => text()();
  TextColumn get itemKey => text()();

  /// 未填為 null。
  TextColumn get condition => textEnum<ItemCondition>().nullable()();

  TextColumn get note => text().withDefault(const Constant(''))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {inspectionId, roomKey, itemKey},
  ];
}
