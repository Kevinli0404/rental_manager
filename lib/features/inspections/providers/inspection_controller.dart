import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

/// 某筆點交的項目結果（不含已刪除），資料一改就自動更新；填寫時的寫入也在這裡。
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
}
