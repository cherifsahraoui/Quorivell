// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_persistence_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalPersistenceFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPersistenceFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LocalPersistenceFailure()';
}


}

/// @nodoc
class $LocalPersistenceFailureCopyWith<$Res>  {
$LocalPersistenceFailureCopyWith(LocalPersistenceFailure _, $Res Function(LocalPersistenceFailure) __);
}


/// Adds pattern-matching-related methods to [LocalPersistenceFailure].
extension LocalPersistenceFailurePatterns on LocalPersistenceFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LocalPersistenceNotFoundFailure value)?  notFound,TResult Function( LocalPersistenceInvalidInputFailure value)?  invalidInput,TResult Function( LocalPersistenceAlreadyExistsFailure value)?  alreadyExists,TResult Function( LocalPersistenceReadFailedFailure value)?  readFailed,TResult Function( LocalPersistenceWriteFailedFailure value)?  writeFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LocalPersistenceNotFoundFailure() when notFound != null:
return notFound(_that);case LocalPersistenceInvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case LocalPersistenceAlreadyExistsFailure() when alreadyExists != null:
return alreadyExists(_that);case LocalPersistenceReadFailedFailure() when readFailed != null:
return readFailed(_that);case LocalPersistenceWriteFailedFailure() when writeFailed != null:
return writeFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LocalPersistenceNotFoundFailure value)  notFound,required TResult Function( LocalPersistenceInvalidInputFailure value)  invalidInput,required TResult Function( LocalPersistenceAlreadyExistsFailure value)  alreadyExists,required TResult Function( LocalPersistenceReadFailedFailure value)  readFailed,required TResult Function( LocalPersistenceWriteFailedFailure value)  writeFailed,}){
final _that = this;
switch (_that) {
case LocalPersistenceNotFoundFailure():
return notFound(_that);case LocalPersistenceInvalidInputFailure():
return invalidInput(_that);case LocalPersistenceAlreadyExistsFailure():
return alreadyExists(_that);case LocalPersistenceReadFailedFailure():
return readFailed(_that);case LocalPersistenceWriteFailedFailure():
return writeFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LocalPersistenceNotFoundFailure value)?  notFound,TResult? Function( LocalPersistenceInvalidInputFailure value)?  invalidInput,TResult? Function( LocalPersistenceAlreadyExistsFailure value)?  alreadyExists,TResult? Function( LocalPersistenceReadFailedFailure value)?  readFailed,TResult? Function( LocalPersistenceWriteFailedFailure value)?  writeFailed,}){
final _that = this;
switch (_that) {
case LocalPersistenceNotFoundFailure() when notFound != null:
return notFound(_that);case LocalPersistenceInvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case LocalPersistenceAlreadyExistsFailure() when alreadyExists != null:
return alreadyExists(_that);case LocalPersistenceReadFailedFailure() when readFailed != null:
return readFailed(_that);case LocalPersistenceWriteFailedFailure() when writeFailed != null:
return writeFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  notFound,TResult Function()?  invalidInput,TResult Function()?  alreadyExists,TResult Function()?  readFailed,TResult Function()?  writeFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LocalPersistenceNotFoundFailure() when notFound != null:
return notFound();case LocalPersistenceInvalidInputFailure() when invalidInput != null:
return invalidInput();case LocalPersistenceAlreadyExistsFailure() when alreadyExists != null:
return alreadyExists();case LocalPersistenceReadFailedFailure() when readFailed != null:
return readFailed();case LocalPersistenceWriteFailedFailure() when writeFailed != null:
return writeFailed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  notFound,required TResult Function()  invalidInput,required TResult Function()  alreadyExists,required TResult Function()  readFailed,required TResult Function()  writeFailed,}) {final _that = this;
switch (_that) {
case LocalPersistenceNotFoundFailure():
return notFound();case LocalPersistenceInvalidInputFailure():
return invalidInput();case LocalPersistenceAlreadyExistsFailure():
return alreadyExists();case LocalPersistenceReadFailedFailure():
return readFailed();case LocalPersistenceWriteFailedFailure():
return writeFailed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  notFound,TResult? Function()?  invalidInput,TResult? Function()?  alreadyExists,TResult? Function()?  readFailed,TResult? Function()?  writeFailed,}) {final _that = this;
switch (_that) {
case LocalPersistenceNotFoundFailure() when notFound != null:
return notFound();case LocalPersistenceInvalidInputFailure() when invalidInput != null:
return invalidInput();case LocalPersistenceAlreadyExistsFailure() when alreadyExists != null:
return alreadyExists();case LocalPersistenceReadFailedFailure() when readFailed != null:
return readFailed();case LocalPersistenceWriteFailedFailure() when writeFailed != null:
return writeFailed();case _:
  return null;

}
}

}

/// @nodoc


class LocalPersistenceNotFoundFailure implements LocalPersistenceFailure {
  const LocalPersistenceNotFoundFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPersistenceNotFoundFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LocalPersistenceFailure.notFound()';
}


}




/// @nodoc


class LocalPersistenceInvalidInputFailure implements LocalPersistenceFailure {
  const LocalPersistenceInvalidInputFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPersistenceInvalidInputFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LocalPersistenceFailure.invalidInput()';
}


}




/// @nodoc


class LocalPersistenceAlreadyExistsFailure implements LocalPersistenceFailure {
  const LocalPersistenceAlreadyExistsFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPersistenceAlreadyExistsFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LocalPersistenceFailure.alreadyExists()';
}


}




/// @nodoc


class LocalPersistenceReadFailedFailure implements LocalPersistenceFailure {
  const LocalPersistenceReadFailedFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPersistenceReadFailedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LocalPersistenceFailure.readFailed()';
}


}




/// @nodoc


class LocalPersistenceWriteFailedFailure implements LocalPersistenceFailure {
  const LocalPersistenceWriteFailedFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPersistenceWriteFailedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LocalPersistenceFailure.writeFailed()';
}


}




// dart format on
