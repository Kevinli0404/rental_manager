import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/files/file_store_provider.dart';
import '../data/photo_repository.dart';

/// 拍照、選相簿；測試換成假的。
final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

/// 照片的寫入都走這裡（D-016）。
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepository(
    ref.watch(databaseProvider),
    ref.watch(fileStoreProvider),
  );
});

/// 某筆點交的照片（不含已刪除），依加入順序，資料一改就自動更新；拍照、選相簿也在這裡。
///
/// 參數是點交紀錄 id；離開點交頁就停止監看（autoDispose）。
final inspectionPhotosProvider = StreamNotifierProvider.autoDispose
    .family<InspectionPhotos, List<Photo>, String>(InspectionPhotos.new);

/// 照片縮小到長邊 1600、品質 80（architecture.md「檔案」、D-021）。
const _maxSize = 1600.0;
const _quality = 80;

class InspectionPhotos extends StreamNotifier<List<Photo>> {
  InspectionPhotos(this.inspectionId);

  final String inspectionId;

  @override
  Stream<List<Photo>> build() {
    return ref.watch(databaseProvider).photosDao.watchPhotos(inspectionId);
  }

  /// 拍照或從相簿選，加到這個項目；取消時什麼都不做。
  ///
  /// 相簿可以一次選多張，依選取順序加入。不要求完整的中繼資料，iOS 選相簿時就不用
  /// 相簿權限。
  ///
  /// 推論：多張裡有一張存失敗時，前面存好的保留，錯誤往上丟，後面的不再存。
  Future<void> pick({
    required ImageSource source,
    required String roomKey,
    required String itemKey,
  }) async {
    // 選照片時使用者可能離開點交頁，等待之後就不能再用 ref，先取出要用的東西。
    final picker = ref.read(imagePickerProvider);
    final repository = ref.read(photoRepositoryProvider);
    final picked = switch (source) {
      ImageSource.camera => [
        ?await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: _maxSize,
          maxHeight: _maxSize,
          imageQuality: _quality,
          requestFullMetadata: false,
        ),
      ],
      ImageSource.gallery => await picker.pickMultiImage(
        maxWidth: _maxSize,
        maxHeight: _maxSize,
        imageQuality: _quality,
        requestFullMetadata: false,
      ),
    };
    for (final file in picked) {
      await repository.addPhoto(
        inspectionId: inspectionId,
        roomKey: roomKey,
        itemKey: itemKey,
        sourcePath: file.path,
      );
    }
  }
}
