// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_user_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalUserScope {

 String get id; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of LocalUserScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalUserScopeCopyWith<LocalUserScope> get copyWith => _$LocalUserScopeCopyWithImpl<LocalUserScope>(this as LocalUserScope, _$identity);

  /// Serializes this LocalUserScope to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LocalUserScope;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalUserScope&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LocalUserScope;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as LocalUserScope;
  return 'LocalUserScope(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $LocalUserScopeCopyWith<$Res>  {
  factory $LocalUserScopeCopyWith(LocalUserScope value, $Res Function(LocalUserScope) _then) = _$LocalUserScopeCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$LocalUserScopeCopyWithImpl<$Res>
    implements $LocalUserScopeCopyWith<$Res> {
  _$LocalUserScopeCopyWithImpl(this._self, this._then);

  final LocalUserScope _self;
  final $Res Function(LocalUserScope) _then;

/// Create a copy of LocalUserScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(LocalUserScope(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalUserScope].
extension LocalUserScopePatterns on LocalUserScope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalUserScope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalUserScope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalUserScope value)  $default,){
final _that = this;
switch (_that) {
case _LocalUserScope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalUserScope value)?  $default,){
final _that = this;
switch (_that) {
case _LocalUserScope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalUserScope() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LocalUserScope():
return $default(_that.id,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LocalUserScope() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalUserScope implements LocalUserScope {
  const _LocalUserScope({required this.id, required this.createdAt, required this.updatedAt});
  factory _LocalUserScope.fromJson(Map<String, dynamic> json) => _$LocalUserScopeFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of LocalUserScope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalUserScopeCopyWith<_LocalUserScope> get copyWith => __$LocalUserScopeCopyWithImpl<_LocalUserScope>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalUserScopeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalUserScope&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt);
}

@override
String toString() {
    return 'LocalUserScope(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LocalUserScopeCopyWith<$Res> implements $LocalUserScopeCopyWith<$Res> {
  factory _$LocalUserScopeCopyWith(_LocalUserScope value, $Res Function(_LocalUserScope) _then) = __$LocalUserScopeCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$LocalUserScopeCopyWithImpl<$Res>
    implements _$LocalUserScopeCopyWith<$Res> {
  __$LocalUserScopeCopyWithImpl(this._self, this._then);

  final _LocalUserScope _self;
  final $Res Function(_LocalUserScope) _then;

/// Create a copy of LocalUserScope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_LocalUserScope(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
