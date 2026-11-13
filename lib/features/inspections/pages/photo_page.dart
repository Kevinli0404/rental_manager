import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/leave_then_delete.dart';
import '../../../app/router.dart';
import '../../../core/database/database.dart';
import '../../../core/files/file_store_provider.dart';
import '../providers/inspection_photos_provider.dart';
import '../providers/inspection_provider.dart';

/// 照片檢視：全螢幕看一張照片，可以雙指放大；草稿時可以刪除
/// （product.md「頁面與路由」）。
///
/// 從點交頁的縮圖用 `context.push` 打開，按返回回到點交頁。
class PhotoPage extends ConsumerWidget {
  const PhotoPage({
    super.key,
    required this.inspectionId,
    required this.photoId,
  });

  final String inspectionId;
  final String photoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = ref.watch(photoProvider(photoId));
    final inspection = ref.watch(inspectionProvider(inspectionId)).value;

    // 推論：黑底，照片看得比較清楚，也是一般看照片的習慣。
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // 只有草稿可以刪除照片（product.md「點交紀錄狀態」）。
          if (photo.value != null &&
              inspection != null &&
              inspection.status == InspectionStatus.draft)
            IconButton(
              tooltip: '刪除',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmAndDelete(context, ref, inspection),
            ),
        ],
      ),
      body: switch (photo) {
        AsyncData(value: final photo?) => _PhotoView(photo: photo),
        AsyncData() => const _Message('找不到這張照片'),
        AsyncError(:final error) => _Message('讀取照片失敗：$error'),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  /// 確認一次就刪除（product.md「刪除規則」），然後回到點交頁。
  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    Inspection inspection,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除照片？'),
        content: const Text('這張照片會從點交紀錄刪除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('刪除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // 回到點交頁後才刪除，刪掉後會自動從縮圖列消失（D-018）。
    final photos = ref.read(inspectionPhotosProvider(inspection.id).notifier);
    await leaveThenDelete(
      context,
      location: AppRoutes.inspection(inspection.propertyId, inspection.id),
      delete: () => photos.delete(photoId),
    );
  }
}

/// 照片本身：照原比例放進畫面，可以雙指放大、拖動。
class _PhotoView extends ConsumerWidget {
  const _PhotoView({required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(fileStoreProvider);
    return InteractiveViewer(
      maxScale: 5,
      child: Center(
        child: Image.file(
          files.resolve(photo.relativePath),
          fit: BoxFit.contain,
          // 推論：檔案讀不到時（例如被系統清掉）顯示文字說明，照片紀錄還是可以刪除。
          errorBuilder: (context, error, stackTrace) =>
              const _Message('讀不到這張照片的檔案'),
        ),
      ),
    );
  }
}

/// 黑底上的白色說明文字。
class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
