import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/config/app_config.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/core/l10n/local_ai_copy.dart';
import 'package:quorivell/features/assistant/data/datasources/firebase_ai_assistant_transport.dart';

void main() {
  final instruction = localAICopyForLocale(
    const Locale('en'),
  ).remoteSystemInstruction;

  test('refuses to build with the default local-only configuration', () {
    expect(
      () => FirebaseAiAssistantTransport(
        systemInstruction: instruction,
        hasUserConsent: true,
      ),
      throwsA(const RemoteFailure.disabled()),
    );
  });

  test('refuses to build without App Check enforcement', () {
    expect(
      () => FirebaseAiAssistantTransport(
        systemInstruction: instruction,
        hasUserConsent: true,
        config: const RemoteAssistantConfig(
          enabled: true,
          modelId: 'test-model',
        ),
      ),
      throwsA(const RemoteFailure.attestationRequired()),
    );
  });

  test('refuses to build without a configured model id', () {
    expect(
      () => FirebaseAiAssistantTransport(
        systemInstruction: instruction,
        hasUserConsent: true,
        config: const RemoteAssistantConfig(
          enabled: true,
          appCheckEnforced: true,
        ),
      ),
      throwsA(const RemoteFailure.notConfigured()),
    );
  });

  test('refuses to build without recorded user consent', () {
    expect(
      () => FirebaseAiAssistantTransport(
        systemInstruction: instruction,
        hasUserConsent: false,
        config: const RemoteAssistantConfig(
          enabled: true,
          appCheckEnforced: true,
          modelId: 'test-model',
        ),
      ),
      throwsA(const RemoteFailure.consentRequired()),
    );
  });
}
