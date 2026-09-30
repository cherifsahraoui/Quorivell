// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extraction_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExtractionProgress {

 int get currentChunk; int get totalChunks; int get candidatesFound; List<double> get chunkTimings; DateTime get startTime; DateTime? get endTime;/// 0-based conversation index within a multi-extract batch.
 int get batchIndex;/// Conversations in this extract run (1 when extracting a single capture).
 int get batchTotal;
/// Create a copy of ExtractionProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractionProgressCopyWith<ExtractionProgress> get copyWith => _$ExtractionProgressCopyWithImpl<ExtractionProgress>(this as ExtractionProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExtractionProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionProgress&&(identical(other.currentChunk, _this.currentChunk) || other.currentChunk == _this.currentChunk)&&(identical(other.totalChunks, _this.totalChunks) || other.totalChunks == _this.totalChunks)&&(identical(other.candidatesFound, _this.candidatesFound) || other.candidatesFound == _this.candidatesFound)&&const DeepCollectionEquality().equals(other.chunkTimings, _this.chunkTimings)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime)&&(identical(other.batchIndex, _this.batchIndex) || other.batchIndex == _this.batchIndex)&&(identical(other.batchTotal, _this.batchTotal) || other.batchTotal == _this.batchTotal));
}


@override
int get hashCode {
  final _this = this as ExtractionProgress;
  return Object.hash(runtimeType,_this.currentChunk,_this.totalChunks,_this.candidatesFound,const DeepCollectionEquality().hash(_this.chunkTimings),_this.startTime,_this.endTime,_this.batchIndex,_this.batchTotal);
}

@override
String toString() {
  final _this = this as ExtractionProgress;
  return 'ExtractionProgress(currentChunk: ${_this.currentChunk}, totalChunks: ${_this.totalChunks}, candidatesFound: ${_this.candidatesFound}, chunkTimings: ${_this.chunkTimings}, startTime: ${_this.startTime}, endTime: ${_this.endTime}, batchIndex: ${_this.batchIndex}, batchTotal: ${_this.batchTotal})';
}


}

/// @nodoc
abstract mixin class $ExtractionProgressCopyWith<$Res>  {
  factory $ExtractionProgressCopyWith(ExtractionProgress value, $Res Function(ExtractionProgress) _then) = _$ExtractionProgressCopyWithImpl;
@useResult
$Res call({
 int currentChunk, int totalChunks, int candidatesFound, List<double> chunkTimings, DateTime startTime, DateTime? endTime, int batchIndex, int batchTotal
});




}
/// @nodoc
class _$ExtractionProgressCopyWithImpl<$Res>
    implements $ExtractionProgressCopyWith<$Res> {
  _$ExtractionProgressCopyWithImpl(this._self, this._then);

  final ExtractionProgress _self;
  final $Res Function(ExtractionProgress) _then;

/// Create a copy of ExtractionProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentChunk = null,Object? totalChunks = null,Object? candidatesFound = null,Object? chunkTimings = null,Object? startTime = null,Object? endTime = freezed,Object? batchIndex = null,Object? batchTotal = null,}) {
  return _then(ExtractionProgress(
currentChunk: null == currentChunk ? _self.currentChunk : currentChunk // ignore: cast_nullable_to_non_nullable
as int,totalChunks: null == totalChunks ? _self.totalChunks : totalChunks // ignore: cast_nullable_to_non_nullable
as int,candidatesFound: null == candidatesFound ? _self.candidatesFound : candidatesFound // ignore: cast_nullable_to_non_nullable
as int,chunkTimings: null == chunkTimings ? _self.chunkTimings : chunkTimings // ignore: cast_nullable_to_non_nullable
as List<double>,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,batchIndex: null == batchIndex ? _self.batchIndex : batchIndex // ignore: cast_nullable_to_non_nullable
as int,batchTotal: null == batchTotal ? _self.batchTotal : batchTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractionProgress].
extension ExtractionProgressPatterns on ExtractionProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractionProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractionProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractionProgress value)  $default,){
final _that = this;
switch (_that) {
case _ExtractionProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractionProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractionProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentChunk,  int totalChunks,  int candidatesFound,  List<double> chunkTimings,  DateTime startTime,  DateTime? endTime,  int batchIndex,  int batchTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractionProgress() when $default != null:
return $default(_that.currentChunk,_that.totalChunks,_that.candidatesFound,_that.chunkTimings,_that.startTime,_that.endTime,_that.batchIndex,_that.batchTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentChunk,  int totalChunks,  int candidatesFound,  List<double> chunkTimings,  DateTime startTime,  DateTime? endTime,  int batchIndex,  int batchTotal)  $default,) {final _that = this;
switch (_that) {
case _ExtractionProgress():
return $default(_that.currentChunk,_that.totalChunks,_that.candidatesFound,_that.chunkTimings,_that.startTime,_that.endTime,_that.batchIndex,_that.batchTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentChunk,  int totalChunks,  int candidatesFound,  List<double> chunkTimings,  DateTime startTime,  DateTime? endTime,  int batchIndex,  int batchTotal)?  $default,) {final _that = this;
switch (_that) {
case _ExtractionProgress() when $default != null:
return $default(_that.currentChunk,_that.totalChunks,_that.candidatesFound,_that.chunkTimings,_that.startTime,_that.endTime,_that.batchIndex,_that.batchTotal);case _:
  return null;

}
}

}

/// @nodoc


class _ExtractionProgress extends ExtractionProgress {
  const _ExtractionProgress({required this.currentChunk, required this.totalChunks, required this.candidatesFound, required  List<double> chunkTimings, required this.startTime, this.endTime, this.batchIndex = 0, this.batchTotal = 1}): _chunkTimings = chunkTimings,super._();
  

@override final  int currentChunk;
@override final  int totalChunks;
@override final  int candidatesFound;
 final  List<double> _chunkTimings;
@override List<double> get chunkTimings {
  if (_chunkTimings is EqualUnmodifiableListView) return _chunkTimings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chunkTimings);
}

@override final  DateTime startTime;
@override final  DateTime? endTime;
/// 0-based conversation index within a multi-extract batch.
@override@JsonKey() final  int batchIndex;
/// Conversations in this extract run (1 when extracting a single capture).
@override@JsonKey() final  int batchTotal;

/// Create a copy of ExtractionProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractionProgressCopyWith<_ExtractionProgress> get copyWith => __$ExtractionProgressCopyWithImpl<_ExtractionProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractionProgress&&(identical(other.currentChunk, currentChunk) || other.currentChunk == currentChunk)&&(identical(other.totalChunks, totalChunks) || other.totalChunks == totalChunks)&&(identical(other.candidatesFound, candidatesFound) || other.candidatesFound == candidatesFound)&&const DeepCollectionEquality().equals(other.chunkTimings, _chunkTimings)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.batchIndex, batchIndex) || other.batchIndex == batchIndex)&&(identical(other.batchTotal, batchTotal) || other.batchTotal == batchTotal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentChunk,totalChunks,candidatesFound,const DeepCollectionEquality().hash(_chunkTimings),startTime,endTime,batchIndex,batchTotal);
}

@override
String toString() {
    return 'ExtractionProgress(currentChunk: $currentChunk, totalChunks: $totalChunks, candidatesFound: $candidatesFound, chunkTimings: $chunkTimings, startTime: $startTime, endTime: $endTime, batchIndex: $batchIndex, batchTotal: $batchTotal)';
}


}

/// @nodoc
abstract mixin class _$ExtractionProgressCopyWith<$Res> implements $ExtractionProgressCopyWith<$Res> {
  factory _$ExtractionProgressCopyWith(_ExtractionProgress value, $Res Function(_ExtractionProgress) _then) = __$ExtractionProgressCopyWithImpl;
@override @useResult
$Res call({
 int currentChunk, int totalChunks, int candidatesFound, List<double> chunkTimings, DateTime startTime, DateTime? endTime, int batchIndex, int batchTotal
});




}
/// @nodoc
class __$ExtractionProgressCopyWithImpl<$Res>
    implements _$ExtractionProgressCopyWith<$Res> {
  __$ExtractionProgressCopyWithImpl(this._self, this._then);

  final _ExtractionProgress _self;
  final $Res Function(_ExtractionProgress) _then;

/// Create a copy of ExtractionProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentChunk = null,Object? totalChunks = null,Object? candidatesFound = null,Object? chunkTimings = null,Object? startTime = null,Object? endTime = freezed,Object? batchIndex = null,Object? batchTotal = null,}) {
  return _then(_ExtractionProgress(
currentChunk: null == currentChunk ? _self.currentChunk : currentChunk // ignore: cast_nullable_to_non_nullable
as int,totalChunks: null == totalChunks ? _self.totalChunks : totalChunks // ignore: cast_nullable_to_non_nullable
as int,candidatesFound: null == candidatesFound ? _self.candidatesFound : candidatesFound // ignore: cast_nullable_to_non_nullable
as int,chunkTimings: null == chunkTimings ? _self._chunkTimings : chunkTimings // ignore: cast_nullable_to_non_nullable
as List<double>,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,batchIndex: null == batchIndex ? _self.batchIndex : batchIndex // ignore: cast_nullable_to_non_nullable
as int,batchTotal: null == batchTotal ? _self.batchTotal : batchTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ExtractionMetrics {

 double get totalSeconds; double get tokensPerSecond; List<double> get chunkTimings; int get totalCandidates;
/// Create a copy of ExtractionMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractionMetricsCopyWith<ExtractionMetrics> get copyWith => _$ExtractionMetricsCopyWithImpl<ExtractionMetrics>(this as ExtractionMetrics, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExtractionMetrics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionMetrics&&(identical(other.totalSeconds, _this.totalSeconds) || other.totalSeconds == _this.totalSeconds)&&(identical(other.tokensPerSecond, _this.tokensPerSecond) || other.tokensPerSecond == _this.tokensPerSecond)&&const DeepCollectionEquality().equals(other.chunkTimings, _this.chunkTimings)&&(identical(other.totalCandidates, _this.totalCandidates) || other.totalCandidates == _this.totalCandidates));
}


@override
int get hashCode {
  final _this = this as ExtractionMetrics;
  return Object.hash(runtimeType,_this.totalSeconds,_this.tokensPerSecond,const DeepCollectionEquality().hash(_this.chunkTimings),_this.totalCandidates);
}

@override
String toString() {
  final _this = this as ExtractionMetrics;
  return 'ExtractionMetrics(totalSeconds: ${_this.totalSeconds}, tokensPerSecond: ${_this.tokensPerSecond}, chunkTimings: ${_this.chunkTimings}, totalCandidates: ${_this.totalCandidates})';
}


}

/// @nodoc
abstract mixin class $ExtractionMetricsCopyWith<$Res>  {
  factory $ExtractionMetricsCopyWith(ExtractionMetrics value, $Res Function(ExtractionMetrics) _then) = _$ExtractionMetricsCopyWithImpl;
@useResult
$Res call({
 double totalSeconds, double tokensPerSecond, List<double> chunkTimings, int totalCandidates
});




}
/// @nodoc
class _$ExtractionMetricsCopyWithImpl<$Res>
    implements $ExtractionMetricsCopyWith<$Res> {
  _$ExtractionMetricsCopyWithImpl(this._self, this._then);

  final ExtractionMetrics _self;
  final $Res Function(ExtractionMetrics) _then;

/// Create a copy of ExtractionMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSeconds = null,Object? tokensPerSecond = null,Object? chunkTimings = null,Object? totalCandidates = null,}) {
  return _then(ExtractionMetrics(
totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as double,tokensPerSecond: null == tokensPerSecond ? _self.tokensPerSecond : tokensPerSecond // ignore: cast_nullable_to_non_nullable
as double,chunkTimings: null == chunkTimings ? _self.chunkTimings : chunkTimings // ignore: cast_nullable_to_non_nullable
as List<double>,totalCandidates: null == totalCandidates ? _self.totalCandidates : totalCandidates // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractionMetrics].
extension ExtractionMetricsPatterns on ExtractionMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractionMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractionMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractionMetrics value)  $default,){
final _that = this;
switch (_that) {
case _ExtractionMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractionMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractionMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalSeconds,  double tokensPerSecond,  List<double> chunkTimings,  int totalCandidates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractionMetrics() when $default != null:
return $default(_that.totalSeconds,_that.tokensPerSecond,_that.chunkTimings,_that.totalCandidates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalSeconds,  double tokensPerSecond,  List<double> chunkTimings,  int totalCandidates)  $default,) {final _that = this;
switch (_that) {
case _ExtractionMetrics():
return $default(_that.totalSeconds,_that.tokensPerSecond,_that.chunkTimings,_that.totalCandidates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalSeconds,  double tokensPerSecond,  List<double> chunkTimings,  int totalCandidates)?  $default,) {final _that = this;
switch (_that) {
case _ExtractionMetrics() when $default != null:
return $default(_that.totalSeconds,_that.tokensPerSecond,_that.chunkTimings,_that.totalCandidates);case _:
  return null;

}
}

}

/// @nodoc


class _ExtractionMetrics implements ExtractionMetrics {
  const _ExtractionMetrics({required this.totalSeconds, required this.tokensPerSecond, required  List<double> chunkTimings, required this.totalCandidates}): _chunkTimings = chunkTimings;
  

@override final  double totalSeconds;
@override final  double tokensPerSecond;
 final  List<double> _chunkTimings;
@override List<double> get chunkTimings {
  if (_chunkTimings is EqualUnmodifiableListView) return _chunkTimings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chunkTimings);
}

@override final  int totalCandidates;

/// Create a copy of ExtractionMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractionMetricsCopyWith<_ExtractionMetrics> get copyWith => __$ExtractionMetricsCopyWithImpl<_ExtractionMetrics>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractionMetrics&&(identical(other.totalSeconds, totalSeconds) || other.totalSeconds == totalSeconds)&&(identical(other.tokensPerSecond, tokensPerSecond) || other.tokensPerSecond == tokensPerSecond)&&const DeepCollectionEquality().equals(other.chunkTimings, _chunkTimings)&&(identical(other.totalCandidates, totalCandidates) || other.totalCandidates == totalCandidates));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalSeconds,tokensPerSecond,const DeepCollectionEquality().hash(_chunkTimings),totalCandidates);
}

@override
String toString() {
    return 'ExtractionMetrics(totalSeconds: $totalSeconds, tokensPerSecond: $tokensPerSecond, chunkTimings: $chunkTimings, totalCandidates: $totalCandidates)';
}


}

/// @nodoc
abstract mixin class _$ExtractionMetricsCopyWith<$Res> implements $ExtractionMetricsCopyWith<$Res> {
  factory _$ExtractionMetricsCopyWith(_ExtractionMetrics value, $Res Function(_ExtractionMetrics) _then) = __$ExtractionMetricsCopyWithImpl;
@override @useResult
$Res call({
 double totalSeconds, double tokensPerSecond, List<double> chunkTimings, int totalCandidates
});




}
/// @nodoc
class __$ExtractionMetricsCopyWithImpl<$Res>
    implements _$ExtractionMetricsCopyWith<$Res> {
  __$ExtractionMetricsCopyWithImpl(this._self, this._then);

  final _ExtractionMetrics _self;
  final $Res Function(_ExtractionMetrics) _then;

/// Create a copy of ExtractionMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSeconds = null,Object? tokensPerSecond = null,Object? chunkTimings = null,Object? totalCandidates = null,}) {
  return _then(_ExtractionMetrics(
totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as double,tokensPerSecond: null == tokensPerSecond ? _self.tokensPerSecond : tokensPerSecond // ignore: cast_nullable_to_non_nullable
as double,chunkTimings: null == chunkTimings ? _self._chunkTimings : chunkTimings // ignore: cast_nullable_to_non_nullable
as List<double>,totalCandidates: null == totalCandidates ? _self.totalCandidates : totalCandidates // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
