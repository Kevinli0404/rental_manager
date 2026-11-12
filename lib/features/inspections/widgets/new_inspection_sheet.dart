import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../providers/inspection_list_provider.dart';
import 'inspection_labels.dart';

/// 打開新增點交的底部選單（product.md 轉跳規則 2）。
///
/// 建立成功時關掉選單並回傳新紀錄的 id，由呼叫的頁面轉跳到點交頁；
/// 沒有建立就關掉時回傳 null。
Future<String?> showNewInspectionSheet(
  BuildContext context, {
  required String propertyId,
}) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (context) => _NewInspectionSheet(propertyId: propertyId),
  );
}

class _NewInspectionSheet extends ConsumerStatefulWidget {
  const _NewInspectionSheet({required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<_NewInspectionSheet> createState() =>
      _NewInspectionSheetState();
}

class _NewInspectionSheetState extends ConsumerState<_NewInspectionSheet> {
  // 推論：類型不預設，選了才能建立。規格只寫日期預設今天；入住、退租選錯會影響
  // 退租對照（T6），所以讓使用者自己選。
  InspectionType? _type;
  DateTime _date = DateUtils.dateOnly(DateTime.now());
  bool _creating = false;
  Object? _error;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      // 推論：日期範圍不限制，規格沒寫。範圍只是日期選擇器要求的上下限。
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _create(InspectionType type) async {
    // 推論：建立中不接受第二次點擊，避免連點時建立兩筆，比照新增物件。
    if (_creating) return;
    setState(() {
      _creating = true;
      _error = null;
    });

    final String id;
    try {
      id = await ref
          .read(inspectionListProvider(widget.propertyId).notifier)
          .create(type: type, inspectedOn: formatInspectedOn(_date));
    } catch (error) {
      // 選單已經關掉就沒有地方顯示，往上丟。
      if (!mounted) rethrow;
      // 推論：建立失敗時選單不關，錯誤顯示在選單裡（SnackBar 會被選單擋住），
      // 已選的類型和日期保留，可以再試一次。
      setState(() {
        _creating = false;
        _error = error;
      });
      return;
    }

    if (mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = _type;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('新增點交', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            SegmentedButton<InspectionType>(
              segments: [
                for (final type in InspectionType.values)
                  ButtonSegment(value: type, label: Text(type.label)),
              ],
              selected: {?type},
              // 一開始沒有選；選了之後再點同一個不會取消。
              emptySelectionAllowed: true,
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  setState(() => _type = selection.single);
                }
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('點交日期'),
              trailing: Text(formatInspectedOn(_date)),
              onTap: _pickDate,
            ),
            if (_error != null) ...[
              Text(
                '建立失敗：$_error',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            FilledButton(
              onPressed: type == null || _creating ? null : () => _create(type),
              child: const Text('建立'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 點交日期存成 `YYYY-MM-DD`（architecture.md「資料表」），畫面上也照這個格式顯示。
String formatInspectedOn(DateTime date) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
}
