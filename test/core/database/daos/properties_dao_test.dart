import 'dart:async';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  final uuidV4 = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );

  const layout = Layout(
    templateId: 'default-residence',
    templateVersion: 1,
    rooms: [
      LayoutRoom(
        key: 'bedroom',
        typeKey: 'bedroom',
        name: '臥室',
        items: [LayoutItem(key: 'wall', name: '牆面')],
      ),
    ],
  );

  Future<String> createInspection(String propertyId) {
    return db.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-04',
      landlordName: '王房東',
      layout: layout,
    );
  }

  Future<List<String>> listedNames() async {
    final properties = await db.propertiesDao.watchProperties().first;
    return [for (final p in properties) p.name];
  }

  void advanceClock() {
    now = now.add(const Duration(minutes: 1));
  }

  setUp(() {
    now = DateTime.utc(2026, 11, 4, 9, 30);
    db = AppDatabase(NativeDatabase.memory(), clock: () => now);
  });

  tearDown(() async {
    await db.close();
  });

  test('建立物件後讀得回來', () async {
    final id = await db.propertiesDao.createProperty(
      name: '中山路公寓',
      address: '台北市中山區中山北路一段 1 號',
      note: '五樓，無電梯',
    );

    final property = await db.propertiesDao.watchProperty(id).first;

    expect(property, isNotNull);
    expect(property!.id, matches(uuidV4));
    expect(property.name, '中山路公寓');
    expect(property.address, '台北市中山區中山北路一段 1 號');
    expect(property.note, '五樓，無電梯');
    expect(property.createdAt, now);
    expect(property.updatedAt, now);
    expect(property.deletedAt, isNull);
  });

  test('只填名稱也能建立，地址和備註是空字串', () async {
    final id = await db.propertiesDao.createProperty(name: '中山路公寓');

    final property = await db.propertiesDao.watchProperty(id).first;

    expect(property!.address, '');
    expect(property.note, '');
  });

  test('每次建立的 id 都不同', () async {
    final first = await db.propertiesDao.createProperty(name: 'A');
    final second = await db.propertiesDao.createProperty(name: 'B');

    expect(first, isNot(second));
  });

  test('已軟刪除的物件查不到', () async {
    final id = await db.propertiesDao.createProperty(name: '中山路公寓');
    await (db.update(db.properties)..where((p) => p.id.equals(id))).write(
      PropertiesCompanion(deletedAt: Value(now)),
    );

    expect(await db.propertiesDao.watchProperty(id).first, isNull);
  });

  group('列表', () {
    test('沒有物件時是空的', () async {
      expect(await listedNames(), isEmpty);
    });

    test('依建立時間新到舊，不含已刪除的物件', () async {
      await db.propertiesDao.createProperty(name: '最早');
      advanceClock();
      final deletedId = await db.propertiesDao.createProperty(name: '已刪除');
      advanceClock();
      await db.propertiesDao.createProperty(name: '最新');
      await db.propertiesDao.deleteProperty(deletedId);

      expect(await listedNames(), ['最新', '最早']);
    });

    test('修改物件不會改變順序', () async {
      final firstId = await db.propertiesDao.createProperty(name: '第一間');
      advanceClock();
      await db.propertiesDao.createProperty(name: '第二間');
      advanceClock();
      await db.propertiesDao.updateProperty(
        id: firstId,
        name: '第一間（改名）',
        address: '',
        note: '',
      );

      expect(await listedNames(), ['第二間', '第一間（改名）']);
    });

    test('新增物件後，監看中的列表會自動收到新資料', () async {
      final received = <List<String>>[];
      final gotInitial = Completer<void>();
      final gotUpdate = Completer<void>();
      final subscription = db.propertiesDao.watchProperties().listen((list) {
        received.add([for (final p in list) p.name]);
        if (received.length == 1) gotInitial.complete();
        if (received.length == 2) gotUpdate.complete();
      });

      // 先等到第一次查詢的結果，確定寫入發生在開始監看之後。
      await gotInitial.future;
      await db.propertiesDao.createProperty(name: '中山路公寓');
      await gotUpdate.future;
      await subscription.cancel();

      expect(received, [
        isEmpty,
        ['中山路公寓'],
      ]);
    });
  });

  group('修改', () {
    test('名稱、地址、備註都會更新；updatedAt 更新、createdAt 不變', () async {
      final createdAt = now;
      final id = await db.propertiesDao.createProperty(
        name: '中山路公寓',
        address: '舊地址',
        note: '舊備註',
      );

      advanceClock();
      await db.propertiesDao.updateProperty(
        id: id,
        name: '中山路公寓 A 棟',
        address: '新地址',
        note: '',
      );

      final property = await db.propertiesDao.watchProperty(id).first;
      expect(property!.name, '中山路公寓 A 棟');
      expect(property.address, '新地址');
      expect(property.note, '');
      expect(property.createdAt, createdAt);
      expect(property.updatedAt, now);
    });

    test('物件不存在或已刪除時丟出 StateError', () async {
      final id = await db.propertiesDao.createProperty(name: '中山路公寓');
      await db.propertiesDao.deleteProperty(id);

      Future<void> update(String id) => db.propertiesDao.updateProperty(
        id: id,
        name: '新名稱',
        address: '',
        note: '',
      );

      await expectLater(update(id), throwsStateError);
      await expectLater(update('not-exist'), throwsStateError);
    });
  });

  group('刪除', () {
    test('物件和底下的點交紀錄一起軟刪除，刪除時間和 updatedAt 都是當下', () async {
      final propertyId = await db.propertiesDao.createProperty(name: '中山路公寓');
      final inspectionId = await createInspection(propertyId);

      advanceClock();
      await db.propertiesDao.deleteProperty(propertyId);

      expect(await db.propertiesDao.watchProperty(propertyId).first, isNull);
      expect(
        await db.inspectionsDao.watchInspection(inspectionId).first,
        isNull,
      );

      final property = await (db.select(
        db.properties,
      )..where((p) => p.id.equals(propertyId))).getSingle();
      final inspection = await (db.select(
        db.inspections,
      )..where((i) => i.id.equals(inspectionId))).getSingle();
      expect(property.deletedAt, now);
      expect(property.updatedAt, now);
      expect(inspection.deletedAt, now);
      expect(inspection.updatedAt, now);
    });

    test('其他物件的點交紀錄不受影響', () async {
      final deletedId = await db.propertiesDao.createProperty(name: '要刪的');
      final keptId = await db.propertiesDao.createProperty(name: '要留的');
      final keptInspectionId = await createInspection(keptId);
      await createInspection(deletedId);

      await db.propertiesDao.deleteProperty(deletedId);

      expect(await db.propertiesDao.watchProperty(keptId).first, isNotNull);
      expect(
        await db.inspectionsDao.watchInspection(keptInspectionId).first,
        isNotNull,
      );
    });

    test('之前已經刪掉的點交紀錄保留原本的刪除時間', () async {
      final propertyId = await db.propertiesDao.createProperty(name: '中山路公寓');
      final inspectionId = await createInspection(propertyId);
      final earlier = now;
      await (db.update(db.inspections)..where((i) => i.id.equals(inspectionId)))
          .write(InspectionsCompanion(deletedAt: Value(earlier)));

      advanceClock();
      await db.propertiesDao.deleteProperty(propertyId);

      final inspection = await (db.select(
        db.inspections,
      )..where((i) => i.id.equals(inspectionId))).getSingle();
      expect(inspection.deletedAt, earlier);
    });

    test('物件不存在或已刪除時丟出 StateError', () async {
      final id = await db.propertiesDao.createProperty(name: '中山路公寓');
      await db.propertiesDao.deleteProperty(id);

      await expectLater(db.propertiesDao.deleteProperty(id), throwsStateError);
      await expectLater(
        db.propertiesDao.deleteProperty('not-exist'),
        throwsStateError,
      );
    });
  });
}
