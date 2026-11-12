import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/features/templates/data/layout.dart';
import 'package:rental_manager/features/templates/data/template.dart';

void main() {
  const template = Template(
    id: 'test-template',
    name: '測試範本',
    version: 3,
    rooms: [
      TemplateRoom(
        key: 'living_room',
        name: '客廳',
        items: [TemplateItem(key: 'wall', name: '牆面')],
      ),
      TemplateRoom(
        key: 'bedroom',
        name: '臥室',
        items: [
          TemplateItem(key: 'wall', name: '牆面'),
          TemplateItem(key: 'floor', name: '地板'),
        ],
      ),
    ],
  );

  group('Layout.fromTemplate', () {
    test('每類空間各一個，順序、空間 key、項目都沿用範本', () {
      final layout = Layout.fromTemplate(template);

      expect(
        layout,
        const Layout(
          templateId: 'test-template',
          templateVersion: 3,
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
              items: [
                LayoutItem(key: 'wall', name: '牆面'),
                LayoutItem(key: 'floor', name: '地板'),
              ],
            ),
          ],
        ),
      );
    });
  });

  group('管理空間', () {
    const bedroomType = TemplateRoom(
      key: 'bedroom',
      name: '臥室',
      items: [
        TemplateItem(key: 'wall', name: '牆面'),
        TemplateItem(key: 'floor', name: '地板'),
      ],
    );

    LayoutRoom room(String key, String typeKey, String name) {
      return LayoutRoom(
        key: key,
        typeKey: typeKey,
        name: name,
        items: const [LayoutItem(key: 'wall', name: '牆面')],
      );
    }

    Layout layoutOf(List<LayoutRoom> rooms) {
      return Layout(
        templateId: 'default-residence',
        templateVersion: 1,
        rooms: rooms,
      );
    }

    List<String> names(Layout layout) => [for (final r in layout.rooms) r.name];

    group('addRoom', () {
      test('沒有同類空間時用類型名稱，排在最後；項目照範本，key 用傳入的', () {
        final layout = layoutOf([
          room('living_room', 'living_room', '客廳'),
          room('bathroom', 'bathroom', '浴室'),
        ]);

        final added = layout.addRoom(bedroomType, key: 'new-key');

        expect(names(added), ['客廳', '浴室', '臥室']);
        expect(
          added.rooms.last,
          const LayoutRoom(
            key: 'new-key',
            typeKey: 'bedroom',
            name: '臥室',
            items: [
              LayoutItem(key: 'wall', name: '牆面'),
              LayoutItem(key: 'floor', name: '地板'),
            ],
          ),
        );
        expect(names(layout), ['客廳', '浴室'], reason: '原本的配置不變');
      });

      test('只有「臥室」時，新增的是「臥室 2」', () {
        final layout = layoutOf([
          room('bedroom', 'bedroom', '臥室'),
          room('balcony', 'balcony', '陽台'),
        ]);

        final added = layout.addRoom(bedroomType, key: 'new-key');

        expect(names(added), ['臥室', '臥室 2', '陽台']);
      });

      test('排在同類空間的最後一間後面，名稱是最大的編號加 1', () {
        final layout = layoutOf([
          room('bedroom', 'bedroom', '臥室'),
          room('bathroom', 'bathroom', '浴室'),
          room('b3', 'bedroom', '臥室 3'),
          room('balcony', 'balcony', '陽台'),
        ]);

        final added = layout.addRoom(bedroomType, key: 'new-key');

        expect(names(added), ['臥室', '浴室', '臥室 3', '臥室 4', '陽台']);
      });

      test('編號用數字大小比較；名稱格式不符的不算，其他類型名稱的編號也不算', () {
        final layout = layoutOf([
          room('b10', 'bedroom', '臥室 10'),
          room('b9', 'bedroom', '臥室 9'),
          room('master', 'bedroom', '主臥室'),
          room('master-20', 'bedroom', '主臥室 20'),
          room('b-x', 'bedroom', '臥室 12 號'),
          room('living_room', 'living_room', '客廳 30'),
        ]);

        final added = layout.addRoom(bedroomType, key: 'new-key');

        expect(
          added.rooms.singleWhere((r) => r.key == 'new-key').name,
          '臥室 11',
        );
      });

      test('同類空間都改過名時，用類型名稱', () {
        final layout = layoutOf([room('bedroom', 'bedroom', '主臥室')]);

        final added = layout.addRoom(bedroomType, key: 'new-key');

        expect(names(added), ['主臥室', '臥室']);
      });
    });

    group('copyRoom', () {
      test('複製原本空間的項目，名稱依類型編號，排在同類的最後一間後面；原本的空間不變', () {
        const source = LayoutRoom(
          key: 'bedroom',
          typeKey: 'bedroom',
          name: '主臥室',
          items: [LayoutItem(key: 'wardrobe', name: '衣櫥')],
        );
        final layout = layoutOf([
          source,
          room('b2', 'bedroom', '臥室 2'),
          room('balcony', 'balcony', '陽台'),
        ]);

        final copied = layout.copyRoom(
          'bedroom',
          key: 'new-key',
          typeName: '臥室',
        );

        expect(names(copied), ['主臥室', '臥室 2', '臥室 3', '陽台']);
        expect(
          copied.rooms[2],
          const LayoutRoom(
            key: 'new-key',
            typeKey: 'bedroom',
            name: '臥室 3',
            items: [LayoutItem(key: 'wardrobe', name: '衣櫥')],
          ),
        );
        expect(copied.rooms.first, source);
      });

      test('空間不存在時丟出 StateError', () {
        final layout = layoutOf([room('bedroom', 'bedroom', '臥室')]);

        expect(
          () => layout.copyRoom('nope', key: 'new-key', typeName: '臥室'),
          throwsStateError,
        );
      });
    });

    group('改名稱', () {
      final layout = layoutOf([
        room('bedroom', 'bedroom', '臥室'),
        room('b2', 'bedroom', '臥室 2'),
      ]);

      test('去掉前後空白後改名，其他空間不變', () {
        final renamed = layout.renameRoom('b2', '  次臥室 ');

        expect(names(renamed), ['臥室', '次臥室']);
        expect(renamed.rooms[1].key, 'b2');
      });

      test('改成自己原本的名稱可以', () {
        expect(layout.roomNameError('b2', '臥室 2'), isNull);
        expect(names(layout.renameRoom('b2', '臥室 2 ')), ['臥室', '臥室 2']);
      });

      test('空白或跟其他空間同名時不行，原因寫清楚；renameRoom 丟出 ArgumentError', () {
        expect(layout.roomNameError('b2', '  '), '請輸入名稱');
        expect(layout.roomNameError('b2', ' 臥室 '), '已經有叫「臥室」的空間');

        expect(() => layout.renameRoom('b2', ''), throwsArgumentError);
        expect(() => layout.renameRoom('b2', '臥室'), throwsArgumentError);
      });

      test('空間不存在時丟出 StateError', () {
        expect(() => layout.renameRoom('nope', '書房'), throwsStateError);
      });
    });

    group('removeRoom', () {
      test('拿掉這個空間，其他空間順序不變', () {
        final layout = layoutOf([
          room('living_room', 'living_room', '客廳'),
          room('bedroom', 'bedroom', '臥室'),
          room('b2', 'bedroom', '臥室 2'),
        ]);

        expect(names(layout.removeRoom('bedroom')), ['客廳', '臥室 2']);
      });

      test('只剩一個空間時丟出 StateError', () {
        final layout = layoutOf([room('bedroom', 'bedroom', '臥室')]);

        expect(() => layout.removeRoom('bedroom'), throwsStateError);
      });

      test('空間不存在時丟出 StateError', () {
        final layout = layoutOf([
          room('bedroom', 'bedroom', '臥室'),
          room('b2', 'bedroom', '臥室 2'),
        ]);

        expect(() => layout.removeRoom('nope'), throwsStateError);
      });
    });
  });

  group('Layout JSON', () {
    // architecture.md「範本與空間配置」裡的範例。
    const documentedJson = '''
{
  "templateId": "default-residence",
  "templateVersion": 1,
  "rooms": [
    {
      "key": "bedroom",
      "typeKey": "bedroom",
      "name": "臥室",
      "items": [{ "key": "wall", "name": "牆面" }]
    },
    {
      "key": "0b7e4c2a-5d1f-4e8b-9a63-2f1c8d7e6b54",
      "typeKey": "bedroom",
      "name": "臥室 2",
      "items": [{ "key": "wall", "name": "牆面" }]
    }
  ]
}
''';

    test('讀得懂 architecture.md 的格式', () {
      final layout = Layout.fromJson(
        jsonDecode(documentedJson) as Map<String, Object?>,
      );

      expect(layout.templateId, 'default-residence');
      expect(layout.templateVersion, 1);
      expect(layout.rooms.map((r) => r.name), ['臥室', '臥室 2']);
      expect(layout.rooms[1].key, '0b7e4c2a-5d1f-4e8b-9a63-2f1c8d7e6b54');
      expect(layout.rooms[1].typeKey, 'bedroom');
      expect(
        layout.rooms[1].items.single,
        const LayoutItem(key: 'wall', name: '牆面'),
      );
    });

    test('輸出的 JSON 和 architecture.md 的格式一致', () {
      final decoded = jsonDecode(documentedJson) as Map<String, Object?>;

      final roundTripped = jsonDecode(
        jsonEncode(Layout.fromJson(decoded).toJson()),
      );

      expect(roundTripped, decoded);
    });

    test('轉成 JSON 字串再轉回來，內容不變', () {
      final layout = Layout.fromTemplate(template);

      final restored = Layout.fromJson(
        jsonDecode(jsonEncode(layout.toJson())) as Map<String, Object?>,
      );

      expect(restored, layout);
    });
  });
}
