import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../templates/data/layout.dart';
import '../../templates/data/template.dart';
import '../../templates/data/template_loader.dart';
import '../providers/inspection_controller.dart';
import '../providers/inspection_provider.dart';

/// 管理空間：列出這筆點交的空間，可以新增、複製、改名稱、刪除（product.md「空間」）。
///
/// 從點交頁右上角選單進來，只有草稿會顯示那個選單。
class InspectionRoomsPage extends ConsumerWidget {
  const InspectionRoomsPage({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspection = ref.watch(inspectionProvider(inspectionId));
    // 刪除前要知道空間有沒有填寫內容；在這頁監看，資料才是最新的。
    final results = ref.watch(inspectionControllerProvider(inspectionId));
    final layout = inspection.value?.layout;

    return Scaffold(
      appBar: AppBar(title: const Text('管理空間')),
      body: switch (inspection) {
        AsyncData(value: final inspection?) => ListView(
          // 底部留空間，最後一列不會被右下角的按鈕蓋住。
          padding: const EdgeInsets.only(top: 8, bottom: 88),
          children: [
            for (final room in inspection.layout.rooms)
              _RoomTile(
                inspectionId: inspectionId,
                layout: inspection.layout,
                room: room,
                results: results.value,
              ),
          ],
        ),
        AsyncData() => const Center(child: Text('找不到這個點交紀錄')),
        AsyncError(:final error) => Center(child: Text('讀取點交紀錄失敗：$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: layout == null
          ? null
          : FloatingActionButton(
              onPressed: () => _addRoom(context, ref),
              tooltip: '新增空間',
              child: const Icon(Icons.add),
            ),
    );
  }

  /// 從範本的空間類型選一個，新增空間。
  Future<void> _addRoom(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(
      inspectionControllerProvider(inspectionId).notifier,
    );
    try {
      final template = await loadDefaultTemplate();
      if (!context.mounted) return;
      final type = await showModalBottomSheet<TemplateRoom>(
        context: context,
        builder: (context) => _RoomTypeSheet(types: template.rooms),
      );
      if (type == null) return;
      await controller.addRoom(type);
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text('新增失敗：$error')));
    }
  }
}

enum _RoomAction { rename, copy, delete }

/// 一個空間：名稱、項目數，右邊的選單可以改名稱、複製、刪除。
class _RoomTile extends ConsumerWidget {
  const _RoomTile({
    required this.inspectionId,
    required this.layout,
    required this.room,
    required this.results,
  });

  final String inspectionId;
  final Layout layout;
  final LayoutRoom room;

  /// 這筆點交的項目結果；還沒讀到或讀取失敗時是 null。
  final List<ItemResult>? results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(room.name),
      subtitle: Text('${room.items.length} 個項目'),
      trailing: PopupMenuButton<_RoomAction>(
        tooltip: '更多',
        onSelected: (action) => switch (action) {
          _RoomAction.rename => _rename(context, ref),
          _RoomAction.copy => _copy(context, ref),
          _RoomAction.delete => _delete(context, ref),
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: _RoomAction.rename, child: Text('改名稱')),
          const PopupMenuItem(value: _RoomAction.copy, child: Text('複製')),
          // 至少要保留一個空間（product.md「空間」）。
          // 推論：只剩一個空間時「刪除」顯示成不能點，不藏起來，讓使用者知道有這個功能。
          PopupMenuItem(
            value: _RoomAction.delete,
            enabled: layout.rooms.length > 1,
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }

  InspectionController _controller(WidgetRef ref) {
    return ref.read(inspectionControllerProvider(inspectionId).notifier);
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = _controller(ref);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _RenameDialog(layout: layout, room: room),
    );
    if (name == null) return;
    try {
      await controller.renameRoom(room.key, name);
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text('儲存失敗：$error')));
    }
  }

  /// 推論：複製不用確認，複製錯了可以直接刪掉；新的空間只有項目，沒有內容。
  Future<void> _copy(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _controller(ref).copyRoom(room.key);
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text('複製失敗：$error')));
    }
  }

  /// 有填寫內容時先確認，沒有就直接刪除（product.md「空間」）。
  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = _controller(ref);
    if (_hasContent()) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('刪除「${room.name}」？'),
          content: const Text('這個空間填寫的內容和照片都會刪除。'),
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
      if (confirmed != true) return;
    }
    try {
      await controller.deleteRoom(room.key);
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text('刪除失敗：$error')));
    }
  }

  /// 這個空間有沒有填寫內容：選了狀況，或備註不是空白。
  ///
  /// 推論：還沒讀到填寫內容（或讀取失敗）時當作有內容，先確認再刪，寧可多問一次。
  /// 照片在 T4 加上後也要算進來（roadmap）。
  bool _hasContent() {
    final results = this.results;
    if (results == null) return true;
    return results.any(
      (r) =>
          r.roomKey == room.key &&
          (r.condition != null || r.note.trim().isNotEmpty),
    );
  }
}

/// 新增空間時選空間類型的底部選單；選了回傳那個類型。
class _RoomTypeSheet extends StatelessWidget {
  const _RoomTypeSheet({required this.types});

  final List<TemplateRoom> types;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('新增空間', style: Theme.of(context).textTheme.titleLarge),
          ),
          for (final type in types)
            ListTile(
              title: Text(type.name),
              onTap: () => Navigator.pop(context, type),
            ),
        ],
      ),
    );
  }
}

/// 改名稱的對話框；儲存時回傳輸入的名稱，取消時回傳 null。
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.layout, required this.room});

  final Layout layout;
  final LayoutRoom room;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _name = TextEditingController(text: widget.room.name);
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    final error = widget.layout.roomNameError(widget.room.key, _name.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.pop(context, _name.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('改名稱'),
      content: TextField(
        controller: _name,
        autofocus: true,
        decoration: InputDecoration(labelText: '名稱', errorText: _error),
        textInputAction: TextInputAction.done,
        // 改了內容就先拿掉錯誤，等按儲存時再檢查。
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(onPressed: _save, child: const Text('儲存')),
      ],
    );
  }
}
