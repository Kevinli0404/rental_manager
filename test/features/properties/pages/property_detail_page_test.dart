import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';
import 'package:rental_manager/app/router.dart';
import 'package:rental_manager/features/properties/providers/property_list_provider.dart';

import '../../../helpers/pump_app.dart';

void main() {
  final appBarTitle = find.descendant(
    of: find.byType(AppBar),
    matching: find.text('中山路公寓'),
  );

  Future<void> openDetail(WidgetTester tester, String name) async {
    await tester.tap(find.widgetWithText(ListTile, name));
    await tester.pumpAndSettle();
  }

  Future<void> chooseDelete(WidgetTester tester) async {
    await tester.tap(find.byTooltip('更多'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('刪除'));
    await tester.pumpAndSettle();
  }

  Future<void> answerDialog(WidgetTester tester, String button) async {
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextButton, button),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('點列表上的物件進詳情，顯示名稱、地址、備註', (tester) async {
    final database = await pumpApp(tester);
    await database.propertiesDao.createProperty(
      name: '中山路公寓',
      address: '台北市中山區中山北路一段 1 號',
      note: '五樓，無電梯',
    );
    await database.propertiesDao.createProperty(name: '民生社區套房');
    await tester.pumpAndSettle();

    await openDetail(tester, '中山路公寓');

    expect(appBarTitle, findsOneWidget);
    expect(find.text('台北市中山區中山北路一段 1 號'), findsOneWidget);
    expect(find.text('五樓，無電梯'), findsOneWidget);
    expect(find.text('未填'), findsNothing);
    expect(find.text('民生社區套房'), findsNothing);
  });

  testWidgets('沒填的地址、備註顯示「未填」', (tester) async {
    final database = await pumpApp(tester);
    await database.propertiesDao.createProperty(name: '中山路公寓');
    await tester.pumpAndSettle();

    await openDetail(tester, '中山路公寓');

    expect(find.text('地址'), findsOneWidget);
    expect(find.text('備註'), findsOneWidget);
    expect(find.text('未填'), findsNWidgets(2));
  });

  testWidgets('按返回回到列表', (tester) async {
    final database = await pumpApp(tester);
    await database.propertiesDao.createProperty(name: '中山路公寓');
    await tester.pumpAndSettle();
    await openDetail(tester, '中山路公寓');

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, '中山路公寓'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('物件不存在時顯示找不到，沒有選單', (tester) async {
    await pumpApp(tester);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RentalManagerApp)),
    );
    container.read(routerProvider).go(AppRoutes.propertyDetail('不存在的 id'));
    await tester.pumpAndSettle();

    expect(find.text('找不到這個物件'), findsOneWidget);
    expect(find.byTooltip('更多'), findsNothing);
  });

  testWidgets('刪除：確認後回到列表，物件消失，資料庫是軟刪除', (tester) async {
    final database = await pumpApp(tester);
    final deletedId = await database.propertiesDao.createProperty(
      name: '中山路公寓',
    );
    final keptId = await database.propertiesDao.createProperty(name: '民生社區套房');
    await tester.pumpAndSettle();
    await openDetail(tester, '中山路公寓');

    await chooseDelete(tester);
    expect(find.textContaining('點交紀錄都會刪除'), findsOneWidget);
    await answerDialog(tester, '刪除');

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.widgetWithText(ListTile, '中山路公寓'), findsNothing);
    expect(find.widgetWithText(ListTile, '民生社區套房'), findsOneWidget);

    final rows = {
      for (final row in await database.select(database.properties).get())
        row.id: row,
    };
    expect(rows, hasLength(2), reason: '軟刪除，資料列還在');
    expect(rows[deletedId]!.deletedAt, isNotNull);
    expect(rows[keptId]!.deletedAt, isNull);
  });

  testWidgets('刪除後的退場動畫中不會閃過「找不到這個物件」', (tester) async {
    final database = await pumpApp(tester);
    await database.propertiesDao.createProperty(name: '中山路公寓');
    await tester.pumpAndSettle();
    await openDetail(tester, '中山路公寓');
    await chooseDelete(tester);

    await tester.tap(find.widgetWithText(TextButton, '刪除').last);
    // 一格一格推進，涵蓋關掉確認視窗、詳情頁退場的每個畫面。
    for (var frame = 0; frame < 60; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(find.text('找不到這個物件'), findsNothing, reason: '第 $frame 格');
    }
    await tester.pumpAndSettle();

    expect(find.text('還沒有物件'), findsOneWidget);
  });

  testWidgets('刪除時按取消，留在詳情，資料不變', (tester) async {
    final database = await pumpApp(tester);
    await database.propertiesDao.createProperty(name: '中山路公寓');
    await tester.pumpAndSettle();
    await openDetail(tester, '中山路公寓');

    await chooseDelete(tester);
    await answerDialog(tester, '取消');

    expect(find.byType(AlertDialog), findsNothing);
    expect(appBarTitle, findsOneWidget);
    final saved = await database.select(database.properties).getSingle();
    expect(saved.deletedAt, isNull);
  });

  testWidgets('刪除失敗時回到列表，物件還在並顯示錯誤', (tester) async {
    final database = await pumpApp(
      tester,
      overrides: [propertyListProvider.overrideWith(_FailingPropertyList.new)],
    );
    await database.propertiesDao.createProperty(name: '中山路公寓');
    await tester.pumpAndSettle();
    await openDetail(tester, '中山路公寓');

    await chooseDelete(tester);
    await answerDialog(tester, '刪除');

    expect(find.widgetWithText(ListTile, '中山路公寓'), findsOneWidget);
    expect(find.textContaining('刪除失敗'), findsOneWidget);
    expect(find.textContaining('資料庫鎖住了'), findsOneWidget);
  });
}

/// 讀取照常，刪除時失敗。
class _FailingPropertyList extends PropertyList {
  @override
  Future<void> delete(String id) async {
    throw StateError('資料庫鎖住了');
  }
}
