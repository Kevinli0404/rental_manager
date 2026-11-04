import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 11, 4, 9, 30);
  final uuidV4 = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );

  setUp(() {
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
}
