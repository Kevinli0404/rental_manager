import 'package:drift/drift.dart';

import '../../../features/templates/data/layout.dart';
import '../database.dart';
import '../tables/inspections.dart';
import '../tables/item_results.dart';
import '../tables/photos.dart';

part 'inspections_dao.g.dart';

@DriftAccessor(tables: [Inspections, ItemResults, Photos])
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

  /// 軟刪除點交紀錄。
  ///
  /// 不存在或已刪除時丟出 [StateError]，不默默略過。項目結果、照片、簽名只會透過
  /// 點交紀錄讀到，不逐筆標記（同 `PropertiesDao.deleteProperty`）。
  Future<void> deleteInspection(String id) async {
    final now = attachedDatabase.nowUtc();
    final count =
        await (update(
          inspections,
        )..where((i) => i.id.equals(id) & i.deletedAt.isNull())).write(
          InspectionsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
    if (count == 0) {
      throw StateError('點交紀錄不存在或已刪除：$id');
    }
  }

  /// 修改空間配置：在交易裡讀出目前的配置，用 [change] 改完寫回，並更新 `updatedAt`。
  ///
  /// 在交易裡讀，才不會拿畫面上過時的配置去改，蓋掉剛寫入的變更。點交紀錄不存在或
  /// 已刪除時丟出 [StateError]；[change] 丟出的錯誤照樣往上丟，資料不變。
  Future<void> updateLayout(String id, Layout Function(Layout layout) change) {
    return transaction(() async {
      final current =
          await (select(inspections)
                ..where((i) => i.id.equals(id) & i.deletedAt.isNull()))
              .getSingleOrNull();
      if (current == null) {
        throw StateError('點交紀錄不存在或已刪除：$id');
      }
      await (update(inspections)..where((i) => i.id.equals(id))).write(
        InspectionsCompanion(
          layout: Value(change(current.layout)),
          updatedAt: Value(attachedDatabase.nowUtc()),
        ),
      );
    });
  }

  /// 刪除空間：從空間配置拿掉，同一個交易裡把這個空間的項目結果和照片也軟刪除
  /// （product.md「空間」：內容和照片一起刪除）。
  ///
  /// 只剩一個空間、空間不存在、點交紀錄不存在或已刪除時丟出 [StateError]，資料不變。
  /// 照片檔案本身的清理在 T4 處理。
  Future<void> deleteRoom(String inspectionId, String roomKey) {
    return transaction(() async {
      await updateLayout(inspectionId, (layout) => layout.removeRoom(roomKey));

      // 之前已經刪掉的（例如單獨刪除的照片）保留原本的刪除時間，只標記還沒刪除的。
      final now = attachedDatabase.nowUtc();
      await (update(itemResults)..where(
            (r) =>
                r.inspectionId.equals(inspectionId) &
                r.roomKey.equals(roomKey) &
                r.deletedAt.isNull(),
          ))
          .write(
            ItemResultsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
          );
      await (update(photos)..where(
            (p) =>
                p.inspectionId.equals(inspectionId) &
                p.roomKey.equals(roomKey) &
                p.deletedAt.isNull(),
          ))
          .write(PhotosCompanion(deletedAt: Value(now), updatedAt: Value(now)));
    });
  }
}
