// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatFailure()';
}


}

/// @nodoc
class $ChatFailureCopyWith<$Res>  {
$ChatFailureCopyWith(ChatFailure _, $Res Function(ChatFailure) __);
}


/// Adds pattern-matching-related methods to [ChatFailure].
extension ChatFailurePatterns on ChatFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatInvalidInputFailure value)?  invalidInput,TResult Function( ChatModelUnavailableFailure value)?  modelUnavailable,TResult Function( ChatUnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatInvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case ChatModelUnavailableFailure() when modelUnavailable != null:
return modelUnavailable(_that);case ChatUnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatInvalidInputFailure value)  invalidInput,required TResult Function( ChatModelUnavailableFailure value)  modelUnavailable,required TResult Function( ChatUnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case ChatInvalidInputFailure():
return invalidInput(_that);case ChatModelUnavailableFailure():
return modelUnavailable(_that);case ChatUnknownFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatInvalidInputFailure value)?  invalidInput,TResult? Function( ChatModelUnavailableFailure value)?  modelUnavailable,TResult? Function( ChatUnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case ChatInvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case ChatModelUnavailableFailure() when modelUnavailable != null:
return modelUnavailable(_that);case ChatUnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidInput,TResult Function()?  modelUnavailable,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatInvalidInputFailure() when invalidInput != null:
return invalidInput();case ChatModelUnavailableFailure() when modelUnavailable != null:
return modelUnavailable();case ChatUnknownFailure() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidInput,required TResult Function()  modelUnavailable,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case ChatInvalidInputFailure():
return invalidInput();case ChatModelUnavailableFailure():
return modelUnavailable();case ChatUnknownFailure():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidInput,TResult? Function()?  modelUnavailable,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case ChatInvalidInputFailure() when invalidInput != null:
return invalidInput();case ChatModelUnavailableFailure() when modelUnavailable != null:
return modelUnavailable();case ChatUnknownFailure() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc


class ChatInvalidInputFailure implements ChatFailure {
  const ChatInvalidInputFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInvalidInputFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatFailure.invalidInput()';
}


}




/// @nodoc


class ChatModelUnavailableFailure implements ChatFailure {
  const ChatModelUnavailableFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatModelUnavailableFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatFailure.modelUnavailable()';
}


}




/// @nodoc


class ChatUnknownFailure implements ChatFailure {
  const ChatUnknownFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUnknownFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatFailure.unknown()';
}


}




// dart format on
