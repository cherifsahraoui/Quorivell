// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extraction_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtractionJob {

 String get id; String get sourceConversationId; int get sourceRevision; int get completedChunkCount; int get totalChunks; int get candidatesFound; DateTime get startTime; List<double> get chunkTimings; String get progressTitle; String get progressBody; String get completionTitle;/// Remaining active source ids after [sourceConversationId], oldest→newest
/// for extract-all. Empty for a single-conversation run.
 List<String> get queuedSourceConversationIds;/// 0-based index of the conversation currently being extracted in a batch.
 int get batchIndex;/// Total conversations in this extract run (1 for a single pick).
 int get batchTotal;
/// Create a copy of ExtractionJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractionJobCopyWith<ExtractionJob> get copyWith => _$ExtractionJobCopyWithImpl<ExtractionJob>(this as ExtractionJob, _$identity);

  /// Serializes this ExtractionJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExtractionJob;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionJob&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sourceConversationId, _this.sourceConversationId) || other.sourceConversationId == _this.sourceConversationId)&&(identical(other.sourceRevision, _this.sourceRevision) || other.sourceRevision == _this.sourceRevision)&&(identical(other.completedChunkCount, _this.completedChunkCount) || other.completedChunkCount == _this.completedChunkCount)&&(identical(other.totalChunks, _this.totalChunks) || other.totalChunks == _this.totalChunks)&&(identical(other.candidatesFound, _this.candidatesFound) || other.candidatesFound == _this.candidatesFound)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&const DeepCollectionEquality().equals(other.chunkTimings, _this.chunkTimings)&&(identical(other.progressTitle, _this.progressTitle) || other.progressTitle == _this.progressTitle)&&(identical(other.progressBody, _this.progressBody) || other.progressBody == _this.progressBody)&&(identical(other.completionTitle, _this.completionTitle) || other.completionTitle == _this.completionTitle)&&const DeepCollectionEquality().equals(other.queuedSourceConversationIds, _this.queuedSourceConversationIds)&&(identical(other.batchIndex, _this.batchIndex) || other.batchIndex == _this.batchIndex)&&(identical(other.batchTotal, _this.batchTotal) || other.batchTotal == _this.batchTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExtractionJob;
  return Object.hash(runtimeType,_this.id,_this.sourceConversationId,_this.sourceRevision,_this.completedChunkCount,_this.totalChunks,_this.candidatesFound,_this.startTime,const DeepCollectionEquality().hash(_this.chunkTimings),_this.progressTitle,_this.progressBody,_this.completionTitle,const DeepCollectionEquality().hash(_this.queuedSourceConversationIds),_this.batchIndex,_this.batchTotal);
}

@override
String toString() {
  final _this = this as ExtractionJob;
  return 'ExtractionJob(id: ${_this.id}, sourceConversationId: ${_this.sourceConversationId}, sourceRevision: ${_this.sourceRevision}, completedChunkCount: ${_this.completedChunkCount}, totalChunks: ${_this.totalChunks}, candidatesFound: ${_this.candidatesFound}, startTime: ${_this.startTime}, chunkTimings: ${_this.chunkTimings}, progressTitle: ${_this.progressTitle}, progressBody: ${_this.progressBody}, completionTitle: ${_this.completionTitle}, queuedSourceConversationIds: ${_this.queuedSourceConversationIds}, batchIndex: ${_this.batchIndex}, batchTotal: ${_this.batchTotal})';
}


}

/// @nodoc
abstract mixin class $ExtractionJobCopyWith<$Res>  {
  factory $ExtractionJobCopyWith(ExtractionJob value, $Res Function(ExtractionJob) _then) = _$ExtractionJobCopyWithImpl;
@useResult
$Res call({
 String id, String sourceConversationId, int sourceRevision, int completedChunkCount, int totalChunks, int candidatesFound, DateTime startTime, List<double> chunkTimings, String progressTitle, String progressBody, String completionTitle, List<String> queuedSourceConversationIds, int batchIndex, int batchTotal
});




}
/// @nodoc
class _$ExtractionJobCopyWithImpl<$Res>
    implements $ExtractionJobCopyWith<$Res> {
  _$ExtractionJobCopyWithImpl(this._self, this._then);

  final ExtractionJob _self;
  final $Res Function(ExtractionJob) _then;

/// Create a copy of ExtractionJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceConversationId = null,Object? sourceRevision = null,Object? completedChunkCount = null,Object? totalChunks = null,Object? candidatesFound = null,Object? startTime = null,Object? chunkTimings = null,Object? progressTitle = null,Object? progressBody = null,Object? completionTitle = null,Object? queuedSourceConversationIds = null,Object? batchIndex = null,Object? batchTotal = null,}) {
  return _then(ExtractionJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceConversationId: null == sourceConversationId ? _self.sourceConversationId : sourceConversationId // ignore: cast_nullable_to_non_nullable
as String,sourceRevision: null == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int,completedChunkCount: null == completedChunkCount ? _self.completedChunkCount : completedChunkCount // ignore: cast_nullable_to_non_nullable
as int,totalChunks: null == totalChunks ? _self.totalChunks : totalChunks // ignore: cast_nullable_to_non_nullable
as int,candidatesFound: null == candidatesFound ? _self.candidatesFound : candidatesFound // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,chunkTimings: null == chunkTimings ? _self.chunkTimings : chunkTimings // ignore: cast_nullable_to_non_nullable
as List<double>,progressTitle: null == progressTitle ? _self.progressTitle : progressTitle // ignore: cast_nullable_to_non_nullable
as String,progressBody: null == progressBody ? _self.progressBody : progressBody // ignore: cast_nullable_to_non_nullable
as String,completionTitle: null == completionTitle ? _self.completionTitle : completionTitle // ignore: cast_nullable_to_non_nullable
as String,queuedSourceConversationIds: null == queuedSourceConversationIds ? _self.queuedSourceConversationIds : queuedSourceConversationIds // ignore: cast_nullable_to_non_nullable
as List<String>,batchIndex: null == batchIndex ? _self.batchIndex : batchIndex // ignore: cast_nullable_to_non_nullable
as int,batchTotal: null == batchTotal ? _self.batchTotal : batchTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractionJob].
extension ExtractionJobPatterns on ExtractionJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractionJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractionJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractionJob value)  $default,){
final _that = this;
switch (_that) {
case _ExtractionJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractionJob value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractionJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceConversationId,  int sourceRevision,  int completedChunkCount,  int totalChunks,  int candidatesFound,  DateTime startTime,  List<double> chunkTimings,  String progressTitle,  String progressBody,  String completionTitle,  List<String> queuedSourceConversationIds,  int batchIndex,  int batchTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractionJob() when $default != null:
return $default(_that.id,_that.sourceConversationId,_that.sourceRevision,_that.completedChunkCount,_that.totalChunks,_that.candidatesFound,_that.startTime,_that.chunkTimings,_that.progressTitle,_that.progressBody,_that.completionTitle,_that.queuedSourceConversationIds,_that.batchIndex,_that.batchTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceConversationId,  int sourceRevision,  int completedChunkCount,  int totalChunks,  int candidatesFound,  DateTime startTime,  List<double> chunkTimings,  String progressTitle,  String progressBody,  String completionTitle,  List<String> queuedSourceConversationIds,  int batchIndex,  int batchTotal)  $default,) {final _that = this;
switch (_that) {
case _ExtractionJob():
return $default(_that.id,_that.sourceConversationId,_that.sourceRevision,_that.completedChunkCount,_that.totalChunks,_that.candidatesFound,_that.startTime,_that.chunkTimings,_that.progressTitle,_that.progressBody,_that.completionTitle,_that.queuedSourceConversationIds,_that.batchIndex,_that.batchTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceConversationId,  int sourceRevision,  int completedChunkCount,  int totalChunks,  int candidatesFound,  DateTime startTime,  List<double> chunkTimings,  String progressTitle,  String progressBody,  String completionTitle,  List<String> queuedSourceConversationIds,  int batchIndex,  int batchTotal)?  $default,) {final _that = this;
switch (_that) {
case _ExtractionJob() when $default != null:
return $default(_that.id,_that.sourceConversationId,_that.sourceRevision,_that.completedChunkCount,_that.totalChunks,_that.candidatesFound,_that.startTime,_that.chunkTimings,_that.progressTitle,_that.progressBody,_that.completionTitle,_that.queuedSourceConversationIds,_that.batchIndex,_that.batchTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtractionJob extends ExtractionJob {
  const _ExtractionJob({this.id = kActiveExtractionJobId, required this.sourceConversationId, this.sourceRevision = 1, this.completedChunkCount = 0, this.totalChunks = 0, this.candidatesFound = 0, required this.startTime,  List<double> chunkTimings = const [], this.progressTitle = '', this.progressBody = '', this.completionTitle = '',  List<String> queuedSourceConversationIds = const [], this.batchIndex = 0, this.batchTotal = 1}): _chunkTimings = chunkTimings,_queuedSourceConversationIds = queuedSourceConversationIds,super._();
  factory _ExtractionJob.fromJson(Map<String, dynamic> json) => _$ExtractionJobFromJson(json);

@override@JsonKey() final  String id;
@override final  String sourceConversationId;
@override@JsonKey() final  int sourceRevision;
@override@JsonKey() final  int completedChunkCount;
@override@JsonKey() final  int totalChunks;
@override@JsonKey() final  int candidatesFound;
@override final  DateTime startTime;
 final  List<double> _chunkTimings;
@override@JsonKey() List<double> get chunkTimings {
  if (_chunkTimings is EqualUnmodifiableListView) return _chunkTimings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chunkTimings);
}

@override@JsonKey() final  String progressTitle;
@override@JsonKey() final  String progressBody;
@override@JsonKey() final  String completionTitle;
/// Remaining active source ids after [sourceConversationId], oldest→newest
/// for extract-all. Empty for a single-conversation run.
 final  List<String> _queuedSourceConversationIds;
/// Remaining active source ids after [sourceConversationId], oldest→newest
/// for extract-all. Empty for a single-conversation run.
@override@JsonKey() List<String> get queuedSourceConversationIds {
  if (_queuedSourceConversationIds is EqualUnmodifiableListView) return _queuedSourceConversationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queuedSourceConversationIds);
}

/// 0-based index of the conversation currently being extracted in a batch.
@override@JsonKey() final  int batchIndex;
/// Total conversations in this extract run (1 for a single pick).
@override@JsonKey() final  int batchTotal;

/// Create a copy of ExtractionJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractionJobCopyWith<_ExtractionJob> get copyWith => __$ExtractionJobCopyWithImpl<_ExtractionJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtractionJobToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractionJob&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceConversationId, sourceConversationId) || other.sourceConversationId == sourceConversationId)&&(identical(other.sourceRevision, sourceRevision) || other.sourceRevision == sourceRevision)&&(identical(other.completedChunkCount, completedChunkCount) || other.completedChunkCount == completedChunkCount)&&(identical(other.totalChunks, totalChunks) || other.totalChunks == totalChunks)&&(identical(other.candidatesFound, candidatesFound) || other.candidatesFound == candidatesFound)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&const DeepCollectionEquality().equals(other.chunkTimings, _chunkTimings)&&(identical(other.progressTitle, progressTitle) || other.progressTitle == progressTitle)&&(identical(other.progressBody, progressBody) || other.progressBody == progressBody)&&(identical(other.completionTitle, completionTitle) || other.completionTitle == completionTitle)&&const DeepCollectionEquality().equals(other.queuedSourceConversationIds, _queuedSourceConversationIds)&&(identical(other.batchIndex, batchIndex) || other.batchIndex == batchIndex)&&(identical(other.batchTotal, batchTotal) || other.batchTotal == batchTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sourceConversationId,sourceRevision,completedChunkCount,totalChunks,candidatesFound,startTime,const DeepCollectionEquality().hash(_chunkTimings),progressTitle,progressBody,completionTitle,const DeepCollectionEquality().hash(_queuedSourceConversationIds),batchIndex,batchTotal);
}

@override
String toString() {
    return 'ExtractionJob(id: $id, sourceConversationId: $sourceConversationId, sourceRevision: $sourceRevision, completedChunkCount: $completedChunkCount, totalChunks: $totalChunks, candidatesFound: $candidatesFound, startTime: $startTime, chunkTimings: $chunkTimings, progressTitle: $progressTitle, progressBody: $progressBody, completionTitle: $completionTitle, queuedSourceConversationIds: $queuedSourceConversationIds, batchIndex: $batchIndex, batchTotal: $batchTotal)';
}


}

/// @nodoc
abstract mixin class _$ExtractionJobCopyWith<$Res> implements $ExtractionJobCopyWith<$Res> {
  factory _$ExtractionJobCopyWith(_ExtractionJob value, $Res Function(_ExtractionJob) _then) = __$ExtractionJobCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceConversationId, int sourceRevision, int completedChunkCount, int totalChunks, int candidatesFound, DateTime startTime, List<double> chunkTimings, String progressTitle, String progressBody, String completionTitle, List<String> queuedSourceConversationIds, int batchIndex, int batchTotal
});




}
/// @nodoc
class __$ExtractionJobCopyWithImpl<$Res>
    implements _$ExtractionJobCopyWith<$Res> {
  __$ExtractionJobCopyWithImpl(this._self, this._then);

  final _ExtractionJob _self;
  final $Res Function(_ExtractionJob) _then;

/// Create a copy of ExtractionJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceConversationId = null,Object? sourceRevision = null,Object? completedChunkCount = null,Object? totalChunks = null,Object? candidatesFound = null,Object? startTime = null,Object? chunkTimings = null,Object? progressTitle = null,Object? progressBody = null,Object? completionTitle = null,Object? queuedSourceConversationIds = null,Object? batchIndex = null,Object? batchTotal = null,}) {
  return _then(_ExtractionJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceConversationId: null == sourceConversationId ? _self.sourceConversationId : sourceConversationId // ignore: cast_nullable_to_non_nullable
as String,sourceRevision: null == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int,completedChunkCount: null == completedChunkCount ? _self.completedChunkCount : completedChunkCount // ignore: cast_nullable_to_non_nullable
as int,totalChunks: null == totalChunks ? _self.totalChunks : totalChunks // ignore: cast_nullable_to_non_nullable
as int,candidatesFound: null == candidatesFound ? _self.candidatesFound : candidatesFound // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,chunkTimings: null == chunkTimings ? _self._chunkTimings : chunkTimings // ignore: cast_nullable_to_non_nullable
as List<double>,progressTitle: null == progressTitle ? _self.progressTitle : progressTitle // ignore: cast_nullable_to_non_nullable
as String,progressBody: null == progressBody ? _self.progressBody : progressBody // ignore: cast_nullable_to_non_nullable
as String,completionTitle: null == completionTitle ? _self.completionTitle : completionTitle // ignore: cast_nullable_to_non_nullable
as String,queuedSourceConversationIds: null == queuedSourceConversationIds ? _self._queuedSourceConversationIds : queuedSourceConversationIds // ignore: cast_nullable_to_non_nullable
as List<String>,batchIndex: null == batchIndex ? _self.batchIndex : batchIndex // ignore: cast_nullable_to_non_nullable
as int,batchTotal: null == batchTotal ? _self.batchTotal : batchTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
