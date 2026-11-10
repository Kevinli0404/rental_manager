import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../providers/property_list_provider.dart';
import '../providers/property_provider.dart';
import '../widgets/property_form.dart';

/// 編輯物件；帶入原本的內容，存檔後回到詳情。
class EditPropertyPage extends ConsumerWidget {
  const EditPropertyPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final property = ref.watch(propertyProvider(propertyId));

    return switch (property) {
      AsyncData(value: final property?) => PropertyForm(
        title: '編輯物件',
        initial: property,
        onSave: (values) => ref
            .read(propertyListProvider.notifier)
            .edit(
              id: property.id,
              name: values.name,
              address: values.address,
              note: values.note,
            ),
        onSaved: () => context.go(AppRoutes.propertyDetail(property.id)),
      ),
      AsyncData() => const _Status(child: Text('找不到這個物件')),
      AsyncError(:final error) => _Status(child: Text('讀取物件失敗：$error')),
      _ => const _Status(child: CircularProgressIndicator()),
    };
  }
}

/// 還沒有表單可以填時（讀取中、找不到、讀取失敗）的頁面。
class _Status extends StatelessWidget {
  const _Status({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('編輯物件')),
      body: Center(child: child),
    );
  }
}
