import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/leave_then_delete.dart';
import '../../../app/router.dart';
import '../../../core/database/database.dart';
import '../providers/inspection_list_provider.dart';
import '../providers/inspection_provider.dart';
import '../widgets/inspection_labels.dart';

/// 點交頁：標題是類型和點交日期；草稿可以從右上角選單刪除。
///
/// 空間分頁、選狀況、填備註在 T3 的下一步加上（roadmap）。
class InspectionPage extends ConsumerWidget {
  const InspectionPage({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspection = ref.watch(inspectionProvider(inspectionId));
    final loaded = inspection.value;

    return Scaffold(
      appBar: AppBar(
        title: loaded == null ? null : Text(_title(loaded)),
        actions: [
          // 只有草稿可以刪除；已簽名的要二次確認，在 T5 加上（roadmap）。
          if (loaded != null && loaded.status == InspectionStatus.draft)
            PopupMenuButton<_MenuAction>(
              tooltip: '更多',
              onSelected: (action) => switch (action) {
                _MenuAction.delete => _confirmAndDelete(context, ref, loaded),
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: _MenuAction.delete, child: Text('刪除')),
              ],
            ),
        ],
      ),
      body: switch (inspection) {
        AsyncData(value: _?) => const SizedBox.shrink(),
        AsyncData() => const Center(child: Text('找不到這個點交紀錄')),
        AsyncError(:final error) => Center(child: Text('讀取點交紀錄失敗：$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

enum _MenuAction { delete }

String _title(Inspection inspection) {
  return '${inspection.type.label} ${inspection.inspectedOn}';
}

/// 草稿確認一次就刪除（product.md「刪除規則」），然後回到物件詳情。
Future<void> _confirmAndDelete(
  BuildContext context,
  WidgetRef ref,
  Inspection inspection,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('刪除點交紀錄？'),
      content: Text('「${_title(inspection)}」和填寫的內容都會刪除。'),
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

  // 回到物件詳情後才刪除，刪掉後會自動從點交紀錄列表消失。
  final inspections = ref.read(
    inspectionListProvider(inspection.propertyId).notifier,
  );
  await leaveThenDelete(
    context,
    location: AppRoutes.propertyDetail(inspection.propertyId),
    delete: () => inspections.delete(inspection.id),
  );
}
