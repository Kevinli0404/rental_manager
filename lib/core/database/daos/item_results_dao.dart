import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/item_results.dart';

part 'item_results_dao.g.dart';

@DriftAccessor(tables: [ItemResults])
class ItemResultsDao extends DatabaseAccessor<AppDatabase>
    with _$ItemResultsDaoMixin {
  ItemResultsDao(super.attachedDatabase);

  /// 設定項目狀況；這個項目還沒有結果時新增一筆，已經有就更新。備註不受影響。
  Future<void> setCondition({
    required String inspectionId,
    required String roomKey,
    required String itemKey,
    required ItemCondition condition,
  }) {
    return _upsert(
      inspectionId: inspectionId,
      roomKey: roomKey,
      itemKey: itemKey,
      changes: ItemResultsCompanion(condition: Value(condition)),
    );
  }

  /// 設定項目備註；這個項目還沒有結果時新增一筆，已經有就更新。狀況不受影響。
  Future<void> setNote({
    required String inspectionId,
    required String roomKey,
    required String itemKey,
    required String note,
  }) {
    return _upsert(
      inspectionId: inspectionId,
      roomKey: roomKey,
      itemKey: itemKey,
      changes: ItemResultsCompanion(note: Value(note)),
    );
  }

  /// 監看某筆點交的所有項目結果（不含已刪除）。
  Stream<List<ItemResult>> watchItemResults(String inspectionId) {
    return (select(itemResults)..where(
          (r) => r.inspectionId.equals(inspectionId) & r.deletedAt.isNull(),
        ))
        .watch();
  }

  /// 依 (inspectionId, roomKey, itemKey) 新增或更新，只寫入 [changes] 裡的欄位。
  Future<void> _upsert({
    required String inspectionId,
    required String roomKey,
    required String itemKey,
    required ItemResultsCompanion changes,
  }) async {
    final now = attachedDatabase.nowUtc();
    await into(itemResults).insert(
      changes.copyWith(
        id: Value(attachedDatabase.newId()),
        createdAt: Value(now),
        updatedAt: Value(now),
        inspectionId: Value(inspectionId),
        roomKey: Value(roomKey),
        itemKey: Value(itemKey),
      ),
      onConflict: DoUpdate(
        (_) => changes.copyWith(updatedAt: Value(now)),
        target: [
          itemResults.inspectionId,
          itemResults.roomKey,
          itemResults.itemKey,
        ],
      ),
    );
  }
}
