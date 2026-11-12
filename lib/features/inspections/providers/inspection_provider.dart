import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

/// 依 id 監看點交紀錄；不存在或已刪除時是 null。離開頁面就停止監看（autoDispose）。
final inspectionProvider = StreamProvider.autoDispose
    .family<Inspection?, String>((ref, id) {
      return ref.watch(databaseProvider).inspectionsDao.watchInspection(id);
    });
