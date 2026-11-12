import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/inspection_provider.dart';
import '../widgets/inspection_labels.dart';

/// 點交頁：標題是類型和點交日期。
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
        title: loaded == null
            ? null
            : Text('${loaded.type.label} ${loaded.inspectedOn}'),
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
