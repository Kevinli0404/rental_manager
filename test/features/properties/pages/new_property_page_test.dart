import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/properties/providers/property_list_provider.dart';

import '../../../helpers/pump_app.dart';

void main() {
  final nameField = find.widgetWithText(TextFormField, '名稱');
  final addressField = find.widgetWithText(TextFormField, '地址（選填）');
  final noteField = find.widgetWithText(TextFormField, '備註（選填）');
  final saveButton = find.widgetWithText(TextButton, '儲存');

  Future<void> openFromEmptyState(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilledButton, '新增物件'));
    await tester.pumpAndSettle();
  }

  Future<List<Property>> savedProperties(AppDatabase database) {
    return database.select(database.properties).get();
  }

  testWidgets('填好儲存後回到列表，新物件自動出現，前後空白已去掉', (tester) async {
    final database = await pumpApp(tester);
    await openFromEmptyState(tester);
    expect(find.text('新增物件'), findsOneWidget);

    await tester.enterText(nameField, '  中山路公寓 ');
    await tester.enterText(addressField, ' 台北市中山區中山北路一段 1 號  ');
    await tester.enterText(noteField, '\n五樓，無電梯\n');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNothing);
    expect(find.widgetWithText(ListTile, '中山路公寓'), findsOneWidget);
    expect(find.text('台北市中山區中山北路一段 1 號'), findsOneWidget);

    final saved = await savedProperties(database);
    expect(saved, hasLength(1));
    expect(saved.single.name, '中山路公寓');
    expect(saved.single.address, '台北市中山區中山北路一段 1 號');
    expect(saved.single.note, '五樓，無電梯');
  });

  testWidgets('只填名稱也能儲存', (tester) async {
    final database = await pumpApp(tester);
    await openFromEmptyState(tester);

    await tester.enterText(nameField, '中山路公寓');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final saved = await savedProperties(database);
    expect(saved.single.address, '');
    expect(saved.single.note, '');
  });

  testWidgets('有物件時從右下角按鈕進新增頁', (tester) async {
    final database = await pumpApp(tester);
    await database.propertiesDao.createProperty(name: '中山路公寓');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(nameField, findsOneWidget);
  });

  testWidgets('名稱沒填或只有空白時不能儲存', (tester) async {
    final database = await pumpApp(tester);
    await openFromEmptyState(tester);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('請輸入名稱'), findsOneWidget);

    await tester.enterText(nameField, '   ');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('請輸入名稱'), findsOneWidget);

    expect(nameField, findsOneWidget);
    expect(await savedProperties(database), isEmpty);
  });

  testWidgets('按返回直接回到列表，不存檔', (tester) async {
    final database = await pumpApp(tester);
    await openFromEmptyState(tester);

    await tester.enterText(nameField, '中山路公寓');
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('還沒有物件'), findsOneWidget);
    expect(await savedProperties(database), isEmpty);
  });

  testWidgets('連點儲存只新增一筆', (tester) async {
    final database = await pumpApp(tester);
    await openFromEmptyState(tester);

    await tester.enterText(nameField, '中山路公寓');
    await tester.tap(saveButton);
    await tester.tap(saveButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(await savedProperties(database), hasLength(1));
  });

  testWidgets('儲存失敗時留在新增頁、保留內容並顯示錯誤', (tester) async {
    await pumpApp(
      tester,
      overrides: [propertyListProvider.overrideWith(_FailingPropertyList.new)],
    );
    await openFromEmptyState(tester);

    await tester.enterText(nameField, '中山路公寓');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('儲存失敗'), findsOneWidget);
    expect(find.textContaining('磁碟已滿'), findsOneWidget);
    expect(find.text('中山路公寓'), findsOneWidget);
    // 失敗後可以再按一次。
    expect(tester.widget<TextButton>(saveButton).onPressed, isNotNull);
  });
}

/// 讀取照常，新增時失敗。
class _FailingPropertyList extends PropertyList {
  @override
  Future<void> create({
    required String name,
    required String address,
    required String note,
  }) async {
    throw StateError('磁碟已滿');
  }
}
