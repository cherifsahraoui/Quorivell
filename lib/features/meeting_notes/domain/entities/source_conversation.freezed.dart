// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SourceConversation {

 String get id; String get userId; String get content; int get sourceRevision; DateTime get createdAt; DateTime get updatedAt; bool get isArchived;
/// Create a copy of SourceConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SourceConversationCopyWith<SourceConversation> get copyWith => _$SourceConversationCopyWithImpl<SourceConversation>(this as SourceConversation, _$identity);

  /// Serializes this SourceConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SourceConversation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SourceConversation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.sourceRevision, _this.sourceRevision) || other.sourceRevision == _this.sourceRevision)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SourceConversation;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.content,_this.sourceRevision,_this.createdAt,_this.updatedAt,_this.isArchived);
}

@override
String toString() {
  final _this = this as SourceConversation;
  return 'SourceConversation(id: ${_this.id}, userId: ${_this.userId}, content: ${_this.content}, sourceRevision: ${_this.sourceRevision}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, isArchived: ${_this.isArchived})';
}


}

/// @nodoc
abstract mixin class $SourceConversationCopyWith<$Res>  {
  factory $SourceConversationCopyWith(SourceConversation value, $Res Function(SourceConversation) _then) = _$SourceConversationCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String content, int sourceRevision, DateTime createdAt, DateTime updatedAt, bool isArchived
});




}
/// @nodoc
class _$SourceConversationCopyWithImpl<$Res>
    implements $SourceConversationCopyWith<$Res> {
  _$SourceConversationCopyWithImpl(this._self, this._then);

  final SourceConversation _self;
  final $Res Function(SourceConversation) _then;

/// Create a copy of SourceConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? content = null,Object? sourceRevision = null,Object? createdAt = null,Object? updatedAt = null,Object? isArchived = null,}) {
  return _then(SourceConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,sourceRevision: null == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SourceConversation].
extension SourceConversationPatterns on SourceConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SourceConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SourceConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SourceConversation value)  $default,){
final _that = this;
switch (_that) {
case _SourceConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SourceConversation value)?  $default,){
final _that = this;
switch (_that) {
case _SourceConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String content,  int sourceRevision,  DateTime createdAt,  DateTime updatedAt,  bool isArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SourceConversation() when $default != null:
return $default(_that.id,_that.userId,_that.content,_that.sourceRevision,_that.createdAt,_that.updatedAt,_that.isArchived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String content,  int sourceRevision,  DateTime createdAt,  DateTime updatedAt,  bool isArchived)  $default,) {final _that = this;
switch (_that) {
case _SourceConversation():
return $default(_that.id,_that.userId,_that.content,_that.sourceRevision,_that.createdAt,_that.updatedAt,_that.isArchived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String content,  int sourceRevision,  DateTime createdAt,  DateTime updatedAt,  bool isArchived)?  $default,) {final _that = this;
switch (_that) {
case _SourceConversation() when $default != null:
return $default(_that.id,_that.userId,_that.content,_that.sourceRevision,_that.createdAt,_that.updatedAt,_that.isArchived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SourceConversation implements SourceConversation {
  const _SourceConversation({required this.id, required this.userId, required this.content, required this.sourceRevision, required this.createdAt, required this.updatedAt, this.isArchived = false});
  factory _SourceConversation.fromJson(Map<String, dynamic> json) => _$SourceConversationFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String content;
@override final  int sourceRevision;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool isArchived;

/// Create a copy of SourceConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SourceConversationCopyWith<_SourceConversation> get copyWith => __$SourceConversationCopyWithImpl<_SourceConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SourceConversationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SourceConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.content, content) || other.content == content)&&(identical(other.sourceRevision, sourceRevision) || other.sourceRevision == sourceRevision)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,content,sourceRevision,createdAt,updatedAt,isArchived);
}

@override
String toString() {
    return 'SourceConversation(id: $id, userId: $userId, content: $content, sourceRevision: $sourceRevision, createdAt: $createdAt, updatedAt: $updatedAt, isArchived: $isArchived)';
}


}

/// @nodoc
abstract mixin class _$SourceConversationCopyWith<$Res> implements $SourceConversationCopyWith<$Res> {
  factory _$SourceConversationCopyWith(_SourceConversation value, $Res Function(_SourceConversation) _then) = __$SourceConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String content, int sourceRevision, DateTime createdAt, DateTime updatedAt, bool isArchived
});




}
/// @nodoc
class __$SourceConversationCopyWithImpl<$Res>
    implements _$SourceConversationCopyWith<$Res> {
  __$SourceConversationCopyWithImpl(this._self, this._then);

  final _SourceConversation _self;
  final $Res Function(_SourceConversation) _then;

/// Create a copy of SourceConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? content = null,Object? sourceRevision = null,Object? createdAt = null,Object? updatedAt = null,Object? isArchived = null,}) {
  return _then(_SourceConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,sourceRevision: null == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
