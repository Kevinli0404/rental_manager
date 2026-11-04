import 'package:drift/drift.dart';

import '../../features/templates/data/layout.dart';
import 'tables/inspections.dart';
import 'tables/item_results.dart';
import 'tables/photos.dart';
import 'tables/properties.dart';
import 'tables/signatures.dart';

export 'tables/inspections.dart' show InspectionStatus, InspectionType;
export 'tables/item_results.dart' show ItemCondition;
export 'tables/signatures.dart' show SignatureRole;

part 'database.g.dart';

@DriftDatabase(
  tables: [Properties, Inspections, ItemResults, Photos, Signatures],
)
class AppDatabase extends _$AppDatabase {
  /// 連線由呼叫端決定：App 用裝置上的檔案，測試用記憶體資料庫。
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // SQLite 預設不檢查外鍵，每次開啟連線都要打開。
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
