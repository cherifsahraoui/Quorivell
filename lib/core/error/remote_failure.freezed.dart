// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteFailure()';
}


}

/// @nodoc
class $RemoteFailureCopyWith<$Res>  {
$RemoteFailureCopyWith(RemoteFailure _, $Res Function(RemoteFailure) __);
}


/// Adds pattern-matching-related methods to [RemoteFailure].
extension RemoteFailurePatterns on RemoteFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RemoteDisabledFailure value)?  disabled,TResult Function( RemoteConsentRequiredFailure value)?  consentRequired,TResult Function( RemoteAttestationRequiredFailure value)?  attestationRequired,TResult Function( RemoteNotConfiguredFailure value)?  notConfigured,TResult Function( RemoteNetworkFailure value)?  network,TResult Function( RemotePermissionDeniedFailure value)?  permissionDenied,TResult Function( RemoteUnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RemoteDisabledFailure() when disabled != null:
return disabled(_that);case RemoteConsentRequiredFailure() when consentRequired != null:
return consentRequired(_that);case RemoteAttestationRequiredFailure() when attestationRequired != null:
return attestationRequired(_that);case RemoteNotConfiguredFailure() when notConfigured != null:
return notConfigured(_that);case RemoteNetworkFailure() when network != null:
return network(_that);case RemotePermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that);case RemoteUnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RemoteDisabledFailure value)  disabled,required TResult Function( RemoteConsentRequiredFailure value)  consentRequired,required TResult Function( RemoteAttestationRequiredFailure value)  attestationRequired,required TResult Function( RemoteNotConfiguredFailure value)  notConfigured,required TResult Function( RemoteNetworkFailure value)  network,required TResult Function( RemotePermissionDeniedFailure value)  permissionDenied,required TResult Function( RemoteUnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case RemoteDisabledFailure():
return disabled(_that);case RemoteConsentRequiredFailure():
return consentRequired(_that);case RemoteAttestationRequiredFailure():
return attestationRequired(_that);case RemoteNotConfiguredFailure():
return notConfigured(_that);case RemoteNetworkFailure():
return network(_that);case RemotePermissionDeniedFailure():
return permissionDenied(_that);case RemoteUnknownFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RemoteDisabledFailure value)?  disabled,TResult? Function( RemoteConsentRequiredFailure value)?  consentRequired,TResult? Function( RemoteAttestationRequiredFailure value)?  attestationRequired,TResult? Function( RemoteNotConfiguredFailure value)?  notConfigured,TResult? Function( RemoteNetworkFailure value)?  network,TResult? Function( RemotePermissionDeniedFailure value)?  permissionDenied,TResult? Function( RemoteUnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case RemoteDisabledFailure() when disabled != null:
return disabled(_that);case RemoteConsentRequiredFailure() when consentRequired != null:
return consentRequired(_that);case RemoteAttestationRequiredFailure() when attestationRequired != null:
return attestationRequired(_that);case RemoteNotConfiguredFailure() when notConfigured != null:
return notConfigured(_that);case RemoteNetworkFailure() when network != null:
return network(_that);case RemotePermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that);case RemoteUnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  disabled,TResult Function()?  consentRequired,TResult Function()?  attestationRequired,TResult Function()?  notConfigured,TResult Function()?  network,TResult Function()?  permissionDenied,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RemoteDisabledFailure() when disabled != null:
return disabled();case RemoteConsentRequiredFailure() when consentRequired != null:
return consentRequired();case RemoteAttestationRequiredFailure() when attestationRequired != null:
return attestationRequired();case RemoteNotConfiguredFailure() when notConfigured != null:
return notConfigured();case RemoteNetworkFailure() when network != null:
return network();case RemotePermissionDeniedFailure() when permissionDenied != null:
return permissionDenied();case RemoteUnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  disabled,required TResult Function()  consentRequired,required TResult Function()  attestationRequired,required TResult Function()  notConfigured,required TResult Function()  network,required TResult Function()  permissionDenied,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case RemoteDisabledFailure():
return disabled();case RemoteConsentRequiredFailure():
return consentRequired();case RemoteAttestationRequiredFailure():
return attestationRequired();case RemoteNotConfiguredFailure():
return notConfigured();case RemoteNetworkFailure():
return network();case RemotePermissionDeniedFailure():
return permissionDenied();case RemoteUnknownFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  disabled,TResult? Function()?  consentRequired,TResult? Function()?  attestationRequired,TResult? Function()?  notConfigured,TResult? Function()?  network,TResult? Function()?  permissionDenied,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case RemoteDisabledFailure() when disabled != null:
return disabled();case RemoteConsentRequiredFailure() when consentRequired != null:
return consentRequired();case RemoteAttestationRequiredFailure() when attestationRequired != null:
return attestationRequired();case RemoteNotConfiguredFailure() when notConfigured != null:
return notConfigured();case RemoteNetworkFailure() when network != null:
return network();case RemotePermissionDeniedFailure() when permissionDenied != null:
return permissionDenied();case RemoteUnknownFailure() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc


class RemoteDisabledFailure implements RemoteFailure {
  const RemoteDisabledFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteDisabledFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteFailure.disabled()';
}


}




/// @nodoc


class RemoteConsentRequiredFailure implements RemoteFailure {
  const RemoteConsentRequiredFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteConsentRequiredFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteFailure.consentRequired()';
}


}




/// @nodoc


class RemoteAttestationRequiredFailure implements RemoteFailure {
  const RemoteAttestationRequiredFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteAttestationRequiredFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteFailure.attestationRequired()';
}


}




/// @nodoc


class RemoteNotConfiguredFailure implements RemoteFailure {
  const RemoteNotConfiguredFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteNotConfiguredFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteFailure.notConfigured()';
}


}




/// @nodoc


class RemoteNetworkFailure implements RemoteFailure {
  const RemoteNetworkFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteNetworkFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteFailure.network()';
}


}




/// @nodoc


class RemotePermissionDeniedFailure implements RemoteFailure {
  const RemotePermissionDeniedFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemotePermissionDeniedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteFailure.permissionDenied()';
}


}




/// @nodoc


class RemoteUnknownFailure implements RemoteFailure {
  const RemoteUnknownFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteUnknownFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteFailure.unknown()';
}


}




// dart format on
