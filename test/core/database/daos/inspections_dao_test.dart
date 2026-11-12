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

  group('deleteInspection', () {
    test('標記刪除時間並更新 updatedAt，之後查不到；其他紀錄不受影響', () async {
      final deletedId = await createMoveIn();
      final keptId = await createMoveIn();
      final deletedAt = now.add(const Duration(hours: 1));
      clockNow = deletedAt;

      await db.inspectionsDao.deleteInspection(deletedId);

      final rows = await db.select(db.inspections).get();
      final deleted = rows.singleWhere((i) => i.id == deletedId);
      expect(deleted.deletedAt, deletedAt);
      expect(deleted.updatedAt, deletedAt);
      final kept = rows.singleWhere((i) => i.id == keptId);
      expect(kept.deletedAt, isNull);
      expect(kept.updatedAt, now);

      expect(await db.inspectionsDao.watchInspection(deletedId).first, isNull);
      final listed = await db.inspectionsDao.watchInspections(propertyId).first;
      expect(listed.map((i) => i.id), [keptId]);
    });

    test('不存在或已刪除時丟出 StateError，已刪除的刪除時間不變', () async {
      final id = await createMoveIn();
      await db.inspectionsDao.deleteInspection(id);
      clockNow = now.add(const Duration(hours: 1));

      await expectLater(
        db.inspectionsDao.deleteInspection(id),
        throwsStateError,
      );
      await expectLater(
        db.inspectionsDao.deleteInspection('not-exist'),
        throwsStateError,
      );
      final row = await db.select(db.inspections).getSingle();
      expect(row.deletedAt, now);
    });
  });

  group('updateLayout', () {
    test('把資料庫裡目前的配置交給 change，改完寫回並更新 updatedAt；其他紀錄不受影響', () async {
      final id = await createMoveIn();
      final otherId = await createMoveIn();
      await db.inspectionsDao.updateLayout(
        id,
        (layout) => layout.renameRoom('bedroom', '主臥室'),
      );
      final changedAt = now.add(const Duration(hours: 1));
      clockNow = changedAt;

      Layout? received;
      await db.inspectionsDao.updateLayout(id, (layout) {
        received = layout;
        return layout.renameRoom('bedroom', '${layout.rooms.single.name}（大）');
      });

      expect(received!.rooms.single.name, '主臥室');
      final rows = await db.select(db.inspections).get();
      final changed = rows.singleWhere((i) => i.id == id);
      expect(changed.layout.rooms.single.name, '主臥室（大）');
      expect(changed.layout.rooms.single.items, layout.rooms.single.items);
      expect(changed.updatedAt, changedAt);
      expect(changed.createdAt, now);
      final other = rows.singleWhere((i) => i.id == otherId);
      expect(other.layout, layout);
      expect(other.updatedAt, now);
    });

    test('不存在或已刪除時丟出 StateError，資料不變', () async {
      final id = await createMoveIn();
      await db.inspectionsDao.deleteInspection(id);
      clockNow = now.add(const Duration(hours: 1));

      await expectLater(
        db.inspectionsDao.updateLayout(
          id,
          (layout) => layout.renameRoom('bedroom', '主臥室'),
        ),
        throwsStateError,
      );
      await expectLater(
        db.inspectionsDao.updateLayout('not-exist', (layout) => layout),
        throwsStateError,
      );
      final row = await db.select(db.inspections).getSingle();
      expect(row.layout, layout);
      expect(row.updatedAt, now);
    });

    test('change 丟出的錯誤照樣往上丟，資料不變', () async {
      final id = await createMoveIn();
      clockNow = now.add(const Duration(hours: 1));

      await expectLater(
        db.inspectionsDao.updateLayout(
          id,
          (layout) => layout.renameRoom('bedroom', '  '),
        ),
        throwsArgumentError,
      );
      final row = await db.select(db.inspections).getSingle();
      expect(row.layout, layout);
      expect(row.updatedAt, now);
    });
  });

  group('deleteRoom', () {
    const twoRooms = Layout(
      templateId: 'default-residence',
      templateVersion: 1,
      rooms: [
        LayoutRoom(
          key: 'bedroom',
          typeKey: 'bedroom',
          name: '臥室',
          items: [LayoutItem(key: 'wall', name: '牆面')],
        ),
        LayoutRoom(
          key: 'b2',
          typeKey: 'bedroom',
          name: '臥室 2',
          items: [LayoutItem(key: 'wall', name: '牆面')],
        ),
      ],
    );

    Future<String> createTwoRooms() => db.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-04',
      landlordName: '王房東',
      layout: twoRooms,
    );

    Future<void> addResult(
      String inspectionId,
      String roomKey, {
      DateTime? deletedAt,
    }) {
      return db
          .into(db.itemResults)
          .insert(
            ItemResultsCompanion.insert(
              id: db.newId(),
              createdAt: now,
              updatedAt: now,
              inspectionId: inspectionId,
              roomKey: roomKey,
              itemKey: 'wall',
              condition: const Value(ItemCondition.damaged),
              deletedAt: Value(deletedAt),
            ),
          );
    }

    Future<void> addPhoto(
      String inspectionId,
      String roomKey, {
      DateTime? deletedAt,
    }) {
      return db
          .into(db.photos)
          .insert(
            PhotosCompanion.insert(
              id: db.newId(),
              createdAt: now,
              updatedAt: now,
              inspectionId: inspectionId,
              roomKey: roomKey,
              itemKey: 'wall',
              relativePath: 'photos/$inspectionId/$roomKey.jpg',
              deletedAt: Value(deletedAt),
            ),
          );
    }

    test('從配置拿掉空間，這個空間的項目結果和照片軟刪除；其他空間、其他點交紀錄的不受影響', () async {
      final id = await createTwoRooms();
      final otherId = await createTwoRooms();
      for (final inspectionId in [id, otherId]) {
        for (final roomKey in ['bedroom', 'b2']) {
          await addResult(inspectionId, roomKey);
          await addPhoto(inspectionId, roomKey);
        }
      }
      final deletedAt = now.add(const Duration(hours: 1));
      clockNow = deletedAt;

      await db.inspectionsDao.deleteRoom(id, 'b2');

      final inspections = await db.select(db.inspections).get();
      final changed = inspections.singleWhere((i) => i.id == id);
      expect(changed.layout.rooms.map((r) => r.key), ['bedroom']);
      expect(changed.updatedAt, deletedAt);
      final other = inspections.singleWhere((i) => i.id == otherId);
      expect(other.layout, twoRooms);
      expect(other.updatedAt, now);

      bool isTarget(String inspectionId, String roomKey) =>
          inspectionId == id && roomKey == 'b2';
      final results = await db.select(db.itemResults).get();
      expect(results, hasLength(4));
      for (final r in results) {
        final target = isTarget(r.inspectionId, r.roomKey);
        expect(r.deletedAt, target ? deletedAt : isNull);
        expect(r.updatedAt, target ? deletedAt : now);
      }
      final photos = await db.select(db.photos).get();
      expect(photos, hasLength(4));
      for (final p in photos) {
        final target = isTarget(p.inspectionId, p.roomKey);
        expect(p.deletedAt, target ? deletedAt : isNull);
        expect(p.updatedAt, target ? deletedAt : now);
      }
    });

    test('之前已經刪掉的結果和照片，保留原本的刪除時間', () async {
      final id = await createTwoRooms();
      await addResult(id, 'b2', deletedAt: now);
      await addPhoto(id, 'b2', deletedAt: now);
      clockNow = now.add(const Duration(hours: 1));

      await db.inspectionsDao.deleteRoom(id, 'b2');

      final result = await db.select(db.itemResults).getSingle();
      expect(result.deletedAt, now);
      expect(result.updatedAt, now);
      final photo = await db.select(db.photos).getSingle();
      expect(photo.deletedAt, now);
      expect(photo.updatedAt, now);
    });

    test('只剩一個空間、空間不存在、點交紀錄不存在或已刪除時丟出 StateError，資料不變', () async {
      final single = await createMoveIn();
      await addResult(single, 'bedroom');
      await addPhoto(single, 'bedroom');
      final id = await createTwoRooms();
      await addResult(id, 'b2');
      await addPhoto(id, 'b2');
      final deleted = await createTwoRooms();
      await db.inspectionsDao.deleteInspection(deleted);
      await addResult(deleted, 'b2');
      clockNow = now.add(const Duration(hours: 1));

      await expectLater(
        db.inspectionsDao.deleteRoom(single, 'bedroom'),
        throwsStateError,
      );
      await expectLater(
        db.inspectionsDao.deleteRoom(id, 'nope'),
        throwsStateError,
      );
      await expectLater(
        db.inspectionsDao.deleteRoom(deleted, 'b2'),
        throwsStateError,
      );
      await expectLater(
        db.inspectionsDao.deleteRoom('not-exist', 'b2'),
        throwsStateError,
      );

      final inspections = await db.select(db.inspections).get();
      expect(inspections.singleWhere((i) => i.id == single).layout, layout);
      expect(inspections.singleWhere((i) => i.id == id).layout, twoRooms);
      expect(inspections.singleWhere((i) => i.id == deleted).layout, twoRooms);
      expect(inspections.map((i) => i.updatedAt), everyElement(now));
      final results = await db.select(db.itemResults).get();
      expect(results.map((r) => r.deletedAt), everyElement(isNull));
      final photos = await db.select(db.photos).get();
      expect(photos.map((p) => p.deletedAt), everyElement(isNull));
    });
  });
}
