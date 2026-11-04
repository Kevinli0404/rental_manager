import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/core/database/database.dart';

import 'generated/schema.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  // 從空的資料庫開始，讓 App 依目前的資料表定義建表，再和匯出的 v1 快照比對。
  // 改了資料表卻沒有升 schemaVersion、沒有重新匯出快照時，這個測試會失敗。
  test('新安裝時建出的資料表結構和 drift_schemas 的 v1 快照一致', () async {
    final db = AppDatabase(NativeDatabase.memory());

    await verifier.migrateAndValidate(db, 1);

    await db.close();
  });
}
