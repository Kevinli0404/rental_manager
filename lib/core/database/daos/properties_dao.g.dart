// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'properties_dao.dart';

// ignore_for_file: type=lint
mixin _$PropertiesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PropertiesTable get properties => attachedDatabase.properties;
  PropertiesDaoManager get managers => PropertiesDaoManager(this);
}

class PropertiesDaoManager {
  final _$PropertiesDaoMixin _db;
  PropertiesDaoManager(this._db);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
}
