import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/leave_then_delete.dart';
import '../../../app/router.dart';
import '../../../core/database/database.dart';
import '../../templates/data/layout.dart';
import '../providers/inspection_controller.dart';
import '../providers/inspection_list_provider.dart';
import '../providers/inspection_provider.dart';
import '../widgets/inspection_labels.dart';

/// 點交頁：上方是空間分頁，每個項目選狀況、填備註；底部固定顯示填寫進度
/// （product.md「點交頁版面」）。草稿可以從右上角選單管理空間、刪除。
///
/// 每次變更都立即寫入，沒有儲存按鈕；備註停止輸入後才寫入（product.md 轉跳規則 4）。
class InspectionPage extends ConsumerWidget {
  const InspectionPage({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(inspectionProvider(inspectionId))) {
      AsyncData(value: final inspection?) => _InspectionScaffold(
        inspection: inspection,
      ),
      AsyncData() => const _Status(child: Text('找不到這個點交紀錄')),
      AsyncError(:final error) => _Status(child: Text('讀取點交紀錄失敗：$error')),
      _ => const _Status(child: CircularProgressIndicator()),
    };
  }
}

/// 還沒有點交紀錄可以顯示時（讀取中、找不到、讀取失敗）的頁面。
class _Status extends StatelessWidget {
  const _Status({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: child),
    );
  }
}

class _InspectionScaffold extends ConsumerWidget {
  const _InspectionScaffold({required this.inspection});

  final Inspection inspection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = inspection.layout.rooms;
    final results = ref.watch(inspectionControllerProvider(inspection.id));

    return DefaultTabController(
      length: rooms.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title(inspection)),
          actions: [
            // 只有草稿可以管理空間、刪除；已簽名的要二次確認才能刪除，在 T5 加上（roadmap）。
            if (inspection.status == InspectionStatus.draft)
              PopupMenuButton<_MenuAction>(
                tooltip: '更多',
                onSelected: (action) => switch (action) {
                  _MenuAction.manageRooms => context.go(
                    AppRoutes.inspectionRooms(
                      inspection.propertyId,
                      inspection.id,
                    ),
                  ),
                  _MenuAction.delete => _confirmAndDelete(
                    context,
                    ref,
                    inspection,
                  ),
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _MenuAction.manageRooms,
                    child: Text('管理空間'),
                  ),
                  PopupMenuItem(value: _MenuAction.delete, child: Text('刪除')),
                ],
              ),
          ],
          bottom: rooms.isEmpty
              ? null
              : TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [for (final room in rooms) Tab(text: room.name)],
                ),
        ),
        body: switch (results) {
          // 推論：配置裡沒有空間時顯示提示。管理空間（T3 下一步）會保留至少一個空間，
          // 這裡只是防止畫面壞掉。
          _ when rooms.isEmpty => const Center(child: Text('這筆點交沒有空間')),
          AsyncData(:final value) => TabBarView(
            children: [
              for (final room in rooms)
                _RoomItems(
                  // 管理空間後分頁的順序會變；用空間 key 對應，保留下來的卡片
                  // （見 _ItemCard）才不會被套到別的空間。
                  key: ValueKey(room.key),
                  inspectionId: inspection.id,
                  room: room,
                  results: _byItem(value),
                ),
            ],
          ),
          AsyncError(:final error) => Center(child: Text('讀取填寫內容失敗：$error')),
          _ => const Center(child: CircularProgressIndicator()),
        },
        bottomNavigationBar: switch (results) {
          AsyncData(:final value) => _Progress(
            layout: inspection.layout,
            results: _byItem(value),
          ),
          _ => null,
        },
      ),
    );
  }
}

typedef _ItemKey = (String roomKey, String itemKey);

Map<_ItemKey, ItemResult> _byItem(List<ItemResult> results) {
  return {
    for (final result in results) (result.roomKey, result.itemKey): result,
  };
}

/// 一個空間的項目列表。
class _RoomItems extends StatelessWidget {
  const _RoomItems({
    super.key,
    required this.inspectionId,
    required this.room,
    required this.results,
  });

  final String inspectionId;
  final LayoutRoom room;
  final Map<_ItemKey, ItemResult> results;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        for (final item in room.items)
          _ItemCard(
            inspectionId: inspectionId,
            roomKey: room.key,
            item: item,
            result: results[(room.key, item.key)],
          ),
      ],
    );
  }
}

/// 停止輸入多久之後寫入備註（D-007 的防抖）。
const _noteSaveDelay = Duration(milliseconds: 500);

/// 一個項目：名稱、狀況和備註。
///
/// 備註輸入框只在建立時從資料庫讀一次，之後以輸入框為準。卡片要求保留（keep alive），
/// 捲出畫面時不會被拆掉；這個要求也會往上傳到分頁，切到別的分頁時整頁一起保留。
/// 這樣寫入還沒完成時卡片不會重建，不會讀到舊的備註。
class _ItemCard extends ConsumerStatefulWidget {
  const _ItemCard({
    required this.inspectionId,
    required this.roomKey,
    required this.item,
    required this.result,
  });

  final String inspectionId;
  final String roomKey;
  final LayoutItem item;
  final ItemResult? result;

  @override
  ConsumerState<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends ConsumerState<_ItemCard>
    with AutomaticKeepAliveClientMixin {
  late final _note = TextEditingController(text: widget.result?.note);

  // dispose 時不能用 ref，先存起來，離開點交頁時才能補寫備註。
  late final InspectionController _inspection;
  late ScaffoldMessengerState _messenger;
  late final AppLifecycleListener _lifecycle;

  /// 還沒寫入的備註；停止輸入 [_noteSaveDelay] 後寫入。
  Timer? _pendingNote;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _inspection = ref.read(
      inspectionControllerProvider(widget.inspectionId).notifier,
    );
    // App 切到背景後隨時可能被關掉，馬上寫入（D-007）。
    _lifecycle = AppLifecycleListener(onInactive: _saveNoteNow);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    // 離開點交頁時，還沒寫入的備註馬上寫入。
    _saveNoteNow();
    _lifecycle.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _select(ItemCondition condition) async {
    try {
      await _inspection.setCondition(
        roomKey: widget.roomKey,
        itemKey: widget.item.key,
        condition: condition,
      );
    } catch (error) {
      // 推論：寫入失敗時顯示錯誤；畫面上的狀況來自資料庫，所以會維持原本的選取，
      // 可以再點一次。
      _messenger.showSnackBar(SnackBar(content: Text('儲存失敗：$error')));
    }
  }

  void _noteChanged(String _) {
    _pendingNote?.cancel();
    _pendingNote = Timer(_noteSaveDelay, () => unawaited(_saveNote()));
  }

  /// 有還沒寫入的備註就馬上寫入。
  void _saveNoteNow() {
    if (_pendingNote?.isActive ?? false) {
      _pendingNote!.cancel();
      unawaited(_saveNote());
    }
  }

  Future<void> _saveNote() async {
    try {
      await _inspection.setNote(
        roomKey: widget.roomKey,
        itemKey: widget.item.key,
        note: _note.text,
      );
    } catch (error) {
      // 推論：寫入失敗時顯示錯誤，輸入框保留打的字；再改一個字就會重新寫入。
      _messenger.showSnackBar(SnackBar(content: Text('儲存失敗：$error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final condition = widget.result?.condition;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.item.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            // 推論：四種狀況並排成一排按鈕，一次點擊就能選，不另外跳選單；
            // 現場要逐項快速填寫。
            SegmentedButton<ItemCondition>(
              segments: [
                for (final condition in ItemCondition.values)
                  ButtonSegment(value: condition, label: Text(condition.label)),
              ],
              selected: {?condition},
              showSelectedIcon: false,
              // 一開始是未填；選了之後只能改成別的狀況，不能改回未填。
              emptySelectionAllowed: true,
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  _select(selection.single);
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: '備註',
                border: OutlineInputBorder(),
              ),
              // 太長自動換行；return 鍵是「完成」，按了收起鍵盤，不換行。
              maxLines: null,
              textInputAction: TextInputAction.done,
              onChanged: _noteChanged,
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部的填寫進度：已選狀況的項目數／空間配置裡的項目總數。
///
/// 推論：只算目前空間配置裡的項目，已經刪掉的空間留下的結果不算。
class _Progress extends StatelessWidget {
  const _Progress({required this.layout, required this.results});

  final Layout layout;
  final Map<_ItemKey, ItemResult> results;

  @override
  Widget build(BuildContext context) {
    var total = 0;
    var filled = 0;
    for (final room in layout.rooms) {
      for (final item in room.items) {
        total++;
        if (results[(room.key, item.key)]?.condition != null) filled++;
      }
    }

    // 推論：用文字加進度條顯示，規格只寫「顯示填寫進度」。
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('已填 $filled / $total'),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: total == 0 ? 0 : filled / total),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _MenuAction { manageRooms, delete }

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
