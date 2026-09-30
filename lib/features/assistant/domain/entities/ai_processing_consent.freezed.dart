// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_processing_consent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiProcessingConsent {

 AiProcessingConsentStatus get status; DateTime get updatedAt;
/// Create a copy of AiProcessingConsent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiProcessingConsentCopyWith<AiProcessingConsent> get copyWith => _$AiProcessingConsentCopyWithImpl<AiProcessingConsent>(this as AiProcessingConsent, _$identity);

  /// Serializes this AiProcessingConsent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiProcessingConsent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiProcessingConsent&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiProcessingConsent;
  return Object.hash(runtimeType,_this.status,_this.updatedAt);
}

@override
String toString() {
  final _this = this as AiProcessingConsent;
  return 'AiProcessingConsent(status: ${_this.status}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $AiProcessingConsentCopyWith<$Res>  {
  factory $AiProcessingConsentCopyWith(AiProcessingConsent value, $Res Function(AiProcessingConsent) _then) = _$AiProcessingConsentCopyWithImpl;
@useResult
$Res call({
 AiProcessingConsentStatus status, DateTime updatedAt
});




}
/// @nodoc
class _$AiProcessingConsentCopyWithImpl<$Res>
    implements $AiProcessingConsentCopyWith<$Res> {
  _$AiProcessingConsentCopyWithImpl(this._self, this._then);

  final AiProcessingConsent _self;
  final $Res Function(AiProcessingConsent) _then;

/// Create a copy of AiProcessingConsent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? updatedAt = null,}) {
  return _then(AiProcessingConsent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiProcessingConsentStatus,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiProcessingConsent].
extension AiProcessingConsentPatterns on AiProcessingConsent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiProcessingConsent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiProcessingConsent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiProcessingConsent value)  $default,){
final _that = this;
switch (_that) {
case _AiProcessingConsent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiProcessingConsent value)?  $default,){
final _that = this;
switch (_that) {
case _AiProcessingConsent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiProcessingConsentStatus status,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiProcessingConsent() when $default != null:
return $default(_that.status,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiProcessingConsentStatus status,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AiProcessingConsent():
return $default(_that.status,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiProcessingConsentStatus status,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiProcessingConsent() when $default != null:
return $default(_that.status,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiProcessingConsent extends AiProcessingConsent {
  const _AiProcessingConsent({required this.status, required this.updatedAt}): super._();
  factory _AiProcessingConsent.fromJson(Map<String, dynamic> json) => _$AiProcessingConsentFromJson(json);

@override final  AiProcessingConsentStatus status;
@override final  DateTime updatedAt;

/// Create a copy of AiProcessingConsent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiProcessingConsentCopyWith<_AiProcessingConsent> get copyWith => __$AiProcessingConsentCopyWithImpl<_AiProcessingConsent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiProcessingConsentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiProcessingConsent&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,updatedAt);
}

@override
String toString() {
    return 'AiProcessingConsent(status: $status, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AiProcessingConsentCopyWith<$Res> implements $AiProcessingConsentCopyWith<$Res> {
  factory _$AiProcessingConsentCopyWith(_AiProcessingConsent value, $Res Function(_AiProcessingConsent) _then) = __$AiProcessingConsentCopyWithImpl;
@override @useResult
$Res call({
 AiProcessingConsentStatus status, DateTime updatedAt
});




}
/// @nodoc
class __$AiProcessingConsentCopyWithImpl<$Res>
    implements _$AiProcessingConsentCopyWith<$Res> {
  __$AiProcessingConsentCopyWithImpl(this._self, this._then);

  final _AiProcessingConsent _self;
  final $Res Function(_AiProcessingConsent) _then;

/// Create a copy of AiProcessingConsent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? updatedAt = null,}) {
  return _then(_AiProcessingConsent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiProcessingConsentStatus,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
