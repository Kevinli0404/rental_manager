import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    messenger.showSnackBar(SnackBar(content: Text('刪除失敗：$error')));
  }
}
