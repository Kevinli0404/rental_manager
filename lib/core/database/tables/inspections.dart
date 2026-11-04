import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../features/templates/data/layout.dart';
import 'properties.dart';
import 'sync_columns.dart';

enum InspectionType { moveIn, moveOut }

enum InspectionStatus { draft, signed }

/// 點交紀錄：某個物件某一次入住或退租的檢查。
class Inspections extends Table with SyncColumns {
  TextColumn get propertyId => text().references(Properties, #id)();
  TextColumn get type => textEnum<InspectionType>()();
  TextColumn get status => textEnum<InspectionStatus>()();

  /// 點交日期，`YYYY-MM-DD`，不做時區轉換。
  TextColumn get inspectedOn => text()();

  // 房客姓名可以先空著（product.md 轉跳規則 2），存空字串。
  TextColumn get landlordName => text().withDefault(const Constant(''))();
  TextColumn get tenantName => text().withDefault(const Constant(''))();

  /// 空間配置快照（D-004）。資料庫裡是 JSON 字串，程式裡是 [Layout]。
  TextColumn get layout =>
      text().named('layout_json').map(const LayoutConverter())();

  /// 退租對照的入住紀錄；沒有對照為 null。
  TextColumn get baseInspectionId =>
      text().nullable().references(Inspections, #id)();

  DateTimeColumn get signedAt => dateTime().nullable()();
}

/// [Layout] 和 JSON 字串互轉。
class LayoutConverter extends TypeConverter<Layout, String> {
  const LayoutConverter();

  @override
  Layout fromSql(String fromDb) =>
      Layout.fromJson(jsonDecode(fromDb) as Map<String, Object?>);

  @override
  String toSql(Layout value) => jsonEncode(value.toJson());
}
