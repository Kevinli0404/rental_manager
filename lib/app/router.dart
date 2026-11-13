import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/inspections/pages/inspection_page.dart';
import '../features/inspections/pages/inspection_rooms_page.dart';
import '../features/inspections/pages/photo_page.dart';
import '../features/properties/pages/edit_property_page.dart';
import '../features/properties/pages/new_property_page.dart';
import '../features/properties/pages/property_detail_page.dart';
import '../features/properties/pages/property_list_page.dart';

/// 各頁的路徑（product.md「頁面與路由」）；畫面裡轉跳一律用這裡的常數和方法。
abstract final class AppRoutes {
  static const propertyList = '/';
  static const newProperty = '/properties/new';
  static String propertyDetail(String propertyId) => '/properties/$propertyId';
  static String editProperty(String propertyId) =>
      '/properties/$propertyId/edit';
  static String inspection(String propertyId, String inspectionId) =>
      '/properties/$propertyId/inspections/$inspectionId';
  static String inspectionRooms(String propertyId, String inspectionId) =>
      '/properties/$propertyId/inspections/$inspectionId/rooms';
  static String photo(String propertyId, String inspectionId, String photoId) =>
      '/properties/$propertyId/inspections/$inspectionId/photos/$photoId';
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
          // 要排在 `properties/:pid` 前面，不然「new」會被當成物件 id。
          GoRoute(
            path: 'properties/new',
            builder: (context, state) => const NewPropertyPage(),
          ),
          GoRoute(
            path: 'properties/:pid',
            builder: (context, state) =>
                PropertyDetailPage(propertyId: state.pathParameters['pid']!),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) =>
                    EditPropertyPage(propertyId: state.pathParameters['pid']!),
              ),
              GoRoute(
                path: 'inspections/:iid',
                builder: (context, state) =>
                    InspectionPage(inspectionId: state.pathParameters['iid']!),
                routes: [
                  GoRoute(
                    path: 'rooms',
                    builder: (context, state) => InspectionRoomsPage(
                      inspectionId: state.pathParameters['iid']!,
                    ),
                  ),
                  GoRoute(
                    path: 'photos/:photoId',
                    builder: (context, state) => PhotoPage(
                      inspectionId: state.pathParameters['iid']!,
                      photoId: state.pathParameters['photoId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
