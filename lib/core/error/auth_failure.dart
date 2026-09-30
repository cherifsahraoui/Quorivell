import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_failure.dart';

part 'auth_failure.freezed.dart';

/// Authentication failures that may cross the repository boundary.
///
/// Firebase codes are mapped in the auth data source implementation and never
/// reach controllers or UI copy.
@freezed
sealed class AuthFailure with _$AuthFailure implements AppFailure {
  const factory AuthFailure.invalidCredentials() =
      AuthInvalidCredentialsFailure;
  const factory AuthFailure.userDisabled() = AuthUserDisabledFailure;
  const factory AuthFailure.tooManyRequests() = AuthTooManyRequestsFailure;
  const factory AuthFailure.network() = AuthNetworkFailure;
  const factory AuthFailure.missingUser() = AuthMissingUserFailure;
  const factory AuthFailure.unknown() = AuthUnknownFailure;
}
