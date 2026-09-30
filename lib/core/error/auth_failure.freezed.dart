// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure()';
}


}

/// @nodoc
class $AuthFailureCopyWith<$Res>  {
$AuthFailureCopyWith(AuthFailure _, $Res Function(AuthFailure) __);
}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthInvalidCredentialsFailure value)?  invalidCredentials,TResult Function( AuthUserDisabledFailure value)?  userDisabled,TResult Function( AuthTooManyRequestsFailure value)?  tooManyRequests,TResult Function( AuthNetworkFailure value)?  network,TResult Function( AuthMissingUserFailure value)?  missingUser,TResult Function( AuthUnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthInvalidCredentialsFailure() when invalidCredentials != null:
return invalidCredentials(_that);case AuthUserDisabledFailure() when userDisabled != null:
return userDisabled(_that);case AuthTooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case AuthNetworkFailure() when network != null:
return network(_that);case AuthMissingUserFailure() when missingUser != null:
return missingUser(_that);case AuthUnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthInvalidCredentialsFailure value)  invalidCredentials,required TResult Function( AuthUserDisabledFailure value)  userDisabled,required TResult Function( AuthTooManyRequestsFailure value)  tooManyRequests,required TResult Function( AuthNetworkFailure value)  network,required TResult Function( AuthMissingUserFailure value)  missingUser,required TResult Function( AuthUnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case AuthInvalidCredentialsFailure():
return invalidCredentials(_that);case AuthUserDisabledFailure():
return userDisabled(_that);case AuthTooManyRequestsFailure():
return tooManyRequests(_that);case AuthNetworkFailure():
return network(_that);case AuthMissingUserFailure():
return missingUser(_that);case AuthUnknownFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthInvalidCredentialsFailure value)?  invalidCredentials,TResult? Function( AuthUserDisabledFailure value)?  userDisabled,TResult? Function( AuthTooManyRequestsFailure value)?  tooManyRequests,TResult? Function( AuthNetworkFailure value)?  network,TResult? Function( AuthMissingUserFailure value)?  missingUser,TResult? Function( AuthUnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case AuthInvalidCredentialsFailure() when invalidCredentials != null:
return invalidCredentials(_that);case AuthUserDisabledFailure() when userDisabled != null:
return userDisabled(_that);case AuthTooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case AuthNetworkFailure() when network != null:
return network(_that);case AuthMissingUserFailure() when missingUser != null:
return missingUser(_that);case AuthUnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidCredentials,TResult Function()?  userDisabled,TResult Function()?  tooManyRequests,TResult Function()?  network,TResult Function()?  missingUser,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthInvalidCredentialsFailure() when invalidCredentials != null:
return invalidCredentials();case AuthUserDisabledFailure() when userDisabled != null:
return userDisabled();case AuthTooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests();case AuthNetworkFailure() when network != null:
return network();case AuthMissingUserFailure() when missingUser != null:
return missingUser();case AuthUnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidCredentials,required TResult Function()  userDisabled,required TResult Function()  tooManyRequests,required TResult Function()  network,required TResult Function()  missingUser,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case AuthInvalidCredentialsFailure():
return invalidCredentials();case AuthUserDisabledFailure():
return userDisabled();case AuthTooManyRequestsFailure():
return tooManyRequests();case AuthNetworkFailure():
return network();case AuthMissingUserFailure():
return missingUser();case AuthUnknownFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidCredentials,TResult? Function()?  userDisabled,TResult? Function()?  tooManyRequests,TResult? Function()?  network,TResult? Function()?  missingUser,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case AuthInvalidCredentialsFailure() when invalidCredentials != null:
return invalidCredentials();case AuthUserDisabledFailure() when userDisabled != null:
return userDisabled();case AuthTooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests();case AuthNetworkFailure() when network != null:
return network();case AuthMissingUserFailure() when missingUser != null:
return missingUser();case AuthUnknownFailure() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc


class AuthInvalidCredentialsFailure implements AuthFailure {
  const AuthInvalidCredentialsFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthInvalidCredentialsFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.invalidCredentials()';
}


}




/// @nodoc


class AuthUserDisabledFailure implements AuthFailure {
  const AuthUserDisabledFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUserDisabledFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.userDisabled()';
}


}




/// @nodoc


class AuthTooManyRequestsFailure implements AuthFailure {
  const AuthTooManyRequestsFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthTooManyRequestsFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.tooManyRequests()';
}


}




/// @nodoc


class AuthNetworkFailure implements AuthFailure {
  const AuthNetworkFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthNetworkFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.network()';
}


}




/// @nodoc


class AuthMissingUserFailure implements AuthFailure {
  const AuthMissingUserFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthMissingUserFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.missingUser()';
}


}




/// @nodoc


class AuthUnknownFailure implements AuthFailure {
  const AuthUnknownFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnknownFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.unknown()';
}


}




// dart format on
