import 'dart:io' show FileSystemException;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';
import 'package:rental_manager/app/router.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/core/database/database_provider.dart';
import 'package:rental_manager/core/files/file_store.dart';
import 'package:rental_manager/features/inspections/providers/inspection_controller.dart';
import 'package:rental_manager/features/inspections/providers/inspection_photos_provider.dart';
import 'package:rental_manager/features/templates/data/layout.dart';
import 'package:rental_manager/features/templates/data/template.dart';

import '../../../helpers/pump_app.dart';

/// 客廳、臥室、陽台；空間類型都是內建範本有的。
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
      key: 'balcony',
      typeKey: 'balcony',
      name: '陽台',
      items: [LayoutItem(key: 'floor', name: '地板')],
    ),
  ],
);

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

  /// 從點交頁右上角選單進管理空間。
  Future<void> openRooms(WidgetTester tester) async {
    await tester.tap(find.byTooltip('更多'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('管理空間'));
    await tester.pumpAndSettle();
  }

  Future<void> goBack(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
  }

  Finder roomTile(String name) => find.widgetWithText(ListTile, name);

  /// 管理空間頁上 [room] 那一列的選單，選 [action]。
  Future<void> chooseRoomAction(
    WidgetTester tester,
    String room,
    String action,
  ) async {
    await tester.tap(
      find.descendant(of: roomTile(room), matching: find.byTooltip('更多')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(action));
    await tester.pumpAndSettle();
  }

  List<String?> listedRooms(WidgetTester tester) => [
    for (final tile in tester.widgetList<ListTile>(find.byType(ListTile)))
      (tile.title! as Text).data,
  ];

  List<String?> tabNames(WidgetTester tester) => [
    for (final tab in tester.widgetList<Tab>(find.byType(Tab))) tab.text,
  ];

  Finder dialogButton(String label) => find.descendant(
    of: find.byType(AlertDialog),
    matching: find.widgetWithText(TextButton, label),
  );

  Future<Layout> savedLayout(AppDatabase database) async {
    final inspection = await (database.select(
      database.inspections,
    )..where((i) => i.id.equals(inspectionId))).getSingle();
    return inspection.layout;
  }

  Future<List<ItemResult>> savedResults(AppDatabase database) {
    return database.select(database.itemResults).get();
  }

  // 點交頁上目前分頁裡 [item] 那張卡片的狀況按鈕、備註輸入框。
  Finder cardOf(String item) =>
      find.ancestor(of: find.text(item), matching: find.byType(Card));
  Set<ItemCondition> selectedOf(WidgetTester tester, String item) => tester
      .widget<SegmentedButton<ItemCondition>>(
        find.descendant(
          of: cardOf(item),
          matching: find.byType(SegmentedButton<ItemCondition>),
        ),
      )
      .selected;
  Finder noteOf(String item) =>
      find.descendant(of: cardOf(item), matching: find.byType(TextField));
  String noteText(WidgetTester tester, String item) =>
      tester.widget<TextField>(noteOf(item)).controller!.text;

  Future<void> openTab(WidgetTester tester, String room) async {
    await tester.tap(find.widgetWithText(Tab, room));
    await tester.pumpAndSettle();
  }

  testWidgets('點交頁選單的「管理空間」進到管理空間頁，依順序列出空間和項目數；按返回回到點交頁', (tester) async {
    await setUpData(tester);
    await openInspection(tester);
    await openRooms(tester);

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('管理空間')),
      findsOneWidget,
    );
    expect(listedRooms(tester), ['客廳', '臥室', '陽台']);
    expect(
      find.descendant(of: roomTile('客廳'), matching: find.text('2 個項目')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: roomTile('陽台'), matching: find.text('1 個項目')),
      findsOneWidget,
    );

    await goBack(tester);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('入住 2026-11-04'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('新增空間：從範本的空間類型選，排在同類空間後面、自動編號、項目照範本；點交頁多一個分頁', (tester) async {
    final database = await setUpData(tester);
    await openInspection(tester);
    await openRooms(tester);

    await tester.tap(find.byTooltip('新增空間'));
    await tester.pumpAndSettle();
    final sheet = find.byType(BottomSheet);
    expect(
      find.descendant(of: sheet, matching: find.text('玄關')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('浴室')),
      findsOneWidget,
    );
    await tester.tap(find.descendant(of: sheet, matching: find.text('臥室')));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
    expect(listedRooms(tester), ['客廳', '臥室', '臥室 2', '陽台']);
    expect(
      find.descendant(of: roomTile('臥室 2'), matching: find.text('11 個項目')),
      findsOneWidget,
      reason: '範本的臥室有 11 個項目',
    );
    final added = (await savedLayout(database)).rooms[2];
    expect(added.typeKey, 'bedroom');
    expect(
      added.key,
      matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-')),
      reason: '新的 UUID（D-011）',
    );

    await goBack(tester);
    expect(tabNames(tester), ['客廳', '臥室', '臥室 2', '陽台']);
  });

  testWidgets('複製空間：只複製項目，不複製狀況和備註；排在同類空間後面', (tester) async {
    final database = await setUpData(tester);
    await database.itemResultsDao.setCondition(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      condition: ItemCondition.damaged,
    );
    await database.itemResultsDao.setNote(
      inspectionId: inspectionId,
      roomKey: 'bedroom',
      itemKey: 'wall',
      note: '有釘孔',
    );
    await openInspection(tester);
    await openRooms(tester);

    await chooseRoomAction(tester, '臥室', '複製');

    expect(listedRooms(tester), ['客廳', '臥室', '臥室 2', '陽台']);
    final layout = await savedLayout(database);
    final copy = layout.rooms[2];
    expect(copy.key, isNot('bedroom'));
    expect(copy.typeKey, 'bedroom');
    expect(copy.items, _layout.rooms[1].items);
    expect(layout.rooms[1], _layout.rooms[1], reason: '原本的空間不變');
    expect((await savedResults(database)).map((r) => r.roomKey), ['bedroom']);

    await goBack(tester);
    await openTab(tester, '臥室 2');
    expect(selectedOf(tester, '牆面'), isEmpty);
    expect(noteText(tester, '牆面'), isEmpty);
  });

  group('改名稱', () {
    Finder nameField() => find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );

    testWidgets('帶入目前名稱；空白、同名時顯示原因不關閉；按完成儲存後列表和分頁都更新', (tester) async {
      final database = await setUpData(tester);
      await openInspection(tester);
      await openRooms(tester);

      await chooseRoomAction(tester, '臥室', '改名稱');
      expect(tester.widget<TextField>(nameField()).controller!.text, '臥室');

      await tester.enterText(nameField(), '  ');
      await tester.tap(dialogButton('儲存'));
      await tester.pumpAndSettle();
      expect(find.text('請輸入名稱'), findsOneWidget);

      await tester.enterText(nameField(), '客廳 ');
      await tester.tap(dialogButton('儲存'));
      await tester.pumpAndSettle();
      expect(find.text('已經有叫「客廳」的空間'), findsOneWidget);
      expect(await savedLayout(database), _layout);

      await tester.enterText(nameField(), ' 主臥室 ');
      await tester.pump();
      expect(find.text('已經有叫「客廳」的空間'), findsNothing, reason: '改了內容就拿掉錯誤');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(listedRooms(tester), ['客廳', '主臥室', '陽台']);
      final renamed = (await savedLayout(database)).rooms[1];
      expect(renamed.name, '主臥室');
      expect(renamed.key, 'bedroom');

      await goBack(tester);
      expect(tabNames(tester), ['客廳', '主臥室', '陽台']);
    });

    testWidgets('按取消名稱不變', (tester) async {
      final database = await setUpData(tester);
      await openInspection(tester);
      await openRooms(tester);

      await chooseRoomAction(tester, '臥室', '改名稱');
      await tester.enterText(nameField(), '主臥室');
      await tester.tap(dialogButton('取消'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(listedRooms(tester), ['客廳', '臥室', '陽台']);
      expect(await savedLayout(database), _layout);
    });
  });

  group('刪除', () {
    testWidgets('選了狀況的空間要先確認：取消不刪；確認後空間和內容一起刪除', (tester) async {
      final database = await setUpData(tester);
      await database.itemResultsDao.setCondition(
        inspectionId: inspectionId,
        roomKey: 'bedroom',
        itemKey: 'wardrobe',
        condition: ItemCondition.good,
      );
      await openInspection(tester);
      await openRooms(tester);

      await chooseRoomAction(tester, '臥室', '刪除');
      expect(find.text('刪除「臥室」？'), findsOneWidget);
      await tester.tap(dialogButton('取消'));
      await tester.pumpAndSettle();
      expect(listedRooms(tester), ['客廳', '臥室', '陽台']);
      expect((await savedResults(database)).single.deletedAt, isNull);

      await chooseRoomAction(tester, '臥室', '刪除');
      await tester.tap(dialogButton('刪除'));
      await tester.pumpAndSettle();

      expect(listedRooms(tester), ['客廳', '陽台']);
      expect((await savedLayout(database)).rooms.map((r) => r.key), [
        'living_room',
        'balcony',
      ]);
      expect((await savedResults(database)).single.deletedAt, isNotNull);

      await goBack(tester);
      expect(tabNames(tester), ['客廳', '陽台']);
    });

    testWidgets('只填了備註也要確認；備註只有空白不算內容，直接刪除', (tester) async {
      final database = await setUpData(tester);
      await database.itemResultsDao.setNote(
        inspectionId: inspectionId,
        roomKey: 'living_room',
        itemKey: 'air_conditioner',
        note: '冷氣漏水',
      );
      await database.itemResultsDao.setNote(
        inspectionId: inspectionId,
        roomKey: 'balcony',
        itemKey: 'floor',
        note: '  ',
      );
      await openInspection(tester);
      await openRooms(tester);

      await chooseRoomAction(tester, '客廳', '刪除');
      expect(find.text('刪除「客廳」？'), findsOneWidget);
      await tester.tap(dialogButton('取消'));
      await tester.pumpAndSettle();

      await chooseRoomAction(tester, '陽台', '刪除');
      expect(find.byType(AlertDialog), findsNothing);
      expect(listedRooms(tester), ['客廳', '臥室']);
    });

    testWidgets('沒有任何結果的空間直接刪除', (tester) async {
      final database = await setUpData(tester);
      await openInspection(tester);
      await openRooms(tester);

      await chooseRoomAction(tester, '陽台', '刪除');

      expect(find.byType(AlertDialog), findsNothing);
      expect(listedRooms(tester), ['客廳', '臥室']);
      expect((await savedLayout(database)).rooms, hasLength(2));
    });

    testWidgets('只有照片的空間也要先確認', (tester) async {
      final database = await setUpData(tester);
      await database.photosDao.insertPhoto(
        id: 'photo-1',
        inspectionId: inspectionId,
        roomKey: 'balcony',
        itemKey: 'floor',
        relativePath: 'photos/$inspectionId/photo-1.jpg',
      );
      await openInspection(tester);
      await openRooms(tester);

      await chooseRoomAction(tester, '陽台', '刪除');
      expect(find.text('刪除「陽台」？'), findsOneWidget);
      await tester.tap(dialogButton('取消'));
      await tester.pumpAndSettle();
      expect(await savedLayout(database), _layout);

      // 照片只算在自己的空間：臥室沒有內容也沒有照片，直接刪除。
      await chooseRoomAction(tester, '臥室', '刪除');
      expect(find.byType(AlertDialog), findsNothing);
      expect(listedRooms(tester), ['客廳', '陽台']);
    });

    testWidgets('讀不到照片時，刪除前一律先確認', (tester) async {
      final database = await setUpData(
        tester,
        overrides: [inspectionPhotosProvider.overrideWith2(_BrokenPhotos.new)],
      );
      await openInspection(tester);
      await openRooms(tester);

      await chooseRoomAction(tester, '陽台', '刪除');
      expect(find.text('刪除「陽台」？'), findsOneWidget);
      await tester.tap(dialogButton('取消'));
      await tester.pumpAndSettle();
      expect(await savedLayout(database), _layout);
    });

    testWidgets('讀不到填寫內容時，刪除前一律先確認', (tester) async {
      final database = await setUpData(
        tester,
        overrides: [
          inspectionControllerProvider.overrideWith2(
            _BrokenResultsController.new,
          ),
        ],
      );
      await openInspection(tester);
      await openRooms(tester);

      await chooseRoomAction(tester, '陽台', '刪除');
      expect(find.text('刪除「陽台」？'), findsOneWidget);
      await tester.tap(dialogButton('取消'));
      await tester.pumpAndSettle();
      expect(await savedLayout(database), _layout);
    });

    testWidgets('只剩一個空間時「刪除」不能點', (tester) async {
      const single = Layout(
        templateId: 'default-residence',
        templateVersion: 1,
        rooms: [
          LayoutRoom(
            key: 'living_room',
            typeKey: 'living_room',
            name: '客廳',
            items: [LayoutItem(key: 'wall', name: '牆面')],
          ),
        ],
      );
      final database = await setUpData(tester, layout: single);
      await openInspection(tester);
      await openRooms(tester);

      await tester.tap(
        find.descendant(of: roomTile('客廳'), matching: find.byTooltip('更多')),
      );
      await tester.pumpAndSettle();
      final deleteItem = find.ancestor(
        of: find.text('刪除'),
        matching: find.byWidgetPredicate((w) => w is PopupMenuItem),
      );
      expect(tester.widget<PopupMenuItem<Object?>>(deleteItem).enabled, false);

      await tester.tap(find.text('刪除'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
      expect(await savedLayout(database), single);
    });
  });

  testWidgets('新增、複製、改名稱、刪除失敗時顯示錯誤，資料不變', (tester) async {
    final database = await setUpData(
      tester,
      overrides: [
        inspectionControllerProvider.overrideWith2(
          _FailingInspectionController.new,
        ),
      ],
    );
    await openInspection(tester);
    await openRooms(tester);

    Future<void> expectError(String message) async {
      expect(find.textContaining(message), findsOneWidget);
      expect(find.textContaining('磁碟已滿'), findsOneWidget);
      // 等這個訊息消失，下一個訊息才會出現。
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byTooltip('新增空間'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(BottomSheet), matching: find.text('臥室')),
    );
    await tester.pumpAndSettle();
    await expectError('新增失敗');

    await chooseRoomAction(tester, '臥室', '複製');
    await expectError('複製失敗');

    await chooseRoomAction(tester, '臥室', '改名稱');
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      '主臥室',
    );
    await tester.tap(dialogButton('儲存'));
    await tester.pumpAndSettle();
    await expectError('儲存失敗');

    await chooseRoomAction(tester, '陽台', '刪除');
    await expectError('刪除失敗');

    expect(listedRooms(tester), ['客廳', '臥室', '陽台']);
    expect(await savedLayout(database), _layout);
  });

  testWidgets('空間已經刪掉、但照片檔沒清掉時分開說明，不說刪除失敗', (tester) async {
    final database = await setUpData(
      tester,
      overrides: [
        inspectionControllerProvider.overrideWith2(
          _CleanupFailingController.new,
        ),
      ],
    );
    await openInspection(tester);
    await openRooms(tester);

    await chooseRoomAction(tester, '陽台', '刪除');
    await tester.pumpAndSettle();

    expect(listedRooms(tester), ['客廳', '臥室']);
    expect((await savedLayout(database)).rooms, hasLength(2));
    expect(find.textContaining('已刪除，但有照片檔沒有清掉'), findsOneWidget);
    expect(find.textContaining('磁碟壞了'), findsOneWidget);
    expect(find.textContaining('刪除失敗'), findsNothing);
  });

  testWidgets('刪除前面的空間後回到點交頁，留下來的分頁顯示的還是自己空間的備註', (tester) async {
    const twoBedrooms = Layout(
      templateId: 'default-residence',
      templateVersion: 1,
      rooms: [
        LayoutRoom(
          key: 'living_room',
          typeKey: 'living_room',
          name: '客廳',
          items: [LayoutItem(key: 'wall', name: '牆面')],
        ),
        LayoutRoom(
          key: 'bedroom',
          typeKey: 'bedroom',
          name: '臥室',
          items: [LayoutItem(key: 'wall', name: '牆面')],
        ),
        LayoutRoom(
          key: '0b7e4c2a-5d1f-4e8b-9a63-2f1c8d7e6b54',
          typeKey: 'bedroom',
          name: '臥室 2',
          items: [LayoutItem(key: 'wall', name: '牆面')],
        ),
      ],
    );
    await setUpData(tester, layout: twoBedrooms);
    await openInspection(tester);
    // 兩間臥室都打開過，點交頁會保留這兩頁的卡片。
    await openTab(tester, '臥室');
    await openTab(tester, '臥室 2');
    await tester.enterText(noteOf('牆面'), '有壁癌');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump(const Duration(milliseconds: 500));

    await openRooms(tester);
    await chooseRoomAction(tester, '臥室', '刪除');
    await goBack(tester);

    expect(tabNames(tester), ['客廳', '臥室 2']);
    await openTab(tester, '臥室 2');
    expect(noteText(tester, '牆面'), '有壁癌');
  });
}

/// 讀取照常，管理空間的寫入都失敗。
class _FailingInspectionController extends InspectionController {
  _FailingInspectionController(super.inspectionId);

  @override
  Future<void> addRoom(TemplateRoom type) async => throw StateError('磁碟已滿');

  @override
  Future<void> copyRoom(String roomKey) async => throw StateError('磁碟已滿');

  @override
  Future<void> renameRoom(String roomKey, String name) async =>
      throw StateError('磁碟已滿');

  @override
  Future<void> deleteRoom(String roomKey) async => throw StateError('磁碟已滿');
}

/// 讀取項目結果失敗。
class _BrokenResultsController extends InspectionController {
  _BrokenResultsController(super.inspectionId);

  @override
  Stream<List<ItemResult>> build() => Stream.error(StateError('資料庫鎖住了'));
}

/// 讀取照片失敗。
class _BrokenPhotos extends InspectionPhotos {
  _BrokenPhotos(super.inspectionId);

  @override
  Stream<List<Photo>> build() => Stream.error(StateError('資料庫鎖住了'));
}

/// 空間照樣從資料庫刪掉，之後刪照片檔失敗。
class _CleanupFailingController extends InspectionController {
  _CleanupFailingController(super.inspectionId);

  @override
  Future<void> deleteRoom(String roomKey) async {
    await ref
        .read(databaseProvider)
        .inspectionsDao
        .deleteRoom(inspectionId, roomKey);
    throw FileCleanupException(const FileSystemException('磁碟壞了'));
  }
}
