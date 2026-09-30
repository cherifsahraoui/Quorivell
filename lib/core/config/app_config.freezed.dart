// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteAssistantConfig implements DiagnosticableTreeMixin {

 bool get enabled; bool get appCheckEnforced; String get modelId;
/// Create a copy of RemoteAssistantConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteAssistantConfigCopyWith<RemoteAssistantConfig> get copyWith => _$RemoteAssistantConfigCopyWithImpl<RemoteAssistantConfig>(this as RemoteAssistantConfig, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as RemoteAssistantConfig;
  properties
    ..add(DiagnosticsProperty('type', 'RemoteAssistantConfig'))
    ..add(DiagnosticsProperty('enabled', _this.enabled))..add(DiagnosticsProperty('appCheckEnforced', _this.appCheckEnforced))..add(DiagnosticsProperty('modelId', _this.modelId));
}

@override
bool operator ==(Object other) {
  final _this = this as RemoteAssistantConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteAssistantConfig&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.appCheckEnforced, _this.appCheckEnforced) || other.appCheckEnforced == _this.appCheckEnforced)&&(identical(other.modelId, _this.modelId) || other.modelId == _this.modelId));
}


@override
int get hashCode {
  final _this = this as RemoteAssistantConfig;
  return Object.hash(runtimeType,_this.enabled,_this.appCheckEnforced,_this.modelId);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as RemoteAssistantConfig;
  return 'RemoteAssistantConfig(enabled: ${_this.enabled}, appCheckEnforced: ${_this.appCheckEnforced}, modelId: ${_this.modelId})';
}


}

/// @nodoc
abstract mixin class $RemoteAssistantConfigCopyWith<$Res>  {
  factory $RemoteAssistantConfigCopyWith(RemoteAssistantConfig value, $Res Function(RemoteAssistantConfig) _then) = _$RemoteAssistantConfigCopyWithImpl;
@useResult
$Res call({
 bool enabled, bool appCheckEnforced, String modelId
});




}
/// @nodoc
class _$RemoteAssistantConfigCopyWithImpl<$Res>
    implements $RemoteAssistantConfigCopyWith<$Res> {
  _$RemoteAssistantConfigCopyWithImpl(this._self, this._then);

  final RemoteAssistantConfig _self;
  final $Res Function(RemoteAssistantConfig) _then;

/// Create a copy of RemoteAssistantConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? appCheckEnforced = null,Object? modelId = null,}) {
  return _then(RemoteAssistantConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,appCheckEnforced: null == appCheckEnforced ? _self.appCheckEnforced : appCheckEnforced // ignore: cast_nullable_to_non_nullable
as bool,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoteAssistantConfig].
extension RemoteAssistantConfigPatterns on RemoteAssistantConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteAssistantConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteAssistantConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteAssistantConfig value)  $default,){
final _that = this;
switch (_that) {
case _RemoteAssistantConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteAssistantConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteAssistantConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  bool appCheckEnforced,  String modelId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteAssistantConfig() when $default != null:
return $default(_that.enabled,_that.appCheckEnforced,_that.modelId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  bool appCheckEnforced,  String modelId)  $default,) {final _that = this;
switch (_that) {
case _RemoteAssistantConfig():
return $default(_that.enabled,_that.appCheckEnforced,_that.modelId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  bool appCheckEnforced,  String modelId)?  $default,) {final _that = this;
switch (_that) {
case _RemoteAssistantConfig() when $default != null:
return $default(_that.enabled,_that.appCheckEnforced,_that.modelId);case _:
  return null;

}
}

}

/// @nodoc


class _RemoteAssistantConfig extends RemoteAssistantConfig with DiagnosticableTreeMixin {
  const _RemoteAssistantConfig({this.enabled = false, this.appCheckEnforced = false, this.modelId = ''}): super._();
  

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool appCheckEnforced;
@override@JsonKey() final  String modelId;

/// Create a copy of RemoteAssistantConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteAssistantConfigCopyWith<_RemoteAssistantConfig> get copyWith => __$RemoteAssistantConfigCopyWithImpl<_RemoteAssistantConfig>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RemoteAssistantConfig'))
    ..add(DiagnosticsProperty('enabled', enabled))..add(DiagnosticsProperty('appCheckEnforced', appCheckEnforced))..add(DiagnosticsProperty('modelId', modelId));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteAssistantConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.appCheckEnforced, appCheckEnforced) || other.appCheckEnforced == appCheckEnforced)&&(identical(other.modelId, modelId) || other.modelId == modelId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,enabled,appCheckEnforced,modelId);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RemoteAssistantConfig(enabled: $enabled, appCheckEnforced: $appCheckEnforced, modelId: $modelId)';
}


}

/// @nodoc
abstract mixin class _$RemoteAssistantConfigCopyWith<$Res> implements $RemoteAssistantConfigCopyWith<$Res> {
  factory _$RemoteAssistantConfigCopyWith(_RemoteAssistantConfig value, $Res Function(_RemoteAssistantConfig) _then) = __$RemoteAssistantConfigCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, bool appCheckEnforced, String modelId
});




}
/// @nodoc
class __$RemoteAssistantConfigCopyWithImpl<$Res>
    implements _$RemoteAssistantConfigCopyWith<$Res> {
  __$RemoteAssistantConfigCopyWithImpl(this._self, this._then);

  final _RemoteAssistantConfig _self;
  final $Res Function(_RemoteAssistantConfig) _then;

/// Create a copy of RemoteAssistantConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? appCheckEnforced = null,Object? modelId = null,}) {
  return _then(_RemoteAssistantConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,appCheckEnforced: null == appCheckEnforced ? _self.appCheckEnforced : appCheckEnforced // ignore: cast_nullable_to_non_nullable
as bool,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
