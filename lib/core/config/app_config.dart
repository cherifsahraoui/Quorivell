import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';

/// Configuration for the optional remote assistant.
///
/// Every field defaults to the private, local-only position. A remote model may
/// only be constructed when the build explicitly opts in, App Check is
/// enforced, and a model id is supplied — no model literal lives in feature
/// code.
@freezed
abstract class RemoteAssistantConfig with _$RemoteAssistantConfig {
  const RemoteAssistantConfig._();

  const factory RemoteAssistantConfig({
    @Default(false) bool enabled,
    @Default(false) bool appCheckEnforced,
    @Default('') String modelId,
  }) = _RemoteAssistantConfig;

  bool get isConfigured => modelId.isNotEmpty;
}

/// Compile-time application configuration.
///
/// Quorivell is local-first: Firebase, App Check, and any remote assistant are
/// optional add-ons that the app must run without.
class AppConfig {
  const AppConfig._();

  /// Whether the build should attempt to initialize Firebase at startup.
  ///
  /// Startup stays guarded even when this is true, so a checkout without
  /// platform Firebase configuration still boots into the local-only flow.
  static const bool firebaseEnabled = bool.fromEnvironment(
    'QUORIVELL_FIREBASE_ENABLED',
    defaultValue: true,
  );

  /// reCAPTCHA v3 site key used for App Check on web.
  ///
  /// Empty by default; web App Check stays off rather than inventing a key.
  static const String appCheckWebSiteKey = String.fromEnvironment(
    'QUORIVELL_APP_CHECK_WEB_SITE_KEY',
  );

  /// Debug attestation providers are only ever used in debug builds.
  static const bool useAppCheckDebugProviders = kDebugMode;

  /// Hosted privacy policy opened from Account. Same URL as the Play listing.
  static const String privacyPolicyUrl = 'https://quorivell.com/privacy/';

  static const RemoteAssistantConfig remoteAssistant = RemoteAssistantConfig(
    enabled: bool.fromEnvironment('QUORIVELL_REMOTE_ASSISTANT_ENABLED'),
    appCheckEnforced: bool.fromEnvironment(
      'QUORIVELL_REMOTE_ASSISTANT_APP_CHECK_ENFORCED',
    ),
    modelId: String.fromEnvironment('QUORIVELL_REMOTE_ASSISTANT_MODEL_ID'),
  );
}
