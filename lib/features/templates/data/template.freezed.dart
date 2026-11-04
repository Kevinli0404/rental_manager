// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Template {

 String get id; String get name; int get version; List<TemplateRoom> get rooms;
/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateCopyWith<Template> get copyWith => _$TemplateCopyWithImpl<Template>(this as Template, _$identity);

  /// Serializes this Template to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Template;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Template&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.rooms, _this.rooms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Template;
  return Object.hash(runtimeType,_this.id,_this.name,_this.version,const DeepCollectionEquality().hash(_this.rooms));
}

@override
String toString() {
  final _this = this as Template;
  return 'Template(id: ${_this.id}, name: ${_this.name}, version: ${_this.version}, rooms: ${_this.rooms})';
}


}

/// @nodoc
abstract mixin class $TemplateCopyWith<$Res>  {
  factory $TemplateCopyWith(Template value, $Res Function(Template) _then) = _$TemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, int version, List<TemplateRoom> rooms
});




}
/// @nodoc
class _$TemplateCopyWithImpl<$Res>
    implements $TemplateCopyWith<$Res> {
  _$TemplateCopyWithImpl(this._self, this._then);

  final Template _self;
  final $Res Function(Template) _then;

/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? version = null,Object? rooms = null,}) {
  return _then(Template(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<TemplateRoom>,
  ));
}

}


/// Adds pattern-matching-related methods to [Template].
extension TemplatePatterns on Template {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Template value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Template() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Template value)  $default,){
final _that = this;
switch (_that) {
case _Template():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Template value)?  $default,){
final _that = this;
switch (_that) {
case _Template() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int version,  List<TemplateRoom> rooms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Template() when $default != null:
return $default(_that.id,_that.name,_that.version,_that.rooms);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int version,  List<TemplateRoom> rooms)  $default,) {final _that = this;
switch (_that) {
case _Template():
return $default(_that.id,_that.name,_that.version,_that.rooms);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int version,  List<TemplateRoom> rooms)?  $default,) {final _that = this;
switch (_that) {
case _Template() when $default != null:
return $default(_that.id,_that.name,_that.version,_that.rooms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Template implements Template {
  const _Template({required this.id, required this.name, required this.version, required  List<TemplateRoom> rooms}): _rooms = rooms;
  factory _Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  int version;
 final  List<TemplateRoom> _rooms;
@override List<TemplateRoom> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}


/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateCopyWith<_Template> get copyWith => __$TemplateCopyWithImpl<_Template>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Template&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.rooms, _rooms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,version,const DeepCollectionEquality().hash(_rooms));
}

@override
String toString() {
    return 'Template(id: $id, name: $name, version: $version, rooms: $rooms)';
}


}

/// @nodoc
abstract mixin class _$TemplateCopyWith<$Res> implements $TemplateCopyWith<$Res> {
  factory _$TemplateCopyWith(_Template value, $Res Function(_Template) _then) = __$TemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int version, List<TemplateRoom> rooms
});




}
/// @nodoc
class __$TemplateCopyWithImpl<$Res>
    implements _$TemplateCopyWith<$Res> {
  __$TemplateCopyWithImpl(this._self, this._then);

  final _Template _self;
  final $Res Function(_Template) _then;

/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? version = null,Object? rooms = null,}) {
  return _then(_Template(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<TemplateRoom>,
  ));
}


}


/// @nodoc
mixin _$TemplateRoom {

 String get key; String get name; List<TemplateItem> get items;
/// Create a copy of TemplateRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateRoomCopyWith<TemplateRoom> get copyWith => _$TemplateRoomCopyWithImpl<TemplateRoom>(this as TemplateRoom, _$identity);

  /// Serializes this TemplateRoom to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TemplateRoom;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateRoom&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TemplateRoom;
  return Object.hash(runtimeType,_this.key,_this.name,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as TemplateRoom;
  return 'TemplateRoom(key: ${_this.key}, name: ${_this.name}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $TemplateRoomCopyWith<$Res>  {
  factory $TemplateRoomCopyWith(TemplateRoom value, $Res Function(TemplateRoom) _then) = _$TemplateRoomCopyWithImpl;
@useResult
$Res call({
 String key, String name, List<TemplateItem> items
});




}
/// @nodoc
class _$TemplateRoomCopyWithImpl<$Res>
    implements $TemplateRoomCopyWith<$Res> {
  _$TemplateRoomCopyWithImpl(this._self, this._then);

  final TemplateRoom _self;
  final $Res Function(TemplateRoom) _then;

/// Create a copy of TemplateRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? items = null,}) {
  return _then(TemplateRoom(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TemplateItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateRoom].
extension TemplateRoomPatterns on TemplateRoom {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateRoom() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateRoom value)  $default,){
final _that = this;
switch (_that) {
case _TemplateRoom():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateRoom value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateRoom() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  List<TemplateItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateRoom() when $default != null:
return $default(_that.key,_that.name,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  List<TemplateItem> items)  $default,) {final _that = this;
switch (_that) {
case _TemplateRoom():
return $default(_that.key,_that.name,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  List<TemplateItem> items)?  $default,) {final _that = this;
switch (_that) {
case _TemplateRoom() when $default != null:
return $default(_that.key,_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateRoom implements TemplateRoom {
  const _TemplateRoom({required this.key, required this.name, required  List<TemplateItem> items}): _items = items;
  factory _TemplateRoom.fromJson(Map<String, dynamic> json) => _$TemplateRoomFromJson(json);

@override final  String key;
@override final  String name;
 final  List<TemplateItem> _items;
@override List<TemplateItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TemplateRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateRoomCopyWith<_TemplateRoom> get copyWith => __$TemplateRoomCopyWithImpl<_TemplateRoom>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateRoomToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateRoom&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,name,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'TemplateRoom(key: $key, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TemplateRoomCopyWith<$Res> implements $TemplateRoomCopyWith<$Res> {
  factory _$TemplateRoomCopyWith(_TemplateRoom value, $Res Function(_TemplateRoom) _then) = __$TemplateRoomCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, List<TemplateItem> items
});




}
/// @nodoc
class __$TemplateRoomCopyWithImpl<$Res>
    implements _$TemplateRoomCopyWith<$Res> {
  __$TemplateRoomCopyWithImpl(this._self, this._then);

  final _TemplateRoom _self;
  final $Res Function(_TemplateRoom) _then;

/// Create a copy of TemplateRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? items = null,}) {
  return _then(_TemplateRoom(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TemplateItem>,
  ));
}


}


/// @nodoc
mixin _$TemplateItem {

 String get key; String get name;
/// Create a copy of TemplateItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateItemCopyWith<TemplateItem> get copyWith => _$TemplateItemCopyWithImpl<TemplateItem>(this as TemplateItem, _$identity);

  /// Serializes this TemplateItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TemplateItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateItem&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TemplateItem;
  return Object.hash(runtimeType,_this.key,_this.name);
}

@override
String toString() {
  final _this = this as TemplateItem;
  return 'TemplateItem(key: ${_this.key}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $TemplateItemCopyWith<$Res>  {
  factory $TemplateItemCopyWith(TemplateItem value, $Res Function(TemplateItem) _then) = _$TemplateItemCopyWithImpl;
@useResult
$Res call({
 String key, String name
});




}
/// @nodoc
class _$TemplateItemCopyWithImpl<$Res>
    implements $TemplateItemCopyWith<$Res> {
  _$TemplateItemCopyWithImpl(this._self, this._then);

  final TemplateItem _self;
  final $Res Function(TemplateItem) _then;

/// Create a copy of TemplateItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,}) {
  return _then(TemplateItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateItem].
extension TemplateItemPatterns on TemplateItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateItem value)  $default,){
final _that = this;
switch (_that) {
case _TemplateItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateItem value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateItem() when $default != null:
return $default(_that.key,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name)  $default,) {final _that = this;
switch (_that) {
case _TemplateItem():
return $default(_that.key,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name)?  $default,) {final _that = this;
switch (_that) {
case _TemplateItem() when $default != null:
return $default(_that.key,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateItem implements TemplateItem {
  const _TemplateItem({required this.key, required this.name});
  factory _TemplateItem.fromJson(Map<String, dynamic> json) => _$TemplateItemFromJson(json);

@override final  String key;
@override final  String name;

/// Create a copy of TemplateItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateItemCopyWith<_TemplateItem> get copyWith => __$TemplateItemCopyWithImpl<_TemplateItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateItem&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,name);
}

@override
String toString() {
    return 'TemplateItem(key: $key, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TemplateItemCopyWith<$Res> implements $TemplateItemCopyWith<$Res> {
  factory _$TemplateItemCopyWith(_TemplateItem value, $Res Function(_TemplateItem) _then) = __$TemplateItemCopyWithImpl;
@override @useResult
$Res call({
 String key, String name
});




}
/// @nodoc
class __$TemplateItemCopyWithImpl<$Res>
    implements _$TemplateItemCopyWith<$Res> {
  __$TemplateItemCopyWithImpl(this._self, this._then);

  final _TemplateItem _self;
  final $Res Function(_TemplateItem) _then;

/// Create a copy of TemplateItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,}) {
  return _then(_TemplateItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
