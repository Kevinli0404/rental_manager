import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/core/files/file_store.dart';
import 'package:rental_manager/features/inspections/data/photo_repository.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

void main() {
  late Directory temp;
  late AppDatabase db;
  late FileStore files;
  late PhotoRepository repository;
  late String inspectionId;
  late String source;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('photo_repository_test');
    files = FileStore(await Directory(p.join(temp.path, 'documents')).create());
    db = AppDatabase(NativeDatabase.memory());
    repository = PhotoRepository(db, files);

    final propertyId = await db.propertiesDao.createProperty(name: '中山路公寓');
    inspectionId = await db.inspectionsDao.createInspection(
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

  Future<void> add({String? forInspection}) {
    return repository.addPhoto(
      inspectionId: forInspection ?? inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      sourcePath: source,
    );
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
}
