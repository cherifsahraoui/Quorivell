// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewCandidate {

 String get id; String get userId; String get sourceConversationId; int get sourceRevision; String get kind; String get statement; String? get owner; DateTime? get dueDate; String? get note; int get quoteStart; int get quoteEnd; String get quoteSnippet; ReviewStatus get reviewStatus;
/// Create a copy of ReviewCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCandidateCopyWith<ReviewCandidate> get copyWith => _$ReviewCandidateCopyWithImpl<ReviewCandidate>(this as ReviewCandidate, _$identity);

  /// Serializes this ReviewCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviewCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewCandidate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.sourceConversationId, _this.sourceConversationId) || other.sourceConversationId == _this.sourceConversationId)&&(identical(other.sourceRevision, _this.sourceRevision) || other.sourceRevision == _this.sourceRevision)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.statement, _this.statement) || other.statement == _this.statement)&&(identical(other.owner, _this.owner) || other.owner == _this.owner)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.quoteStart, _this.quoteStart) || other.quoteStart == _this.quoteStart)&&(identical(other.quoteEnd, _this.quoteEnd) || other.quoteEnd == _this.quoteEnd)&&(identical(other.quoteSnippet, _this.quoteSnippet) || other.quoteSnippet == _this.quoteSnippet)&&(identical(other.reviewStatus, _this.reviewStatus) || other.reviewStatus == _this.reviewStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviewCandidate;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.sourceConversationId,_this.sourceRevision,_this.kind,_this.statement,_this.owner,_this.dueDate,_this.note,_this.quoteStart,_this.quoteEnd,_this.quoteSnippet,_this.reviewStatus);
}

@override
String toString() {
  final _this = this as ReviewCandidate;
  return 'ReviewCandidate(id: ${_this.id}, userId: ${_this.userId}, sourceConversationId: ${_this.sourceConversationId}, sourceRevision: ${_this.sourceRevision}, kind: ${_this.kind}, statement: ${_this.statement}, owner: ${_this.owner}, dueDate: ${_this.dueDate}, note: ${_this.note}, quoteStart: ${_this.quoteStart}, quoteEnd: ${_this.quoteEnd}, quoteSnippet: ${_this.quoteSnippet}, reviewStatus: ${_this.reviewStatus})';
}


}

/// @nodoc
abstract mixin class $ReviewCandidateCopyWith<$Res>  {
  factory $ReviewCandidateCopyWith(ReviewCandidate value, $Res Function(ReviewCandidate) _then) = _$ReviewCandidateCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String sourceConversationId, int sourceRevision, String kind, String statement, String? owner, DateTime? dueDate, String? note, int quoteStart, int quoteEnd, String quoteSnippet, ReviewStatus reviewStatus
});




}
/// @nodoc
class _$ReviewCandidateCopyWithImpl<$Res>
    implements $ReviewCandidateCopyWith<$Res> {
  _$ReviewCandidateCopyWithImpl(this._self, this._then);

  final ReviewCandidate _self;
  final $Res Function(ReviewCandidate) _then;

/// Create a copy of ReviewCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? sourceConversationId = null,Object? sourceRevision = null,Object? kind = null,Object? statement = null,Object? owner = freezed,Object? dueDate = freezed,Object? note = freezed,Object? quoteStart = null,Object? quoteEnd = null,Object? quoteSnippet = null,Object? reviewStatus = null,}) {
  return _then(ReviewCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,sourceConversationId: null == sourceConversationId ? _self.sourceConversationId : sourceConversationId // ignore: cast_nullable_to_non_nullable
as String,sourceRevision: null == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,quoteStart: null == quoteStart ? _self.quoteStart : quoteStart // ignore: cast_nullable_to_non_nullable
as int,quoteEnd: null == quoteEnd ? _self.quoteEnd : quoteEnd // ignore: cast_nullable_to_non_nullable
as int,quoteSnippet: null == quoteSnippet ? _self.quoteSnippet : quoteSnippet // ignore: cast_nullable_to_non_nullable
as String,reviewStatus: null == reviewStatus ? _self.reviewStatus : reviewStatus // ignore: cast_nullable_to_non_nullable
as ReviewStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewCandidate].
extension ReviewCandidatePatterns on ReviewCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewCandidate value)  $default,){
final _that = this;
switch (_that) {
case _ReviewCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String sourceConversationId,  int sourceRevision,  String kind,  String statement,  String? owner,  DateTime? dueDate,  String? note,  int quoteStart,  int quoteEnd,  String quoteSnippet,  ReviewStatus reviewStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewCandidate() when $default != null:
return $default(_that.id,_that.userId,_that.sourceConversationId,_that.sourceRevision,_that.kind,_that.statement,_that.owner,_that.dueDate,_that.note,_that.quoteStart,_that.quoteEnd,_that.quoteSnippet,_that.reviewStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String sourceConversationId,  int sourceRevision,  String kind,  String statement,  String? owner,  DateTime? dueDate,  String? note,  int quoteStart,  int quoteEnd,  String quoteSnippet,  ReviewStatus reviewStatus)  $default,) {final _that = this;
switch (_that) {
case _ReviewCandidate():
return $default(_that.id,_that.userId,_that.sourceConversationId,_that.sourceRevision,_that.kind,_that.statement,_that.owner,_that.dueDate,_that.note,_that.quoteStart,_that.quoteEnd,_that.quoteSnippet,_that.reviewStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String sourceConversationId,  int sourceRevision,  String kind,  String statement,  String? owner,  DateTime? dueDate,  String? note,  int quoteStart,  int quoteEnd,  String quoteSnippet,  ReviewStatus reviewStatus)?  $default,) {final _that = this;
switch (_that) {
case _ReviewCandidate() when $default != null:
return $default(_that.id,_that.userId,_that.sourceConversationId,_that.sourceRevision,_that.kind,_that.statement,_that.owner,_that.dueDate,_that.note,_that.quoteStart,_that.quoteEnd,_that.quoteSnippet,_that.reviewStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewCandidate implements ReviewCandidate {
  const _ReviewCandidate({required this.id, required this.userId, required this.sourceConversationId, required this.sourceRevision, required this.kind, required this.statement, required this.owner, required this.dueDate, this.note, required this.quoteStart, required this.quoteEnd, required this.quoteSnippet, required this.reviewStatus});
  factory _ReviewCandidate.fromJson(Map<String, dynamic> json) => _$ReviewCandidateFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String sourceConversationId;
@override final  int sourceRevision;
@override final  String kind;
@override final  String statement;
@override final  String? owner;
@override final  DateTime? dueDate;
@override final  String? note;
@override final  int quoteStart;
@override final  int quoteEnd;
@override final  String quoteSnippet;
@override final  ReviewStatus reviewStatus;

/// Create a copy of ReviewCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCandidateCopyWith<_ReviewCandidate> get copyWith => __$ReviewCandidateCopyWithImpl<_ReviewCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sourceConversationId, sourceConversationId) || other.sourceConversationId == sourceConversationId)&&(identical(other.sourceRevision, sourceRevision) || other.sourceRevision == sourceRevision)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.statement, statement) || other.statement == statement)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.note, note) || other.note == note)&&(identical(other.quoteStart, quoteStart) || other.quoteStart == quoteStart)&&(identical(other.quoteEnd, quoteEnd) || other.quoteEnd == quoteEnd)&&(identical(other.quoteSnippet, quoteSnippet) || other.quoteSnippet == quoteSnippet)&&(identical(other.reviewStatus, reviewStatus) || other.reviewStatus == reviewStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,sourceConversationId,sourceRevision,kind,statement,owner,dueDate,note,quoteStart,quoteEnd,quoteSnippet,reviewStatus);
}

@override
String toString() {
    return 'ReviewCandidate(id: $id, userId: $userId, sourceConversationId: $sourceConversationId, sourceRevision: $sourceRevision, kind: $kind, statement: $statement, owner: $owner, dueDate: $dueDate, note: $note, quoteStart: $quoteStart, quoteEnd: $quoteEnd, quoteSnippet: $quoteSnippet, reviewStatus: $reviewStatus)';
}


}

/// @nodoc
abstract mixin class _$ReviewCandidateCopyWith<$Res> implements $ReviewCandidateCopyWith<$Res> {
  factory _$ReviewCandidateCopyWith(_ReviewCandidate value, $Res Function(_ReviewCandidate) _then) = __$ReviewCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String sourceConversationId, int sourceRevision, String kind, String statement, String? owner, DateTime? dueDate, String? note, int quoteStart, int quoteEnd, String quoteSnippet, ReviewStatus reviewStatus
});




}
/// @nodoc
class __$ReviewCandidateCopyWithImpl<$Res>
    implements _$ReviewCandidateCopyWith<$Res> {
  __$ReviewCandidateCopyWithImpl(this._self, this._then);

  final _ReviewCandidate _self;
  final $Res Function(_ReviewCandidate) _then;

/// Create a copy of ReviewCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? sourceConversationId = null,Object? sourceRevision = null,Object? kind = null,Object? statement = null,Object? owner = freezed,Object? dueDate = freezed,Object? note = freezed,Object? quoteStart = null,Object? quoteEnd = null,Object? quoteSnippet = null,Object? reviewStatus = null,}) {
  return _then(_ReviewCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,sourceConversationId: null == sourceConversationId ? _self.sourceConversationId : sourceConversationId // ignore: cast_nullable_to_non_nullable
as String,sourceRevision: null == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,quoteStart: null == quoteStart ? _self.quoteStart : quoteStart // ignore: cast_nullable_to_non_nullable
as int,quoteEnd: null == quoteEnd ? _self.quoteEnd : quoteEnd // ignore: cast_nullable_to_non_nullable
as int,quoteSnippet: null == quoteSnippet ? _self.quoteSnippet : quoteSnippet // ignore: cast_nullable_to_non_nullable
as String,reviewStatus: null == reviewStatus ? _self.reviewStatus : reviewStatus // ignore: cast_nullable_to_non_nullable
as ReviewStatus,
  ));
}


}

// dart format on
