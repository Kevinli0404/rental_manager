// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_results_dao.dart';

// ignore_for_file: type=lint
mixin _$ItemResultsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PropertiesTable get properties => attachedDatabase.properties;
  $InspectionsTable get inspections => attachedDatabase.inspections;
  $ItemResultsTable get itemResults => attachedDatabase.itemResults;
  ItemResultsDaoManager get managers => ItemResultsDaoManager(this);
}

class ItemResultsDaoManager {
  final _$ItemResultsDaoMixin _db;
  ItemResultsDaoManager(this._db);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db.attachedDatabase, _db.inspections);
  $$ItemResultsTableTableManager get itemResults =>
      $$ItemResultsTableTableManager(_db.attachedDatabase, _db.itemResults);
}
