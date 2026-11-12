import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/database/database.dart';
import '../../inspections/providers/inspection_list_provider.dart';
import '../../inspections/widgets/inspection_labels.dart';
import '../../inspections/widgets/new_inspection_sheet.dart';
import '../providers/property_list_provider.dart';
import '../providers/property_provider.dart';

/// 物件詳情：標題是名稱，下面是地址、備註和點交紀錄列表；右上角選單可以編輯、刪除，
/// 右下角按鈕新增點交。
class PropertyDetailPage extends ConsumerWidget {
  const PropertyDetailPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final property = ref.watch(propertyProvider(propertyId));
    final loaded = property.value;

    return Scaffold(
      appBar: AppBar(
        title: loaded == null ? null : Text(loaded.name),
        actions: [
          // 推論：編輯、刪除放在右上角選單，刪除不直接放按鈕，避免誤觸。規格沒寫版面。
          if (loaded != null)
            PopupMenuButton<_MenuAction>(
              tooltip: '更多',
              onSelected: (action) => switch (action) {
                _MenuAction.edit => context.go(
                  AppRoutes.editProperty(loaded.id),
                ),
                _MenuAction.delete => _confirmAndDelete(context, ref, loaded),
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: _MenuAction.edit, child: Text('編輯')),
                PopupMenuItem(value: _MenuAction.delete, child: Text('刪除')),
              ],
            ),
        ],
      ),
      body: switch (property) {
        AsyncData(value: final property?) => _PropertyBody(property: property),
        AsyncData() => const Center(child: Text('找不到這個物件')),
        AsyncError(:final error) => Center(child: Text('讀取物件失敗：$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
      // 推論：新增點交的按鈕一直顯示，沒有點交紀錄時列表只顯示文字，不另外放按鈕；
      // 同一個畫面不放兩個新增按鈕，比照物件列表。
      floatingActionButton: loaded == null
          ? null
          : FloatingActionButton(
              onPressed: () => _addInspection(context, loaded.id),
              tooltip: '新增點交',
              child: const Icon(Icons.add),
            ),
    );
  }
}

/// 用底部選單建立點交草稿，建立後直接進點交頁（product.md 轉跳規則 2）。
Future<void> _addInspection(BuildContext context, String propertyId) async {
  final inspectionId = await showNewInspectionSheet(
    context,
    propertyId: propertyId,
  );
  if (inspectionId == null || !context.mounted) return;
  context.go(AppRoutes.inspection(propertyId, inspectionId));
}

enum _MenuAction { edit, delete }

/// 確認一次就刪除（product.md「刪除規則」），然後回到列表。
///
/// 推論：物件底下有已簽名的點交紀錄時要不要二次確認，規格沒寫，列在 product.md
/// 「待決定」。T2 還不能建立點交紀錄，先照草稿的規則確認一次。
Future<void> _confirmAndDelete(
  BuildContext context,
  WidgetRef ref,
  Property property,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('刪除物件？'),
      content: Text('「${property.name}」和底下的點交紀錄都會刪除。'),
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

  // 先回到列表，等這頁的退場動畫結束、頁面關掉之後才刪除。這頁在退場動畫中
  // 還會重畫，在那之前刪除的話，會閃過「找不到這個物件」。物件刪掉後會自動從列表消失。
  // 離開後這頁的 context 和 ref 就不能用，要用的東西先取出來。
  final route = ModalRoute.of(context)!;
  final properties = ref.read(propertyListProvider.notifier);
  final messenger = ScaffoldMessenger.of(context);
  context.go(AppRoutes.propertyList);
  await route.completed;
  try {
    await properties.delete(property.id);
  } catch (error) {
    // 推論：刪除失敗時停在列表、顯示錯誤，物件還在列表上，可以再試一次。
    messenger.showSnackBar(SnackBar(content: Text('刪除失敗：$error')));
  }
}

class _PropertyBody extends ConsumerWidget {
  const _PropertyBody({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspections = ref.watch(inspectionListProvider(property.id));
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return ListView(
      // 底部留空間，最後一列不會被右下角的按鈕蓋住。
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      children: [
        _Field(label: '地址', value: property.address),
        _Field(label: '備註', value: property.note),
        const Divider(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('點交紀錄', style: theme.textTheme.titleSmall),
        ),
        ...switch (inspections) {
          AsyncData(:final value) when value.isEmpty => [
            ListTile(
              title: Text('還沒有點交紀錄', style: TextStyle(color: muted)),
            ),
          ],
          AsyncData(:final value) => [
            for (final inspection in value)
              ListTile(
                title: Text(inspection.type.label),
                subtitle: Text(inspection.inspectedOn),
                trailing: Text(inspection.status.label),
                onTap: () => context.go(
                  AppRoutes.inspection(property.id, inspection.id),
                ),
              ),
          ],
          AsyncError(:final error) => [
            ListTile(title: Text('讀取點交紀錄失敗：$error')),
          ],
          _ => [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        },
      ],
    );
  }
}

/// 一個欄位：上面是欄位名稱，下面是內容。
///
/// 推論：沒填的欄位顯示「未填」，不整個藏起來，讓使用者知道這個欄位可以填。
/// 規格沒寫；列表上沒有地址時不顯示，是因為列表要精簡。
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: 4),
          if (value.isEmpty)
            Text('未填', style: TextStyle(color: muted))
          else
            Text(value),
        ],
      ),
    );
  }
}
