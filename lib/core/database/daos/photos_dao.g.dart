// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_dao.dart';

// ignore_for_file: type=lint
mixin _$PhotosDaoMixin on DatabaseAccessor<AppDatabase> {
  $PropertiesTable get properties => attachedDatabase.properties;
  $InspectionsTable get inspections => attachedDatabase.inspections;
  $PhotosTable get photos => attachedDatabase.photos;
  PhotosDaoManager get managers => PhotosDaoManager(this);
}

class PhotosDaoManager {
  final _$PhotosDaoMixin _db;
  PhotosDaoManager(this._db);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db.attachedDatabase, _db.inspections);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db.attachedDatabase, _db.photos);
}
