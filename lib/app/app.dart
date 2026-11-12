import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      // 只支援繁體中文，不跟著裝置語系切換（D-019）；日期選擇器、返回按鈕這些內建文字
      // 都用繁體中文。
      locale: const Locale('zh', 'TW'),
      supportedLocales: const [Locale('zh', 'TW')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
