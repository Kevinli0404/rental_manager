import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/properties/pages/new_property_page.dart';
import '../features/properties/pages/property_list_page.dart';

/// 各頁的路徑（product.md「頁面與路由」）；畫面裡轉跳一律用這裡的常數。
abstract final class AppRoutes {
  static const propertyList = '/';
  static const newProperty = '/properties/new';
}

/// 路由照路徑巢狀排列，`context.go` 時依路徑建立返回堆疊。
///
/// 子路由的 `path` 是相對路徑，要和 [AppRoutes] 的完整路徑一致；
/// widget test 會從 [AppRoutes] 轉跳，路徑對不上時測試會失敗。
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.propertyList,
        builder: (context, state) => const PropertyListPage(),
        routes: [
          GoRoute(
            path: 'properties/new',
            builder: (context, state) => const NewPropertyPage(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
