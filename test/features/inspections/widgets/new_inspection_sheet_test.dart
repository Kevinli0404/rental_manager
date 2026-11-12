import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/inspections/providers/inspection_list_provider.dart';
import 'package:rental_manager/features/inspections/widgets/new_inspection_sheet.dart';
import 'package:rental_manager/features/templates/data/layout.dart';
import 'package:rental_manager/features/templates/data/template_loader.dart';

import '../../../helpers/pump_app.dart';

void main() {
  final createButton = find.widgetWithText(FilledButton, '建立');
  final sheet = find.byType(BottomSheet);

  Finder inAppBar(String text) {
    return find.descendant(of: find.byType(AppBar), matching: find.text(text));
  }

  String today() => formatInspectedOn(DateTime.now());

  /// 建立物件，從列表進詳情，打開新增點交的底部選單。
  Future<void> openSheet(WidgetTester tester, AppDatabase database) async {
    await database.propertiesDao.createProperty(name: '中山路公寓');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '中山路公寓'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('新增點交'));
    await tester.pumpAndSettle();
  }

  Future<void> chooseType(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<InspectionType>),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<List<Inspection>> savedInspections(AppDatabase database) {
    return database.select(database.inspections).get();
  }

  testWidgets('一開始沒選類型，不能建立；日期預設今天', (tester) async {
    final database = await pumpApp(tester);
    await openSheet(tester, database);

    expect(find.descendant(of: sheet, matching: find.text('新增點交')), findsOne);
    expect(find.text(today()), findsOneWidget);
    expect(tester.widget<FilledButton>(createButton).onPressed, isNull);

    await chooseType(tester, '入住');
    expect(tester.widget<FilledButton>(createButton).onPressed, isNotNull);

    // 再點一次同一個類型不會取消選取。
    await chooseType(tester, '入住');
    expect(tester.widget<FilledButton>(createButton).onPressed, isNotNull);
  });

  testWidgets('選退租後建立：進點交頁，存成照範本建立的草稿；返回後詳情列出這一筆', (tester) async {
    final database = await pumpApp(tester);
    await openSheet(tester, database);

    await chooseType(tester, '退租');
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(sheet, findsNothing);
    expect(inAppBar('退租 ${today()}'), findsOneWidget);

    final saved = (await savedInspections(database)).single;
    final property = await database.select(database.properties).getSingle();
    expect(saved.propertyId, property.id);
    expect(saved.type, InspectionType.moveOut);
    expect(saved.status, InspectionStatus.draft);
    expect(saved.inspectedOn, today());
    expect(saved.landlordName, '');
    expect(saved.tenantName, '');
    expect(saved.baseInspectionId, isNull);
    final template = await tester.runAsync(loadDefaultTemplate);
    expect(saved.layout, Layout.fromTemplate(template!));

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(inAppBar('中山路公寓'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '退租'), findsOneWidget);
  });

  testWidgets('從日期選擇器改日期後建立，存的是選的日期', (tester) async {
    final database = await pumpApp(tester);
    await openSheet(tester, database);

    // 選這個月裡不是今天的另一天。
    final now = DateTime.now();
    final day = now.day == 1 ? 2 : 1;
    final picked = formatInspectedOn(DateTime(now.year, now.month, day));

    await tester.tap(find.widgetWithText(ListTile, '點交日期'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(CalendarDatePicker),
        matching: find.text('$day'),
      ),
    );
    await tester.tap(find.widgetWithText(TextButton, '確定'));
    await tester.pumpAndSettle();
    expect(find.text(picked), findsOneWidget);

    await chooseType(tester, '入住');
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(inAppBar('入住 $picked'), findsOneWidget);
    final saved = (await savedInspections(database)).single;
    expect(saved.type, InspectionType.moveIn);
    expect(saved.inspectedOn, picked);
  });

  testWidgets('連點建立只建立一筆', (tester) async {
    // 讓建立停在半途：記憶體資料庫寫得太快，不擋住的話，第二下點擊前選單就關了。
    final firstCreateHeld = Completer<void>();
    final database = await pumpApp(
      tester,
      overrides: [
        inspectionListProvider.overrideWith2(
          (propertyId) =>
              _HeldInspectionList(propertyId, firstCreateHeld.future),
        ),
      ],
    );
    await openSheet(tester, database);

    await chooseType(tester, '入住');
    await tester.tap(createButton);
    await tester.tap(createButton);
    firstCreateHeld.complete();
    await tester.pumpAndSettle();

    expect(await savedInspections(database), hasLength(1));
  });

  testWidgets('點選單外面關掉選單，不建立', (tester) async {
    final database = await pumpApp(tester);
    await openSheet(tester, database);

    await chooseType(tester, '入住');
    await tester.tapAt(const Offset(10, 100));
    await tester.pumpAndSettle();

    expect(sheet, findsNothing);
    expect(inAppBar('中山路公寓'), findsOneWidget);
    expect(await savedInspections(database), isEmpty);
  });

  testWidgets('建立失敗時選單不關，顯示錯誤，保留已選的類型，可以再按一次', (tester) async {
    final database = await pumpApp(
      tester,
      overrides: [
        inspectionListProvider.overrideWith2(_FailingInspectionList.new),
      ],
    );
    await openSheet(tester, database);

    await chooseType(tester, '退租');
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(sheet, findsOneWidget);
    expect(find.textContaining('建立失敗'), findsOneWidget);
    expect(find.textContaining('磁碟已滿'), findsOneWidget);
    final segments = tester.widget<SegmentedButton<InspectionType>>(
      find.byType(SegmentedButton<InspectionType>),
    );
    expect(segments.selected, {InspectionType.moveOut});
    expect(tester.widget<FilledButton>(createButton).onPressed, isNotNull);
    expect(await savedInspections(database), isEmpty);
  });
}

/// 建立時先等 [_release]，再照常建立。
class _HeldInspectionList extends InspectionList {
  _HeldInspectionList(super.propertyId, this._release);

  final Future<void> _release;

  @override
  Future<String> create({
    required InspectionType type,
    required String inspectedOn,
  }) async {
    await _release;
    return super.create(type: type, inspectedOn: inspectedOn);
  }
}

/// 讀取照常，建立時失敗。
class _FailingInspectionList extends InspectionList {
  _FailingInspectionList(super.propertyId);

  @override
  Future<String> create({
    required InspectionType type,
    required String inspectedOn,
  }) async {
    throw StateError('磁碟已滿');
  }
}
