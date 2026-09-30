// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LedgerItem {

 String get id; String get userId; String get kind; String get statement; LedgerItemStatus get status; String? get owner; DateTime? get dueDate; String? get note; String get kindDisplayNameSnapshot; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of LedgerItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerItemCopyWith<LedgerItem> get copyWith => _$LedgerItemCopyWithImpl<LedgerItem>(this as LedgerItem, _$identity);

  /// Serializes this LedgerItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LedgerItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.statement, _this.statement) || other.statement == _this.statement)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.owner, _this.owner) || other.owner == _this.owner)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.kindDisplayNameSnapshot, _this.kindDisplayNameSnapshot) || other.kindDisplayNameSnapshot == _this.kindDisplayNameSnapshot)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LedgerItem;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.kind,_this.statement,_this.status,_this.owner,_this.dueDate,_this.note,_this.kindDisplayNameSnapshot,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as LedgerItem;
  return 'LedgerItem(id: ${_this.id}, userId: ${_this.userId}, kind: ${_this.kind}, statement: ${_this.statement}, status: ${_this.status}, owner: ${_this.owner}, dueDate: ${_this.dueDate}, note: ${_this.note}, kindDisplayNameSnapshot: ${_this.kindDisplayNameSnapshot}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $LedgerItemCopyWith<$Res>  {
  factory $LedgerItemCopyWith(LedgerItem value, $Res Function(LedgerItem) _then) = _$LedgerItemCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String kind, String statement, LedgerItemStatus status, String? owner, DateTime? dueDate, String? note, String kindDisplayNameSnapshot, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$LedgerItemCopyWithImpl<$Res>
    implements $LedgerItemCopyWith<$Res> {
  _$LedgerItemCopyWithImpl(this._self, this._then);

  final LedgerItem _self;
  final $Res Function(LedgerItem) _then;

/// Create a copy of LedgerItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? kind = null,Object? statement = null,Object? status = null,Object? owner = freezed,Object? dueDate = freezed,Object? note = freezed,Object? kindDisplayNameSnapshot = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(LedgerItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LedgerItemStatus,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,kindDisplayNameSnapshot: null == kindDisplayNameSnapshot ? _self.kindDisplayNameSnapshot : kindDisplayNameSnapshot // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerItem].
extension LedgerItemPatterns on LedgerItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerItem value)  $default,){
final _that = this;
switch (_that) {
case _LedgerItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerItem value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String kind,  String statement,  LedgerItemStatus status,  String? owner,  DateTime? dueDate,  String? note,  String kindDisplayNameSnapshot,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerItem() when $default != null:
return $default(_that.id,_that.userId,_that.kind,_that.statement,_that.status,_that.owner,_that.dueDate,_that.note,_that.kindDisplayNameSnapshot,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String kind,  String statement,  LedgerItemStatus status,  String? owner,  DateTime? dueDate,  String? note,  String kindDisplayNameSnapshot,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LedgerItem():
return $default(_that.id,_that.userId,_that.kind,_that.statement,_that.status,_that.owner,_that.dueDate,_that.note,_that.kindDisplayNameSnapshot,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String kind,  String statement,  LedgerItemStatus status,  String? owner,  DateTime? dueDate,  String? note,  String kindDisplayNameSnapshot,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LedgerItem() when $default != null:
return $default(_that.id,_that.userId,_that.kind,_that.statement,_that.status,_that.owner,_that.dueDate,_that.note,_that.kindDisplayNameSnapshot,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LedgerItem implements LedgerItem {
  const _LedgerItem({required this.id, required this.userId, required this.kind, required this.statement, required this.status, required this.owner, required this.dueDate, this.note, this.kindDisplayNameSnapshot = '', required this.createdAt, required this.updatedAt});
  factory _LedgerItem.fromJson(Map<String, dynamic> json) => _$LedgerItemFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String kind;
@override final  String statement;
@override final  LedgerItemStatus status;
@override final  String? owner;
@override final  DateTime? dueDate;
@override final  String? note;
@override@JsonKey() final  String kindDisplayNameSnapshot;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of LedgerItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerItemCopyWith<_LedgerItem> get copyWith => __$LedgerItemCopyWithImpl<_LedgerItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.statement, statement) || other.statement == statement)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.note, note) || other.note == note)&&(identical(other.kindDisplayNameSnapshot, kindDisplayNameSnapshot) || other.kindDisplayNameSnapshot == kindDisplayNameSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,kind,statement,status,owner,dueDate,note,kindDisplayNameSnapshot,createdAt,updatedAt);
}

@override
String toString() {
    return 'LedgerItem(id: $id, userId: $userId, kind: $kind, statement: $statement, status: $status, owner: $owner, dueDate: $dueDate, note: $note, kindDisplayNameSnapshot: $kindDisplayNameSnapshot, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LedgerItemCopyWith<$Res> implements $LedgerItemCopyWith<$Res> {
  factory _$LedgerItemCopyWith(_LedgerItem value, $Res Function(_LedgerItem) _then) = __$LedgerItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String kind, String statement, LedgerItemStatus status, String? owner, DateTime? dueDate, String? note, String kindDisplayNameSnapshot, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$LedgerItemCopyWithImpl<$Res>
    implements _$LedgerItemCopyWith<$Res> {
  __$LedgerItemCopyWithImpl(this._self, this._then);

  final _LedgerItem _self;
  final $Res Function(_LedgerItem) _then;

/// Create a copy of LedgerItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? kind = null,Object? statement = null,Object? status = null,Object? owner = freezed,Object? dueDate = freezed,Object? note = freezed,Object? kindDisplayNameSnapshot = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_LedgerItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LedgerItemStatus,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,kindDisplayNameSnapshot: null == kindDisplayNameSnapshot ? _self.kindDisplayNameSnapshot : kindDisplayNameSnapshot // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$EvidenceReference {

 String get id; String get ledgerItemId; String get sourceConversationId; int get sourceRevision; int get quoteStart; int get quoteEnd; String get quoteSnippet;
/// Create a copy of EvidenceReference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvidenceReferenceCopyWith<EvidenceReference> get copyWith => _$EvidenceReferenceCopyWithImpl<EvidenceReference>(this as EvidenceReference, _$identity);

  /// Serializes this EvidenceReference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EvidenceReference;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvidenceReference&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.ledgerItemId, _this.ledgerItemId) || other.ledgerItemId == _this.ledgerItemId)&&(identical(other.sourceConversationId, _this.sourceConversationId) || other.sourceConversationId == _this.sourceConversationId)&&(identical(other.sourceRevision, _this.sourceRevision) || other.sourceRevision == _this.sourceRevision)&&(identical(other.quoteStart, _this.quoteStart) || other.quoteStart == _this.quoteStart)&&(identical(other.quoteEnd, _this.quoteEnd) || other.quoteEnd == _this.quoteEnd)&&(identical(other.quoteSnippet, _this.quoteSnippet) || other.quoteSnippet == _this.quoteSnippet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EvidenceReference;
  return Object.hash(runtimeType,_this.id,_this.ledgerItemId,_this.sourceConversationId,_this.sourceRevision,_this.quoteStart,_this.quoteEnd,_this.quoteSnippet);
}

@override
String toString() {
  final _this = this as EvidenceReference;
  return 'EvidenceReference(id: ${_this.id}, ledgerItemId: ${_this.ledgerItemId}, sourceConversationId: ${_this.sourceConversationId}, sourceRevision: ${_this.sourceRevision}, quoteStart: ${_this.quoteStart}, quoteEnd: ${_this.quoteEnd}, quoteSnippet: ${_this.quoteSnippet})';
}


}

/// @nodoc
abstract mixin class $EvidenceReferenceCopyWith<$Res>  {
  factory $EvidenceReferenceCopyWith(EvidenceReference value, $Res Function(EvidenceReference) _then) = _$EvidenceReferenceCopyWithImpl;
@useResult
$Res call({
 String id, String ledgerItemId, String sourceConversationId, int sourceRevision, int quoteStart, int quoteEnd, String quoteSnippet
});




}
/// @nodoc
class _$EvidenceReferenceCopyWithImpl<$Res>
    implements $EvidenceReferenceCopyWith<$Res> {
  _$EvidenceReferenceCopyWithImpl(this._self, this._then);

  final EvidenceReference _self;
  final $Res Function(EvidenceReference) _then;

/// Create a copy of EvidenceReference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ledgerItemId = null,Object? sourceConversationId = null,Object? sourceRevision = null,Object? quoteStart = null,Object? quoteEnd = null,Object? quoteSnippet = null,}) {
  return _then(EvidenceReference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ledgerItemId: null == ledgerItemId ? _self.ledgerItemId : ledgerItemId // ignore: cast_nullable_to_non_nullable
as String,sourceConversationId: null == sourceConversationId ? _self.sourceConversationId : sourceConversationId // ignore: cast_nullable_to_non_nullable
as String,sourceRevision: null == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int,quoteStart: null == quoteStart ? _self.quoteStart : quoteStart // ignore: cast_nullable_to_non_nullable
as int,quoteEnd: null == quoteEnd ? _self.quoteEnd : quoteEnd // ignore: cast_nullable_to_non_nullable
as int,quoteSnippet: null == quoteSnippet ? _self.quoteSnippet : quoteSnippet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EvidenceReference].
extension EvidenceReferencePatterns on EvidenceReference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvidenceReference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvidenceReference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvidenceReference value)  $default,){
final _that = this;
switch (_that) {
case _EvidenceReference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvidenceReference value)?  $default,){
final _that = this;
switch (_that) {
case _EvidenceReference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ledgerItemId,  String sourceConversationId,  int sourceRevision,  int quoteStart,  int quoteEnd,  String quoteSnippet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvidenceReference() when $default != null:
return $default(_that.id,_that.ledgerItemId,_that.sourceConversationId,_that.sourceRevision,_that.quoteStart,_that.quoteEnd,_that.quoteSnippet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ledgerItemId,  String sourceConversationId,  int sourceRevision,  int quoteStart,  int quoteEnd,  String quoteSnippet)  $default,) {final _that = this;
switch (_that) {
case _EvidenceReference():
return $default(_that.id,_that.ledgerItemId,_that.sourceConversationId,_that.sourceRevision,_that.quoteStart,_that.quoteEnd,_that.quoteSnippet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ledgerItemId,  String sourceConversationId,  int sourceRevision,  int quoteStart,  int quoteEnd,  String quoteSnippet)?  $default,) {final _that = this;
switch (_that) {
case _EvidenceReference() when $default != null:
return $default(_that.id,_that.ledgerItemId,_that.sourceConversationId,_that.sourceRevision,_that.quoteStart,_that.quoteEnd,_that.quoteSnippet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EvidenceReference implements EvidenceReference {
  const _EvidenceReference({required this.id, required this.ledgerItemId, required this.sourceConversationId, required this.sourceRevision, required this.quoteStart, required this.quoteEnd, required this.quoteSnippet});
  factory _EvidenceReference.fromJson(Map<String, dynamic> json) => _$EvidenceReferenceFromJson(json);

@override final  String id;
@override final  String ledgerItemId;
@override final  String sourceConversationId;
@override final  int sourceRevision;
@override final  int quoteStart;
@override final  int quoteEnd;
@override final  String quoteSnippet;

/// Create a copy of EvidenceReference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvidenceReferenceCopyWith<_EvidenceReference> get copyWith => __$EvidenceReferenceCopyWithImpl<_EvidenceReference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EvidenceReferenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvidenceReference&&(identical(other.id, id) || other.id == id)&&(identical(other.ledgerItemId, ledgerItemId) || other.ledgerItemId == ledgerItemId)&&(identical(other.sourceConversationId, sourceConversationId) || other.sourceConversationId == sourceConversationId)&&(identical(other.sourceRevision, sourceRevision) || other.sourceRevision == sourceRevision)&&(identical(other.quoteStart, quoteStart) || other.quoteStart == quoteStart)&&(identical(other.quoteEnd, quoteEnd) || other.quoteEnd == quoteEnd)&&(identical(other.quoteSnippet, quoteSnippet) || other.quoteSnippet == quoteSnippet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,ledgerItemId,sourceConversationId,sourceRevision,quoteStart,quoteEnd,quoteSnippet);
}

@override
String toString() {
    return 'EvidenceReference(id: $id, ledgerItemId: $ledgerItemId, sourceConversationId: $sourceConversationId, sourceRevision: $sourceRevision, quoteStart: $quoteStart, quoteEnd: $quoteEnd, quoteSnippet: $quoteSnippet)';
}


}

/// @nodoc
abstract mixin class _$EvidenceReferenceCopyWith<$Res> implements $EvidenceReferenceCopyWith<$Res> {
  factory _$EvidenceReferenceCopyWith(_EvidenceReference value, $Res Function(_EvidenceReference) _then) = __$EvidenceReferenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String ledgerItemId, String sourceConversationId, int sourceRevision, int quoteStart, int quoteEnd, String quoteSnippet
});




}
/// @nodoc
class __$EvidenceReferenceCopyWithImpl<$Res>
    implements _$EvidenceReferenceCopyWith<$Res> {
  __$EvidenceReferenceCopyWithImpl(this._self, this._then);

  final _EvidenceReference _self;
  final $Res Function(_EvidenceReference) _then;

/// Create a copy of EvidenceReference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ledgerItemId = null,Object? sourceConversationId = null,Object? sourceRevision = null,Object? quoteStart = null,Object? quoteEnd = null,Object? quoteSnippet = null,}) {
  return _then(_EvidenceReference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ledgerItemId: null == ledgerItemId ? _self.ledgerItemId : ledgerItemId // ignore: cast_nullable_to_non_nullable
as String,sourceConversationId: null == sourceConversationId ? _self.sourceConversationId : sourceConversationId // ignore: cast_nullable_to_non_nullable
as String,sourceRevision: null == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int,quoteStart: null == quoteStart ? _self.quoteStart : quoteStart // ignore: cast_nullable_to_non_nullable
as int,quoteEnd: null == quoteEnd ? _self.quoteEnd : quoteEnd // ignore: cast_nullable_to_non_nullable
as int,quoteSnippet: null == quoteSnippet ? _self.quoteSnippet : quoteSnippet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
