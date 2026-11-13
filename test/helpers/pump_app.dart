import 'dart:io';

import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/core/database/database_provider.dart';
import 'package:rental_manager/core/files/file_store.dart';
import 'package:rental_manager/core/files/file_store_provider.dart';

/// 用記憶體資料庫啟動整個 App（含路由），停在首頁。
///
/// 回傳資料庫，讓測試準備資料或檢查寫入結果；[overrides] 用來換掉其他 provider。
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) async {
  // 清掉上一個測試留下的資產快取（例如範本 JSON）。快取裡的 Future 是在上一個測試的
  // 假時間 zone 裡建立的，這個測試再 await 它時，回呼會排進已經結束的 zone，永遠等不到。
  rootBundle.clear();

  // 停止監看時立刻關閉查詢。drift 預設會多等一輪事件迴圈，留下計時器，
  // 測試結束時 flutter_test 會判定為殘留的計時器而失敗。
  final database = AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );

  // 照片檔案放在這個測試專用的暫存資料夾（Documents 目錄要靠 main.dart 啟動時取得）。
  final documents = Directory.systemTemp.createTempSync('rental_manager_test');
  addTearDown(() => documents.deleteSync(recursive: true));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        fileStoreProvider.overrideWithValue(FileStore(documents)),
        // 資料庫跟 App 一樣由 ProviderScope 關閉，不用 addTearDown。
        // 測試失敗時 flutter_test 不會拆掉畫面，被蓋住的頁面（例如新增頁底下的列表）
        // 的監看查詢還在暫停中；這時在 tearDown 關資料庫，會一直等不到那個查詢結束，
        // 測試就卡住。ProviderScope 被拆掉時（測試通過時，或失敗後下一個測試開始時），
        // Riverpod 會先取消監看，最後才處理資料庫。
        databaseProvider.overrideWith((ref) {
          ref.onDispose(database.close);
          return database;
        }),
        ...overrides,
      ],
      // 測試裡讀取失敗就直接顯示錯誤，不自動重試（重試會留下計時器）。
      retry: (retryCount, error) => null,
      child: const RentalManagerApp(),
    ),
  );
  await tester.pumpAndSettle();
  return database;
}
