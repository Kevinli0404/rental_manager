import '../../../core/database/database.dart';
import '../../../core/files/file_store.dart';

/// 照片的新增和刪除：要同時處理檔案和資料庫，所以用 repository（D-016）。
///
/// 照片的寫入都走這裡，不直接呼叫 `PhotosDao`。
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
    await _files.delete(relativePath);
  }
}
