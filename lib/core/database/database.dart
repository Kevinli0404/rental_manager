import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../features/templates/data/layout.dart';
import 'daos/inspections_dao.dart';
import 'daos/item_results_dao.dart';
import 'daos/photos_dao.dart';
import 'daos/properties_dao.dart';
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
  daos: [PropertiesDao, InspectionsDao, ItemResultsDao, PhotosDao],
)
class AppDatabase extends _$AppDatabase {
  /// 連線由呼叫端決定：App 用裝置上的檔案，測試用記憶體資料庫。
  ///
  /// [clock] 預設是 [DateTime.now]；測試可以換成固定時間，驗證 `updatedAt`。
  AppDatabase(super.executor, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  static const _uuid = Uuid();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // SQLite 預設不檢查外鍵，每次開啟連線都要打開。
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// 目前時間（UTC），寫入 `createdAt`、`updatedAt` 時使用。
  DateTime nowUtc() => _clock().toUtc();

  /// 新資料列的主鍵（UUID v4，D-003）。
  String newId() => _uuid.v4();
}
