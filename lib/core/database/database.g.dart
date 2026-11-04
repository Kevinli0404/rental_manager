// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PropertiesTable extends Properties
    with TableInfo<$PropertiesTable, Property> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    address,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Property> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Property map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Property(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $PropertiesTable createAlias(String alias) {
    return $PropertiesTable(attachedDatabase, alias);
  }
}

class Property extends DataClass implements Insertable<Property> {
  /// UUID 字串。
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String address;
  final String note;
  const Property({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.address,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['note'] = Variable<String>(note);
    return map;
  }

  PropertiesCompanion toCompanion(bool nullToAbsent) {
    return PropertiesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      address: Value(address),
      note: Value(note),
    );
  }

  factory Property.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Property(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'note': serializer.toJson<String>(note),
    };
  }

  Property copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? address,
    String? note,
  }) => Property(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    address: address ?? this.address,
    note: note ?? this.note,
  );
  Property copyWithCompanion(PropertiesCompanion data) {
    return Property(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Property(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, name, address, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Property &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.address == this.address &&
          other.note == this.note);
}

class PropertiesCompanion extends UpdateCompanion<Property> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> address;
  final Value<String> note;
  final Value<int> rowid;
  const PropertiesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertiesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Property> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertiesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? address,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return PropertiesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      address: address ?? this.address,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, Inspection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES properties (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<InspectionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InspectionType>($InspectionsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<InspectionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InspectionStatus>($InspectionsTable.$converterstatus);
  static const VerificationMeta _inspectedOnMeta = const VerificationMeta(
    'inspectedOn',
  );
  @override
  late final GeneratedColumn<String> inspectedOn = GeneratedColumn<String>(
    'inspected_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _landlordNameMeta = const VerificationMeta(
    'landlordName',
  );
  @override
  late final GeneratedColumn<String> landlordName = GeneratedColumn<String>(
    'landlord_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tenantNameMeta = const VerificationMeta(
    'tenantName',
  );
  @override
  late final GeneratedColumn<String> tenantName = GeneratedColumn<String>(
    'tenant_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Layout, String> layout =
      GeneratedColumn<String>(
        'layout_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Layout>($InspectionsTable.$converterlayout);
  static const VerificationMeta _baseInspectionIdMeta = const VerificationMeta(
    'baseInspectionId',
  );
  @override
  late final GeneratedColumn<String> baseInspectionId = GeneratedColumn<String>(
    'base_inspection_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id)',
    ),
  );
  static const VerificationMeta _signedAtMeta = const VerificationMeta(
    'signedAt',
  );
  @override
  late final GeneratedColumn<DateTime> signedAt = GeneratedColumn<DateTime>(
    'signed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    propertyId,
    type,
    status,
    inspectedOn,
    landlordName,
    tenantName,
    layout,
    baseInspectionId,
    signedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Inspection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('inspected_on')) {
      context.handle(
        _inspectedOnMeta,
        inspectedOn.isAcceptableOrUnknown(
          data['inspected_on']!,
          _inspectedOnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectedOnMeta);
    }
    if (data.containsKey('landlord_name')) {
      context.handle(
        _landlordNameMeta,
        landlordName.isAcceptableOrUnknown(
          data['landlord_name']!,
          _landlordNameMeta,
        ),
      );
    }
    if (data.containsKey('tenant_name')) {
      context.handle(
        _tenantNameMeta,
        tenantName.isAcceptableOrUnknown(data['tenant_name']!, _tenantNameMeta),
      );
    }
    if (data.containsKey('base_inspection_id')) {
      context.handle(
        _baseInspectionIdMeta,
        baseInspectionId.isAcceptableOrUnknown(
          data['base_inspection_id']!,
          _baseInspectionIdMeta,
        ),
      );
    }
    if (data.containsKey('signed_at')) {
      context.handle(
        _signedAtMeta,
        signedAt.isAcceptableOrUnknown(data['signed_at']!, _signedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inspection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      propertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_id'],
      )!,
      type: $InspectionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      status: $InspectionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      inspectedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspected_on'],
      )!,
      landlordName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}landlord_name'],
      )!,
      tenantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_name'],
      )!,
      layout: $InspectionsTable.$converterlayout.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}layout_json'],
        )!,
      ),
      baseInspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_inspection_id'],
      ),
      signedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}signed_at'],
      ),
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InspectionType, String, String> $convertertype =
      const EnumNameConverter<InspectionType>(InspectionType.values);
  static JsonTypeConverter2<InspectionStatus, String, String> $converterstatus =
      const EnumNameConverter<InspectionStatus>(InspectionStatus.values);
  static TypeConverter<Layout, String> $converterlayout =
      const LayoutConverter();
}

class Inspection extends DataClass implements Insertable<Inspection> {
  /// UUID 字串。
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String propertyId;
  final InspectionType type;
  final InspectionStatus status;

  /// 點交日期，`YYYY-MM-DD`，不做時區轉換。
  final String inspectedOn;
  final String landlordName;
  final String tenantName;

  /// 空間配置快照（D-004）。資料庫裡是 JSON 字串，程式裡是 [Layout]。
  final Layout layout;

  /// 退租對照的入住紀錄；沒有對照為 null。
  final String? baseInspectionId;
  final DateTime? signedAt;
  const Inspection({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.propertyId,
    required this.type,
    required this.status,
    required this.inspectedOn,
    required this.landlordName,
    required this.tenantName,
    required this.layout,
    this.baseInspectionId,
    this.signedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['property_id'] = Variable<String>(propertyId);
    {
      map['type'] = Variable<String>(
        $InspectionsTable.$convertertype.toSql(type),
      );
    }
    {
      map['status'] = Variable<String>(
        $InspectionsTable.$converterstatus.toSql(status),
      );
    }
    map['inspected_on'] = Variable<String>(inspectedOn);
    map['landlord_name'] = Variable<String>(landlordName);
    map['tenant_name'] = Variable<String>(tenantName);
    {
      map['layout_json'] = Variable<String>(
        $InspectionsTable.$converterlayout.toSql(layout),
      );
    }
    if (!nullToAbsent || baseInspectionId != null) {
      map['base_inspection_id'] = Variable<String>(baseInspectionId);
    }
    if (!nullToAbsent || signedAt != null) {
      map['signed_at'] = Variable<DateTime>(signedAt);
    }
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      propertyId: Value(propertyId),
      type: Value(type),
      status: Value(status),
      inspectedOn: Value(inspectedOn),
      landlordName: Value(landlordName),
      tenantName: Value(tenantName),
      layout: Value(layout),
      baseInspectionId: baseInspectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(baseInspectionId),
      signedAt: signedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(signedAt),
    );
  }

  factory Inspection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inspection(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      propertyId: serializer.fromJson<String>(json['propertyId']),
      type: $InspectionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      status: $InspectionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      inspectedOn: serializer.fromJson<String>(json['inspectedOn']),
      landlordName: serializer.fromJson<String>(json['landlordName']),
      tenantName: serializer.fromJson<String>(json['tenantName']),
      layout: serializer.fromJson<Layout>(json['layout']),
      baseInspectionId: serializer.fromJson<String?>(json['baseInspectionId']),
      signedAt: serializer.fromJson<DateTime?>(json['signedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'propertyId': serializer.toJson<String>(propertyId),
      'type': serializer.toJson<String>(
        $InspectionsTable.$convertertype.toJson(type),
      ),
      'status': serializer.toJson<String>(
        $InspectionsTable.$converterstatus.toJson(status),
      ),
      'inspectedOn': serializer.toJson<String>(inspectedOn),
      'landlordName': serializer.toJson<String>(landlordName),
      'tenantName': serializer.toJson<String>(tenantName),
      'layout': serializer.toJson<Layout>(layout),
      'baseInspectionId': serializer.toJson<String?>(baseInspectionId),
      'signedAt': serializer.toJson<DateTime?>(signedAt),
    };
  }

  Inspection copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? propertyId,
    InspectionType? type,
    InspectionStatus? status,
    String? inspectedOn,
    String? landlordName,
    String? tenantName,
    Layout? layout,
    Value<String?> baseInspectionId = const Value.absent(),
    Value<DateTime?> signedAt = const Value.absent(),
  }) => Inspection(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    propertyId: propertyId ?? this.propertyId,
    type: type ?? this.type,
    status: status ?? this.status,
    inspectedOn: inspectedOn ?? this.inspectedOn,
    landlordName: landlordName ?? this.landlordName,
    tenantName: tenantName ?? this.tenantName,
    layout: layout ?? this.layout,
    baseInspectionId: baseInspectionId.present
        ? baseInspectionId.value
        : this.baseInspectionId,
    signedAt: signedAt.present ? signedAt.value : this.signedAt,
  );
  Inspection copyWithCompanion(InspectionsCompanion data) {
    return Inspection(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      propertyId: data.propertyId.present
          ? data.propertyId.value
          : this.propertyId,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      inspectedOn: data.inspectedOn.present
          ? data.inspectedOn.value
          : this.inspectedOn,
      landlordName: data.landlordName.present
          ? data.landlordName.value
          : this.landlordName,
      tenantName: data.tenantName.present
          ? data.tenantName.value
          : this.tenantName,
      layout: data.layout.present ? data.layout.value : this.layout,
      baseInspectionId: data.baseInspectionId.present
          ? data.baseInspectionId.value
          : this.baseInspectionId,
      signedAt: data.signedAt.present ? data.signedAt.value : this.signedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inspection(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('propertyId: $propertyId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('inspectedOn: $inspectedOn, ')
          ..write('landlordName: $landlordName, ')
          ..write('tenantName: $tenantName, ')
          ..write('layout: $layout, ')
          ..write('baseInspectionId: $baseInspectionId, ')
          ..write('signedAt: $signedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    propertyId,
    type,
    status,
    inspectedOn,
    landlordName,
    tenantName,
    layout,
    baseInspectionId,
    signedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inspection &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.propertyId == this.propertyId &&
          other.type == this.type &&
          other.status == this.status &&
          other.inspectedOn == this.inspectedOn &&
          other.landlordName == this.landlordName &&
          other.tenantName == this.tenantName &&
          other.layout == this.layout &&
          other.baseInspectionId == this.baseInspectionId &&
          other.signedAt == this.signedAt);
}

class InspectionsCompanion extends UpdateCompanion<Inspection> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> propertyId;
  final Value<InspectionType> type;
  final Value<InspectionStatus> status;
  final Value<String> inspectedOn;
  final Value<String> landlordName;
  final Value<String> tenantName;
  final Value<Layout> layout;
  final Value<String?> baseInspectionId;
  final Value<DateTime?> signedAt;
  final Value<int> rowid;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.inspectedOn = const Value.absent(),
    this.landlordName = const Value.absent(),
    this.tenantName = const Value.absent(),
    this.layout = const Value.absent(),
    this.baseInspectionId = const Value.absent(),
    this.signedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String propertyId,
    required InspectionType type,
    required InspectionStatus status,
    required String inspectedOn,
    this.landlordName = const Value.absent(),
    this.tenantName = const Value.absent(),
    required Layout layout,
    this.baseInspectionId = const Value.absent(),
    this.signedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       propertyId = Value(propertyId),
       type = Value(type),
       status = Value(status),
       inspectedOn = Value(inspectedOn),
       layout = Value(layout);
  static Insertable<Inspection> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? propertyId,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? inspectedOn,
    Expression<String>? landlordName,
    Expression<String>? tenantName,
    Expression<String>? layout,
    Expression<String>? baseInspectionId,
    Expression<DateTime>? signedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (propertyId != null) 'property_id': propertyId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (inspectedOn != null) 'inspected_on': inspectedOn,
      if (landlordName != null) 'landlord_name': landlordName,
      if (tenantName != null) 'tenant_name': tenantName,
      if (layout != null) 'layout_json': layout,
      if (baseInspectionId != null) 'base_inspection_id': baseInspectionId,
      if (signedAt != null) 'signed_at': signedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? propertyId,
    Value<InspectionType>? type,
    Value<InspectionStatus>? status,
    Value<String>? inspectedOn,
    Value<String>? landlordName,
    Value<String>? tenantName,
    Value<Layout>? layout,
    Value<String?>? baseInspectionId,
    Value<DateTime?>? signedAt,
    Value<int>? rowid,
  }) {
    return InspectionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      propertyId: propertyId ?? this.propertyId,
      type: type ?? this.type,
      status: status ?? this.status,
      inspectedOn: inspectedOn ?? this.inspectedOn,
      landlordName: landlordName ?? this.landlordName,
      tenantName: tenantName ?? this.tenantName,
      layout: layout ?? this.layout,
      baseInspectionId: baseInspectionId ?? this.baseInspectionId,
      signedAt: signedAt ?? this.signedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $InspectionsTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InspectionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (inspectedOn.present) {
      map['inspected_on'] = Variable<String>(inspectedOn.value);
    }
    if (landlordName.present) {
      map['landlord_name'] = Variable<String>(landlordName.value);
    }
    if (tenantName.present) {
      map['tenant_name'] = Variable<String>(tenantName.value);
    }
    if (layout.present) {
      map['layout_json'] = Variable<String>(
        $InspectionsTable.$converterlayout.toSql(layout.value),
      );
    }
    if (baseInspectionId.present) {
      map['base_inspection_id'] = Variable<String>(baseInspectionId.value);
    }
    if (signedAt.present) {
      map['signed_at'] = Variable<DateTime>(signedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('propertyId: $propertyId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('inspectedOn: $inspectedOn, ')
          ..write('landlordName: $landlordName, ')
          ..write('tenantName: $tenantName, ')
          ..write('layout: $layout, ')
          ..write('baseInspectionId: $baseInspectionId, ')
          ..write('signedAt: $signedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemResultsTable extends ItemResults
    with TableInfo<$ItemResultsTable, ItemResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id)',
    ),
  );
  static const VerificationMeta _roomKeyMeta = const VerificationMeta(
    'roomKey',
  );
  @override
  late final GeneratedColumn<String> roomKey = GeneratedColumn<String>(
    'room_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemKeyMeta = const VerificationMeta(
    'itemKey',
  );
  @override
  late final GeneratedColumn<String> itemKey = GeneratedColumn<String>(
    'item_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ItemCondition?, String>
  condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<ItemCondition?>($ItemResultsTable.$converterconditionn);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    inspectionId,
    roomKey,
    itemKey,
    condition,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('room_key')) {
      context.handle(
        _roomKeyMeta,
        roomKey.isAcceptableOrUnknown(data['room_key']!, _roomKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_roomKeyMeta);
    }
    if (data.containsKey('item_key')) {
      context.handle(
        _itemKeyMeta,
        itemKey.isAcceptableOrUnknown(data['item_key']!, _itemKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_itemKeyMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {inspectionId, roomKey, itemKey},
  ];
  @override
  ItemResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      roomKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_key'],
      )!,
      itemKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_key'],
      )!,
      condition: $ItemResultsTable.$converterconditionn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}condition'],
        ),
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $ItemResultsTable createAlias(String alias) {
    return $ItemResultsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemCondition, String, String> $convertercondition =
      const EnumNameConverter<ItemCondition>(ItemCondition.values);
  static JsonTypeConverter2<ItemCondition?, String?, String?>
  $converterconditionn = JsonTypeConverter2.asNullable($convertercondition);
}

class ItemResult extends DataClass implements Insertable<ItemResult> {
  /// UUID 字串。
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String inspectionId;
  final String roomKey;
  final String itemKey;

  /// 未填為 null。
  final ItemCondition? condition;
  final String note;
  const ItemResult({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.inspectionId,
    required this.roomKey,
    required this.itemKey,
    this.condition,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['inspection_id'] = Variable<String>(inspectionId);
    map['room_key'] = Variable<String>(roomKey);
    map['item_key'] = Variable<String>(itemKey);
    if (!nullToAbsent || condition != null) {
      map['condition'] = Variable<String>(
        $ItemResultsTable.$converterconditionn.toSql(condition),
      );
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  ItemResultsCompanion toCompanion(bool nullToAbsent) {
    return ItemResultsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      inspectionId: Value(inspectionId),
      roomKey: Value(roomKey),
      itemKey: Value(itemKey),
      condition: condition == null && nullToAbsent
          ? const Value.absent()
          : Value(condition),
      note: Value(note),
    );
  }

  factory ItemResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemResult(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      roomKey: serializer.fromJson<String>(json['roomKey']),
      itemKey: serializer.fromJson<String>(json['itemKey']),
      condition: $ItemResultsTable.$converterconditionn.fromJson(
        serializer.fromJson<String?>(json['condition']),
      ),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'roomKey': serializer.toJson<String>(roomKey),
      'itemKey': serializer.toJson<String>(itemKey),
      'condition': serializer.toJson<String?>(
        $ItemResultsTable.$converterconditionn.toJson(condition),
      ),
      'note': serializer.toJson<String>(note),
    };
  }

  ItemResult copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? inspectionId,
    String? roomKey,
    String? itemKey,
    Value<ItemCondition?> condition = const Value.absent(),
    String? note,
  }) => ItemResult(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    inspectionId: inspectionId ?? this.inspectionId,
    roomKey: roomKey ?? this.roomKey,
    itemKey: itemKey ?? this.itemKey,
    condition: condition.present ? condition.value : this.condition,
    note: note ?? this.note,
  );
  ItemResult copyWithCompanion(ItemResultsCompanion data) {
    return ItemResult(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      roomKey: data.roomKey.present ? data.roomKey.value : this.roomKey,
      itemKey: data.itemKey.present ? data.itemKey.value : this.itemKey,
      condition: data.condition.present ? data.condition.value : this.condition,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemResult(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('roomKey: $roomKey, ')
          ..write('itemKey: $itemKey, ')
          ..write('condition: $condition, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    inspectionId,
    roomKey,
    itemKey,
    condition,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemResult &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.inspectionId == this.inspectionId &&
          other.roomKey == this.roomKey &&
          other.itemKey == this.itemKey &&
          other.condition == this.condition &&
          other.note == this.note);
}

class ItemResultsCompanion extends UpdateCompanion<ItemResult> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> inspectionId;
  final Value<String> roomKey;
  final Value<String> itemKey;
  final Value<ItemCondition?> condition;
  final Value<String> note;
  final Value<int> rowid;
  const ItemResultsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.roomKey = const Value.absent(),
    this.itemKey = const Value.absent(),
    this.condition = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemResultsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String inspectionId,
    required String roomKey,
    required String itemKey,
    this.condition = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       inspectionId = Value(inspectionId),
       roomKey = Value(roomKey),
       itemKey = Value(itemKey);
  static Insertable<ItemResult> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? inspectionId,
    Expression<String>? roomKey,
    Expression<String>? itemKey,
    Expression<String>? condition,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (roomKey != null) 'room_key': roomKey,
      if (itemKey != null) 'item_key': itemKey,
      if (condition != null) 'condition': condition,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemResultsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? inspectionId,
    Value<String>? roomKey,
    Value<String>? itemKey,
    Value<ItemCondition?>? condition,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return ItemResultsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      inspectionId: inspectionId ?? this.inspectionId,
      roomKey: roomKey ?? this.roomKey,
      itemKey: itemKey ?? this.itemKey,
      condition: condition ?? this.condition,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (roomKey.present) {
      map['room_key'] = Variable<String>(roomKey.value);
    }
    if (itemKey.present) {
      map['item_key'] = Variable<String>(itemKey.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(
        $ItemResultsTable.$converterconditionn.toSql(condition.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemResultsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('roomKey: $roomKey, ')
          ..write('itemKey: $itemKey, ')
          ..write('condition: $condition, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id)',
    ),
  );
  static const VerificationMeta _roomKeyMeta = const VerificationMeta(
    'roomKey',
  );
  @override
  late final GeneratedColumn<String> roomKey = GeneratedColumn<String>(
    'room_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemKeyMeta = const VerificationMeta(
    'itemKey',
  );
  @override
  late final GeneratedColumn<String> itemKey = GeneratedColumn<String>(
    'item_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    inspectionId,
    roomKey,
    itemKey,
    relativePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Photo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('room_key')) {
      context.handle(
        _roomKeyMeta,
        roomKey.isAcceptableOrUnknown(data['room_key']!, _roomKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_roomKeyMeta);
    }
    if (data.containsKey('item_key')) {
      context.handle(
        _itemKeyMeta,
        itemKey.isAcceptableOrUnknown(data['item_key']!, _itemKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_itemKeyMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      roomKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_key'],
      )!,
      itemKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_key'],
      )!,
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  /// UUID 字串。
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String inspectionId;
  final String roomKey;
  final String itemKey;
  final String relativePath;
  const Photo({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.inspectionId,
    required this.roomKey,
    required this.itemKey,
    required this.relativePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['inspection_id'] = Variable<String>(inspectionId);
    map['room_key'] = Variable<String>(roomKey);
    map['item_key'] = Variable<String>(itemKey);
    map['relative_path'] = Variable<String>(relativePath);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      inspectionId: Value(inspectionId),
      roomKey: Value(roomKey),
      itemKey: Value(itemKey),
      relativePath: Value(relativePath),
    );
  }

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      roomKey: serializer.fromJson<String>(json['roomKey']),
      itemKey: serializer.fromJson<String>(json['itemKey']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'roomKey': serializer.toJson<String>(roomKey),
      'itemKey': serializer.toJson<String>(itemKey),
      'relativePath': serializer.toJson<String>(relativePath),
    };
  }

  Photo copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? inspectionId,
    String? roomKey,
    String? itemKey,
    String? relativePath,
  }) => Photo(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    inspectionId: inspectionId ?? this.inspectionId,
    roomKey: roomKey ?? this.roomKey,
    itemKey: itemKey ?? this.itemKey,
    relativePath: relativePath ?? this.relativePath,
  );
  Photo copyWithCompanion(PhotosCompanion data) {
    return Photo(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      roomKey: data.roomKey.present ? data.roomKey.value : this.roomKey,
      itemKey: data.itemKey.present ? data.itemKey.value : this.itemKey,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('roomKey: $roomKey, ')
          ..write('itemKey: $itemKey, ')
          ..write('relativePath: $relativePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    inspectionId,
    roomKey,
    itemKey,
    relativePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.inspectionId == this.inspectionId &&
          other.roomKey == this.roomKey &&
          other.itemKey == this.itemKey &&
          other.relativePath == this.relativePath);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> inspectionId;
  final Value<String> roomKey;
  final Value<String> itemKey;
  final Value<String> relativePath;
  final Value<int> rowid;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.roomKey = const Value.absent(),
    this.itemKey = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotosCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String inspectionId,
    required String roomKey,
    required String itemKey,
    required String relativePath,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       inspectionId = Value(inspectionId),
       roomKey = Value(roomKey),
       itemKey = Value(itemKey),
       relativePath = Value(relativePath);
  static Insertable<Photo> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? inspectionId,
    Expression<String>? roomKey,
    Expression<String>? itemKey,
    Expression<String>? relativePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (roomKey != null) 'room_key': roomKey,
      if (itemKey != null) 'item_key': itemKey,
      if (relativePath != null) 'relative_path': relativePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotosCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? inspectionId,
    Value<String>? roomKey,
    Value<String>? itemKey,
    Value<String>? relativePath,
    Value<int>? rowid,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      inspectionId: inspectionId ?? this.inspectionId,
      roomKey: roomKey ?? this.roomKey,
      itemKey: itemKey ?? this.itemKey,
      relativePath: relativePath ?? this.relativePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (roomKey.present) {
      map['room_key'] = Variable<String>(roomKey.value);
    }
    if (itemKey.present) {
      map['item_key'] = Variable<String>(itemKey.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('roomKey: $roomKey, ')
          ..write('itemKey: $itemKey, ')
          ..write('relativePath: $relativePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SignaturesTable extends Signatures
    with TableInfo<$SignaturesTable, Signature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SignaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SignatureRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SignatureRole>($SignaturesTable.$converterrole);
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signedAtMeta = const VerificationMeta(
    'signedAt',
  );
  @override
  late final GeneratedColumn<DateTime> signedAt = GeneratedColumn<DateTime>(
    'signed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    inspectionId,
    role,
    relativePath,
    signedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'signatures';
  @override
  VerificationContext validateIntegrity(
    Insertable<Signature> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('signed_at')) {
      context.handle(
        _signedAtMeta,
        signedAt.isAcceptableOrUnknown(data['signed_at']!, _signedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_signedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {inspectionId, role},
  ];
  @override
  Signature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Signature(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      role: $SignaturesTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      signedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}signed_at'],
      )!,
    );
  }

  @override
  $SignaturesTable createAlias(String alias) {
    return $SignaturesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SignatureRole, String, String> $converterrole =
      const EnumNameConverter<SignatureRole>(SignatureRole.values);
}

class Signature extends DataClass implements Insertable<Signature> {
  /// UUID 字串。
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String inspectionId;
  final SignatureRole role;
  final String relativePath;
  final DateTime signedAt;
  const Signature({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.inspectionId,
    required this.role,
    required this.relativePath,
    required this.signedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['inspection_id'] = Variable<String>(inspectionId);
    {
      map['role'] = Variable<String>(
        $SignaturesTable.$converterrole.toSql(role),
      );
    }
    map['relative_path'] = Variable<String>(relativePath);
    map['signed_at'] = Variable<DateTime>(signedAt);
    return map;
  }

  SignaturesCompanion toCompanion(bool nullToAbsent) {
    return SignaturesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      inspectionId: Value(inspectionId),
      role: Value(role),
      relativePath: Value(relativePath),
      signedAt: Value(signedAt),
    );
  }

  factory Signature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Signature(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      role: $SignaturesTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      signedAt: serializer.fromJson<DateTime>(json['signedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'role': serializer.toJson<String>(
        $SignaturesTable.$converterrole.toJson(role),
      ),
      'relativePath': serializer.toJson<String>(relativePath),
      'signedAt': serializer.toJson<DateTime>(signedAt),
    };
  }

  Signature copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? inspectionId,
    SignatureRole? role,
    String? relativePath,
    DateTime? signedAt,
  }) => Signature(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    inspectionId: inspectionId ?? this.inspectionId,
    role: role ?? this.role,
    relativePath: relativePath ?? this.relativePath,
    signedAt: signedAt ?? this.signedAt,
  );
  Signature copyWithCompanion(SignaturesCompanion data) {
    return Signature(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      role: data.role.present ? data.role.value : this.role,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      signedAt: data.signedAt.present ? data.signedAt.value : this.signedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Signature(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('role: $role, ')
          ..write('relativePath: $relativePath, ')
          ..write('signedAt: $signedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    inspectionId,
    role,
    relativePath,
    signedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Signature &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.inspectionId == this.inspectionId &&
          other.role == this.role &&
          other.relativePath == this.relativePath &&
          other.signedAt == this.signedAt);
}

class SignaturesCompanion extends UpdateCompanion<Signature> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> inspectionId;
  final Value<SignatureRole> role;
  final Value<String> relativePath;
  final Value<DateTime> signedAt;
  final Value<int> rowid;
  const SignaturesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.role = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.signedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SignaturesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String inspectionId,
    required SignatureRole role,
    required String relativePath,
    required DateTime signedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       inspectionId = Value(inspectionId),
       role = Value(role),
       relativePath = Value(relativePath),
       signedAt = Value(signedAt);
  static Insertable<Signature> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? inspectionId,
    Expression<String>? role,
    Expression<String>? relativePath,
    Expression<DateTime>? signedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (role != null) 'role': role,
      if (relativePath != null) 'relative_path': relativePath,
      if (signedAt != null) 'signed_at': signedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SignaturesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? inspectionId,
    Value<SignatureRole>? role,
    Value<String>? relativePath,
    Value<DateTime>? signedAt,
    Value<int>? rowid,
  }) {
    return SignaturesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      inspectionId: inspectionId ?? this.inspectionId,
      role: role ?? this.role,
      relativePath: relativePath ?? this.relativePath,
      signedAt: signedAt ?? this.signedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $SignaturesTable.$converterrole.toSql(role.value),
      );
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (signedAt.present) {
      map['signed_at'] = Variable<DateTime>(signedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SignaturesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('role: $role, ')
          ..write('relativePath: $relativePath, ')
          ..write('signedAt: $signedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PropertiesTable properties = $PropertiesTable(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  late final $ItemResultsTable itemResults = $ItemResultsTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $SignaturesTable signatures = $SignaturesTable(this);
  late final PropertiesDao propertiesDao = PropertiesDao(this as AppDatabase);
  late final InspectionsDao inspectionsDao = InspectionsDao(
    this as AppDatabase,
  );
  late final ItemResultsDao itemResultsDao = ItemResultsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    properties,
    inspections,
    itemResults,
    photos,
    signatures,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$PropertiesTableCreateCompanionBuilder = PropertiesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  required String name,
  Value<String> address,
  Value<String> note,
  Value<int> rowid,
});
typedef $$PropertiesTableUpdateCompanionBuilder = PropertiesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> name,
  Value<String> address,
  Value<String> note,
  Value<int> rowid,
});

final class $$PropertiesTableReferences
    extends BaseReferences<_$AppDatabase, $PropertiesTable, Property> {
  $$PropertiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InspectionsTable, List<Inspection>>
  _inspectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inspections,
    aliasName: 'properties__id__inspections__property_id',
  );

  $$InspectionsTableProcessedTableManager get inspectionsRefs {
    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.propertyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inspectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PropertiesTableFilterComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inspectionsRefs(
    Expression<bool> Function($$InspectionsTableFilterComposer f) f,
  ) {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  Expression<T> inspectionsRefs<T extends Object>(
    Expression<T> Function($$InspectionsTableAnnotationComposer a) f,
  ) {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertiesTable,
          Property,
          $$PropertiesTableFilterComposer,
          $$PropertiesTableOrderingComposer,
          $$PropertiesTableAnnotationComposer,
          $$PropertiesTableCreateCompanionBuilder,
          $$PropertiesTableUpdateCompanionBuilder,
          (Property, $$PropertiesTableReferences),
          Property,
          PrefetchHooks Function({bool inspectionsRefs})
        > {
  $$PropertiesTableTableManager(_$AppDatabase db, $PropertiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                address: address,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String> address = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                address: address,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PropertiesTable, Property>(table),
                  $$PropertiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (inspectionsRefs) db.inspections],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inspectionsRefs)
                    await $_getPrefetchedDataByColumns<
                      Property,
                      $PropertiesTable,
                      Inspection,
                      $InspectionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$PropertiesTableReferences
                          ._inspectionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PropertiesTableReferences(
                            db,
                            table,
                            p0,
                          ).inspectionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'property_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PropertiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertiesTable,
      Property,
      $$PropertiesTableFilterComposer,
      $$PropertiesTableOrderingComposer,
      $$PropertiesTableAnnotationComposer,
      $$PropertiesTableCreateCompanionBuilder,
      $$PropertiesTableUpdateCompanionBuilder,
      (Property, $$PropertiesTableReferences),
      Property,
      PrefetchHooks Function({bool inspectionsRefs})
    >;
typedef $$InspectionsTableCreateCompanionBuilder =
    InspectionsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required String propertyId,
      required InspectionType type,
      required InspectionStatus status,
      required String inspectedOn,
      Value<String> landlordName,
      Value<String> tenantName,
      required Layout layout,
      Value<String?> baseInspectionId,
      Value<DateTime?> signedAt,
      Value<int> rowid,
    });
typedef $$InspectionsTableUpdateCompanionBuilder =
    InspectionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> propertyId,
      Value<InspectionType> type,
      Value<InspectionStatus> status,
      Value<String> inspectedOn,
      Value<String> landlordName,
      Value<String> tenantName,
      Value<Layout> layout,
      Value<String?> baseInspectionId,
      Value<DateTime?> signedAt,
      Value<int> rowid,
    });

final class $$InspectionsTableReferences
    extends BaseReferences<_$AppDatabase, $InspectionsTable, Inspection> {
  $$InspectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PropertiesTable _propertyIdTable(_$AppDatabase db) =>
      db.properties.createAlias('inspections__property_id__properties__id');

  $$PropertiesTableProcessedTableManager get propertyId {
    final $_column = $_itemColumn<String>('property_id')!;

    final manager = $$PropertiesTableTableManager(
      $_db,
      $_db.properties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propertyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InspectionsTable _baseInspectionIdTable(_$AppDatabase db) => db
      .inspections
      .createAlias('inspections__base_inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager? get baseInspectionId {
    final $_column = $_itemColumn<String>('base_inspection_id');
    if ($_column == null) return null;
    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseInspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemResultsTable, List<ItemResult>>
  _itemResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemResults,
    aliasName: 'inspections__id__item_results__inspection_id',
  );

  $$ItemResultsTableProcessedTableManager get itemResultsRefs {
    final manager = $$ItemResultsTableTableManager(
      $_db,
      $_db.itemResults,
    ).filter((f) => f.inspectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<Photo>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: 'inspections__id__photos__inspection_id',
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.inspectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SignaturesTable, List<Signature>>
  _signaturesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.signatures,
    aliasName: 'inspections__id__signatures__inspection_id',
  );

  $$SignaturesTableProcessedTableManager get signaturesRefs {
    final manager = $$SignaturesTableTableManager(
      $_db,
      $_db.signatures,
    ).filter((f) => f.inspectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_signaturesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InspectionType, InspectionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<InspectionStatus, InspectionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get inspectedOn => $composableBuilder(
    column: $table.inspectedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get landlordName => $composableBuilder(
    column: $table.landlordName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantName => $composableBuilder(
    column: $table.tenantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Layout, Layout, String> get layout =>
      $composableBuilder(
        column: $table.layout,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PropertiesTableFilterComposer get propertyId {
    final $$PropertiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableFilterComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableFilterComposer get baseInspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseInspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemResultsRefs(
    Expression<bool> Function($$ItemResultsTableFilterComposer f) f,
  ) {
    final $$ItemResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemResults,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemResultsTableFilterComposer(
            $db: $db,
            $table: $db.itemResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> signaturesRefs(
    Expression<bool> Function($$SignaturesTableFilterComposer f) f,
  ) {
    final $$SignaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.signatures,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SignaturesTableFilterComposer(
            $db: $db,
            $table: $db.signatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspectedOn => $composableBuilder(
    column: $table.inspectedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landlordName => $composableBuilder(
    column: $table.landlordName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantName => $composableBuilder(
    column: $table.tenantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layout => $composableBuilder(
    column: $table.layout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropertiesTableOrderingComposer get propertyId {
    final $$PropertiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableOrderingComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableOrderingComposer get baseInspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseInspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InspectionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InspectionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get inspectedOn => $composableBuilder(
    column: $table.inspectedOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get landlordName => $composableBuilder(
    column: $table.landlordName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tenantName => $composableBuilder(
    column: $table.tenantName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Layout, String> get layout =>
      $composableBuilder(column: $table.layout, builder: (column) => column);

  GeneratedColumn<DateTime> get signedAt =>
      $composableBuilder(column: $table.signedAt, builder: (column) => column);

  $$PropertiesTableAnnotationComposer get propertyId {
    final $$PropertiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableAnnotationComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableAnnotationComposer get baseInspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseInspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemResultsRefs<T extends Object>(
    Expression<T> Function($$ItemResultsTableAnnotationComposer a) f,
  ) {
    final $$ItemResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemResults,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> signaturesRefs<T extends Object>(
    Expression<T> Function($$SignaturesTableAnnotationComposer a) f,
  ) {
    final $$SignaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.signatures,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SignaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.signatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionsTable,
          Inspection,
          $$InspectionsTableFilterComposer,
          $$InspectionsTableOrderingComposer,
          $$InspectionsTableAnnotationComposer,
          $$InspectionsTableCreateCompanionBuilder,
          $$InspectionsTableUpdateCompanionBuilder,
          (Inspection, $$InspectionsTableReferences),
          Inspection,
          PrefetchHooks Function({
            bool propertyId,
            bool baseInspectionId,
            bool itemResultsRefs,
            bool photosRefs,
            bool signaturesRefs,
          })
        > {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<InspectionType> type = const Value.absent(),
                Value<InspectionStatus> status = const Value.absent(),
                Value<String> inspectedOn = const Value.absent(),
                Value<String> landlordName = const Value.absent(),
                Value<String> tenantName = const Value.absent(),
                Value<Layout> layout = const Value.absent(),
                Value<String?> baseInspectionId = const Value.absent(),
                Value<DateTime?> signedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                propertyId: propertyId,
                type: type,
                status: status,
                inspectedOn: inspectedOn,
                landlordName: landlordName,
                tenantName: tenantName,
                layout: layout,
                baseInspectionId: baseInspectionId,
                signedAt: signedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String propertyId,
                required InspectionType type,
                required InspectionStatus status,
                required String inspectedOn,
                Value<String> landlordName = const Value.absent(),
                Value<String> tenantName = const Value.absent(),
                required Layout layout,
                Value<String?> baseInspectionId = const Value.absent(),
                Value<DateTime?> signedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                propertyId: propertyId,
                type: type,
                status: status,
                inspectedOn: inspectedOn,
                landlordName: landlordName,
                tenantName: tenantName,
                layout: layout,
                baseInspectionId: baseInspectionId,
                signedAt: signedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionsTable, Inspection>(table),
                  $$InspectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                propertyId = false,
                baseInspectionId = false,
                itemResultsRefs = false,
                photosRefs = false,
                signaturesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemResultsRefs) db.itemResults,
                    if (photosRefs) db.photos,
                    if (signaturesRefs) db.signatures,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (propertyId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.propertyId,
                            referencedTable: $$InspectionsTableReferences
                                ._propertyIdTable(db),
                            referencedColumn: $$InspectionsTableReferences
                                ._propertyIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (baseInspectionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.baseInspectionId,
                            referencedTable: $$InspectionsTableReferences
                                ._baseInspectionIdTable(db),
                            referencedColumn: $$InspectionsTableReferences
                                ._baseInspectionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemResultsRefs)
                        await $_getPrefetchedDataByColumns<
                          Inspection,
                          $InspectionsTable,
                          ItemResult,
                          $ItemResultsTable
                        >(
                          currentTable: table,
                          referencedTable: $$InspectionsTableReferences
                              ._itemResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemResultsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'inspection_id',
                          typedResults: items,
                        ),
                      if (photosRefs)
                        await $_getPrefetchedDataByColumns<
                          Inspection,
                          $InspectionsTable,
                          Photo,
                          $PhotosTable
                        >(
                          currentTable: table,
                          referencedTable: $$InspectionsTableReferences
                              ._photosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).photosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'inspection_id',
                          typedResults: items,
                        ),
                      if (signaturesRefs)
                        await $_getPrefetchedDataByColumns<
                          Inspection,
                          $InspectionsTable,
                          Signature,
                          $SignaturesTable
                        >(
                          currentTable: table,
                          referencedTable: $$InspectionsTableReferences
                              ._signaturesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).signaturesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'inspection_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InspectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionsTable,
      Inspection,
      $$InspectionsTableFilterComposer,
      $$InspectionsTableOrderingComposer,
      $$InspectionsTableAnnotationComposer,
      $$InspectionsTableCreateCompanionBuilder,
      $$InspectionsTableUpdateCompanionBuilder,
      (Inspection, $$InspectionsTableReferences),
      Inspection,
      PrefetchHooks Function({
        bool propertyId,
        bool baseInspectionId,
        bool itemResultsRefs,
        bool photosRefs,
        bool signaturesRefs,
      })
    >;
typedef $$ItemResultsTableCreateCompanionBuilder =
    ItemResultsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required String inspectionId,
      required String roomKey,
      required String itemKey,
      Value<ItemCondition?> condition,
      Value<String> note,
      Value<int> rowid,
    });
typedef $$ItemResultsTableUpdateCompanionBuilder =
    ItemResultsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> inspectionId,
      Value<String> roomKey,
      Value<String> itemKey,
      Value<ItemCondition?> condition,
      Value<String> note,
      Value<int> rowid,
    });

final class $$ItemResultsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemResultsTable, ItemResult> {
  $$ItemResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InspectionsTable _inspectionIdTable(_$AppDatabase db) => db
      .inspections
      .createAlias('item_results__inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager get inspectionId {
    final $_column = $_itemColumn<String>('inspection_id')!;

    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemResultsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemResultsTable> {
  $$ItemResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomKey => $composableBuilder(
    column: $table.roomKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemCondition?, ItemCondition, String>
  get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$InspectionsTableFilterComposer get inspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemResultsTable> {
  $$ItemResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomKey => $composableBuilder(
    column: $table.roomKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspectionsTableOrderingComposer get inspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemResultsTable> {
  $$ItemResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get roomKey =>
      $composableBuilder(column: $table.roomKey, builder: (column) => column);

  GeneratedColumn<String> get itemKey =>
      $composableBuilder(column: $table.itemKey, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemCondition?, String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$InspectionsTableAnnotationComposer get inspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemResultsTable,
          ItemResult,
          $$ItemResultsTableFilterComposer,
          $$ItemResultsTableOrderingComposer,
          $$ItemResultsTableAnnotationComposer,
          $$ItemResultsTableCreateCompanionBuilder,
          $$ItemResultsTableUpdateCompanionBuilder,
          (ItemResult, $$ItemResultsTableReferences),
          ItemResult,
          PrefetchHooks Function({bool inspectionId})
        > {
  $$ItemResultsTableTableManager(_$AppDatabase db, $ItemResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String> roomKey = const Value.absent(),
                Value<String> itemKey = const Value.absent(),
                Value<ItemCondition?> condition = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemResultsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                inspectionId: inspectionId,
                roomKey: roomKey,
                itemKey: itemKey,
                condition: condition,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String inspectionId,
                required String roomKey,
                required String itemKey,
                Value<ItemCondition?> condition = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemResultsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                inspectionId: inspectionId,
                roomKey: roomKey,
                itemKey: itemKey,
                condition: condition,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemResultsTable, ItemResult>(table),
                  $$ItemResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (inspectionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.inspectionId,
                        referencedTable: $$ItemResultsTableReferences
                            ._inspectionIdTable(db),
                        referencedColumn: $$ItemResultsTableReferences
                            ._inspectionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemResultsTable,
      ItemResult,
      $$ItemResultsTableFilterComposer,
      $$ItemResultsTableOrderingComposer,
      $$ItemResultsTableAnnotationComposer,
      $$ItemResultsTableCreateCompanionBuilder,
      $$ItemResultsTableUpdateCompanionBuilder,
      (ItemResult, $$ItemResultsTableReferences),
      ItemResult,
      PrefetchHooks Function({bool inspectionId})
    >;
typedef $$PhotosTableCreateCompanionBuilder = PhotosCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  required String inspectionId,
  required String roomKey,
  required String itemKey,
  required String relativePath,
  Value<int> rowid,
});
typedef $$PhotosTableUpdateCompanionBuilder = PhotosCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> inspectionId,
  Value<String> roomKey,
  Value<String> itemKey,
  Value<String> relativePath,
  Value<int> rowid,
});

final class $$PhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PhotosTable, Photo> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InspectionsTable _inspectionIdTable(_$AppDatabase db) =>
      db.inspections.createAlias('photos__inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager get inspectionId {
    final $_column = $_itemColumn<String>('inspection_id')!;

    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomKey => $composableBuilder(
    column: $table.roomKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  $$InspectionsTableFilterComposer get inspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomKey => $composableBuilder(
    column: $table.roomKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspectionsTableOrderingComposer get inspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get roomKey =>
      $composableBuilder(column: $table.roomKey, builder: (column) => column);

  GeneratedColumn<String> get itemKey =>
      $composableBuilder(column: $table.itemKey, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  $$InspectionsTableAnnotationComposer get inspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          Photo,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (Photo, $$PhotosTableReferences),
          Photo,
          PrefetchHooks Function({bool inspectionId})
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String> roomKey = const Value.absent(),
                Value<String> itemKey = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                inspectionId: inspectionId,
                roomKey: roomKey,
                itemKey: itemKey,
                relativePath: relativePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String inspectionId,
                required String roomKey,
                required String itemKey,
                required String relativePath,
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                inspectionId: inspectionId,
                roomKey: roomKey,
                itemKey: itemKey,
                relativePath: relativePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PhotosTable, Photo>(table),
                  $$PhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (inspectionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.inspectionId,
                        referencedTable: $$PhotosTableReferences
                            ._inspectionIdTable(db),
                        referencedColumn: $$PhotosTableReferences
                            ._inspectionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      Photo,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (Photo, $$PhotosTableReferences),
      Photo,
      PrefetchHooks Function({bool inspectionId})
    >;
typedef $$SignaturesTableCreateCompanionBuilder = SignaturesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  required String inspectionId,
  required SignatureRole role,
  required String relativePath,
  required DateTime signedAt,
  Value<int> rowid,
});
typedef $$SignaturesTableUpdateCompanionBuilder = SignaturesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> inspectionId,
  Value<SignatureRole> role,
  Value<String> relativePath,
  Value<DateTime> signedAt,
  Value<int> rowid,
});

final class $$SignaturesTableReferences
    extends BaseReferences<_$AppDatabase, $SignaturesTable, Signature> {
  $$SignaturesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InspectionsTable _inspectionIdTable(_$AppDatabase db) =>
      db.inspections.createAlias('signatures__inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager get inspectionId {
    final $_column = $_itemColumn<String>('inspection_id')!;

    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SignaturesTableFilterComposer
    extends Composer<_$AppDatabase, $SignaturesTable> {
  $$SignaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SignatureRole, SignatureRole, String>
  get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InspectionsTableFilterComposer get inspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SignaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $SignaturesTable> {
  $$SignaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspectionsTableOrderingComposer get inspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SignaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SignaturesTable> {
  $$SignaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SignatureRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get signedAt =>
      $composableBuilder(column: $table.signedAt, builder: (column) => column);

  $$InspectionsTableAnnotationComposer get inspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SignaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SignaturesTable,
          Signature,
          $$SignaturesTableFilterComposer,
          $$SignaturesTableOrderingComposer,
          $$SignaturesTableAnnotationComposer,
          $$SignaturesTableCreateCompanionBuilder,
          $$SignaturesTableUpdateCompanionBuilder,
          (Signature, $$SignaturesTableReferences),
          Signature,
          PrefetchHooks Function({bool inspectionId})
        > {
  $$SignaturesTableTableManager(_$AppDatabase db, $SignaturesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SignaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SignaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SignaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<SignatureRole> role = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<DateTime> signedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SignaturesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                inspectionId: inspectionId,
                role: role,
                relativePath: relativePath,
                signedAt: signedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String inspectionId,
                required SignatureRole role,
                required String relativePath,
                required DateTime signedAt,
                Value<int> rowid = const Value.absent(),
              }) => SignaturesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                inspectionId: inspectionId,
                role: role,
                relativePath: relativePath,
                signedAt: signedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SignaturesTable, Signature>(table),
                  $$SignaturesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (inspectionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.inspectionId,
                        referencedTable: $$SignaturesTableReferences
                            ._inspectionIdTable(db),
                        referencedColumn: $$SignaturesTableReferences
                            ._inspectionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SignaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SignaturesTable,
      Signature,
      $$SignaturesTableFilterComposer,
      $$SignaturesTableOrderingComposer,
      $$SignaturesTableAnnotationComposer,
      $$SignaturesTableCreateCompanionBuilder,
      $$SignaturesTableUpdateCompanionBuilder,
      (Signature, $$SignaturesTableReferences),
      Signature,
      PrefetchHooks Function({bool inspectionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db, _db.properties);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
  $$ItemResultsTableTableManager get itemResults =>
      $$ItemResultsTableTableManager(_db, _db.itemResults);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
  $$SignaturesTableTableManager get signatures =>
      $$SignaturesTableTableManager(_db, _db.signatures);
}
