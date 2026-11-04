import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';
import 'package:rental_manager/features/templates/data/layout.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 11, 4, 3, 20, 5, 123);

  const layout = Layout(
    templateId: 'default-residence',
    templateVersion: 1,
    rooms: [
      LayoutRoom(
        key: 'bedroom',
        typeKey: 'bedroom',
        name: '臥室',
        items: [LayoutItem(key: 'wall', name: '牆面')],
      ),
    ],
  );

  Future<void> insertProperty(String id) => db
      .into(db.properties)
      .insert(
        PropertiesCompanion.insert(
          id: id,
          createdAt: now,
          updatedAt: now,
          name: '測試物件',
        ),
      );

  Future<void> insertInspection(String id, {required String propertyId}) => db
      .into(db.inspections)
      .insert(
        InspectionsCompanion.insert(
          id: id,
          createdAt: now,
          updatedAt: now,
          propertyId: propertyId,
          type: InspectionType.moveIn,
          status: InspectionStatus.draft,
          inspectedOn: '2026-11-04',
          layout: layout,
        ),
      );

  Future<void> insertItemResult(String id, {required String inspectionId}) => db
      .into(db.itemResults)
      .insert(
        ItemResultsCompanion.insert(
          id: id,
          createdAt: now,
          updatedAt: now,
          inspectionId: inspectionId,
          roomKey: 'bedroom',
          itemKey: 'wall',
        ),
      );

  Future<void> insertSignature(String id, {required String inspectionId}) => db
      .into(db.signatures)
      .insert(
        SignaturesCompanion.insert(
          id: id,
          createdAt: now,
          updatedAt: now,
          inspectionId: inspectionId,
          role: SignatureRole.landlord,
          relativePath: 'signatures/$inspectionId/landlord.png',
          signedAt: now,
        ),
      );

  Matcher throwsConstraint(String message) => throwsA(
    isA<Exception>().having((e) => e.toString(), 'message', contains(message)),
  );

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('欄位存放格式', () {
    test('空間配置存成 JSON 字串，讀回來內容不變', () async {
      await insertProperty('p1');
      await insertInspection('i1', propertyId: 'p1');

      final saved = await db.select(db.inspections).getSingle();
      expect(saved.layout, layout);

      final raw = await db
          .customSelect('SELECT layout_json FROM inspections')
          .getSingle();
      expect(
        raw.read<String>('layout_json'),
        startsWith('{"templateId":"default-residence"'),
      );
    });

    test('enum 存成名稱文字（D-008）', () async {
      await insertProperty('p1');
      await insertInspection('i1', propertyId: 'p1');

      final raw = await db
          .customSelect('SELECT type, status FROM inspections')
          .getSingle();

      expect(raw.read<String>('type'), 'moveIn');
      expect(raw.read<String>('status'), 'draft');
    });

    test('時間存成 ISO-8601 文字，保留 UTC 和毫秒', () async {
      await insertProperty('p1');

      final raw = await db
          .customSelect('SELECT created_at FROM properties')
          .getSingle();
      expect(raw.read<String>('created_at'), '2026-11-04T03:20:05.123Z');

      final saved = await db.select(db.properties).getSingle();
      expect(saved.createdAt, now);
      expect(saved.createdAt.isUtc, isTrue);
    });

    test('地址、備註沒填時是空字串', () async {
      await insertProperty('p1');

      final saved = await db.select(db.properties).getSingle();

      expect(saved.address, '');
      expect(saved.note, '');
    });
  });

  group('限制', () {
    test('點交紀錄對應的物件必須存在', () async {
      expect(
        insertInspection('i1', propertyId: 'missing'),
        throwsConstraint('FOREIGN KEY constraint failed'),
      );
    });

    test('同一筆點交的同一個項目只能有一筆結果', () async {
      await insertProperty('p1');
      await insertInspection('i1', propertyId: 'p1');
      await insertItemResult('r1', inspectionId: 'i1');

      expect(
        insertItemResult('r2', inspectionId: 'i1'),
        throwsConstraint('UNIQUE constraint failed'),
      );
    });

    test('不同點交的同一個項目可以各有一筆結果', () async {
      await insertProperty('p1');
      await insertInspection('i1', propertyId: 'p1');
      await insertInspection('i2', propertyId: 'p1');

      await insertItemResult('r1', inspectionId: 'i1');
      await insertItemResult('r2', inspectionId: 'i2');

      expect(await db.select(db.itemResults).get(), hasLength(2));
    });

    test('同一筆點交的同一個角色只能有一個簽名', () async {
      await insertProperty('p1');
      await insertInspection('i1', propertyId: 'p1');
      await insertSignature('s1', inspectionId: 'i1');

      expect(
        insertSignature('s2', inspectionId: 'i1'),
        throwsConstraint('UNIQUE constraint failed'),
      );
    });
  });
}
