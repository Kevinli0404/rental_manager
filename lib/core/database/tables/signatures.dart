import 'package:drift/drift.dart';

import 'inspections.dart';
import 'sync_columns.dart';

enum SignatureRole { landlord, tenant }

/// 房東、房客的簽名。圖檔存在 Documents 目錄，這裡只記相對路徑（D-005）。
class Signatures extends Table with SyncColumns {
  TextColumn get inspectionId => text().references(Inspections, #id)();
  TextColumn get role => textEnum<SignatureRole>()();
  TextColumn get relativePath => text()();
  DateTimeColumn get signedAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {inspectionId, role},
  ];
}
