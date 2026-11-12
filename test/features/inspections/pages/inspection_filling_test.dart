import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';
import 'package:rental_manager/app/router.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/inspections/pages/inspection_page.dart';
import 'package:rental_manager/features/inspections/providers/inspection_controller.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

import '../../../helpers/pump_app.dart';

/// 客廳、臥室、臥室 2，各兩個項目；兩間臥室的項目 key 一樣，只有空間 key 不同。
const _layout = Layout(
  templateId: 'default-residence',
  templateVersion: 1,
  rooms: [
    LayoutRoom(
      key: 'living_room',
      typeKey: 'living_room',
      name: '客廳',
      items: [
        LayoutItem(key: 'wall', name: '牆面'),
        LayoutItem(key: 'air_conditioner', name: '冷氣'),
      ],
    ),
    LayoutRoom(
      key: 'bedroom',
      typeKey: 'bedroom',
      name: '臥室',
      items: [
        LayoutItem(key: 'wall', name: '牆面'),
        LayoutItem(key: 'wardrobe', name: '衣櫥'),
      ],
    ),
    LayoutRoom(
      key: '0b7e4c2a-5d1f-4e8b-9a63-2f1c8d7e6b54',
      typeKey: 'bedroom',
      name: '臥室 2',
      items: [
        LayoutItem(key: 'wall', name: '牆面'),
        LayoutItem(key: 'wardrobe', name: '衣櫥'),
      ],
    ),
  ],
);

const _secondBedroomKey = '0b7e4c2a-5d1f-4e8b-9a63-2f1c8d7e6b54';

void main() {
  late String propertyId;
  late String inspectionId;

  /// 建立物件和一筆入住草稿（空間配置預設是 [_layout]），不打開任何頁面。
  Future<AppDatabase> setUpData(
    WidgetTester tester, {
    List<Override> overrides = const [],
    Layout layout = _layout,
  }) async {
    final database = await pumpApp(tester, overrides: overrides);
    propertyId = await database.propertiesDao.createProperty(name: '中山路公寓');
    inspectionId = await database.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-04',
      landlordName: '',
      layout: layout,
    );
    return database;
  }

  Future<void> openInspection(WidgetTester tester) async {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(RentalManagerApp)),
    );
    container
        .read(routerProvider)
        .go(AppRoutes.inspection(propertyId, inspectionId));
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester, String room) async {
    await tester.tap(find.widgetWithText(Tab, room));
    await tester.pumpAndSettle();
  }

  /// 目前分頁裡 [item] 那張卡片。
  Finder cardOf(String item) {
    return find.ancestor(of: find.text(item), matching: find.byType(Card));
  }

  /// 目前分頁裡 [item] 那張卡片的狀況按鈕。
  Finder conditionsOf(String item) {
    return find.descendant(
      of: cardOf(item),
      matching: find.byType(SegmentedButton<ItemCondition>),
    );
  }

  /// 目前分頁裡 [item] 那張卡片的備註輸入框。
  Finder noteOf(String item) {
    return find.descendant(of: cardOf(item), matching: find.byType(TextField));
  }

  String noteText(WidgetTester tester, String item) {
    return tester.widget<TextField>(noteOf(item)).controller!.text;
  }

  Future<void> choose(WidgetTester tester, String item, String label) async {
    await tester.tap(
      find.descendant(of: conditionsOf(item), matching: find.text(label)),
    );
    await tester.pumpAndSettle();
  }

  Set<ItemCondition> selectedOf(WidgetTester tester, String item) {
    return tester
        .widget<SegmentedButton<ItemCondition>>(conditionsOf(item))
        .selected;
  }

  Future<Map<(String, String), ItemCondition?>> savedConditions(
    AppDatabase database,
  ) async {
    final rows = await database.select(database.itemResults).get();
    return {for (final r in rows) (r.roomKey, r.itemKey): r.condition};
  }

  Future<Map<(String, String), String>> savedNotes(AppDatabase database) async {
    final rows = await database.select(database.itemResults).get();
    return {for (final r in rows) (r.roomKey, r.itemKey): r.note};
  }

  testWidgets('空間分頁照配置順序，目前分頁列出該空間的項目，一開始都是未填', (tester) async {
    await setUpData(tester);
    await openInspection(tester);

    final tabs = [
      for (final room in ['客廳', '臥室', '臥室 2'])
        tester.getTopLeft(find.widgetWithText(Tab, room)).dx,
    ];
    expect(tabs[0], lessThan(tabs[1]));
    expect(tabs[1], lessThan(tabs[2]));

    expect(find.text('牆面'), findsOneWidget);
    expect(find.text('冷氣'), findsOneWidget);
    expect(find.text('衣櫥'), findsNothing);
    expect(selectedOf(tester, '牆面'), isEmpty);
    expect(find.text('已填 0 / 6'), findsOneWidget);

    await openTab(tester, '臥室');
    expect(find.text('衣櫥'), findsOneWidget);
    expect(find.text('冷氣'), findsNothing);
  });

  testWidgets('選狀況立即寫入、進度更新；可以改選，再點同一個不會變回未填', (tester) async {
    final database = await setUpData(tester);
    await openInspection(tester);

    await choose(tester, '牆面', '良好');
    expect(selectedOf(tester, '牆面'), {ItemCondition.good});
    expect(await savedConditions(database), {
      ('living_room', 'wall'): ItemCondition.good,
    });
    expect(find.text('已填 1 / 6'), findsOneWidget);

    await choose(tester, '牆面', '損壞');
    expect(selectedOf(tester, '牆面'), {ItemCondition.damaged});
    expect(await savedConditions(database), {
      ('living_room', 'wall'): ItemCondition.damaged,
    });
    expect(find.text('已填 1 / 6'), findsOneWidget);

    await choose(tester, '牆面', '損壞');
    expect(selectedOf(tester, '牆面'), {ItemCondition.damaged});
    expect(find.text('已填 1 / 6'), findsOneWidget);
  });

  testWidgets('兩間臥室各自填寫，結果分開存；進度算全部空間', (tester) async {
    final database = await setUpData(tester);
    await openInspection(tester);

    await openTab(tester, '臥室');
    await choose(tester, '牆面', '良好');
    await openTab(tester, '臥室 2');
    expect(selectedOf(tester, '牆面'), isEmpty);
    await choose(tester, '牆面', '缺少');
    await choose(tester, '衣櫥', '不適用');

    expect(await savedConditions(database), {
      ('bedroom', 'wall'): ItemCondition.good,
      (_secondBedroomKey, 'wall'): ItemCondition.missing,
      (_secondBedroomKey, 'wardrobe'): ItemCondition.notApplicable,
    });
    expect(find.text('已填 3 / 6'), findsOneWidget);

    await openTab(tester, '臥室');
    expect(selectedOf(tester, '牆面'), {ItemCondition.good});
    expect(selectedOf(tester, '衣櫥'), isEmpty);
  });

  testWidgets('離開點交頁再進來，已選的狀況都還在', (tester) async {
    await setUpData(tester);
    await openInspection(tester);
    await choose(tester, '冷氣', '損壞');
    await openTab(tester, '臥室 2');
    await choose(tester, '衣櫥', '良好');

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('點交紀錄'), findsOneWidget, reason: '回到物件詳情');
    await tester.tap(find.widgetWithText(ListTile, '2026-11-04'));
    await tester.pumpAndSettle();

    expect(selectedOf(tester, '冷氣'), {ItemCondition.damaged});
    expect(find.text('已填 2 / 6'), findsOneWidget);
    await openTab(tester, '臥室 2');
    expect(selectedOf(tester, '衣櫥'), {ItemCondition.good});
  });

  testWidgets('進度只算目前空間配置裡的項目', (tester) async {
    final database = await setUpData(tester);
    // 已經不在空間配置裡的空間留下的結果（例如刪掉的空間）。
    await database.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'removed_room',
      itemKey: 'wall',
      condition: ItemCondition.good,
    );
    await database.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wardrobe',
      condition: ItemCondition.good,
    );
    await openInspection(tester);

    expect(find.text('已填 1 / 6'), findsOneWidget);
  });

  testWidgets('寫入失敗時顯示錯誤，選取維持原狀', (tester) async {
    final database = await setUpData(
      tester,
      overrides: [
        inspectionControllerProvider.overrideWith2(
          _FailingInspectionController.new,
        ),
      ],
    );
    await openInspection(tester);

    await choose(tester, '牆面', '良好');

    expect(find.textContaining('儲存失敗'), findsOneWidget);
    expect(find.textContaining('磁碟已滿'), findsOneWidget);
    expect(selectedOf(tester, '牆面'), isEmpty);
    expect(find.text('已填 0 / 6'), findsOneWidget);
    expect(await savedConditions(database), isEmpty);
  });

  testWidgets('空間配置沒有空間時顯示提示', (tester) async {
    final database = await pumpApp(tester);
    propertyId = await database.propertiesDao.createProperty(name: '中山路公寓');
    inspectionId = await database.inspectionsDao.createInspection(
      propertyId: propertyId,
      type: InspectionType.moveIn,
      inspectedOn: '2026-11-04',
      landlordName: '',
      layout: const Layout(
        templateId: 'default-residence',
        templateVersion: 1,
        rooms: [],
      ),
    );
    await openInspection(tester);

    expect(find.text('這筆點交沒有空間'), findsOneWidget);
    expect(find.byType(Tab), findsNothing);
    expect(find.text('已填 0 / 0'), findsOneWidget);
  });

  group('備註', () {
    testWidgets('顯示已存的備註；停止輸入 0.5 秒後才寫入，繼續打字會重新計時；狀況和進度不受影響', (tester) async {
      final database = await setUpData(tester);
      await database.itemResultsDao.setCondition(
        inspectionId: inspectionId,
        roomKey: 'living_room',
        itemKey: 'wall',
        condition: ItemCondition.good,
      );
      await database.itemResultsDao.setNote(
        inspectionId: inspectionId,
        roomKey: 'living_room',
        itemKey: 'air_conditioner',
        note: '遙控器不見了',
      );
      await openInspection(tester);

      expect(noteText(tester, '牆面'), isEmpty);
      expect(noteText(tester, '冷氣'), '遙控器不見了');

      await tester.enterText(noteOf('牆面'), '左下角');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.enterText(noteOf('牆面'), '左下角有裂痕');
      await tester.pump(const Duration(milliseconds: 499));
      expect(
        (await savedNotes(database))[('living_room', 'wall')],
        isEmpty,
        reason: '最後一次輸入後還不到 0.5 秒',
      );

      await tester.pump(const Duration(milliseconds: 1));
      expect(await savedNotes(database), {
        ('living_room', 'wall'): '左下角有裂痕',
        ('living_room', 'air_conditioner'): '遙控器不見了',
      });
      expect(await savedConditions(database), {
        ('living_room', 'wall'): ItemCondition.good,
        ('living_room', 'air_conditioner'): null,
      });
      expect(find.text('已填 1 / 6'), findsOneWidget, reason: '冷氣只有備註，不算已填');
    });

    testWidgets('兩間臥室各自填備註，分開存', (tester) async {
      final database = await setUpData(tester);
      await openInspection(tester);

      await openTab(tester, '臥室');
      await tester.enterText(noteOf('牆面'), '有釘孔');
      await openTab(tester, '臥室 2');
      await tester.enterText(noteOf('牆面'), '有壁癌');
      await tester.pump(const Duration(milliseconds: 500));

      expect(await savedNotes(database), {
        ('bedroom', 'wall'): '有釘孔',
        (_secondBedroomKey, 'wall'): '有壁癌',
      });
    });

    testWidgets('打完字還沒滿 0.5 秒就離開點交頁，備註照樣寫入；再進來還在', (tester) async {
      final database = await setUpData(tester);
      await openInspection(tester);

      await tester.enterText(noteOf('冷氣'), '遙控器不見了');
      await tester.tap(find.byType(BackButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 460));
      expect(
        find.byType(InspectionPage),
        findsNothing,
        reason: '點交頁已經關掉，離輸入還不到 0.5 秒',
      );
      expect(await savedNotes(database), {
        ('living_room', 'air_conditioner'): '遙控器不見了',
      });

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, '2026-11-04'));
      await tester.pumpAndSettle();
      expect(noteText(tester, '冷氣'), '遙控器不見了');
    });

    testWidgets('還沒滿 0.5 秒 App 就切到背景，備註馬上寫入', (tester) async {
      final database = await setUpData(tester);
      await openInspection(tester);
      addTearDown(
        () => tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        ),
      );

      await tester.enterText(noteOf('牆面'), '有釘孔');
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();

      expect(await savedNotes(database), {('living_room', 'wall'): '有釘孔'});
    });

    testWidgets('寫入還沒完成時，捲到下面或切到別的分頁再回來，輸入框不會變回舊的內容', (tester) async {
      final gate = Completer<void>();
      final database = await setUpData(
        tester,
        layout: _longLayout,
        overrides: [
          inspectionControllerProvider.overrideWith2(
            (id) => _HeldNoteController(id, gate.future),
          ),
        ],
      );
      await openInspection(tester);

      await tester.enterText(noteOf('項目 1'), '水龍頭會滴水');
      // 收起鍵盤。輸入框有焦點時 Flutter 本來就會保留它，要沒有焦點才測得出來。
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pumpAndSettle();
      expect(find.text('項目 20'), findsOneWidget);
      expect(find.text('項目 1'), findsNothing);
      await tester.drag(find.byType(ListView), const Offset(0, 5000));
      await tester.pumpAndSettle();
      expect(noteText(tester, '項目 1'), '水龍頭會滴水', reason: '捲動之後');

      await openTab(tester, '陽台');
      await openTab(tester, '浴室');
      expect(noteText(tester, '項目 1'), '水龍頭會滴水', reason: '切換分頁之後');

      gate.complete();
      await tester.pumpAndSettle();
      expect(await savedNotes(database), {('bathroom', 'item_1'): '水龍頭會滴水'});
    });

    testWidgets('寫入失敗時顯示錯誤，輸入框保留打的字', (tester) async {
      final database = await setUpData(
        tester,
        overrides: [
          inspectionControllerProvider.overrideWith2(
            _FailingInspectionController.new,
          ),
        ],
      );
      await openInspection(tester);

      await tester.enterText(noteOf('牆面'), '有釘孔');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.textContaining('儲存失敗'), findsOneWidget);
      expect(find.textContaining('磁碟已滿'), findsOneWidget);
      expect(noteText(tester, '牆面'), '有釘孔');
      expect(await savedNotes(database), isEmpty);
    });

    testWidgets('太長的備註自動換行；鍵盤的 return 鍵是「完成」，按了收起鍵盤', (tester) async {
      await setUpData(tester);
      await openInspection(tester);
      final oneLine = tester.getSize(noteOf('牆面')).height;

      await tester.enterText(noteOf('牆面'), '左下角有一道裂痕，' * 10);
      await tester.pump();
      expect(tester.getSize(noteOf('牆面')).height, greaterThan(oneLine));
      expect(
        tester.testTextInput.setClientArgs!['inputAction'],
        TextInputAction.done.toString(),
      );

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(tester.testTextInput.isVisible, isFalse);
    });
  });
}

/// 一個項目很多、要捲動的空間，加上另一個空間。
final _longLayout = Layout(
  templateId: 'default-residence',
  templateVersion: 1,
  rooms: [
    LayoutRoom(
      key: 'bathroom',
      typeKey: 'bathroom',
      name: '浴室',
      items: [
        for (var i = 1; i <= 20; i++) LayoutItem(key: 'item_$i', name: '項目 $i'),
      ],
    ),
    const LayoutRoom(
      key: 'balcony',
      typeKey: 'balcony',
      name: '陽台',
      items: [LayoutItem(key: 'floor', name: '地板')],
    ),
  ],
);

/// 讀取照常，寫入狀況、備註時失敗。
class _FailingInspectionController extends InspectionController {
  _FailingInspectionController(super.inspectionId);

  @override
  Future<void> setCondition({
    required String roomKey,
    required String itemKey,
    required ItemCondition condition,
  }) async {
    throw StateError('磁碟已滿');
  }

  @override
  Future<void> setNote({
    required String roomKey,
    required String itemKey,
    required String note,
  }) async {
    throw StateError('磁碟已滿');
  }
}

/// 寫入備註時先停住，等 [gate] 完成才真的寫入，模擬寫入很慢。
class _HeldNoteController extends InspectionController {
  _HeldNoteController(super.inspectionId, this.gate);

  final Future<void> gate;

  @override
  Future<void> setNote({
    required String roomKey,
    required String itemKey,
    required String note,
  }) async {
    await gate;
    return super.setNote(roomKey: roomKey, itemKey: itemKey, note: note);
  }
}
