import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

/// App 唯一的資料庫連線。
///
/// App 開 Documents 目錄裡的資料庫檔案（drift_flutter 的預設位置），
/// ProviderScope 結束時關閉；測試用 `overrideWithValue` 換成記憶體資料庫。
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(driftDatabase(name: 'rental_manager'));
  ref.onDispose(database.close);
  return database;
});
