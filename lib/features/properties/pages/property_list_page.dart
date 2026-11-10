import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app.dart';
import '../../../app/router.dart';
import '../../../core/database/database.dart';
import '../providers/property_list_provider.dart';

/// 首頁：物件列表。
class PropertyListPage extends ConsumerWidget {
  const PropertyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = ref.watch(propertyListProvider);
    final hasProperties = properties.value?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text(RentalManagerApp.title)),
      body: switch (properties) {
        AsyncData(:final value) when value.isEmpty => const _EmptyState(),
        AsyncData(:final value) => _PropertyListView(properties: value),
        AsyncError(:final error) => Center(child: Text('讀取物件失敗：$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
      // 推論：有物件時才顯示右下角的新增按鈕；沒有物件時空狀態裡已經有新增按鈕，
      // 同一個畫面不放兩個。
      floatingActionButton: hasProperties
          ? FloatingActionButton(
              onPressed: () => context.go(AppRoutes.newProperty),
              tooltip: '新增物件',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('還沒有物件'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go(AppRoutes.newProperty),
            icon: const Icon(Icons.add),
            label: const Text('新增物件'),
          ),
        ],
      ),
    );
  }
}

class _PropertyListView extends StatelessWidget {
  const _PropertyListView({required this.properties});

  final List<Property> properties;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // 底部留空間，最後一列不會被右下角的按鈕蓋住。
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return ListTile(
          title: Text(property.name),
          subtitle: property.address.isEmpty ? null : Text(property.address),
        );
      },
    );
  }
}
