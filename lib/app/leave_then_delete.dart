import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/files/file_store.dart';

/// 刪除目前這頁顯示的資料：先轉跳到 [location]，等這頁的退場動畫結束、頁面關掉之後，
/// 才執行 [delete]（D-018）。
///
/// 這頁在退場動畫中還會重畫，在那之前刪除的話，會閃過「找不到」的畫面。
/// 離開後這頁的 context 和 ref 就不能用，[delete] 要用的東西請在呼叫前先取出來。
Future<void> leaveThenDelete(
  BuildContext context, {
  required String location,
  required Future<void> Function() delete,
}) async {
  final route = ModalRoute.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  context.go(location);
  await route.completed;
  try {
    await delete();
  } catch (error) {
    // 推論：刪除失敗時停在離開後的頁面、顯示錯誤，資料還在，可以再試一次。
    messenger.showSnackBar(SnackBar(content: Text(deleteErrorMessage(error))));
  }
}

/// 刪除時發生錯誤要給使用者看的訊息。
///
/// 資料已經刪掉、只是照片檔沒清掉時（[FileCleanupException]），不說「刪除失敗」，
/// 以免使用者以為沒刪成（D-022）。
String deleteErrorMessage(Object error) {
  return switch (error) {
    FileCleanupException(:final cause) => '已刪除，但有照片檔沒有清掉：$cause',
    _ => '刪除失敗：$error',
  };
}
