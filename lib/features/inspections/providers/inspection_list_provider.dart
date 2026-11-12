import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../templates/data/layout.dart';
import '../../templates/data/template_loader.dart';

/// 某個物件的點交紀錄（不含已刪除），依點交日期新到舊，資料一改就自動更新。
///
/// 參數是物件 id；離開物件詳情就停止監看（autoDispose）。
final inspectionListProvider = StreamNotifierProvider.autoDispose
    .family<InspectionList, List<Inspection>, String>(InspectionList.new);

class InspectionList extends StreamNotifier<List<Inspection>> {
  InspectionList(this.propertyId);

  final String propertyId;

  @override
  Stream<List<Inspection>> build() {
    return ref
        .watch(databaseProvider)
        .inspectionsDao
        .watchInspections(propertyId);
  }

  /// 建立草稿狀態的點交紀錄，回傳新紀錄的 id。
  ///
  /// 入住、退租都依內建範本產生空間配置；退租改成沿用入住的空間配置是 T6 的工作
  /// （roadmap）。
  Future<String> create({
    required InspectionType type,
    required String inspectedOn,
  }) async {
    final template = await loadDefaultTemplate();
    return ref
        .read(databaseProvider)
        .inspectionsDao
        .createInspection(
          propertyId: propertyId,
          type: type,
          inspectedOn: inspectedOn,
          // 推論：預設房東姓名要等 T8 的設定頁，先存空字串。依據是 product.md 轉跳規則 2
          // 「房東姓名帶入設定裡的預設值」，現在還沒有設定可以帶入；姓名在 T5 可以修改。
          landlordName: '',
          layout: Layout.fromTemplate(template),
        );
  }

  /// 軟刪除點交紀錄（見 `InspectionsDao.deleteInspection`）。
  Future<void> delete(String id) async {
    await ref.read(databaseProvider).inspectionsDao.deleteInspection(id);
  }
}
