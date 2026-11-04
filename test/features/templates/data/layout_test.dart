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
