import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

/// App 的根元件；上層要有 ProviderScope（見 `main.dart`）。
class RentalManagerApp extends ConsumerWidget {
  const RentalManagerApp({super.key});

  static const String title = 'Rental Manager';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: title,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
