import '../../../core/database/database.dart';
import '../../../core/files/file_store.dart';

/// 照片的新增和刪除，以及會連帶刪掉照片的刪除（空間、點交紀錄、物件）：要同時處理
/// 檔案和資料庫，所以用 repository（D-016、D-022）。
///
/// 這些寫入都走這裡，不直接呼叫 DAO。先寫資料庫，成功後才刪檔；刪檔失敗時丟出
/// [FileCleanupException]，表示資料已經刪了、只是檔案沒清掉。
class PhotoRepository {
  PhotoRepository(this._database, this._files);

  final AppDatabase _database;
  final FileStore _files;

  /// 把 [sourcePath] 的照片加到某筆點交的某個項目。
  ///
  /// 先存檔再寫資料庫，資料庫只存相對路徑（D-005）。資料庫寫入失敗時，刪掉剛存的檔再把錯誤
  /// 往上丟，不留下沒有紀錄的檔案；刪檔本身也失敗的話，丟出的是刪檔的錯誤。
  Future<void> addPhoto({
    required String inspectionId,
    required String roomKey,
    required String itemKey,
    required String sourcePath,
  }) async {
    final id = _database.newId();
    final relativePath = await _files.savePhoto(
      inspectionId: inspectionId,
      photoId: id,
      sourcePath: sourcePath,
    );
    try {
      await _database.photosDao.insertPhoto(
        id: id,
        inspectionId: inspectionId,
        roomKey: roomKey,
        itemKey: itemKey,
        relativePath: relativePath,
      );
    } catch (_) {
      await _files.delete(relativePath);
      rethrow;
    }
  }

  /// 刪除照片：先在資料庫標記刪除，成功後才刪檔（architecture.md「檔案」）。
  ///
  /// 照片不存在或已刪除時丟出 [StateError]，檔案不動。
  Future<void> deletePhoto(String id) async {
    final relativePath = await _database.photosDao.deletePhoto(id);
    await _cleanUp(() => _files.delete(relativePath));
  }

  /// 刪除空間（見 `InspectionsDao.deleteRoom`），再刪這個空間的照片檔。
  Future<void> deleteRoom(String inspectionId, String roomKey) async {
    final relativePaths = await _database.inspectionsDao.deleteRoom(
      inspectionId,
      roomKey,
    );
    await _cleanUp(() async {
      for (final relativePath in relativePaths) {
        await _files.delete(relativePath);
      }
    });
  }

  /// 刪除點交紀錄（見 `InspectionsDao.deleteInspection`），再刪它的照片資料夾。
  Future<void> deleteInspection(String id) async {
    await _database.inspectionsDao.deleteInspection(id);
    await _cleanUp(() => _files.deleteInspectionPhotos(id));
  }

  /// 刪除物件（見 `PropertiesDao.deleteProperty`），再刪這次一起刪掉的點交紀錄的
  /// 照片資料夾。之前就刪掉的點交紀錄，照片在當時已經刪了。
  Future<void> deleteProperty(String id) async {
    final inspectionIds = await _database.propertiesDao.deleteProperty(id);
    await _cleanUp(() async {
      for (final inspectionId in inspectionIds) {
        await _files.deleteInspectionPhotos(inspectionId);
      }
    });
  }

  /// 資料庫已經刪除後的刪檔；失敗時包成 [FileCleanupException]。
  ///
  /// 推論：有一個檔案刪失敗就停下來，剩下的檔案也留著，一起當作沒清掉。
  Future<void> _cleanUp(Future<void> Function() deleteFiles) async {
    try {
      await deleteFiles();
    } catch (error) {
      throw FileCleanupException(error);
    }
  }
}
