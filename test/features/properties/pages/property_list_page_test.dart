import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/properties/providers/property_list_provider.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('沒有物件時顯示空狀態和新增按鈕，沒有右下角按鈕', (tester) async {
    await pumpApp(tester);

    expect(find.text('還沒有物件'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '新增物件'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('列出物件的名稱，有地址才顯示地址', (tester) async {
    final database = await pumpApp(tester);
    await database.propertiesDao.createProperty(
      name: '中山路公寓',
      address: '台北市中山區中山北路一段 1 號',
    );
    await database.propertiesDao.createProperty(name: '民生社區套房');
    await tester.pumpAndSettle();

    expect(find.text('還沒有物件'), findsNothing);
    expect(find.widgetWithText(ListTile, '中山路公寓'), findsOneWidget);
    expect(find.text('台北市中山區中山北路一段 1 號'), findsOneWidget);
    final tileWithoutAddress = tester.widget<ListTile>(
      find.widgetWithText(ListTile, '民生社區套房'),
    );
    expect(tileWithoutAddress.subtitle, isNull);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('刪除的物件會自動從列表消失', (tester) async {
    final database = await pumpApp(tester);
    final id = await database.propertiesDao.createProperty(name: '中山路公寓');
    await tester.pumpAndSettle();
    expect(find.text('中山路公寓'), findsOneWidget);

    await database.propertiesDao.deleteProperty(id);
    await tester.pumpAndSettle();

    expect(find.text('中山路公寓'), findsNothing);
    expect(find.text('還沒有物件'), findsOneWidget);
  });

  testWidgets('讀取失敗時顯示錯誤訊息', (tester) async {
    await pumpApp(
      tester,
      overrides: [propertyListProvider.overrideWith(_FailingPropertyList.new)],
    );

    expect(find.textContaining('讀取物件失敗'), findsOneWidget);
    expect(find.textContaining('資料庫壞了'), findsOneWidget);
  });
}

class _FailingPropertyList extends PropertyList {
  @override
  Stream<List<Property>> build() => Stream.error(StateError('資料庫壞了'));
}
