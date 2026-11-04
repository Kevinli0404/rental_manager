import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

void main() {
  late AppDatabase db;
  late String propertyId;
  final now = DateTime.utc(2026, 11, 4, 9, 30);

  const layout = Layout(
    templateId: 'default-residence',
    templateVersion: 1,
    rooms: [
      LayoutRoom(
        key: 'bedroom',
        typeKey: 'bedroom',
        name: '臥室',
        items: [
          LayoutItem(key: 'wall', name: '牆面'),
          LayoutItem(key: 'floor', name: '地板'),
        ],
      ),
    ],
  );

  Future<String> createMoveIn() => db.inspectionsDao.createInspection(
    propertyId: propertyId,
    type: InspectionType.moveIn,
    inspectedOn: '2026-11-04',
    landlordName: '王房東',
    layout: layout,
  );

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory(), clock: () => now);
    propertyId = await db.propertiesDao.createProperty(name: '中山路公寓');
  });

  tearDown(() async {
    await db.close();
  });

  test('建立的點交紀錄是草稿，欄位和空間配置都讀得回來', () async {
    final id = await createMoveIn();

    final inspection = await db.inspectionsDao.watchInspection(id).first;

    expect(inspection, isNotNull);
    expect(inspection!.propertyId, propertyId);
    expect(inspection.type, InspectionType.moveIn);
    expect(inspection.status, InspectionStatus.draft);
    expect(inspection.inspectedOn, '2026-11-04');
    expect(inspection.landlordName, '王房東');
    expect(inspection.tenantName, '');
    expect(inspection.layout, layout);
    expect(inspection.baseInspectionId, isNull);
    expect(inspection.signedAt, isNull);
    expect(inspection.createdAt, now);
    expect(inspection.updatedAt, now);
  });

  test('已軟刪除的點交紀錄查不到', () async {
    final id = await createMoveIn();
    await (db.update(db.inspections)..where((i) => i.id.equals(id))).write(
      InspectionsCompanion(deletedAt: Value(now)),
    );

    expect(await db.inspectionsDao.watchInspection(id).first, isNull);
  });
}
