import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'file_store.dart';

/// App 的檔案存取。
///
/// Documents 目錄要非同步取得，所以由 `main.dart` 啟動時取好，再用 `overrideWithValue`
/// 放進來；測試換成暫存資料夾（`test/helpers/pump_app.dart`）。
final fileStoreProvider = Provider<FileStore>((ref) {
  throw UnimplementedError(
    'fileStoreProvider 要在 main.dart 用 overrideWithValue 提供',
  );
});
