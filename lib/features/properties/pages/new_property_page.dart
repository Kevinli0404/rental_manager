import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../providers/property_list_provider.dart';
import '../widgets/property_form.dart';

/// 新增物件；存檔後回到列表。
class NewPropertyPage extends ConsumerWidget {
  const NewPropertyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PropertyForm(
      title: '新增物件',
      onSave: (values) => ref
          .read(propertyListProvider.notifier)
          .create(
            name: values.name,
            address: values.address,
            note: values.note,
          ),
      onSaved: () => context.go(AppRoutes.propertyList),
    );
  }
}
