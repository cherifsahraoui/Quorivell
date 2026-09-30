import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/error/failure_messages.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/l10n/app_localizations.dart';
import 'package:quorivell/l10n/app_localizations_en.dart';

void main() {
  final AppLocalizations l10n = AppLocalizationsEn();

  const failures = <Object>[
    AuthFailure.invalidCredentials(),
    AuthFailure.userDisabled(),
    AuthFailure.tooManyRequests(),
    AuthFailure.network(),
    AuthFailure.missingUser(),
    AuthFailure.unknown(),
    ExtractionFailure.noSourceConversation(),
    ExtractionFailure.invalidInput(),
    ExtractionFailure.modelUnavailable(),
    ExtractionFailure.modelUnsupported(),
    ExtractionFailure.invalidOutput(),
    ExtractionFailure.unknown(),
    ExtractionFailure.cancelled(),
    ChatFailure.invalidInput(),
    ChatFailure.modelUnavailable(),
    ChatFailure.unknown(),
    LocalPersistenceFailure.notFound(),
    LocalPersistenceFailure.invalidInput(),
    LocalPersistenceFailure.alreadyExists(),
    LocalPersistenceFailure.readFailed(),
    LocalPersistenceFailure.writeFailed(),
    RemoteFailure.disabled(),
    RemoteFailure.consentRequired(),
    RemoteFailure.attestationRequired(),
    RemoteFailure.notConfigured(),
    RemoteFailure.network(),
    RemoteFailure.permissionDenied(),
    RemoteFailure.unknown(),
  ];

  test('every typed failure has non-empty localized copy', () {
    for (final failure in failures) {
      final message = failureMessage(l10n, failure);
      expect(message, isNotEmpty, reason: '$failure');
    }
  });

  test('never renders exception text or an error code', () {
    for (final failure in failures) {
      final message = failureMessage(l10n, failure);
      expect(message, isNot(contains('Failure')), reason: '$failure');
      expect(message, isNot(contains('Exception')), reason: '$failure');
      expect(message, isNot(contains(failure.toString())), reason: '$failure');
    }
  });

  test('falls back to generic copy for an unmapped error', () {
    expect(
      failureMessage(l10n, StateError('raw infrastructure detail')),
      l10n.errorGeneric,
    );
    expect(failureMessage(l10n, null), l10n.errorGeneric);
  });

  test('maps sign-in and storage failures to distinct copy', () {
    expect(
      failureMessage(l10n, const AuthFailure.invalidCredentials()),
      l10n.errorSignInInvalidCredentials,
    );
    expect(
      failureMessage(l10n, const LocalPersistenceFailure.writeFailed()),
      l10n.errorLocalStorage,
    );
    expect(
      failureMessage(l10n, const ExtractionFailure.noSourceConversation()),
      l10n.reviewCaptureFirstError,
    );
  });
}
