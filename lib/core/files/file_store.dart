import 'dart:io';

import 'package:path/path.dart' as p;

/// App Documents 目錄裡的照片、簽名檔案（architecture.md「檔案」）。
///
/// 對外只用相對路徑（D-005）：iOS 更新 App 之後沙盒的絕對路徑可能會變，
/// 每次用的時候再依 [root] 組出絕對路徑。相對路徑一律用 `/` 分隔。
class FileStore {
  FileStore(this.root);

  /// Documents 目錄。
  final Directory root;

  /// 把 [sourcePath] 的檔案複製成 `photos/{inspectionId}/{photoId}{副檔名}`，回傳相對路徑。
  ///
  /// 副檔名照來源檔、轉成小寫：image_picker 輸出的 JPEG 是 `.jpg`，相簿裡的 PNG、GIF
  /// 保留原本的格式（D-021）。來源檔不會被改動。
  Future<String> savePhoto({
    required String inspectionId,
    required String photoId,
    required String sourcePath,
  }) async {
    final extension = p.extension(sourcePath).toLowerCase();
    final relativePath = p.posix.join(
      'photos',
      inspectionId,
      '$photoId$extension',
    );
    final target = resolve(relativePath);
    await target.parent.create(recursive: true);
    await File(sourcePath).copy(target.path);
    return relativePath;
  }

  /// 相對路徑對應的檔案。
  File resolve(String relativePath) {
    return File(p.joinAll([root.path, ...p.posix.split(relativePath)]));
  }

  /// 刪除某筆點交的所有照片檔，也就是整個 `photos/{inspectionId}/` 資料夾；
  /// 資料夾不存在也算成功。
  Future<void> deleteInspectionPhotos(String inspectionId) async {
    final folder = Directory(p.join(root.path, 'photos', inspectionId));
    if (await folder.exists()) {
      await folder.delete(recursive: true);
    }
  }

  /// 刪除檔案；檔案本來就不存在也算成功。
  ///
  /// 推論：不存在就當作已經刪掉。例如上次刪到一半 App 被關掉，再刪一次時不該報錯。
  Future<void> delete(String relativePath) async {
    final file = resolve(relativePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

/// 資料已經刪除，但有檔案沒刪掉。
///
/// 資料不用重刪，只是檔案還留在 Documents 裡佔空間；畫面上要跟「刪除失敗」分開說明
/// （D-022）。
class FileCleanupException implements Exception {
  FileCleanupException(this.cause);

  /// 刪檔時發生的錯誤。
  final Object cause;

  @override
  String toString() => 'FileCleanupException: $cause';
}
