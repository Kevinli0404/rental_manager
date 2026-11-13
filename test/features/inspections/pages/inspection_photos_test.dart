import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
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

/// 客廳（牆面、冷氣）、臥室、臥室 2；兩間臥室的項目 key 一樣。
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
    LayoutRoom(
      key: 'bedroom',
      typeKey: 'bedroom',
      name: '臥室',
      items: [LayoutItem(key: 'wall', name: '牆面')],
    ),
    LayoutRoom(
      key: '0b7e4c2a-5d1f-4e8b-9a63-2f1c8d7e6b54',
      typeKey: 'bedroom',
      name: '臥室 2',
      items: [LayoutItem(key: 'wall', name: '牆面')],
    ),
  ],
);

const _secondBedroomKey = '0b7e4c2a-5d1f-4e8b-9a63-2f1c8d7e6b54';

void main() {
  late String inspectionId;
  late _FakeImagePicker picker;
  late _FakePhotoRepository repository;

  /// 建立物件和一筆入住草稿，打開點交頁。拍照、選相簿和寫入都換成假的。
  Future<AppDatabase> openInspection(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    picker = _FakeImagePicker();
    final database = await pumpApp(
      tester,
      overrides: [
        imagePickerProvider.overrideWithValue(picker),
        photoRepositoryProvider.overrideWith(
          (ref) => repository = _FakePhotoRepository(
            ref.watch(databaseProvider),
            ref.watch(fileStoreProvider),
          ),
        ),
        ...overrides,
      ],
    );
    final propertyId = await database.propertiesDao.createProperty(
      name: '中山路公寓',
    );
    inspectionId = await database.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-12',
      landlordName: '',
      layout: _layout,
    );
    _container(tester)
        .read(routerProvider)
        .go(AppRoutes.inspection(propertyId, inspectionId));
    await tester.pumpAndSettle();
    return database;
  }

  Finder cardOf(String item) {
    return find.ancestor(of: find.text(item), matching: find.byType(Card));
  }

  /// 按 [item] 的相機鈕，在底部選單選 [source]（「拍照」或「從相簿選」）。
  Future<void> addPhotos(
    WidgetTester tester,
    String item,
    String source,
  ) async {
    final button = find.descendant(
      of: cardOf(item),
      matching: find.byTooltip('新增照片'),
    );
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.tap(find.text(source));
    await tester.pumpAndSettle();
  }

  /// [item] 卡片上縮圖對應的檔案路徑，依顯示順序。
  List<String> thumbnailsOf(WidgetTester tester, String item) {
    return [
      for (final image in tester.widgetList<Image>(
        find.descendant(of: cardOf(item), matching: find.byType(Image)),
      ))
        _filePath(image.image),
    ];
  }

  Future<List<Photo>> savedPhotos(AppDatabase database) {
    return (database.select(
      database.photos,
    )..orderBy([(p) => OrderingTerm.asc(p.createdAt)])).get();
  }

  Future<void> openTab(WidgetTester tester, String room) async {
    await tester.tap(find.widgetWithText(Tab, room));
    await tester.pumpAndSettle();
  }

  testWidgets('相機鈕跳出「拍照」「從相簿選」；拍照要求長邊 1600、品質 80，照片加到這個項目並顯示縮圖', (
    tester,
  ) async {
    final database = await openInspection(tester);
    picker.camera = XFile('/picker/camera_1.jpg');

    await tester.tap(
      find.descendant(of: cardOf('牆面'), matching: find.byTooltip('新增照片')),
    );
    await tester.pumpAndSettle();
    expect(find.text('拍照'), findsOneWidget);
    expect(find.text('從相簿選'), findsOneWidget);
    await tester.tap(find.text('拍照'));
    await tester.pumpAndSettle();

    expect(picker.calls, [
      'pickImage(camera, maxWidth: 1600.0, maxHeight: 1600.0, '
          'imageQuality: 80, requestFullMetadata: false)',
    ]);
    expect(repository.sources, ['/picker/camera_1.jpg']);
    final photo = (await savedPhotos(database)).single;
    expect(photo.inspectionId, inspectionId);
    expect(photo.roomKey, 'living_room');
    expect(photo.itemKey, 'wall');
    final files = _container(tester).read(fileStoreProvider);
    expect(thumbnailsOf(tester, '牆面'), [
      files.resolve(photo.relativePath).path,
    ]);
    expect(thumbnailsOf(tester, '冷氣'), isEmpty);
  });

  testWidgets('從相簿一次選多張，同樣的縮小要求，依選取順序加入', (tester) async {
    final database = await openInspection(tester);
    picker.gallery = [XFile('/picker/a.jpg'), XFile('/picker/b.png')];

    await addPhotos(tester, '冷氣', '從相簿選');

    expect(picker.calls, [
      'pickMultiImage(maxWidth: 1600.0, maxHeight: 1600.0, '
          'imageQuality: 80, requestFullMetadata: false)',
    ]);
    expect(repository.sources, ['/picker/a.jpg', '/picker/b.png']);
    final photos = await savedPhotos(database);
    expect(photos.map((p) => p.itemKey), [
      'air_conditioner',
      'air_conditioner',
    ]);
    final thumbnails = thumbnailsOf(tester, '冷氣');
    expect(thumbnails.map(p.extension), ['.jpg', '.png']);
  });

  testWidgets('沒選來源、拍照取消、相簿沒選照片時，什麼都不做', (tester) async {
    final database = await openInspection(tester);

    await tester.tap(
      find.descendant(of: cardOf('牆面'), matching: find.byTooltip('新增照片')),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('拍照'), findsNothing, reason: '底部選單關掉了');
    expect(picker.calls, isEmpty);

    await addPhotos(tester, '牆面', '拍照');
    await addPhotos(tester, '牆面', '從相簿選');

    expect(picker.calls, hasLength(2));
    expect(await savedPhotos(database), isEmpty);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('兩間臥室的項目 key 一樣，照片還是分開存、分開顯示', (tester) async {
    final database = await openInspection(tester);
    picker.camera = XFile('/picker/camera_1.jpg');

    await openTab(tester, '臥室 2');
    await addPhotos(tester, '牆面', '拍照');
    expect(thumbnailsOf(tester, '牆面'), hasLength(1));

    final photo = (await savedPhotos(database)).single;
    expect(photo.roomKey, _secondBedroomKey);
    await openTab(tester, '臥室');
    expect(thumbnailsOf(tester, '牆面'), isEmpty);
  });

  testWidgets('沒有相機權限時提示到「設定」開啟；其他失敗顯示錯誤', (tester) async {
    final database = await openInspection(tester);

    Future<void> expectMessage(String message) async {
      expect(find.text(message), findsOneWidget);
      // 等這個訊息消失，下一個訊息才會出現。
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }

    for (final code in ['camera_access_denied', 'camera_access_restricted']) {
      picker.error = PlatformException(code: code);
      await addPhotos(tester, '牆面', '拍照');
      await expectMessage('沒有相機權限，請到「設定」開啟');
    }

    picker.error = null;
    picker.gallery = [XFile('/picker/a.jpg')];
    repository.error = StateError('磁碟已滿');
    await addPhotos(tester, '牆面', '從相簿選');
    expect(find.textContaining('加入照片失敗'), findsOneWidget);
    expect(find.textContaining('磁碟已滿'), findsOneWidget);

    expect(await savedPhotos(database), isEmpty);
  });

  testWidgets('照片檔讀不到時，縮圖顯示破圖示', (tester) async {
    final database = await openInspection(tester);
    await database.photosDao.insertPhoto(
      id: 'photo-1',
      inspectionId: inspectionId,
      roomKey: 'living_room',
      itemKey: 'wall',
      relativePath: 'photos/$inspectionId/photo-1.jpg',
    );
    await tester.pumpAndSettle();
    // 讓讀檔真的跑完（widget test 預設用假時間，真的檔案讀取不會自己完成）。
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: cardOf('牆面'),
        matching: find.byIcon(Icons.broken_image_outlined),
      ),
      findsOneWidget,
    );
  });

  testWidgets('讀取照片失敗時顯示錯誤', (tester) async {
    await openInspection(
      tester,
      overrides: [inspectionPhotosProvider.overrideWith2(_BrokenPhotos.new)],
    );

    expect(find.textContaining('讀取照片失敗'), findsOneWidget);
    expect(find.textContaining('資料庫鎖住了'), findsOneWidget);
  });
}

ProviderContainer _container(WidgetTester tester) {
  return ProviderScope.containerOf(
    tester.element(find.byType(RentalManagerApp)),
  );
}

String _filePath(ImageProvider provider) {
  return switch (provider) {
    ResizeImage(:final imageProvider) => _filePath(imageProvider),
    FileImage(:final file) => file.path,
    _ => throw StateError('不是照片檔：$provider'),
  };
}

/// 記下被呼叫的方式，回傳事先指定的結果。
class _FakeImagePicker extends Fake implements ImagePicker {
  final calls = <String>[];
  XFile? camera;
  List<XFile> gallery = [];
  Exception? error;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    calls.add(
      'pickImage(${source.name}, maxWidth: $maxWidth, maxHeight: $maxHeight, '
      'imageQuality: $imageQuality, requestFullMetadata: $requestFullMetadata)',
    );
    if (error case final error?) throw error;
    return camera;
  }

  @override
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    calls.add(
      'pickMultiImage(maxWidth: $maxWidth, maxHeight: $maxHeight, '
      'imageQuality: $imageQuality, requestFullMetadata: $requestFullMetadata)',
    );
    if (error case final error?) throw error;
    return gallery;
  }
}

/// 只寫資料庫、不碰檔案的 repository；檔案的部分在 photo_repository_test.dart 測。
///
/// widget test 用假時間，真的檔案讀寫不會自己完成。
class _FakePhotoRepository extends PhotoRepository {
  _FakePhotoRepository(this._db, FileStore files) : super(_db, files);

  final AppDatabase _db;
  final sources = <String>[];
  Error? error;

  @override
  Future<void> addPhoto({
    required String inspectionId,
    required String roomKey,
    required String itemKey,
    required String sourcePath,
  }) async {
    if (error case final error?) throw error;
    sources.add(sourcePath);
    final id = _db.newId();
    await _db.photosDao.insertPhoto(
      id: id,
      inspectionId: inspectionId,
      roomKey: roomKey,
      itemKey: itemKey,
      relativePath: 'photos/$inspectionId/$id${p.extension(sourcePath)}',
    );
  }
}

/// 讀取照片失敗。
class _BrokenPhotos extends InspectionPhotos {
  _BrokenPhotos(super.inspectionId);

  @override
  Stream<List<Photo>> build() => Stream.error(StateError('資料庫鎖住了'));
}
