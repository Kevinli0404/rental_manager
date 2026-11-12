import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

void main() {
  late AppDatabase db;
  late String propertyId;
  final now = DateTime.utc(2026, 11, 4, 9, 30);
  // 資料庫的時間；要讓資料的建立時間不同時，測試裡可以往後調。
  late DateTime clockNow;

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
    clockNow = now;
    db = AppDatabase(NativeDatabase.memory(), clock: () => clockNow);
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

  group('watchInspections', () {
    Future<String> createOn(String inspectedOn, {String? forProperty}) {
      clockNow = clockNow.add(const Duration(minutes: 1));
      return db.inspectionsDao.createInspection(
        propertyId: forProperty ?? propertyId,
        type: InspectionType.moveIn,
        inspectedOn: inspectedOn,
        landlordName: '',
        layout: layout,
      );
    }

    Future<List<String>> listedIds() async {
      final list = await db.inspectionsDao.watchInspections(propertyId).first;
      return [for (final inspection in list) inspection.id];
    }

    test('依點交日期新到舊；同一天的，後建立的排前面', () async {
      final oldest = await createOn('2026-01-15');
      final sameDayFirst = await createOn('2026-11-04');
      final newest = await createOn('2026-12-01');
      final sameDaySecond = await createOn('2026-11-04');

      expect(await listedIds(), [newest, sameDaySecond, sameDayFirst, oldest]);
    });

    test('不含已刪除的，也不含其他物件的', () async {
      final kept = await createOn('2026-11-04');
      final deleted = await createOn('2026-11-04');
      await (db.update(db.inspections)..where((i) => i.id.equals(deleted)))
          .write(InspectionsCompanion(deletedAt: Value(now)));
      final otherProperty = await db.propertiesDao.createProperty(
        name: '民生社區套房',
      );
      await createOn('2026-11-04', forProperty: otherProperty);

      expect(await listedIds(), [kept]);
    });

    test('新增後自動送出新的列表', () async {
      final stream = db.inspectionsDao.watchInspections(propertyId);
      final emitted = stream.map((list) => list.length).take(2).toList();
      // 等第一次結果送出後才新增，確認第二次是新增觸發的。
      await stream.first;
      await createOn('2026-11-04');

      expect(await emitted, [0, 1]);
    });
  });
}
