import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';
import 'package:rental_manager/app/router.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/properties/providers/property_list_provider.dart';

import '../../../helpers/pump_app.dart';

void main() {
  final nameField = find.widgetWithText(TextFormField, '名稱');
  final addressField = find.widgetWithText(TextFormField, '地址（選填）');
  final noteField = find.widgetWithText(TextFormField, '備註（選填）');
  final saveButton = find.widgetWithText(TextButton, '儲存');

  Finder fieldWithValue(Finder field, String value) {
    return find.descendant(of: field, matching: find.text(value));
  }

  Finder inAppBar(String text) {
    return find.descendant(of: find.byType(AppBar), matching: find.text(text));
  }

  /// 建立物件，從列表進詳情，再從選單進編輯頁。
  Future<String> openEdit(WidgetTester tester, AppDatabase database) async {
    final id = await database.propertiesDao.createProperty(
      name: '中山路公寓',
      address: '台北市中山區中山北路一段 1 號',
      note: '五樓，無電梯',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '中山路公寓'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('更多'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('編輯'));
    await tester.pumpAndSettle();
    return id;
  }

  Future<Property> savedProperty(AppDatabase database) {
    return database.select(database.properties).getSingle();
  }

  testWidgets('從詳情的選單進編輯頁，帶入原本的內容', (tester) async {
    final database = await pumpApp(tester);
    await openEdit(tester, database);

    expect(inAppBar('編輯物件'), findsOneWidget);
    expect(fieldWithValue(nameField, '中山路公寓'), findsOneWidget);
    expect(fieldWithValue(addressField, '台北市中山區中山北路一段 1 號'), findsOneWidget);
    expect(fieldWithValue(noteField, '五樓，無電梯'), findsOneWidget);
  });

  testWidgets('改完儲存後回到詳情顯示新內容，前後空白已去掉；再返回到列表', (tester) async {
    final database = await pumpApp(tester);
    await openEdit(tester, database);

    await tester.enterText(nameField, ' 中山路公寓 5F  ');
    await tester.enterText(addressField, '');
    await tester.enterText(noteField, '  已換新門鎖\n');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNothing);
    expect(inAppBar('中山路公寓 5F'), findsOneWidget);
    expect(find.text('已換新門鎖'), findsOneWidget);
    expect(find.text('未填'), findsOneWidget, reason: '地址清空了');

    final saved = await savedProperty(database);
    expect(saved.name, '中山路公寓 5F');
    expect(saved.address, '');
    expect(saved.note, '已換新門鎖');

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, '中山路公寓 5F'), findsOneWidget);
  });

  testWidgets('名稱清空或只有空白時不能儲存，資料不變', (tester) async {
    final database = await pumpApp(tester);
    await openEdit(tester, database);

    await tester.enterText(nameField, '');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('請輸入名稱'), findsOneWidget);

    await tester.enterText(nameField, '   ');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('請輸入名稱'), findsOneWidget);

    expect(inAppBar('編輯物件'), findsOneWidget);
    expect((await savedProperty(database)).name, '中山路公寓');
  });

  testWidgets('按返回回到詳情，不存檔', (tester) async {
    final database = await pumpApp(tester);
    await openEdit(tester, database);

    await tester.enterText(nameField, '民生社區套房');
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(inAppBar('中山路公寓'), findsOneWidget);
    expect((await savedProperty(database)).name, '中山路公寓');
  });

  testWidgets('儲存失敗時留在編輯頁、保留內容並顯示錯誤', (tester) async {
    final database = await pumpApp(
      tester,
      overrides: [propertyListProvider.overrideWith(_FailingPropertyList.new)],
    );
    await openEdit(tester, database);

    await tester.enterText(nameField, '民生社區套房');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('儲存失敗'), findsOneWidget);
    expect(find.textContaining('物件已被刪除'), findsOneWidget);
    expect(inAppBar('編輯物件'), findsOneWidget);
    expect(fieldWithValue(nameField, '民生社區套房'), findsOneWidget);
    expect(tester.widget<TextButton>(saveButton).onPressed, isNotNull);
  });

  testWidgets('物件不存在時顯示找不到，沒有表單', (tester) async {
    await pumpApp(tester);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RentalManagerApp)),
    );
    container.read(routerProvider).go(AppRoutes.editProperty('不存在的 id'));
    await tester.pumpAndSettle();

    expect(find.text('找不到這個物件'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(saveButton, findsNothing);
  });
}

/// 讀取照常，修改時失敗。
class _FailingPropertyList extends PropertyList {
  @override
  Future<void> edit({
    required String id,
    required String name,
    required String address,
    required String note,
  }) async {
    throw StateError('物件已被刪除');
  }
}
