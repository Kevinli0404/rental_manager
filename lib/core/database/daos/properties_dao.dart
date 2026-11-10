import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/inspections.dart';
import '../tables/properties.dart';

part 'properties_dao.g.dart';

@DriftAccessor(tables: [Properties, Inspections])
class PropertiesDao extends DatabaseAccessor<AppDatabase>
    with _$PropertiesDaoMixin {
  PropertiesDao(super.attachedDatabase);

  /// 新增物件，回傳新物件的 id。
  Future<String> createProperty({
    required String name,
    String address = '',
    String note = '',
  }) async {
    final id = attachedDatabase.newId();
    final now = attachedDatabase.nowUtc();
    await into(properties).insert(
      PropertiesCompanion.insert(
        id: id,
        createdAt: now,
        updatedAt: now,
        name: name,
        address: Value(address),
        note: Value(note),
      ),
    );
    return id;
  }

  /// 監看所有物件（不含已刪除），依建立時間新到舊。
  Stream<List<Property>> watchProperties() {
    return (select(properties)
          ..where((p) => p.deletedAt.isNull())
          ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
        .watch();
  }

  /// 依 id 監看物件；不存在或已刪除時是 null。
  Stream<Property?> watchProperty(String id) {
    return (select(properties)
          ..where((p) => p.id.equals(id) & p.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// 修改物件的名稱、地址、備註。
  ///
  /// 物件不存在或已刪除時丟出 [StateError]，不默默略過使用者的修改。
  Future<void> updateProperty({
    required String id,
    required String name,
    required String address,
    required String note,
  }) async {
    final count = await _whereActive(id).write(
      PropertiesCompanion(
        name: Value(name),
        address: Value(address),
        note: Value(note),
        updatedAt: Value(attachedDatabase.nowUtc()),
      ),
    );
    _ensureFound(count, id);
  }

  /// 軟刪除物件，底下的點交紀錄在同一個交易裡一起軟刪除（product.md「刪除規則」）。
  ///
  /// 物件不存在或已刪除時丟出 [StateError]，整個交易不生效。
  Future<void> deleteProperty(String id) {
    return transaction(() async {
      final now = attachedDatabase.nowUtc();
      final count = await _whereActive(id).write(
        PropertiesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      _ensureFound(count, id);

      // 推論：之前已經刪掉的點交紀錄保留原本的刪除時間，只標記還沒刪除的。
      // 推論：項目結果、照片、簽名只會透過點交紀錄讀到，點交紀錄刪除後就不會顯示，
      // 所以不逐筆標記。
      await (update(
        inspections,
      )..where((i) => i.propertyId.equals(id) & i.deletedAt.isNull())).write(
        InspectionsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  UpdateStatement<$PropertiesTable, Property> _whereActive(String id) {
    return update(properties)
      ..where((p) => p.id.equals(id) & p.deletedAt.isNull());
  }

  void _ensureFound(int count, String id) {
    if (count == 0) {
      throw StateError('物件不存在或已刪除：$id');
    }
  }
}
