import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/photos.dart';

part 'photos_dao.g.dart';

/// 照片紀錄；檔案本身由 `FileStore` 處理，這裡只存相對路徑（D-005）。
@DriftAccessor(tables: [Photos])
class PhotosDao extends DatabaseAccessor<AppDatabase> with _$PhotosDaoMixin {
  PhotosDao(super.attachedDatabase);

  /// 新增照片紀錄。
  ///
  /// [id] 由呼叫端先產生（`AppDatabase.newId()`），因為檔名要用到它，檔案存好之後才寫入。
  Future<void> insertPhoto({
    required String id,
    required String inspectionId,
    required String roomKey,
    required String itemKey,
    required String relativePath,
  }) async {
    final now = attachedDatabase.nowUtc();
    await into(photos).insert(
      PhotosCompanion.insert(
        id: id,
        createdAt: now,
        updatedAt: now,
        inspectionId: inspectionId,
        roomKey: roomKey,
        itemKey: itemKey,
        relativePath: relativePath,
      ),
    );
  }

  /// 監看某筆點交的照片（不含已刪除），依建立時間舊到新。
  ///
  /// 推論：舊到新，跟拍照的先後順序一致；新拍的接在縮圖列最後面。
  Stream<List<Photo>> watchPhotos(String inspectionId) {
    return (select(photos)
          ..where(
            (p) => p.inspectionId.equals(inspectionId) & p.deletedAt.isNull(),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.createdAt)]))
        .watch();
  }

  /// 軟刪除照片，回傳它的相對路徑，讓呼叫端接著刪檔。
  ///
  /// 不存在或已刪除時丟出 [StateError]，不默默略過。
  Future<String> deletePhoto(String id) {
    return transaction(() async {
      final photo =
          await (select(photos)
                ..where((p) => p.id.equals(id) & p.deletedAt.isNull()))
              .getSingleOrNull();
      if (photo == null) {
        throw StateError('照片不存在或已刪除：$id');
      }
      final now = attachedDatabase.nowUtc();
      await (update(photos)..where((p) => p.id.equals(id))).write(
        PhotosCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      return photo.relativePath;
    });
  }
}
