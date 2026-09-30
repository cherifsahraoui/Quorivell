// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiChatThread {

 String get id; String get userId; String get title; String? get modelId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of AiChatThread
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatThreadCopyWith<AiChatThread> get copyWith => _$AiChatThreadCopyWithImpl<AiChatThread>(this as AiChatThread, _$identity);

  /// Serializes this AiChatThread to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiChatThread;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatThread&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.modelId, _this.modelId) || other.modelId == _this.modelId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiChatThread;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.title,_this.modelId,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as AiChatThread;
  return 'AiChatThread(id: ${_this.id}, userId: ${_this.userId}, title: ${_this.title}, modelId: ${_this.modelId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $AiChatThreadCopyWith<$Res>  {
  factory $AiChatThreadCopyWith(AiChatThread value, $Res Function(AiChatThread) _then) = _$AiChatThreadCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String? modelId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$AiChatThreadCopyWithImpl<$Res>
    implements $AiChatThreadCopyWith<$Res> {
  _$AiChatThreadCopyWithImpl(this._self, this._then);

  final AiChatThread _self;
  final $Res Function(AiChatThread) _then;

/// Create a copy of AiChatThread
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? modelId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(AiChatThread(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,modelId: freezed == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiChatThread].
extension AiChatThreadPatterns on AiChatThread {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatThread value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatThread() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatThread value)  $default,){
final _that = this;
switch (_that) {
case _AiChatThread():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatThread value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatThread() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String? modelId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatThread() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.modelId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String? modelId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AiChatThread():
return $default(_that.id,_that.userId,_that.title,_that.modelId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String? modelId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiChatThread() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.modelId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiChatThread implements AiChatThread {
  const _AiChatThread({required this.id, required this.userId, required this.title, required this.modelId, required this.createdAt, required this.updatedAt});
  factory _AiChatThread.fromJson(Map<String, dynamic> json) => _$AiChatThreadFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override final  String? modelId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of AiChatThread
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatThreadCopyWith<_AiChatThread> get copyWith => __$AiChatThreadCopyWithImpl<_AiChatThread>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiChatThreadToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatThread&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,title,modelId,createdAt,updatedAt);
}

@override
String toString() {
    return 'AiChatThread(id: $id, userId: $userId, title: $title, modelId: $modelId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AiChatThreadCopyWith<$Res> implements $AiChatThreadCopyWith<$Res> {
  factory _$AiChatThreadCopyWith(_AiChatThread value, $Res Function(_AiChatThread) _then) = __$AiChatThreadCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String? modelId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$AiChatThreadCopyWithImpl<$Res>
    implements _$AiChatThreadCopyWith<$Res> {
  __$AiChatThreadCopyWithImpl(this._self, this._then);

  final _AiChatThread _self;
  final $Res Function(_AiChatThread) _then;

/// Create a copy of AiChatThread
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? modelId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AiChatThread(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,modelId: freezed == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
