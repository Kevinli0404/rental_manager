import 'dart:io' show FileSystemException;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';
import 'package:rental_manager/app/router.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/core/database/database_provider.dart';
import 'package:rental_manager/core/files/file_store.dart';
import 'package:rental_manager/core/files/file_store_provider.dart';
import 'package:rental_manager/features/inspections/data/photo_repository.dart';
import 'package:rental_manager/features/inspections/providers/inspection_photos_provider.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

import '../../../helpers/pump_app.dart';

const _layout = Layout(
  templateId: 'default-residence',
  templateVersion: 1,
  rooms: [
    LayoutRoom(
      key: 'living_room',
      typeKey: 'living_room',
      name: '客廳',
      items: [
        LayoutItem(key: 'wall', name: '牆面'),
        LayoutItem(key: 'air_conditioner', name: '冷氣'),
      ],
    ),
  ],
);

void main() {
  late String propertyId;
  late String inspectionId;
  late _FakePhotoRepository repository;

  /// 建立物件、一筆入住草稿和「牆面」的兩張照片（photo-1、photo-2），不打開任何頁面。
  Future<AppDatabase> setUpData(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    final database = await pumpApp(
      tester,
      overrides: [
        photoRepositoryProvider.overrideWith(
          (ref) => repository = _FakePhotoRepository(
            ref.watch(databaseProvider),
            ref.watch(fileStoreProvider),
          ),
        ),
        ...overrides,
      ],
    );
    propertyId = await database.propertiesDao.createProperty(name: '中山路公寓');
    inspectionId = await database.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-13',
      landlordName: '',
      layout: _layout,
    );
    for (final id in ['photo-1', 'photo-2']) {
      await database.photosDao.insertPhoto(
        id: id,
        inspectionId: inspectionId,
        roomKey: 'living_room',
        itemKey: 'wall',
        relativePath: 'photos/$inspectionId/$id.jpg',
      );
    }
    // provider 第一次讀取時才建立；先建立好，測試才拿得到這次的假 repository。
    _container(tester).read(photoRepositoryProvider);
    return database;
  }

  void go(WidgetTester tester, String location) {
    _container(tester).read(routerProvider).go(location);
  }

  Future<void> openInspection(WidgetTester tester) async {
    go(tester, AppRoutes.inspection(propertyId, inspectionId));
    await tester.pumpAndSettle();
  }

  Finder thumbnails() => find.descendant(
    of: find.ancestor(of: find.text('牆面'), matching: find.byType(Card)),
    matching: find.byType(Image),
  );

  /// 在點交頁點「牆面」的第 [index] 張縮圖。
  Future<void> openThumbnail(WidgetTester tester, int index) async {
    await tester.tap(thumbnails().at(index));
    await tester.pumpAndSettle();
  }

  String photoPath(WidgetTester tester, String photoId) {
    return _container(tester)
        .read(fileStoreProvider)
        .resolve('photos/$inspectionId/$photoId.jpg')
        .path;
  }

  Finder viewerImage() => find.descendant(
    of: find.byType(InteractiveViewer),
    matching: find.byType(Image),
  );

  Finder inAppBar(String text) =>
      find.descendant(of: find.byType(AppBar), matching: find.text(text));

  Finder dialogButton(String label) => find.descendant(
    of: find.byType(AlertDialog),
    matching: find.widgetWithText(TextButton, label),
  );

  Future<Photo> savedPhoto(AppDatabase database, String id) {
    return (database.select(
      database.photos,
    )..where((p) => p.id.equals(id))).getSingle();
  }

  testWidgets('點縮圖打開照片檢視，顯示那張照片的檔案、可以放大；按返回回到點交頁', (tester) async {
    await setUpData(tester);
    await openInspection(tester);

    await openThumbnail(tester, 1);

    expect(inAppBar('入住 2026-11-13'), findsNothing);
    final image = tester.widget<Image>(viewerImage());
    expect((image.image as FileImage).file.path, photoPath(tester, 'photo-2'));
    expect(
      tester.widget<InteractiveViewer>(find.byType(InteractiveViewer)).maxScale,
      greaterThan(1),
    );

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(inAppBar('入住 2026-11-13'), findsOneWidget);
    expect(thumbnails(), findsNWidgets(2));
  });

  group('刪除', () {
    testWidgets('按取消留在檢視頁；確認後回到點交頁，這張照片從縮圖列消失', (tester) async {
      final database = await setUpData(tester);
      await openInspection(tester);
      await openThumbnail(tester, 1);

      await tester.tap(find.byTooltip('刪除'));
      await tester.pumpAndSettle();
      expect(find.text('刪除照片？'), findsOneWidget);
      await tester.tap(dialogButton('取消'));
      await tester.pumpAndSettle();
      expect(viewerImage(), findsOneWidget);
      expect(repository.deleted, isEmpty);

      await tester.tap(find.byTooltip('刪除'));
      await tester.pumpAndSettle();
      await tester.tap(dialogButton('刪除'));
      await tester.pumpAndSettle();

      expect(inAppBar('入住 2026-11-13'), findsOneWidget);
      expect(repository.deleted, ['photo-2']);
      expect((await savedPhoto(database, 'photo-2')).deletedAt, isNotNull);
      expect((await savedPhoto(database, 'photo-1')).deletedAt, isNull);
      final remaining = tester.widget<Image>(thumbnails());
      expect(
        (remaining.image as ResizeImage).imageProvider,
        isA<FileImage>().having(
          (f) => f.file.path,
          'path',
          photoPath(tester, 'photo-1'),
        ),
      );
    });

    testWidgets('刪除後的退場動畫中不會閃過「找不到這張照片」', (tester) async {
      await setUpData(tester);
      await openInspection(tester);
      await openThumbnail(tester, 0);
      await tester.tap(find.byTooltip('刪除'));
      await tester.pumpAndSettle();

      await tester.tap(dialogButton('刪除'));
      // 一格一格推進，涵蓋關掉確認視窗、檢視頁退場的每個畫面。
      for (var frame = 0; frame < 60; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        expect(find.text('找不到這張照片'), findsNothing, reason: '第 $frame 格');
      }
      await tester.pumpAndSettle();

      expect(thumbnails(), findsOneWidget);
    });

    testWidgets('刪除失敗時回到點交頁，照片還在並顯示錯誤', (tester) async {
      final database = await setUpData(tester);
      await openInspection(tester);
      await openThumbnail(tester, 0);
      repository.error = StateError('資料庫鎖住了');

      await tester.tap(find.byTooltip('刪除'));
      await tester.pumpAndSettle();
      await tester.tap(dialogButton('刪除'));
      await tester.pumpAndSettle();

      expect(inAppBar('入住 2026-11-13'), findsOneWidget);
      expect(thumbnails(), findsNWidgets(2));
      expect(find.textContaining('刪除失敗'), findsOneWidget);
      expect(find.textContaining('資料庫鎖住了'), findsOneWidget);
      expect((await savedPhoto(database, 'photo-1')).deletedAt, isNull);
    });
  });

  testWidgets('照片已經刪掉、但檔案沒清掉時，回到點交頁並分開說明，不說刪除失敗', (tester) async {
    await setUpData(tester);
    await openInspection(tester);
    await openThumbnail(tester, 0);
    repository.cleanupError = FileCleanupException(
      const FileSystemException('磁碟壞了'),
    );

    await tester.tap(find.byTooltip('刪除'));
    await tester.pumpAndSettle();
    await tester.tap(dialogButton('刪除'));
    await tester.pumpAndSettle();

    expect(inAppBar('入住 2026-11-13'), findsOneWidget);
    expect(thumbnails(), findsOneWidget);
    expect(find.textContaining('已刪除，但有照片檔沒有清掉'), findsOneWidget);
    expect(find.textContaining('磁碟壞了'), findsOneWidget);
    expect(find.textContaining('刪除失敗'), findsNothing);
  });

  testWidgets('已簽名的點交紀錄沒有刪除鈕', (tester) async {
    final database = await setUpData(tester);
    await (database.update(
      database.inspections,
    )..where((i) => i.id.equals(inspectionId))).write(
      const InspectionsCompanion(status: Value(InspectionStatus.signed)),
    );

    go(tester, AppRoutes.photo(propertyId, inspectionId, 'photo-1'));
    await tester.pumpAndSettle();

    expect(viewerImage(), findsOneWidget);
    expect(find.byTooltip('刪除'), findsNothing);
  });

  testWidgets('照片不存在或已刪除時顯示找不到，也沒有刪除鈕', (tester) async {
    final database = await setUpData(tester);
    await database.photosDao.deletePhoto('photo-1');

    for (final id in ['photo-1', 'not-exist']) {
      go(tester, AppRoutes.photo(propertyId, inspectionId, id));
      await tester.pumpAndSettle();

      expect(find.text('找不到這張照片'), findsOneWidget, reason: id);
      expect(find.byTooltip('刪除'), findsNothing, reason: id);
    }
  });

  testWidgets('照片檔讀不到時顯示說明', (tester) async {
    await setUpData(tester);
    go(tester, AppRoutes.photo(propertyId, inspectionId, 'photo-1'));
    await tester.pumpAndSettle();
    // 讓讀檔真的跑完（widget test 預設用假時間，真的檔案讀取不會自己完成）。
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();

    expect(find.text('讀不到這張照片的檔案'), findsOneWidget);
  });

  testWidgets('讀取照片失敗時顯示錯誤', (tester) async {
    await setUpData(
      tester,
      overrides: [
        photoProvider.overrideWith(
          (ref, id) => Stream.error(StateError('資料庫鎖住了')),
        ),
      ],
    );
    go(tester, AppRoutes.photo(propertyId, inspectionId, 'photo-1'));
    await tester.pumpAndSettle();

    expect(find.textContaining('讀取照片失敗'), findsOneWidget);
    expect(find.textContaining('資料庫鎖住了'), findsOneWidget);
    expect(find.byTooltip('刪除'), findsNothing);
  });
}

ProviderContainer _container(WidgetTester tester) {
  return ProviderScope.containerOf(
    tester.element(find.byType(RentalManagerApp)),
  );
}

/// 只改資料庫、不碰檔案的 repository；檔案的部分在 photo_repository_test.dart 測。
///
/// widget test 用假時間，真的檔案讀寫不會自己完成。
class _FakePhotoRepository extends PhotoRepository {
  _FakePhotoRepository(this._db, FileStore files) : super(_db, files);

  final AppDatabase _db;
  final deleted = <String>[];
  Error? error;

  /// 資料庫照樣刪除，之後丟出這個錯誤（模擬照片檔刪失敗）。
  FileCleanupException? cleanupError;

  @override
  Future<void> deletePhoto(String id) async {
    if (error case final error?) throw error;
    deleted.add(id);
    await _db.photosDao.deletePhoto(id);
    if (cleanupError case final cleanupError?) throw cleanupError;
  }
}
