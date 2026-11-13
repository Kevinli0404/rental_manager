import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

void main() {
  late AppDatabase db;
  late String inspectionId;
  final now = DateTime.utc(2026, 11, 12, 9, 30);
  // 資料庫的時間；要讓資料的建立時間不同時，測試裡可以往後調。
  late DateTime clockNow;

  Future<String> createInspection(String propertyId) {
    return db.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-12',
      landlordName: '',
      layout: const Layout(
        templateId: 'default-residence',
        templateVersion: 1,
        rooms: [],
      ),
    );
  }

  Future<void> insert(String id, {String? forInspection}) {
    return db.photosDao.insertPhoto(
      id: id,
      inspectionId: forInspection ?? inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      relativePath: 'photos/${forInspection ?? inspectionId}/$id.jpg',
    );
  }

  Future<List<String>> watchedIds() async {
    final photos = await db.photosDao.watchPhotos(inspectionId).first;
    return [for (final photo in photos) photo.id];
  }

  setUp(() async {
    clockNow = now;
    db = AppDatabase(NativeDatabase.memory(), clock: () => clockNow);
    final propertyId = await db.propertiesDao.createProperty(name: '中山路公寓');
    inspectionId = await createInspection(propertyId);
  });

  tearDown(() async {
    await db.close();
  });

  test('新增的照片讀得回來，欄位都對', () async {
    await insert('photo-1');

    final photo = (await db.photosDao.watchPhotos(inspectionId).first).single;
    expect(photo.id, 'photo-1');
    expect(photo.inspectionId, inspectionId);
    expect(photo.roomKey, 'bedroom');
    expect(photo.itemKey, 'wall');
    expect(photo.relativePath, 'photos/$inspectionId/photo-1.jpg');
    expect(photo.createdAt, now);
    expect(photo.updatedAt, now);
    expect(photo.deletedAt, isNull);
  });

  test('依建立時間舊到新；不含已刪除的，也不含其他點交的', () async {
    clockNow = now.add(const Duration(minutes: 2));
    await insert('later');
    clockNow = now;
    await insert('earlier');
    clockNow = now.add(const Duration(minutes: 1));
    await insert('deleted');
    await db.photosDao.deletePhoto('deleted');
    final otherProperty = await db.propertiesDao.createProperty(name: '民生社區');
    await insert('other', forInspection: await createInspection(otherProperty));

    expect(await watchedIds(), ['earlier', 'later']);
  });

  test('新增後，監看中的查詢自動收到新的列表', () async {
    final stream = db.photosDao.watchPhotos(inspectionId);
    final emitted = stream.map((photos) => photos.length).take(2).toList();
    await stream.first;
    await insert('photo-1');

    expect(await emitted, [0, 1]);
  });

  test('依 id 監看照片；不存在或已刪除時是 null', () async {
    await insert('photo-1');
    await insert('deleted');
    await db.photosDao.deletePhoto('deleted');

    expect((await db.photosDao.watchPhoto('photo-1').first)?.id, 'photo-1');
    expect(await db.photosDao.watchPhoto('deleted').first, isNull);
    expect(await db.photosDao.watchPhoto('not-exist').first, isNull);
  });

  group('deletePhoto', () {
    test('標記刪除時間並更新 updatedAt，回傳相對路徑；其他照片不受影響', () async {
      await insert('deleted');
      await insert('kept');
      final deletedAt = now.add(const Duration(hours: 1));
      clockNow = deletedAt;

      final relativePath = await db.photosDao.deletePhoto('deleted');

      expect(relativePath, 'photos/$inspectionId/deleted.jpg');
      final rows = await db.select(db.photos).get();
      final deleted = rows.singleWhere((p) => p.id == 'deleted');
      expect(deleted.deletedAt, deletedAt);
      expect(deleted.updatedAt, deletedAt);
      final kept = rows.singleWhere((p) => p.id == 'kept');
      expect(kept.deletedAt, isNull);
      expect(kept.updatedAt, now);
    });

    test('不存在或已刪除時丟出 StateError，已刪除的刪除時間不變', () async {
      await insert('photo-1');
      await db.photosDao.deletePhoto('photo-1');
      clockNow = now.add(const Duration(hours: 1));

      await expectLater(db.photosDao.deletePhoto('photo-1'), throwsStateError);
      await expectLater(
        db.photosDao.deletePhoto('not-exist'),
        throwsStateError,
      );
      final row = await db.select(db.photos).getSingle();
      expect(row.deletedAt, now);
      expect(row.updatedAt, now);
    });
  });
}
