import 'dart:async';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late String propertyId;
  late String inspectionId;

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

  Future<String> createInspection() => db.inspectionsDao.createInspection(
    propertyId: propertyId,
    type: InspectionType.moveIn,
    inspectedOn: '2026-11-04',
    landlordName: '王房東',
    layout: layout,
  );

  Future<List<ItemResult>> resultsOf(String id) =>
      db.itemResultsDao.watchItemResults(id).first;

  setUp(() async {
    now = DateTime.utc(2026, 11, 4, 9, 30);
    db = AppDatabase(NativeDatabase.memory(), clock: () => now);
    propertyId = await db.propertiesDao.createProperty(name: '中山路公寓');
    inspectionId = await createInspection();
  });

  tearDown(() async {
    await db.close();
  });

  test('建立物件和點交紀錄、寫入項目結果之後，全部都能正確讀回來', () async {
    await db.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      condition: ItemCondition.damaged,
    );
    await db.itemResultsDao.setNote(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      note: '牆角有水漬',
    );
    await db.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'floor',
      condition: ItemCondition.good,
    );

    final property = await db.propertiesDao.watchProperty(propertyId).first;
    final inspection = await db.inspectionsDao
        .watchInspection(inspectionId)
        .first;
    final results = await resultsOf(inspectionId);

    expect(property!.name, '中山路公寓');
    expect(inspection!.propertyId, propertyId);
    expect(inspection.layout, layout);
    expect(
      {for (final r in results) (r.roomKey, r.itemKey): (r.condition, r.note)},
      {
        ('bedroom', 'wall'): (ItemCondition.damaged, '牆角有水漬'),
        ('bedroom', 'floor'): (ItemCondition.good, ''),
      },
    );
  });

  test('狀況和備註分開寫入，不會互相蓋掉', () async {
    await db.itemResultsDao.setNote(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      note: '有釘孔',
    );
    await db.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      condition: ItemCondition.damaged,
    );

    final result = (await resultsOf(inspectionId)).single;

    expect(result.condition, ItemCondition.damaged);
    expect(result.note, '有釘孔');
  });

  test('同一個項目再寫一次是更新：不會多一筆，updatedAt 更新、createdAt 不變', () async {
    final createdAt = now;
    await db.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      condition: ItemCondition.good,
    );

    now = now.add(const Duration(minutes: 5));
    await db.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      condition: ItemCondition.missing,
    );

    final result = (await resultsOf(inspectionId)).single;

    expect(result.condition, ItemCondition.missing);
    expect(result.createdAt, createdAt);
    expect(result.updatedAt, now);
  });

  test('只讀到這筆點交的結果', () async {
    final otherInspectionId = await createInspection();
    await db.itemResultsDao.setCondition(
      inspectionId: otherInspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      condition: ItemCondition.good,
    );

    expect(await resultsOf(inspectionId), isEmpty);
    expect(await resultsOf(otherInspectionId), hasLength(1));
  });

  test('已軟刪除的結果不會出現', () async {
    await db.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      condition: ItemCondition.good,
    );
    await (db.update(db.itemResults))
        .write(ItemResultsCompanion(deletedAt: Value(now)));

    expect(await resultsOf(inspectionId), isEmpty);
  });

  test('寫入之後，監看中的查詢會自動收到新資料', () async {
    final received = <List<ItemCondition?>>[];
    final gotInitial = Completer<void>();
    final gotUpdate = Completer<void>();
    final subscription = db.itemResultsDao
        .watchItemResults(inspectionId)
        .listen((results) {
          received.add([for (final r in results) r.condition]);
          if (received.length == 1) gotInitial.complete();
          if (received.length == 2) gotUpdate.complete();
        });

    // 先等到第一次查詢的結果，確定寫入發生在開始監看之後。
    await gotInitial.future;
    await db.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      condition: ItemCondition.good,
    );
    await gotUpdate.future;
    await subscription.cancel();

    expect(received, [
      isEmpty,
      [ItemCondition.good],
    ]);
  });
}
