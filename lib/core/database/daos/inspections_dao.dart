import 'package:drift/drift.dart';

import '../../../features/templates/data/layout.dart';
import '../database.dart';
import '../tables/inspections.dart';

part 'inspections_dao.g.dart';

@DriftAccessor(tables: [Inspections])
class InspectionsDao extends DatabaseAccessor<AppDatabase>
    with _$InspectionsDaoMixin {
  InspectionsDao(super.attachedDatabase);

  /// 建立草稿狀態的點交紀錄，回傳新紀錄的 id。
  ///
  /// [inspectedOn] 是 `YYYY-MM-DD`。房客姓名一開始空著（product.md 轉跳規則 2）。
  Future<String> createInspection({
    required String propertyId,
    required InspectionType type,
    required String inspectedOn,
    required String landlordName,
    required Layout layout,
  }) async {
    final id = attachedDatabase.newId();
    final now = attachedDatabase.nowUtc();
    await into(inspections).insert(
      InspectionsCompanion.insert(
        id: id,
        createdAt: now,
        updatedAt: now,
        propertyId: propertyId,
        type: type,
        status: InspectionStatus.draft,
        inspectedOn: inspectedOn,
        landlordName: Value(landlordName),
        layout: layout,
      ),
    );
    return id;
  }

  /// 監看某個物件的點交紀錄（不含已刪除），依點交日期新到舊；同一天依建立時間新到舊。
  ///
  /// 推論：同一天依建立時間排序。規格只寫「新到舊」；同一天最後建立的通常是最新的一次。
  Stream<List<Inspection>> watchInspections(String propertyId) {
    return (select(inspections)
          ..where((i) => i.propertyId.equals(propertyId) & i.deletedAt.isNull())
          ..orderBy([
            (i) => OrderingTerm.desc(i.inspectedOn),
            (i) => OrderingTerm.desc(i.createdAt),
          ]))
        .watch();
  }

  /// 依 id 監看點交紀錄；不存在或已刪除時是 null。
  Stream<Inspection?> watchInspection(String id) {
    return (select(inspections)
          ..where((i) => i.id.equals(id) & i.deletedAt.isNull()))
        .watchSingleOrNull();
  }
}
