// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extraction_run.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtractionRun {

 String get id; String get userId; String? get sourceConversationId; String? get sourceConversationTitle; String get modelId; String? get modelDisplayName; DateTime get startedAt; DateTime get completedAt; ExtractionRunStatus get status; int get durationMs; List<String> get enabledKindSlugs; Map<String, int> get kindCounts; int get acceptedCount; int get rejectedCount; int get pendingCount;
/// Create a copy of ExtractionRun
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractionRunCopyWith<ExtractionRun> get copyWith => _$ExtractionRunCopyWithImpl<ExtractionRun>(this as ExtractionRun, _$identity);

  /// Serializes this ExtractionRun to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExtractionRun;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionRun&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.sourceConversationId, _this.sourceConversationId) || other.sourceConversationId == _this.sourceConversationId)&&(identical(other.sourceConversationTitle, _this.sourceConversationTitle) || other.sourceConversationTitle == _this.sourceConversationTitle)&&(identical(other.modelId, _this.modelId) || other.modelId == _this.modelId)&&(identical(other.modelDisplayName, _this.modelDisplayName) || other.modelDisplayName == _this.modelDisplayName)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&const DeepCollectionEquality().equals(other.enabledKindSlugs, _this.enabledKindSlugs)&&const DeepCollectionEquality().equals(other.kindCounts, _this.kindCounts)&&(identical(other.acceptedCount, _this.acceptedCount) || other.acceptedCount == _this.acceptedCount)&&(identical(other.rejectedCount, _this.rejectedCount) || other.rejectedCount == _this.rejectedCount)&&(identical(other.pendingCount, _this.pendingCount) || other.pendingCount == _this.pendingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExtractionRun;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.sourceConversationId,_this.sourceConversationTitle,_this.modelId,_this.modelDisplayName,_this.startedAt,_this.completedAt,_this.status,_this.durationMs,const DeepCollectionEquality().hash(_this.enabledKindSlugs),const DeepCollectionEquality().hash(_this.kindCounts),_this.acceptedCount,_this.rejectedCount,_this.pendingCount);
}

@override
String toString() {
  final _this = this as ExtractionRun;
  return 'ExtractionRun(id: ${_this.id}, userId: ${_this.userId}, sourceConversationId: ${_this.sourceConversationId}, sourceConversationTitle: ${_this.sourceConversationTitle}, modelId: ${_this.modelId}, modelDisplayName: ${_this.modelDisplayName}, startedAt: ${_this.startedAt}, completedAt: ${_this.completedAt}, status: ${_this.status}, durationMs: ${_this.durationMs}, enabledKindSlugs: ${_this.enabledKindSlugs}, kindCounts: ${_this.kindCounts}, acceptedCount: ${_this.acceptedCount}, rejectedCount: ${_this.rejectedCount}, pendingCount: ${_this.pendingCount})';
}


}

/// @nodoc
abstract mixin class $ExtractionRunCopyWith<$Res>  {
  factory $ExtractionRunCopyWith(ExtractionRun value, $Res Function(ExtractionRun) _then) = _$ExtractionRunCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? sourceConversationId, String? sourceConversationTitle, String modelId, String? modelDisplayName, DateTime startedAt, DateTime completedAt, ExtractionRunStatus status, int durationMs, List<String> enabledKindSlugs, Map<String, int> kindCounts, int acceptedCount, int rejectedCount, int pendingCount
});




}
/// @nodoc
class _$ExtractionRunCopyWithImpl<$Res>
    implements $ExtractionRunCopyWith<$Res> {
  _$ExtractionRunCopyWithImpl(this._self, this._then);

  final ExtractionRun _self;
  final $Res Function(ExtractionRun) _then;

/// Create a copy of ExtractionRun
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? sourceConversationId = freezed,Object? sourceConversationTitle = freezed,Object? modelId = null,Object? modelDisplayName = freezed,Object? startedAt = null,Object? completedAt = null,Object? status = null,Object? durationMs = null,Object? enabledKindSlugs = null,Object? kindCounts = null,Object? acceptedCount = null,Object? rejectedCount = null,Object? pendingCount = null,}) {
  return _then(ExtractionRun(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,sourceConversationId: freezed == sourceConversationId ? _self.sourceConversationId : sourceConversationId // ignore: cast_nullable_to_non_nullable
as String?,sourceConversationTitle: freezed == sourceConversationTitle ? _self.sourceConversationTitle : sourceConversationTitle // ignore: cast_nullable_to_non_nullable
as String?,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,modelDisplayName: freezed == modelDisplayName ? _self.modelDisplayName : modelDisplayName // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExtractionRunStatus,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,enabledKindSlugs: null == enabledKindSlugs ? _self.enabledKindSlugs : enabledKindSlugs // ignore: cast_nullable_to_non_nullable
as List<String>,kindCounts: null == kindCounts ? _self.kindCounts : kindCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,acceptedCount: null == acceptedCount ? _self.acceptedCount : acceptedCount // ignore: cast_nullable_to_non_nullable
as int,rejectedCount: null == rejectedCount ? _self.rejectedCount : rejectedCount // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractionRun].
extension ExtractionRunPatterns on ExtractionRun {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractionRun value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractionRun() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractionRun value)  $default,){
final _that = this;
switch (_that) {
case _ExtractionRun():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractionRun value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractionRun() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? sourceConversationId,  String? sourceConversationTitle,  String modelId,  String? modelDisplayName,  DateTime startedAt,  DateTime completedAt,  ExtractionRunStatus status,  int durationMs,  List<String> enabledKindSlugs,  Map<String, int> kindCounts,  int acceptedCount,  int rejectedCount,  int pendingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractionRun() when $default != null:
return $default(_that.id,_that.userId,_that.sourceConversationId,_that.sourceConversationTitle,_that.modelId,_that.modelDisplayName,_that.startedAt,_that.completedAt,_that.status,_that.durationMs,_that.enabledKindSlugs,_that.kindCounts,_that.acceptedCount,_that.rejectedCount,_that.pendingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? sourceConversationId,  String? sourceConversationTitle,  String modelId,  String? modelDisplayName,  DateTime startedAt,  DateTime completedAt,  ExtractionRunStatus status,  int durationMs,  List<String> enabledKindSlugs,  Map<String, int> kindCounts,  int acceptedCount,  int rejectedCount,  int pendingCount)  $default,) {final _that = this;
switch (_that) {
case _ExtractionRun():
return $default(_that.id,_that.userId,_that.sourceConversationId,_that.sourceConversationTitle,_that.modelId,_that.modelDisplayName,_that.startedAt,_that.completedAt,_that.status,_that.durationMs,_that.enabledKindSlugs,_that.kindCounts,_that.acceptedCount,_that.rejectedCount,_that.pendingCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? sourceConversationId,  String? sourceConversationTitle,  String modelId,  String? modelDisplayName,  DateTime startedAt,  DateTime completedAt,  ExtractionRunStatus status,  int durationMs,  List<String> enabledKindSlugs,  Map<String, int> kindCounts,  int acceptedCount,  int rejectedCount,  int pendingCount)?  $default,) {final _that = this;
switch (_that) {
case _ExtractionRun() when $default != null:
return $default(_that.id,_that.userId,_that.sourceConversationId,_that.sourceConversationTitle,_that.modelId,_that.modelDisplayName,_that.startedAt,_that.completedAt,_that.status,_that.durationMs,_that.enabledKindSlugs,_that.kindCounts,_that.acceptedCount,_that.rejectedCount,_that.pendingCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtractionRun extends ExtractionRun {
  const _ExtractionRun({required this.id, required this.userId, this.sourceConversationId, this.sourceConversationTitle, required this.modelId, this.modelDisplayName, required this.startedAt, required this.completedAt, required this.status, required this.durationMs,  List<String> enabledKindSlugs = const ['decision', 'commitment'],  Map<String, int> kindCounts = const {}, this.acceptedCount = 0, this.rejectedCount = 0, this.pendingCount = 0}): _enabledKindSlugs = enabledKindSlugs,_kindCounts = kindCounts,super._();
  factory _ExtractionRun.fromJson(Map<String, dynamic> json) => _$ExtractionRunFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? sourceConversationId;
@override final  String? sourceConversationTitle;
@override final  String modelId;
@override final  String? modelDisplayName;
@override final  DateTime startedAt;
@override final  DateTime completedAt;
@override final  ExtractionRunStatus status;
@override final  int durationMs;
 final  List<String> _enabledKindSlugs;
@override@JsonKey() List<String> get enabledKindSlugs {
  if (_enabledKindSlugs is EqualUnmodifiableListView) return _enabledKindSlugs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_enabledKindSlugs);
}

 final  Map<String, int> _kindCounts;
@override@JsonKey() Map<String, int> get kindCounts {
  if (_kindCounts is EqualUnmodifiableMapView) return _kindCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_kindCounts);
}

@override@JsonKey() final  int acceptedCount;
@override@JsonKey() final  int rejectedCount;
@override@JsonKey() final  int pendingCount;

/// Create a copy of ExtractionRun
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractionRunCopyWith<_ExtractionRun> get copyWith => __$ExtractionRunCopyWithImpl<_ExtractionRun>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtractionRunToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractionRun&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sourceConversationId, sourceConversationId) || other.sourceConversationId == sourceConversationId)&&(identical(other.sourceConversationTitle, sourceConversationTitle) || other.sourceConversationTitle == sourceConversationTitle)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.modelDisplayName, modelDisplayName) || other.modelDisplayName == modelDisplayName)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&const DeepCollectionEquality().equals(other.enabledKindSlugs, _enabledKindSlugs)&&const DeepCollectionEquality().equals(other.kindCounts, _kindCounts)&&(identical(other.acceptedCount, acceptedCount) || other.acceptedCount == acceptedCount)&&(identical(other.rejectedCount, rejectedCount) || other.rejectedCount == rejectedCount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,sourceConversationId,sourceConversationTitle,modelId,modelDisplayName,startedAt,completedAt,status,durationMs,const DeepCollectionEquality().hash(_enabledKindSlugs),const DeepCollectionEquality().hash(_kindCounts),acceptedCount,rejectedCount,pendingCount);
}

@override
String toString() {
    return 'ExtractionRun(id: $id, userId: $userId, sourceConversationId: $sourceConversationId, sourceConversationTitle: $sourceConversationTitle, modelId: $modelId, modelDisplayName: $modelDisplayName, startedAt: $startedAt, completedAt: $completedAt, status: $status, durationMs: $durationMs, enabledKindSlugs: $enabledKindSlugs, kindCounts: $kindCounts, acceptedCount: $acceptedCount, rejectedCount: $rejectedCount, pendingCount: $pendingCount)';
}


}

/// @nodoc
abstract mixin class _$ExtractionRunCopyWith<$Res> implements $ExtractionRunCopyWith<$Res> {
  factory _$ExtractionRunCopyWith(_ExtractionRun value, $Res Function(_ExtractionRun) _then) = __$ExtractionRunCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? sourceConversationId, String? sourceConversationTitle, String modelId, String? modelDisplayName, DateTime startedAt, DateTime completedAt, ExtractionRunStatus status, int durationMs, List<String> enabledKindSlugs, Map<String, int> kindCounts, int acceptedCount, int rejectedCount, int pendingCount
});




}
/// @nodoc
class __$ExtractionRunCopyWithImpl<$Res>
    implements _$ExtractionRunCopyWith<$Res> {
  __$ExtractionRunCopyWithImpl(this._self, this._then);

  final _ExtractionRun _self;
  final $Res Function(_ExtractionRun) _then;

/// Create a copy of ExtractionRun
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? sourceConversationId = freezed,Object? sourceConversationTitle = freezed,Object? modelId = null,Object? modelDisplayName = freezed,Object? startedAt = null,Object? completedAt = null,Object? status = null,Object? durationMs = null,Object? enabledKindSlugs = null,Object? kindCounts = null,Object? acceptedCount = null,Object? rejectedCount = null,Object? pendingCount = null,}) {
  return _then(_ExtractionRun(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,sourceConversationId: freezed == sourceConversationId ? _self.sourceConversationId : sourceConversationId // ignore: cast_nullable_to_non_nullable
as String?,sourceConversationTitle: freezed == sourceConversationTitle ? _self.sourceConversationTitle : sourceConversationTitle // ignore: cast_nullable_to_non_nullable
as String?,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,modelDisplayName: freezed == modelDisplayName ? _self.modelDisplayName : modelDisplayName // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExtractionRunStatus,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,enabledKindSlugs: null == enabledKindSlugs ? _self._enabledKindSlugs : enabledKindSlugs // ignore: cast_nullable_to_non_nullable
as List<String>,kindCounts: null == kindCounts ? _self._kindCounts : kindCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,acceptedCount: null == acceptedCount ? _self.acceptedCount : acceptedCount // ignore: cast_nullable_to_non_nullable
as int,rejectedCount: null == rejectedCount ? _self.rejectedCount : rejectedCount // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
