import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

/// 依 id 監看單一物件；不存在或已刪除時是 null。
///
/// 離開頁面就停止監看（autoDispose），不會每看過一個物件就多留一個查詢。
final propertyProvider = StreamProvider.autoDispose.family<Property?, String>((
  ref,
  id,
) {
  return ref.watch(databaseProvider).propertiesDao.watchProperty(id);
});
