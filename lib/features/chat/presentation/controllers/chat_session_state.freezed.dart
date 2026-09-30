// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatSessionState {

 String? get threadId; bool get draftNew; bool get isGenerating; String get streamingText; bool get autoScrollEnabled; AppFailure? get sendFailure;
/// Create a copy of ChatSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSessionStateCopyWith<ChatSessionState> get copyWith => _$ChatSessionStateCopyWithImpl<ChatSessionState>(this as ChatSessionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChatSessionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSessionState&&(identical(other.threadId, _this.threadId) || other.threadId == _this.threadId)&&(identical(other.draftNew, _this.draftNew) || other.draftNew == _this.draftNew)&&(identical(other.isGenerating, _this.isGenerating) || other.isGenerating == _this.isGenerating)&&(identical(other.streamingText, _this.streamingText) || other.streamingText == _this.streamingText)&&(identical(other.autoScrollEnabled, _this.autoScrollEnabled) || other.autoScrollEnabled == _this.autoScrollEnabled)&&(identical(other.sendFailure, _this.sendFailure) || other.sendFailure == _this.sendFailure));
}


@override
int get hashCode {
  final _this = this as ChatSessionState;
  return Object.hash(runtimeType,_this.threadId,_this.draftNew,_this.isGenerating,_this.streamingText,_this.autoScrollEnabled,_this.sendFailure);
}

@override
String toString() {
  final _this = this as ChatSessionState;
  return 'ChatSessionState(threadId: ${_this.threadId}, draftNew: ${_this.draftNew}, isGenerating: ${_this.isGenerating}, streamingText: ${_this.streamingText}, autoScrollEnabled: ${_this.autoScrollEnabled}, sendFailure: ${_this.sendFailure})';
}


}

/// @nodoc
abstract mixin class $ChatSessionStateCopyWith<$Res>  {
  factory $ChatSessionStateCopyWith(ChatSessionState value, $Res Function(ChatSessionState) _then) = _$ChatSessionStateCopyWithImpl;
@useResult
$Res call({
 String? threadId, bool draftNew, bool isGenerating, String streamingText, bool autoScrollEnabled, AppFailure? sendFailure
});




}
/// @nodoc
class _$ChatSessionStateCopyWithImpl<$Res>
    implements $ChatSessionStateCopyWith<$Res> {
  _$ChatSessionStateCopyWithImpl(this._self, this._then);

  final ChatSessionState _self;
  final $Res Function(ChatSessionState) _then;

/// Create a copy of ChatSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? threadId = freezed,Object? draftNew = null,Object? isGenerating = null,Object? streamingText = null,Object? autoScrollEnabled = null,Object? sendFailure = freezed,}) {
  return _then(ChatSessionState(
threadId: freezed == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String?,draftNew: null == draftNew ? _self.draftNew : draftNew // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,streamingText: null == streamingText ? _self.streamingText : streamingText // ignore: cast_nullable_to_non_nullable
as String,autoScrollEnabled: null == autoScrollEnabled ? _self.autoScrollEnabled : autoScrollEnabled // ignore: cast_nullable_to_non_nullable
as bool,sendFailure: freezed == sendFailure ? _self.sendFailure : sendFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSessionState].
extension ChatSessionStatePatterns on ChatSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSessionState value)  $default,){
final _that = this;
switch (_that) {
case _ChatSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? threadId,  bool draftNew,  bool isGenerating,  String streamingText,  bool autoScrollEnabled,  AppFailure? sendFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSessionState() when $default != null:
return $default(_that.threadId,_that.draftNew,_that.isGenerating,_that.streamingText,_that.autoScrollEnabled,_that.sendFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? threadId,  bool draftNew,  bool isGenerating,  String streamingText,  bool autoScrollEnabled,  AppFailure? sendFailure)  $default,) {final _that = this;
switch (_that) {
case _ChatSessionState():
return $default(_that.threadId,_that.draftNew,_that.isGenerating,_that.streamingText,_that.autoScrollEnabled,_that.sendFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? threadId,  bool draftNew,  bool isGenerating,  String streamingText,  bool autoScrollEnabled,  AppFailure? sendFailure)?  $default,) {final _that = this;
switch (_that) {
case _ChatSessionState() when $default != null:
return $default(_that.threadId,_that.draftNew,_that.isGenerating,_that.streamingText,_that.autoScrollEnabled,_that.sendFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ChatSessionState implements ChatSessionState {
  const _ChatSessionState({this.threadId, this.draftNew = true, this.isGenerating = false, this.streamingText = '', this.autoScrollEnabled = true, this.sendFailure});
  

@override final  String? threadId;
@override@JsonKey() final  bool draftNew;
@override@JsonKey() final  bool isGenerating;
@override@JsonKey() final  String streamingText;
@override@JsonKey() final  bool autoScrollEnabled;
@override final  AppFailure? sendFailure;

/// Create a copy of ChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSessionStateCopyWith<_ChatSessionState> get copyWith => __$ChatSessionStateCopyWithImpl<_ChatSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSessionState&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.draftNew, draftNew) || other.draftNew == draftNew)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.streamingText, streamingText) || other.streamingText == streamingText)&&(identical(other.autoScrollEnabled, autoScrollEnabled) || other.autoScrollEnabled == autoScrollEnabled)&&(identical(other.sendFailure, sendFailure) || other.sendFailure == sendFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,threadId,draftNew,isGenerating,streamingText,autoScrollEnabled,sendFailure);
}

@override
String toString() {
    return 'ChatSessionState(threadId: $threadId, draftNew: $draftNew, isGenerating: $isGenerating, streamingText: $streamingText, autoScrollEnabled: $autoScrollEnabled, sendFailure: $sendFailure)';
}


}

/// @nodoc
abstract mixin class _$ChatSessionStateCopyWith<$Res> implements $ChatSessionStateCopyWith<$Res> {
  factory _$ChatSessionStateCopyWith(_ChatSessionState value, $Res Function(_ChatSessionState) _then) = __$ChatSessionStateCopyWithImpl;
@override @useResult
$Res call({
 String? threadId, bool draftNew, bool isGenerating, String streamingText, bool autoScrollEnabled, AppFailure? sendFailure
});




}
/// @nodoc
class __$ChatSessionStateCopyWithImpl<$Res>
    implements _$ChatSessionStateCopyWith<$Res> {
  __$ChatSessionStateCopyWithImpl(this._self, this._then);

  final _ChatSessionState _self;
  final $Res Function(_ChatSessionState) _then;

/// Create a copy of ChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? threadId = freezed,Object? draftNew = null,Object? isGenerating = null,Object? streamingText = null,Object? autoScrollEnabled = null,Object? sendFailure = freezed,}) {
  return _then(_ChatSessionState(
threadId: freezed == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String?,draftNew: null == draftNew ? _self.draftNew : draftNew // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,streamingText: null == streamingText ? _self.streamingText : streamingText // ignore: cast_nullable_to_non_nullable
as String,autoScrollEnabled: null == autoScrollEnabled ? _self.autoScrollEnabled : autoScrollEnabled // ignore: cast_nullable_to_non_nullable
as bool,sendFailure: freezed == sendFailure ? _self.sendFailure : sendFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
