import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_failure.dart';

part 'remote_failure.freezed.dart';

/// Failures raised by remote (network-backed) capabilities.
///
/// [RemoteFailure.consentRequired] and [RemoteFailure.attestationRequired] are
/// the guards that keep private conversation content on the device until an
/// explicit consent flow and App Check enforcement are both in place.
@freezed
sealed class RemoteFailure with _$RemoteFailure implements AppFailure {
  const factory RemoteFailure.disabled() = RemoteDisabledFailure;
  const factory RemoteFailure.consentRequired() = RemoteConsentRequiredFailure;
  const factory RemoteFailure.attestationRequired() =
      RemoteAttestationRequiredFailure;
  const factory RemoteFailure.notConfigured() = RemoteNotConfiguredFailure;
  const factory RemoteFailure.network() = RemoteNetworkFailure;
  const factory RemoteFailure.permissionDenied() =
      RemotePermissionDeniedFailure;
  const factory RemoteFailure.unknown() = RemoteUnknownFailure;
}
