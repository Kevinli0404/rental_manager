import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/core/database/database_provider.dart';
import 'package:rental_manager/core/files/file_store.dart';
import 'package:rental_manager/core/files/file_store_provider.dart';
import 'package:rental_manager/features/inspections/providers/inspection_controller.dart';
import 'package:rental_manager/features/inspections/providers/inspection_list_provider.dart';
import 'package:rental_manager/features/inspections/providers/inspection_photos_provider.dart';
import 'package:rental_manager/features/properties/providers/property_list_provider.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

/// 畫面上的刪除（空間、點交紀錄、物件）都經過 PhotoRepository，照片檔會一起刪掉（D-022）。
///
/// widget test 用假時間，真的檔案刪除不會自己完成，所以這裡直接呼叫 provider。
void main() {
  late Directory temp;
  late AppDatabase db;
  late FileStore files;
  late ProviderContainer container;
  late String propertyId;
  late String inspectionId;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('delete_with_photos_test');
    files = FileStore(await Directory(p.join(temp.path, 'documents')).create());
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        fileStoreProvider.overrideWithValue(files),
      ],
    );

    propertyId = await db.propertiesDao.createProperty(name: '中山路公寓');
    inspectionId = await db.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-13',
      landlordName: '',
      layout: const Layout(
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
      ),
    );
    final source = File(p.join(temp.path, 'picked.jpg'));
    await source.writeAsBytes([1, 2, 3]);
    await container
        .read(photoRepositoryProvider)
        .addPhoto(
          inspectionId: inspectionId,
          roomKey: 'b2',
          itemKey: 'wall',
          sourcePath: source.path,
        );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
    await temp.delete(recursive: true);
  });

  Future<bool> photoFileExists() async {
    final photo = await db.select(db.photos).getSingle();
    return files.resolve(photo.relativePath).exists();
  }

  test('管理空間刪除空間時，照片檔一起刪掉', () async {
    expect(await photoFileExists(), isTrue);
    final subscription = container.listen(
      inspectionControllerProvider(inspectionId),
      (_, _) {},
    );
    addTearDown(subscription.close);

    await container
        .read(inspectionControllerProvider(inspectionId).notifier)
        .deleteRoom('b2');

    expect(await photoFileExists(), isFalse);
  });

  test('刪除點交紀錄時，照片檔一起刪掉', () async {
    final subscription = container.listen(
      inspectionListProvider(propertyId),
      (_, _) {},
    );
    addTearDown(subscription.close);

    await container
        .read(inspectionListProvider(propertyId).notifier)
        .delete(inspectionId);

    expect(await photoFileExists(), isFalse);
  });

  test('刪除物件時，底下點交紀錄的照片檔一起刪掉', () async {
    final subscription = container.listen(propertyListProvider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(propertyListProvider.notifier).delete(propertyId);

    expect(await photoFileExists(), isFalse);
  });
}
