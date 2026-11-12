import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';
import 'package:rental_manager/app/router.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/inspections/providers/inspection_list_provider.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Finder inAppBar(String text) {
    return find.descendant(of: find.byType(AppBar), matching: find.text(text));
  }

  Future<String> addInspection(
    AppDatabase database,
    String propertyId,
    String inspectedOn,
  ) {
    return database.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: inspectedOn,
      landlordName: '',
      layout: const Layout(
        templateId: 'default-residence',
        templateVersion: 1,
        rooms: [],
      ),
    );
  }

  /// 建立物件和兩筆入住草稿，從列表進詳情，再進 2026-11-04 那一筆的點交頁。
  ///
  /// 回傳 (要操作的那筆, 另一筆) 的 id。
  Future<(String, String)> openInspection(
    WidgetTester tester,
    AppDatabase database,
  ) async {
    final propertyId = await database.propertiesDao.createProperty(
      name: '中山路公寓',
    );
    final target = await addInspection(database, propertyId, '2026-11-04');
    final other = await addInspection(database, propertyId, '2026-01-15');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '中山路公寓'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '2026-11-04'));
    await tester.pumpAndSettle();
    return (target, other);
  }

  Future<void> chooseDelete(WidgetTester tester) async {
    await tester.tap(find.byTooltip('更多'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('刪除'));
    await tester.pumpAndSettle();
  }

  Finder dialogButton(String label) {
    return find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(TextButton, label),
    );
  }

  Future<Inspection> savedInspection(AppDatabase database, String id) {
    return (database.select(
      database.inspections,
    )..where((i) => i.id.equals(id))).getSingle();
  }

  testWidgets('點交紀錄不存在時顯示找不到', (tester) async {
    final database = await pumpApp(tester);
    final propertyId = await database.propertiesDao.createProperty(
      name: '中山路公寓',
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RentalManagerApp)),
    );
    container
        .read(routerProvider)
        .go(AppRoutes.inspection(propertyId, '不存在的 id'));
    await tester.pumpAndSettle();

    expect(find.text('找不到這個點交紀錄'), findsOneWidget);
    expect(find.byTooltip('更多'), findsNothing);
  });

  group('刪除草稿', () {
    testWidgets('確認後回到物件詳情，這一筆從列表消失；資料庫標記刪除，另一筆不受影響', (tester) async {
      final database = await pumpApp(tester);
      final (target, other) = await openInspection(tester, database);

      await chooseDelete(tester);
      expect(find.text('刪除點交紀錄？'), findsOneWidget);
      expect(find.textContaining('入住 2026-11-04'), findsWidgets);
      await tester.tap(dialogButton('刪除'));
      await tester.pumpAndSettle();

      expect(inAppBar('中山路公寓'), findsOneWidget);
      expect(find.widgetWithText(ListTile, '2026-11-04'), findsNothing);
      expect(find.widgetWithText(ListTile, '2026-01-15'), findsOneWidget);
      expect((await savedInspection(database, target)).deletedAt, isNotNull);
      expect((await savedInspection(database, other)).deletedAt, isNull);
    });

    testWidgets('刪除後的退場動畫中不會閃過「找不到這個點交紀錄」', (tester) async {
      final database = await pumpApp(tester);
      await openInspection(tester, database);
      await chooseDelete(tester);

      await tester.tap(dialogButton('刪除'));
      // 一格一格推進，涵蓋關掉確認視窗、點交頁退場的每個畫面。
      for (var frame = 0; frame < 60; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        expect(find.text('找不到這個點交紀錄'), findsNothing, reason: '第 $frame 格');
      }
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, '2026-11-04'), findsNothing);
    });

    testWidgets('按取消留在點交頁，資料不變', (tester) async {
      final database = await pumpApp(tester);
      final (target, _) = await openInspection(tester, database);

      await chooseDelete(tester);
      await tester.tap(dialogButton('取消'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(inAppBar('入住 2026-11-04'), findsOneWidget);
      expect((await savedInspection(database, target)).deletedAt, isNull);
    });

    testWidgets('刪除失敗時回到物件詳情，紀錄還在並顯示錯誤', (tester) async {
      final database = await pumpApp(
        tester,
        overrides: [
          inspectionListProvider.overrideWith2(_FailingInspectionList.new),
        ],
      );
      final (target, _) = await openInspection(tester, database);

      await chooseDelete(tester);
      await tester.tap(dialogButton('刪除'));
      await tester.pumpAndSettle();

      expect(inAppBar('中山路公寓'), findsOneWidget);
      expect(find.widgetWithText(ListTile, '2026-11-04'), findsOneWidget);
      expect(find.textContaining('刪除失敗'), findsOneWidget);
      expect(find.textContaining('資料庫鎖住了'), findsOneWidget);
      expect((await savedInspection(database, target)).deletedAt, isNull);
    });
  });

  testWidgets('已簽名的點交紀錄沒有刪除選單', (tester) async {
    final database = await pumpApp(tester);
    final propertyId = await database.propertiesDao.createProperty(
      name: '中山路公寓',
    );
    final id = await addInspection(database, propertyId, '2026-11-04');
    await (database.update(
      database.inspections,
    )..where((i) => i.id.equals(id))).write(
      const InspectionsCompanion(status: Value(InspectionStatus.signed)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '中山路公寓'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '2026-11-04'));
    await tester.pumpAndSettle();

    expect(inAppBar('入住 2026-11-04'), findsOneWidget);
    expect(find.byTooltip('更多'), findsNothing);
  });
}

/// 讀取照常，刪除時失敗。
class _FailingInspectionList extends InspectionList {
  _FailingInspectionList(super.propertyId);

  @override
  Future<void> delete(String id) async {
    throw StateError('資料庫鎖住了');
  }
}
