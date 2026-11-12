// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspections_dao.dart';

// ignore_for_file: type=lint
mixin _$InspectionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PropertiesTable get properties => attachedDatabase.properties;
  $InspectionsTable get inspections => attachedDatabase.inspections;
  $ItemResultsTable get itemResults => attachedDatabase.itemResults;
  $PhotosTable get photos => attachedDatabase.photos;
  InspectionsDaoManager get managers => InspectionsDaoManager(this);
}

class InspectionsDaoManager {
  final _$InspectionsDaoMixin _db;
  InspectionsDaoManager(this._db);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db.attachedDatabase, _db.inspections);
  $$ItemResultsTableTableManager get itemResults =>
      $$ItemResultsTableTableManager(_db.attachedDatabase, _db.itemResults);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db.attachedDatabase, _db.photos);
}
