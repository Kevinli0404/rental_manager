// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Layout {

 String get templateId; int get templateVersion; List<LayoutRoom> get rooms;
/// Create a copy of Layout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutCopyWith<Layout> get copyWith => _$LayoutCopyWithImpl<Layout>(this as Layout, _$identity);

  /// Serializes this Layout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Layout;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Layout&&(identical(other.templateId, _this.templateId) || other.templateId == _this.templateId)&&(identical(other.templateVersion, _this.templateVersion) || other.templateVersion == _this.templateVersion)&&const DeepCollectionEquality().equals(other.rooms, _this.rooms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Layout;
  return Object.hash(runtimeType,_this.templateId,_this.templateVersion,const DeepCollectionEquality().hash(_this.rooms));
}

@override
String toString() {
  final _this = this as Layout;
  return 'Layout(templateId: ${_this.templateId}, templateVersion: ${_this.templateVersion}, rooms: ${_this.rooms})';
}


}

/// @nodoc
abstract mixin class $LayoutCopyWith<$Res>  {
  factory $LayoutCopyWith(Layout value, $Res Function(Layout) _then) = _$LayoutCopyWithImpl;
@useResult
$Res call({
 String templateId, int templateVersion, List<LayoutRoom> rooms
});




}
/// @nodoc
class _$LayoutCopyWithImpl<$Res>
    implements $LayoutCopyWith<$Res> {
  _$LayoutCopyWithImpl(this._self, this._then);

  final Layout _self;
  final $Res Function(Layout) _then;

/// Create a copy of Layout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? templateVersion = null,Object? rooms = null,}) {
  return _then(Layout(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,templateVersion: null == templateVersion ? _self.templateVersion : templateVersion // ignore: cast_nullable_to_non_nullable
as int,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<LayoutRoom>,
  ));
}

}


/// Adds pattern-matching-related methods to [Layout].
extension LayoutPatterns on Layout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Layout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Layout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Layout value)  $default,){
final _that = this;
switch (_that) {
case _Layout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Layout value)?  $default,){
final _that = this;
switch (_that) {
case _Layout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String templateId,  int templateVersion,  List<LayoutRoom> rooms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Layout() when $default != null:
return $default(_that.templateId,_that.templateVersion,_that.rooms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String templateId,  int templateVersion,  List<LayoutRoom> rooms)  $default,) {final _that = this;
switch (_that) {
case _Layout():
return $default(_that.templateId,_that.templateVersion,_that.rooms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String templateId,  int templateVersion,  List<LayoutRoom> rooms)?  $default,) {final _that = this;
switch (_that) {
case _Layout() when $default != null:
return $default(_that.templateId,_that.templateVersion,_that.rooms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Layout implements Layout {
  const _Layout({required this.templateId, required this.templateVersion, required  List<LayoutRoom> rooms}): _rooms = rooms;
  factory _Layout.fromJson(Map<String, dynamic> json) => _$LayoutFromJson(json);

@override final  String templateId;
@override final  int templateVersion;
 final  List<LayoutRoom> _rooms;
@override List<LayoutRoom> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}


/// Create a copy of Layout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutCopyWith<_Layout> get copyWith => __$LayoutCopyWithImpl<_Layout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayoutToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Layout&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.templateVersion, templateVersion) || other.templateVersion == templateVersion)&&const DeepCollectionEquality().equals(other.rooms, _rooms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,templateId,templateVersion,const DeepCollectionEquality().hash(_rooms));
}

@override
String toString() {
    return 'Layout(templateId: $templateId, templateVersion: $templateVersion, rooms: $rooms)';
}


}

/// @nodoc
abstract mixin class _$LayoutCopyWith<$Res> implements $LayoutCopyWith<$Res> {
  factory _$LayoutCopyWith(_Layout value, $Res Function(_Layout) _then) = __$LayoutCopyWithImpl;
@override @useResult
$Res call({
 String templateId, int templateVersion, List<LayoutRoom> rooms
});




}
/// @nodoc
class __$LayoutCopyWithImpl<$Res>
    implements _$LayoutCopyWith<$Res> {
  __$LayoutCopyWithImpl(this._self, this._then);

  final _Layout _self;
  final $Res Function(_Layout) _then;

/// Create a copy of Layout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? templateVersion = null,Object? rooms = null,}) {
  return _then(_Layout(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,templateVersion: null == templateVersion ? _self.templateVersion : templateVersion // ignore: cast_nullable_to_non_nullable
as int,rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<LayoutRoom>,
  ));
}


}


/// @nodoc
mixin _$LayoutRoom {

 String get key; String get typeKey; String get name; List<LayoutItem> get items;
/// Create a copy of LayoutRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutRoomCopyWith<LayoutRoom> get copyWith => _$LayoutRoomCopyWithImpl<LayoutRoom>(this as LayoutRoom, _$identity);

  /// Serializes this LayoutRoom to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LayoutRoom;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutRoom&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.typeKey, _this.typeKey) || other.typeKey == _this.typeKey)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LayoutRoom;
  return Object.hash(runtimeType,_this.key,_this.typeKey,_this.name,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as LayoutRoom;
  return 'LayoutRoom(key: ${_this.key}, typeKey: ${_this.typeKey}, name: ${_this.name}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $LayoutRoomCopyWith<$Res>  {
  factory $LayoutRoomCopyWith(LayoutRoom value, $Res Function(LayoutRoom) _then) = _$LayoutRoomCopyWithImpl;
@useResult
$Res call({
 String key, String typeKey, String name, List<LayoutItem> items
});




}
/// @nodoc
class _$LayoutRoomCopyWithImpl<$Res>
    implements $LayoutRoomCopyWith<$Res> {
  _$LayoutRoomCopyWithImpl(this._self, this._then);

  final LayoutRoom _self;
  final $Res Function(LayoutRoom) _then;

/// Create a copy of LayoutRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? typeKey = null,Object? name = null,Object? items = null,}) {
  return _then(LayoutRoom(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,typeKey: null == typeKey ? _self.typeKey : typeKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LayoutItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutRoom].
extension LayoutRoomPatterns on LayoutRoom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayoutRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayoutRoom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayoutRoom value)  $default,){
final _that = this;
switch (_that) {
case _LayoutRoom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayoutRoom value)?  $default,){
final _that = this;
switch (_that) {
case _LayoutRoom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String typeKey,  String name,  List<LayoutItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayoutRoom() when $default != null:
return $default(_that.key,_that.typeKey,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String typeKey,  String name,  List<LayoutItem> items)  $default,) {final _that = this;
switch (_that) {
case _LayoutRoom():
return $default(_that.key,_that.typeKey,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String typeKey,  String name,  List<LayoutItem> items)?  $default,) {final _that = this;
switch (_that) {
case _LayoutRoom() when $default != null:
return $default(_that.key,_that.typeKey,_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LayoutRoom implements LayoutRoom {
  const _LayoutRoom({required this.key, required this.typeKey, required this.name, required  List<LayoutItem> items}): _items = items;
  factory _LayoutRoom.fromJson(Map<String, dynamic> json) => _$LayoutRoomFromJson(json);

@override final  String key;
@override final  String typeKey;
@override final  String name;
 final  List<LayoutItem> _items;
@override List<LayoutItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of LayoutRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutRoomCopyWith<_LayoutRoom> get copyWith => __$LayoutRoomCopyWithImpl<_LayoutRoom>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayoutRoomToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayoutRoom&&(identical(other.key, key) || other.key == key)&&(identical(other.typeKey, typeKey) || other.typeKey == typeKey)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,typeKey,name,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'LayoutRoom(key: $key, typeKey: $typeKey, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$LayoutRoomCopyWith<$Res> implements $LayoutRoomCopyWith<$Res> {
  factory _$LayoutRoomCopyWith(_LayoutRoom value, $Res Function(_LayoutRoom) _then) = __$LayoutRoomCopyWithImpl;
@override @useResult
$Res call({
 String key, String typeKey, String name, List<LayoutItem> items
});




}
/// @nodoc
class __$LayoutRoomCopyWithImpl<$Res>
    implements _$LayoutRoomCopyWith<$Res> {
  __$LayoutRoomCopyWithImpl(this._self, this._then);

  final _LayoutRoom _self;
  final $Res Function(_LayoutRoom) _then;

/// Create a copy of LayoutRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? typeKey = null,Object? name = null,Object? items = null,}) {
  return _then(_LayoutRoom(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,typeKey: null == typeKey ? _self.typeKey : typeKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LayoutItem>,
  ));
}


}


/// @nodoc
mixin _$LayoutItem {

 String get key; String get name;
/// Create a copy of LayoutItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutItemCopyWith<LayoutItem> get copyWith => _$LayoutItemCopyWithImpl<LayoutItem>(this as LayoutItem, _$identity);

  /// Serializes this LayoutItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LayoutItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutItem&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LayoutItem;
  return Object.hash(runtimeType,_this.key,_this.name);
}

@override
String toString() {
  final _this = this as LayoutItem;
  return 'LayoutItem(key: ${_this.key}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $LayoutItemCopyWith<$Res>  {
  factory $LayoutItemCopyWith(LayoutItem value, $Res Function(LayoutItem) _then) = _$LayoutItemCopyWithImpl;
@useResult
$Res call({
 String key, String name
});




}
/// @nodoc
class _$LayoutItemCopyWithImpl<$Res>
    implements $LayoutItemCopyWith<$Res> {
  _$LayoutItemCopyWithImpl(this._self, this._then);

  final LayoutItem _self;
  final $Res Function(LayoutItem) _then;

/// Create a copy of LayoutItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,}) {
  return _then(LayoutItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutItem].
extension LayoutItemPatterns on LayoutItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayoutItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayoutItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayoutItem value)  $default,){
final _that = this;
switch (_that) {
case _LayoutItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayoutItem value)?  $default,){
final _that = this;
switch (_that) {
case _LayoutItem() when $default != null:
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
case _LayoutItem() when $default != null:
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
case _LayoutItem():
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
case _LayoutItem() when $default != null:
return $default(_that.key,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LayoutItem implements LayoutItem {
  const _LayoutItem({required this.key, required this.name});
  factory _LayoutItem.fromJson(Map<String, dynamic> json) => _$LayoutItemFromJson(json);

@override final  String key;
@override final  String name;

/// Create a copy of LayoutItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutItemCopyWith<_LayoutItem> get copyWith => __$LayoutItemCopyWithImpl<_LayoutItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayoutItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayoutItem&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,name);
}

@override
String toString() {
    return 'LayoutItem(key: $key, name: $name)';
}


}

/// @nodoc
abstract mixin class _$LayoutItemCopyWith<$Res> implements $LayoutItemCopyWith<$Res> {
  factory _$LayoutItemCopyWith(_LayoutItem value, $Res Function(_LayoutItem) _then) = __$LayoutItemCopyWithImpl;
@override @useResult
$Res call({
 String key, String name
});




}
/// @nodoc
class __$LayoutItemCopyWithImpl<$Res>
    implements _$LayoutItemCopyWith<$Res> {
  __$LayoutItemCopyWithImpl(this._self, this._then);

  final _LayoutItem _self;
  final $Res Function(_LayoutItem) _then;

/// Create a copy of LayoutItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,}) {
  return _then(_LayoutItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
