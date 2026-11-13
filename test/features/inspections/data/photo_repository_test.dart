import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/core/files/file_store.dart';
import 'package:rental_manager/features/inspections/data/photo_repository.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

/// 臥室、臥室 2，各一個項目。
const _twoRooms = Layout(
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

void main() {
  late Directory temp;
  late AppDatabase db;
  late FileStore files;
  late PhotoRepository repository;
  late String propertyId;
  late String inspectionId;
  late String source;

  Future<String> createInspection(String forProperty) {
    return db.inspectionsDao.createInspection(
      propertyId: forProperty,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-12',
      landlordName: '',
      layout: _twoRooms,
    );
  }

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('photo_repository_test');
    files = FileStore(await Directory(p.join(temp.path, 'documents')).create());
    db = AppDatabase(NativeDatabase.memory());
    repository = PhotoRepository(db, files);

    propertyId = await db.propertiesDao.createProperty(name: '中山路公寓');
    inspectionId = await createInspection(propertyId);

    // image_picker 給的暫存檔，在 Documents 外面。
    final picked = File(p.join(temp.path, 'picker', 'image_picker_1.jpg'));
    await picked.parent.create(recursive: true);
    await picked.writeAsBytes([1, 2, 3]);
    source = picked.path;
  });

  tearDown(() async {
    await db.close();
    await temp.delete(recursive: true);
  });

  /// Documents 裡所有的照片檔（相對於 Documents 的路徑）。
  Future<List<String>> savedFiles() async {
    final photos = Directory(p.join(files.root.path, 'photos'));
    if (!await photos.exists()) return [];
    return [
      await for (final entity in photos.list(recursive: true))
        if (entity is File) p.relative(entity.path, from: files.root.path),
    ];
  }

  Future<void> add({String? forInspection, String roomKey = 'bedroom'}) {
    return repository.addPhoto(
      inspectionId: forInspection ?? inspectionId,
      roomKey: roomKey,
      itemKey: 'wall',
      sourcePath: source,
    );
  }

  /// 某筆點交在資料庫裡的照片（含已刪除的），依建立時間。
  Future<List<Photo>> photosOf(String forInspection) {
    return (db.select(db.photos)
          ..where((p) => p.inspectionId.equals(forInspection))
          ..orderBy([(p) => OrderingTerm.asc(p.createdAt)]))
        .get();
  }

  group('addPhoto', () {
    test('照片存進 Documents，資料庫只存相對路徑', () async {
      await add();

      final photo = await db.select(db.photos).getSingle();
      expect(photo.inspectionId, inspectionId);
      expect(photo.roomKey, 'bedroom');
      expect(photo.itemKey, 'wall');
      expect(photo.relativePath, 'photos/$inspectionId/${photo.id}.jpg');
      expect(photo.relativePath, isNot(contains(temp.path)));
      expect(await files.resolve(photo.relativePath).readAsBytes(), [1, 2, 3]);
    });

    test('資料庫寫入失敗時，剛存的檔刪掉，錯誤往上丟', () async {
      // 點交紀錄不存在，外鍵檢查讓寫入失敗。
      await expectLater(
        add(forInspection: 'not-exist'),
        throwsA(isA<SqliteException>()),
      );

      expect(await db.select(db.photos).get(), isEmpty);
      expect(await savedFiles(), isEmpty);
    });
  });

  group('deletePhoto', () {
    test('資料庫標記刪除，檔案也刪掉；其他照片不受影響', () async {
      await add();
      await add();
      final [deleted, kept] = await db.select(db.photos).get();

      await repository.deletePhoto(deleted.id);

      final rows = await db.select(db.photos).get();
      expect(rows.singleWhere((r) => r.id == deleted.id).deletedAt, isNotNull);
      expect(rows.singleWhere((r) => r.id == kept.id).deletedAt, isNull);
      expect(await savedFiles(), [kept.relativePath]);
    });

    test('照片不存在或已刪除時丟出 StateError，檔案不動', () async {
      await add();
      final photo = await db.select(db.photos).getSingle();
      // 只在資料庫標記刪除，檔案還在。
      await db.photosDao.deletePhoto(photo.id);

      await expectLater(repository.deletePhoto(photo.id), throwsStateError);
      await expectLater(repository.deletePhoto('not-exist'), throwsStateError);

      expect(await savedFiles(), [photo.relativePath]);
    });
  });

  group('會連帶刪掉照片的刪除', () {
    test('刪除空間：這個空間的照片檔刪掉，其他空間的照片還在', () async {
      await add(roomKey: 'bedroom');
      await add(roomKey: 'b2');
      final [kept, deleted] = await photosOf(inspectionId);

      await repository.deleteRoom(inspectionId, 'b2');

      expect(await savedFiles(), [kept.relativePath]);
      final [keptRow, deletedRow] = await photosOf(inspectionId);
      expect(keptRow.deletedAt, isNull);
      expect(deletedRow.id, deleted.id);
      expect(deletedRow.deletedAt, isNotNull);
    });

    test('刪除點交紀錄：它的照片資料夾整個刪掉，其他點交紀錄的照片還在', () async {
      final otherId = await createInspection(propertyId);
      await add();
      await add(roomKey: 'b2');
      await add(forInspection: otherId);

      await repository.deleteInspection(inspectionId);

      final [kept] = await photosOf(otherId);
      expect(await savedFiles(), [kept.relativePath]);
      expect(
        await db.inspectionsDao.watchInspection(inspectionId).first,
        isNull,
      );
    });

    test('刪除物件：底下點交紀錄的照片都刪掉，其他物件的照片還在', () async {
      final secondId = await createInspection(propertyId);
      final otherProperty = await db.propertiesDao.createProperty(name: '民生社區');
      final otherId = await createInspection(otherProperty);
      await add();
      await add(forInspection: secondId);
      await add(forInspection: otherId);

      await repository.deleteProperty(propertyId);

      final [kept] = await photosOf(otherId);
      expect(await savedFiles(), [kept.relativePath]);
      expect(await db.propertiesDao.watchProperty(propertyId).first, isNull);
    });

    test('資料庫刪除失敗時丟出原本的錯誤，照片檔不動', () async {
      final single = await db.inspectionsDao.createInspection(
        propertyId: propertyId,
        type: InspectionType.moveIn,
        inspectedOn: '2026-11-12',
        landlordName: '',
        layout: _twoRooms.copyWith(rooms: [_twoRooms.rooms.first]),
      );
      await add(forInspection: single);
      // 已經從資料庫刪掉、照片檔還在的點交紀錄。
      await add();
      await db.inspectionsDao.deleteInspection(inspectionId);
      final before = await savedFiles();

      // 只剩一個空間、點交紀錄已刪除、物件不存在。
      await expectLater(
        repository.deleteRoom(single, 'bedroom'),
        throwsStateError,
      );
      await expectLater(
        repository.deleteInspection(inspectionId),
        throwsStateError,
      );
      await expectLater(
        repository.deleteProperty('not-exist'),
        throwsStateError,
      );

      expect(await savedFiles(), before);
    });

    test('資料庫已經刪掉、但刪檔失敗時丟出 FileCleanupException', () async {
      await add();
      await add(roomKey: 'b2');
      final [photo, roomPhoto] = await photosOf(inspectionId);
      // 刪物件時要有還沒刪除的點交紀錄，才會去刪它的照片資料夾。
      await createInspection(propertyId);
      final failing = PhotoRepository(db, _FailingFileStore(files.root));

      Matcher cleanupFailed() => throwsA(
        isA<FileCleanupException>().having(
          (e) => e.cause,
          'cause',
          isA<FileSystemException>(),
        ),
      );
      await expectLater(failing.deletePhoto(photo.id), cleanupFailed());
      await expectLater(
        failing.deleteRoom(inspectionId, 'b2'),
        cleanupFailed(),
      );
      await expectLater(
        failing.deleteInspection(inspectionId),
        cleanupFailed(),
      );
      await expectLater(failing.deleteProperty(propertyId), cleanupFailed());

      // 資料都已經刪掉了，只是檔案還在。
      final rows = await photosOf(inspectionId);
      expect(rows.map((r) => r.deletedAt), everyElement(isNotNull));
      expect(rows.map((r) => r.id), [photo.id, roomPhoto.id]);
      expect(await db.propertiesDao.watchProperty(propertyId).first, isNull);
      expect(await savedFiles(), hasLength(2));
    });
  });
}

/// 刪檔一定失敗的 FileStore。
class _FailingFileStore extends FileStore {
  _FailingFileStore(super.root);

  @override
  Future<void> delete(String relativePath) async {
    throw FileSystemException('磁碟壞了', relativePath);
  }

  @override
  Future<void> deleteInspectionPhotos(String inspectionId) async {
    throw FileSystemException('磁碟壞了', inspectionId);
  }
}
