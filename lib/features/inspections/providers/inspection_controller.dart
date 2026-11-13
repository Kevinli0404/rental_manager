import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../templates/data/layout.dart';
import '../../templates/data/template.dart';
import '../../templates/data/template_loader.dart';
import 'inspection_photos_provider.dart';

/// 某筆點交的項目結果（不含已刪除），資料一改就自動更新；填寫時的寫入（狀況、備註、
/// 管理空間）也在這裡。
///
/// 參數是點交紀錄 id；離開點交頁就停止監看（autoDispose）。
final inspectionControllerProvider = StreamNotifierProvider.autoDispose
    .family<InspectionController, List<ItemResult>, String>(
      InspectionController.new,
    );

class InspectionController extends StreamNotifier<List<ItemResult>> {
  InspectionController(this.inspectionId);

  final String inspectionId;

  @override
  Stream<List<ItemResult>> build() {
    return ref
        .watch(databaseProvider)
        .itemResultsDao
        .watchItemResults(inspectionId);
  }

  /// 設定項目狀況，立即寫入（product.md 轉跳規則 4）。
  Future<void> setCondition({
    required String roomKey,
    required String itemKey,
    required ItemCondition condition,
  }) {
    return ref
        .read(databaseProvider)
        .itemResultsDao
        .setCondition(
          inspectionId: inspectionId,
          roomKey: roomKey,
          itemKey: itemKey,
          condition: condition,
        );
  }

  /// 設定項目備註；連續輸入的防抖由呼叫端處理（D-007）。
  Future<void> setNote({
    required String roomKey,
    required String itemKey,
    required String note,
  }) {
    return ref
        .read(databaseProvider)
        .itemResultsDao
        .setNote(
          inspectionId: inspectionId,
          roomKey: roomKey,
          itemKey: itemKey,
          note: note,
        );
  }

  /// 新增 [type] 類型的空間（規則見 `LayoutRoomEditing.addRoom`）。
  Future<void> addRoom(TemplateRoom type) {
    final database = ref.read(databaseProvider);
    return database.inspectionsDao.updateLayout(
      inspectionId,
      (layout) => layout.addRoom(type, key: database.newId()),
    );
  }

  /// 複製 [roomKey] 的空間（規則見 `LayoutRoomEditing.copyRoom`）。
  ///
  /// 名稱用內建範本裡這類空間的名稱編號。
  Future<void> copyRoom(String roomKey) async {
    final database = ref.read(databaseProvider);
    final template = await loadDefaultTemplate();
    await database.inspectionsDao.updateLayout(inspectionId, (layout) {
      final typeKey = layout.rooms.firstWhere((r) => r.key == roomKey).typeKey;
      final type = template.rooms.firstWhere((t) => t.key == typeKey);
      return layout.copyRoom(
        roomKey,
        key: database.newId(),
        typeName: type.name,
      );
    });
  }

  /// 把 [roomKey] 的空間改名成 [name]（規則見 `LayoutRoomEditing.renameRoom`）。
  Future<void> renameRoom(String roomKey, String name) {
    return ref
        .read(databaseProvider)
        .inspectionsDao
        .updateLayout(
          inspectionId,
          (layout) => layout.renameRoom(roomKey, name),
        );
  }

  /// 刪除空間，連同它的項目結果、照片紀錄和照片檔（見 `PhotoRepository.deleteRoom`）。
  Future<void> deleteRoom(String roomKey) {
    return ref.read(photoRepositoryProvider).deleteRoom(inspectionId, roomKey);
  }
}
