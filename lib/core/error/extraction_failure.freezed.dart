// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extraction_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExtractionFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure()';
}


}

/// @nodoc
class $ExtractionFailureCopyWith<$Res>  {
$ExtractionFailureCopyWith(ExtractionFailure _, $Res Function(ExtractionFailure) __);
}


/// Adds pattern-matching-related methods to [ExtractionFailure].
extension ExtractionFailurePatterns on ExtractionFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExtractionNoSourceConversationFailure value)?  noSourceConversation,TResult Function( ExtractionSourceArchivedFailure value)?  sourceArchived,TResult Function( ExtractionInvalidInputFailure value)?  invalidInput,TResult Function( ExtractionModelUnavailableFailure value)?  modelUnavailable,TResult Function( ExtractionModelUnsupportedFailure value)?  modelUnsupported,TResult Function( ExtractionInvalidOutputFailure value)?  invalidOutput,TResult Function( ExtractionUnknownFailure value)?  unknown,TResult Function( ExtractionCancelledFailure value)?  cancelled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExtractionNoSourceConversationFailure() when noSourceConversation != null:
return noSourceConversation(_that);case ExtractionSourceArchivedFailure() when sourceArchived != null:
return sourceArchived(_that);case ExtractionInvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case ExtractionModelUnavailableFailure() when modelUnavailable != null:
return modelUnavailable(_that);case ExtractionModelUnsupportedFailure() when modelUnsupported != null:
return modelUnsupported(_that);case ExtractionInvalidOutputFailure() when invalidOutput != null:
return invalidOutput(_that);case ExtractionUnknownFailure() when unknown != null:
return unknown(_that);case ExtractionCancelledFailure() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExtractionNoSourceConversationFailure value)  noSourceConversation,required TResult Function( ExtractionSourceArchivedFailure value)  sourceArchived,required TResult Function( ExtractionInvalidInputFailure value)  invalidInput,required TResult Function( ExtractionModelUnavailableFailure value)  modelUnavailable,required TResult Function( ExtractionModelUnsupportedFailure value)  modelUnsupported,required TResult Function( ExtractionInvalidOutputFailure value)  invalidOutput,required TResult Function( ExtractionUnknownFailure value)  unknown,required TResult Function( ExtractionCancelledFailure value)  cancelled,}){
final _that = this;
switch (_that) {
case ExtractionNoSourceConversationFailure():
return noSourceConversation(_that);case ExtractionSourceArchivedFailure():
return sourceArchived(_that);case ExtractionInvalidInputFailure():
return invalidInput(_that);case ExtractionModelUnavailableFailure():
return modelUnavailable(_that);case ExtractionModelUnsupportedFailure():
return modelUnsupported(_that);case ExtractionInvalidOutputFailure():
return invalidOutput(_that);case ExtractionUnknownFailure():
return unknown(_that);case ExtractionCancelledFailure():
return cancelled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExtractionNoSourceConversationFailure value)?  noSourceConversation,TResult? Function( ExtractionSourceArchivedFailure value)?  sourceArchived,TResult? Function( ExtractionInvalidInputFailure value)?  invalidInput,TResult? Function( ExtractionModelUnavailableFailure value)?  modelUnavailable,TResult? Function( ExtractionModelUnsupportedFailure value)?  modelUnsupported,TResult? Function( ExtractionInvalidOutputFailure value)?  invalidOutput,TResult? Function( ExtractionUnknownFailure value)?  unknown,TResult? Function( ExtractionCancelledFailure value)?  cancelled,}){
final _that = this;
switch (_that) {
case ExtractionNoSourceConversationFailure() when noSourceConversation != null:
return noSourceConversation(_that);case ExtractionSourceArchivedFailure() when sourceArchived != null:
return sourceArchived(_that);case ExtractionInvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case ExtractionModelUnavailableFailure() when modelUnavailable != null:
return modelUnavailable(_that);case ExtractionModelUnsupportedFailure() when modelUnsupported != null:
return modelUnsupported(_that);case ExtractionInvalidOutputFailure() when invalidOutput != null:
return invalidOutput(_that);case ExtractionUnknownFailure() when unknown != null:
return unknown(_that);case ExtractionCancelledFailure() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  noSourceConversation,TResult Function()?  sourceArchived,TResult Function()?  invalidInput,TResult Function()?  modelUnavailable,TResult Function()?  modelUnsupported,TResult Function()?  invalidOutput,TResult Function()?  unknown,TResult Function()?  cancelled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExtractionNoSourceConversationFailure() when noSourceConversation != null:
return noSourceConversation();case ExtractionSourceArchivedFailure() when sourceArchived != null:
return sourceArchived();case ExtractionInvalidInputFailure() when invalidInput != null:
return invalidInput();case ExtractionModelUnavailableFailure() when modelUnavailable != null:
return modelUnavailable();case ExtractionModelUnsupportedFailure() when modelUnsupported != null:
return modelUnsupported();case ExtractionInvalidOutputFailure() when invalidOutput != null:
return invalidOutput();case ExtractionUnknownFailure() when unknown != null:
return unknown();case ExtractionCancelledFailure() when cancelled != null:
return cancelled();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  noSourceConversation,required TResult Function()  sourceArchived,required TResult Function()  invalidInput,required TResult Function()  modelUnavailable,required TResult Function()  modelUnsupported,required TResult Function()  invalidOutput,required TResult Function()  unknown,required TResult Function()  cancelled,}) {final _that = this;
switch (_that) {
case ExtractionNoSourceConversationFailure():
return noSourceConversation();case ExtractionSourceArchivedFailure():
return sourceArchived();case ExtractionInvalidInputFailure():
return invalidInput();case ExtractionModelUnavailableFailure():
return modelUnavailable();case ExtractionModelUnsupportedFailure():
return modelUnsupported();case ExtractionInvalidOutputFailure():
return invalidOutput();case ExtractionUnknownFailure():
return unknown();case ExtractionCancelledFailure():
return cancelled();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  noSourceConversation,TResult? Function()?  sourceArchived,TResult? Function()?  invalidInput,TResult? Function()?  modelUnavailable,TResult? Function()?  modelUnsupported,TResult? Function()?  invalidOutput,TResult? Function()?  unknown,TResult? Function()?  cancelled,}) {final _that = this;
switch (_that) {
case ExtractionNoSourceConversationFailure() when noSourceConversation != null:
return noSourceConversation();case ExtractionSourceArchivedFailure() when sourceArchived != null:
return sourceArchived();case ExtractionInvalidInputFailure() when invalidInput != null:
return invalidInput();case ExtractionModelUnavailableFailure() when modelUnavailable != null:
return modelUnavailable();case ExtractionModelUnsupportedFailure() when modelUnsupported != null:
return modelUnsupported();case ExtractionInvalidOutputFailure() when invalidOutput != null:
return invalidOutput();case ExtractionUnknownFailure() when unknown != null:
return unknown();case ExtractionCancelledFailure() when cancelled != null:
return cancelled();case _:
  return null;

}
}

}

/// @nodoc


class ExtractionNoSourceConversationFailure implements ExtractionFailure {
  const ExtractionNoSourceConversationFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionNoSourceConversationFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure.noSourceConversation()';
}


}




/// @nodoc


class ExtractionSourceArchivedFailure implements ExtractionFailure {
  const ExtractionSourceArchivedFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionSourceArchivedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure.sourceArchived()';
}


}




/// @nodoc


class ExtractionInvalidInputFailure implements ExtractionFailure {
  const ExtractionInvalidInputFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionInvalidInputFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure.invalidInput()';
}


}




/// @nodoc


class ExtractionModelUnavailableFailure implements ExtractionFailure {
  const ExtractionModelUnavailableFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionModelUnavailableFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure.modelUnavailable()';
}


}




/// @nodoc


class ExtractionModelUnsupportedFailure implements ExtractionFailure {
  const ExtractionModelUnsupportedFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionModelUnsupportedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure.modelUnsupported()';
}


}




/// @nodoc


class ExtractionInvalidOutputFailure implements ExtractionFailure {
  const ExtractionInvalidOutputFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionInvalidOutputFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure.invalidOutput()';
}


}




/// @nodoc


class ExtractionUnknownFailure implements ExtractionFailure {
  const ExtractionUnknownFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionUnknownFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure.unknown()';
}


}




/// @nodoc


class ExtractionCancelledFailure implements ExtractionFailure {
  const ExtractionCancelledFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionCancelledFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExtractionFailure.cancelled()';
}


}




// dart format on
