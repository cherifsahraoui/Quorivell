// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPreference {

 String get id; String get userId; AppearanceThemeMode get themeMode; AppLocalePreference get localePreference; bool get debugModeEnabled; String? get chatSystemPromptOverride; String? get extractionPromptOverride; String? get extractionSystemPromptOverride; bool get extractionKindsIntroDismissed; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferenceCopyWith<UserPreference> get copyWith => _$UserPreferenceCopyWithImpl<UserPreference>(this as UserPreference, _$identity);

  /// Serializes this UserPreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserPreference;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreference&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&(identical(other.localePreference, _this.localePreference) || other.localePreference == _this.localePreference)&&(identical(other.debugModeEnabled, _this.debugModeEnabled) || other.debugModeEnabled == _this.debugModeEnabled)&&(identical(other.chatSystemPromptOverride, _this.chatSystemPromptOverride) || other.chatSystemPromptOverride == _this.chatSystemPromptOverride)&&(identical(other.extractionPromptOverride, _this.extractionPromptOverride) || other.extractionPromptOverride == _this.extractionPromptOverride)&&(identical(other.extractionSystemPromptOverride, _this.extractionSystemPromptOverride) || other.extractionSystemPromptOverride == _this.extractionSystemPromptOverride)&&(identical(other.extractionKindsIntroDismissed, _this.extractionKindsIntroDismissed) || other.extractionKindsIntroDismissed == _this.extractionKindsIntroDismissed)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserPreference;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.themeMode,_this.localePreference,_this.debugModeEnabled,_this.chatSystemPromptOverride,_this.extractionPromptOverride,_this.extractionSystemPromptOverride,_this.extractionKindsIntroDismissed,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as UserPreference;
  return 'UserPreference(id: ${_this.id}, userId: ${_this.userId}, themeMode: ${_this.themeMode}, localePreference: ${_this.localePreference}, debugModeEnabled: ${_this.debugModeEnabled}, chatSystemPromptOverride: ${_this.chatSystemPromptOverride}, extractionPromptOverride: ${_this.extractionPromptOverride}, extractionSystemPromptOverride: ${_this.extractionSystemPromptOverride}, extractionKindsIntroDismissed: ${_this.extractionKindsIntroDismissed}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $UserPreferenceCopyWith<$Res>  {
  factory $UserPreferenceCopyWith(UserPreference value, $Res Function(UserPreference) _then) = _$UserPreferenceCopyWithImpl;
@useResult
$Res call({
 String id, String userId, AppearanceThemeMode themeMode, AppLocalePreference localePreference, bool debugModeEnabled, String? chatSystemPromptOverride, String? extractionPromptOverride, String? extractionSystemPromptOverride, bool extractionKindsIntroDismissed, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserPreferenceCopyWithImpl<$Res>
    implements $UserPreferenceCopyWith<$Res> {
  _$UserPreferenceCopyWithImpl(this._self, this._then);

  final UserPreference _self;
  final $Res Function(UserPreference) _then;

/// Create a copy of UserPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? themeMode = null,Object? localePreference = null,Object? debugModeEnabled = null,Object? chatSystemPromptOverride = freezed,Object? extractionPromptOverride = freezed,Object? extractionSystemPromptOverride = freezed,Object? extractionKindsIntroDismissed = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(UserPreference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppearanceThemeMode,localePreference: null == localePreference ? _self.localePreference : localePreference // ignore: cast_nullable_to_non_nullable
as AppLocalePreference,debugModeEnabled: null == debugModeEnabled ? _self.debugModeEnabled : debugModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,chatSystemPromptOverride: freezed == chatSystemPromptOverride ? _self.chatSystemPromptOverride : chatSystemPromptOverride // ignore: cast_nullable_to_non_nullable
as String?,extractionPromptOverride: freezed == extractionPromptOverride ? _self.extractionPromptOverride : extractionPromptOverride // ignore: cast_nullable_to_non_nullable
as String?,extractionSystemPromptOverride: freezed == extractionSystemPromptOverride ? _self.extractionSystemPromptOverride : extractionSystemPromptOverride // ignore: cast_nullable_to_non_nullable
as String?,extractionKindsIntroDismissed: null == extractionKindsIntroDismissed ? _self.extractionKindsIntroDismissed : extractionKindsIntroDismissed // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreference].
extension UserPreferencePatterns on UserPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreference value)  $default,){
final _that = this;
switch (_that) {
case _UserPreference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreference value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  AppearanceThemeMode themeMode,  AppLocalePreference localePreference,  bool debugModeEnabled,  String? chatSystemPromptOverride,  String? extractionPromptOverride,  String? extractionSystemPromptOverride,  bool extractionKindsIntroDismissed,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreference() when $default != null:
return $default(_that.id,_that.userId,_that.themeMode,_that.localePreference,_that.debugModeEnabled,_that.chatSystemPromptOverride,_that.extractionPromptOverride,_that.extractionSystemPromptOverride,_that.extractionKindsIntroDismissed,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  AppearanceThemeMode themeMode,  AppLocalePreference localePreference,  bool debugModeEnabled,  String? chatSystemPromptOverride,  String? extractionPromptOverride,  String? extractionSystemPromptOverride,  bool extractionKindsIntroDismissed,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserPreference():
return $default(_that.id,_that.userId,_that.themeMode,_that.localePreference,_that.debugModeEnabled,_that.chatSystemPromptOverride,_that.extractionPromptOverride,_that.extractionSystemPromptOverride,_that.extractionKindsIntroDismissed,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  AppearanceThemeMode themeMode,  AppLocalePreference localePreference,  bool debugModeEnabled,  String? chatSystemPromptOverride,  String? extractionPromptOverride,  String? extractionSystemPromptOverride,  bool extractionKindsIntroDismissed,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserPreference() when $default != null:
return $default(_that.id,_that.userId,_that.themeMode,_that.localePreference,_that.debugModeEnabled,_that.chatSystemPromptOverride,_that.extractionPromptOverride,_that.extractionSystemPromptOverride,_that.extractionKindsIntroDismissed,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserPreference implements UserPreference {
  const _UserPreference({required this.id, required this.userId, required this.themeMode, required this.localePreference, this.debugModeEnabled = false, this.chatSystemPromptOverride, this.extractionPromptOverride, this.extractionSystemPromptOverride, this.extractionKindsIntroDismissed = false, required this.createdAt, required this.updatedAt});
  factory _UserPreference.fromJson(Map<String, dynamic> json) => _$UserPreferenceFromJson(json);

@override final  String id;
@override final  String userId;
@override final  AppearanceThemeMode themeMode;
@override final  AppLocalePreference localePreference;
@override@JsonKey() final  bool debugModeEnabled;
@override final  String? chatSystemPromptOverride;
@override final  String? extractionPromptOverride;
@override final  String? extractionSystemPromptOverride;
@override@JsonKey() final  bool extractionKindsIntroDismissed;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferenceCopyWith<_UserPreference> get copyWith => __$UserPreferenceCopyWithImpl<_UserPreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreference&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.localePreference, localePreference) || other.localePreference == localePreference)&&(identical(other.debugModeEnabled, debugModeEnabled) || other.debugModeEnabled == debugModeEnabled)&&(identical(other.chatSystemPromptOverride, chatSystemPromptOverride) || other.chatSystemPromptOverride == chatSystemPromptOverride)&&(identical(other.extractionPromptOverride, extractionPromptOverride) || other.extractionPromptOverride == extractionPromptOverride)&&(identical(other.extractionSystemPromptOverride, extractionSystemPromptOverride) || other.extractionSystemPromptOverride == extractionSystemPromptOverride)&&(identical(other.extractionKindsIntroDismissed, extractionKindsIntroDismissed) || other.extractionKindsIntroDismissed == extractionKindsIntroDismissed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,themeMode,localePreference,debugModeEnabled,chatSystemPromptOverride,extractionPromptOverride,extractionSystemPromptOverride,extractionKindsIntroDismissed,createdAt,updatedAt);
}

@override
String toString() {
    return 'UserPreference(id: $id, userId: $userId, themeMode: $themeMode, localePreference: $localePreference, debugModeEnabled: $debugModeEnabled, chatSystemPromptOverride: $chatSystemPromptOverride, extractionPromptOverride: $extractionPromptOverride, extractionSystemPromptOverride: $extractionSystemPromptOverride, extractionKindsIntroDismissed: $extractionKindsIntroDismissed, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserPreferenceCopyWith<$Res> implements $UserPreferenceCopyWith<$Res> {
  factory _$UserPreferenceCopyWith(_UserPreference value, $Res Function(_UserPreference) _then) = __$UserPreferenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, AppearanceThemeMode themeMode, AppLocalePreference localePreference, bool debugModeEnabled, String? chatSystemPromptOverride, String? extractionPromptOverride, String? extractionSystemPromptOverride, bool extractionKindsIntroDismissed, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserPreferenceCopyWithImpl<$Res>
    implements _$UserPreferenceCopyWith<$Res> {
  __$UserPreferenceCopyWithImpl(this._self, this._then);

  final _UserPreference _self;
  final $Res Function(_UserPreference) _then;

/// Create a copy of UserPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? themeMode = null,Object? localePreference = null,Object? debugModeEnabled = null,Object? chatSystemPromptOverride = freezed,Object? extractionPromptOverride = freezed,Object? extractionSystemPromptOverride = freezed,Object? extractionKindsIntroDismissed = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserPreference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppearanceThemeMode,localePreference: null == localePreference ? _self.localePreference : localePreference // ignore: cast_nullable_to_non_nullable
as AppLocalePreference,debugModeEnabled: null == debugModeEnabled ? _self.debugModeEnabled : debugModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,chatSystemPromptOverride: freezed == chatSystemPromptOverride ? _self.chatSystemPromptOverride : chatSystemPromptOverride // ignore: cast_nullable_to_non_nullable
as String?,extractionPromptOverride: freezed == extractionPromptOverride ? _self.extractionPromptOverride : extractionPromptOverride // ignore: cast_nullable_to_non_nullable
as String?,extractionSystemPromptOverride: freezed == extractionSystemPromptOverride ? _self.extractionSystemPromptOverride : extractionSystemPromptOverride // ignore: cast_nullable_to_non_nullable
as String?,extractionKindsIntroDismissed: null == extractionKindsIntroDismissed ? _self.extractionKindsIntroDismissed : extractionKindsIntroDismissed // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
