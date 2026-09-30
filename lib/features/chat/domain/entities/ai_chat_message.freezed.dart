// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiChatMessage {

 String get id; String get userId; String get threadId; AiChatRole get role; String get content; AiChatMessageStatus get status; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of AiChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatMessageCopyWith<AiChatMessage> get copyWith => _$AiChatMessageCopyWithImpl<AiChatMessage>(this as AiChatMessage, _$identity);

  /// Serializes this AiChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiChatMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.threadId, _this.threadId) || other.threadId == _this.threadId)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiChatMessage;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.threadId,_this.role,_this.content,_this.status,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as AiChatMessage;
  return 'AiChatMessage(id: ${_this.id}, userId: ${_this.userId}, threadId: ${_this.threadId}, role: ${_this.role}, content: ${_this.content}, status: ${_this.status}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $AiChatMessageCopyWith<$Res>  {
  factory $AiChatMessageCopyWith(AiChatMessage value, $Res Function(AiChatMessage) _then) = _$AiChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String threadId, AiChatRole role, String content, AiChatMessageStatus status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$AiChatMessageCopyWithImpl<$Res>
    implements $AiChatMessageCopyWith<$Res> {
  _$AiChatMessageCopyWithImpl(this._self, this._then);

  final AiChatMessage _self;
  final $Res Function(AiChatMessage) _then;

/// Create a copy of AiChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? threadId = null,Object? role = null,Object? content = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(AiChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,threadId: null == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AiChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiChatMessageStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiChatMessage].
extension AiChatMessagePatterns on AiChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _AiChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String threadId,  AiChatRole role,  String content,  AiChatMessageStatus status,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatMessage() when $default != null:
return $default(_that.id,_that.userId,_that.threadId,_that.role,_that.content,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String threadId,  AiChatRole role,  String content,  AiChatMessageStatus status,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AiChatMessage():
return $default(_that.id,_that.userId,_that.threadId,_that.role,_that.content,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String threadId,  AiChatRole role,  String content,  AiChatMessageStatus status,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiChatMessage() when $default != null:
return $default(_that.id,_that.userId,_that.threadId,_that.role,_that.content,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiChatMessage implements AiChatMessage {
  const _AiChatMessage({required this.id, required this.userId, required this.threadId, required this.role, required this.content, required this.status, required this.createdAt, required this.updatedAt});
  factory _AiChatMessage.fromJson(Map<String, dynamic> json) => _$AiChatMessageFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String threadId;
@override final  AiChatRole role;
@override final  String content;
@override final  AiChatMessageStatus status;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of AiChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatMessageCopyWith<_AiChatMessage> get copyWith => __$AiChatMessageCopyWithImpl<_AiChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,threadId,role,content,status,createdAt,updatedAt);
}

@override
String toString() {
    return 'AiChatMessage(id: $id, userId: $userId, threadId: $threadId, role: $role, content: $content, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AiChatMessageCopyWith<$Res> implements $AiChatMessageCopyWith<$Res> {
  factory _$AiChatMessageCopyWith(_AiChatMessage value, $Res Function(_AiChatMessage) _then) = __$AiChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String threadId, AiChatRole role, String content, AiChatMessageStatus status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$AiChatMessageCopyWithImpl<$Res>
    implements _$AiChatMessageCopyWith<$Res> {
  __$AiChatMessageCopyWithImpl(this._self, this._then);

  final _AiChatMessage _self;
  final $Res Function(_AiChatMessage) _then;

/// Create a copy of AiChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? threadId = null,Object? role = null,Object? content = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AiChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,threadId: null == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AiChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiChatMessageStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
