import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import 'app_config.dart';

enum FirebaseBootstrapFailureKind { configuration, initialization, attestation }

class FirebaseBootstrapException implements Exception {
  const FirebaseBootstrapException({required this.kind, this.cause});

  final FirebaseBootstrapFailureKind kind;
  final Object? cause;

  @override
  String toString() => 'FirebaseBootstrapException(kind: $kind)';
}

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<void> initialize({
    bool Function()? isInitialized,
    Future<void> Function()? initializeApp,
    Future<void> Function()? activateAppCheck,
  }) async {
    final initialized = isInitialized ?? () => Firebase.apps.isNotEmpty;
    final initialize =
        initializeApp ??
        () => Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
    final activate = activateAppCheck ?? activateDefaultAppCheck;

    if (initialized()) {
      return;
    }

    try {
      await initialize();
    } on UnsupportedError catch (error) {
      throw FirebaseBootstrapException(
        kind: FirebaseBootstrapFailureKind.configuration,
        cause: error,
      );
    } on Object catch (error) {
      throw FirebaseBootstrapException(
        kind: FirebaseBootstrapFailureKind.initialization,
        cause: error,
      );
    }

    try {
      await activate();
    } on Object catch (error) {
      throw FirebaseBootstrapException(
        kind: FirebaseBootstrapFailureKind.attestation,
        cause: error,
      );
    }
  }

  /// Enables App Check with the platform-recommended attestation provider.
  ///
  /// Debug providers are only selected in debug builds. Web activation is
  /// skipped unless a reCAPTCHA site key is configured, because a site key must
  /// come from the project rather than from source.
  static Future<void> activateDefaultAppCheck() {
    final debug = AppConfig.useAppCheckDebugProviders;
    final webProvider = _webProvider(debug: debug);
    if (kIsWeb && webProvider == null) {
      return Future<void>.value();
    }

    return FirebaseAppCheck.instance.activate(
      providerAndroid: debug
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: debug
          ? const AppleDebugProvider()
          : const AppleAppAttestWithDeviceCheckFallbackProvider(),
      providerWeb: webProvider,
    );
  }

  static WebProvider? _webProvider({required bool debug}) {
    if (!kIsWeb) return null;
    if (debug) return WebDebugProvider();
    final siteKey = AppConfig.appCheckWebSiteKey;
    return siteKey.isEmpty ? null : ReCaptchaV3Provider(siteKey);
  }
}
