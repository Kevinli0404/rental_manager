import 'package:drift/drift.dart';

import 'sync_columns.dart';

/// 物件：一間出租的房子。
class Properties extends Table with SyncColumns {
  TextColumn get name => text()();

  // 推論：規格沒寫地址、備註是否必填；先允許空白，存空字串而不是 null，
  // 表單和 PDF 都不用另外處理 null。
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
}
