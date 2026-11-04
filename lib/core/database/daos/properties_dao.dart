import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/properties.dart';

part 'properties_dao.g.dart';

@DriftAccessor(tables: [Properties])
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

  /// 依 id 監看物件；不存在或已刪除時是 null。
  Stream<Property?> watchProperty(String id) {
    return (select(properties)
          ..where((p) => p.id.equals(id) & p.deletedAt.isNull()))
        .watchSingleOrNull();
  }
}
