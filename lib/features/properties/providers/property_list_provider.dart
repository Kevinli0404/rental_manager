import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../inspections/providers/inspection_photos_provider.dart';

/// 物件列表（不含已刪除），依建立時間新到舊，資料一改就自動更新。
final propertyListProvider =
    StreamNotifierProvider<PropertyList, List<Property>>(PropertyList.new);

class PropertyList extends StreamNotifier<List<Property>> {
  @override
  Stream<List<Property>> build() {
    return ref.watch(databaseProvider).propertiesDao.watchProperties();
  }

  /// 新增物件。
  ///
  /// 推論：名稱、地址、備註存檔前去掉前後空白。規格沒寫；依據是只有空白的名稱
  /// 在列表上看起來是空的，前後多出的空白也會留到 PDF 上。
  Future<void> create({
    required String name,
    required String address,
    required String note,
  }) async {
    await ref
        .read(databaseProvider)
        .propertiesDao
        .createProperty(
          name: name.trim(),
          address: address.trim(),
          note: note.trim(),
        );
  }

  /// 修改物件；跟 [create] 一樣，存檔前去掉前後空白。
  Future<void> edit({
    required String id,
    required String name,
    required String address,
    required String note,
  }) async {
    await ref
        .read(databaseProvider)
        .propertiesDao
        .updateProperty(
          id: id,
          name: name.trim(),
          address: address.trim(),
          note: note.trim(),
        );
  }

  /// 軟刪除物件，底下的點交紀錄和照片檔一起刪除（見 `PhotoRepository.deleteProperty`）。
  Future<void> delete(String id) async {
    await ref.read(photoRepositoryProvider).deleteProperty(id);
  }
}
