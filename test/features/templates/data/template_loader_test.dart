import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/features/templates/data/template_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('內建範本', () {
    test('能從 assets 載入一般住宅範本', () async {
      final template = await loadDefaultTemplate();

      expect(template.id, 'default-residence');
      expect(template.name, '一般住宅');
      expect(template.version, 2);
      expect(template.rooms.map((r) => r.name), [
        '玄關',
        '客廳',
        '廚房',
        '浴室',
        '臥室',
        '陽台',
      ]);
    });

    test('每類空間只列 1～2 個項目，共 10 個（D-023）', () async {
      final template = await loadDefaultTemplate();

      expect(
        {
          for (final room in template.rooms)
            room.name: [for (final item in room.items) item.name],
        },
        {
          '玄關': ['大門', '門鎖'],
          '客廳': ['牆面', '冷氣'],
          '廚房': ['流理台', '瓦斯爐'],
          '浴室': ['馬桶', '水龍頭'],
          '臥室': ['牆面'],
          '陽台': ['欄杆'],
        },
      );
    });

    test('空間 key 不重複，每個空間的項目 key 不重複', () async {
      final template = await loadDefaultTemplate();

      final roomKeys = template.rooms.map((r) => r.key).toList();
      expect(roomKeys.toSet(), hasLength(roomKeys.length));

      for (final room in template.rooms) {
        final itemKeys = room.items.map((i) => i.key).toList();
        expect(
          itemKeys.toSet(),
          hasLength(itemKeys.length),
          reason: '${room.name} 有重複的項目 key',
        );
      }
    });

    test('每個空間都有項目，key 和名稱都不是空字串', () async {
      final template = await loadDefaultTemplate();

      for (final room in template.rooms) {
        expect(room.key, isNotEmpty);
        expect(room.name, isNotEmpty);
        expect(room.items, isNotEmpty, reason: '${room.name} 沒有項目');
        for (final item in room.items) {
          expect(item.key, isNotEmpty, reason: '${room.name} 有項目沒有 key');
          expect(item.name, isNotEmpty, reason: '${room.name} 有項目沒有名稱');
        }
      }
    });
  });
}
