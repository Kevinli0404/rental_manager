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
