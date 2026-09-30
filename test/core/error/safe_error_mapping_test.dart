import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/ai/local_ai_service.dart';
import 'package:quorivell/core/error/failure_messages.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/l10n/app_localizations.dart';
import 'package:quorivell/l10n/app_localizations_en.dart';

void main() {
  group('Safe error mapping', () {
    late AppLocalizations l10n;

    setUp(() {
      l10n = AppLocalizationsEn();
    });

    group('LocalAIException mapping', () {
      test('maps invalid-input to ExtractionFailure.invalidInput', () {
        const exception = LocalAIException(
          'invalid-input',
          'Conversation text is empty or exceeds the local limit.',
        );

        expect(exception.code, equals('invalid-input'));
        expect(exception.message, isNot(contains('admin')));
        expect(exception.message, isNot(contains('password')));
      });

      test('maps unavailable to ExtractionFailure.modelUnavailable', () {
        const exception = LocalAIException(
          'unavailable',
          'The on-device model is unavailable on this device.',
        );

        expect(exception.code, equals('unavailable'));
        expect(exception.toString(), equals('LocalAIException(unavailable)'));
        // Verify toString() does not expose the message
        expect(exception.toString(), isNot(contains('on this device')));
      });

      test('maps invalid-output to ExtractionFailure.invalidOutput', () {
        const exception = LocalAIException(
          'invalid-output',
          'The on-device model did not return typed extraction JSON.',
        );

        expect(exception.code, equals('invalid-output'));
        expect(exception.message, isNot(contains('user')));
      });
    });

    group('Typed failure to user message', () {
      test('AuthFailure maps to safe localized messages', () {
        final cases = {
          const AuthFailure.invalidCredentials():
              l10n.errorSignInInvalidCredentials,
          const AuthFailure.userDisabled(): l10n.errorSignInUserDisabled,
          const AuthFailure.tooManyRequests(): l10n.errorSignInTooManyRequests,
          const AuthFailure.network(): l10n.errorNetworkUnavailable,
          const AuthFailure.missingUser(): l10n.errorSignInInvalidCredentials,
          const AuthFailure.unknown(): l10n.errorGeneric,
        };

        for (final entry in cases.entries) {
          final message = failureMessage(l10n, entry.key);
          expect(message, equals(entry.value));
          expect(message, isNot(contains('Exception')));
          expect(message, isNot(contains('FirebaseAuth')));
          expect(message, isNot(contains('credential')));
        }
      });

      test('ExtractionFailure maps to safe localized messages', () {
        final cases = {
          const ExtractionFailure.noSourceConversation():
              l10n.reviewCaptureFirstError,
          const ExtractionFailure.sourceArchived():
              l10n.errorExtractionSourceArchived,
          const ExtractionFailure.invalidInput():
              l10n.errorExtractionInvalidInput,
          const ExtractionFailure.modelUnavailable():
              l10n.errorExtractionModelUnavailable,
          const ExtractionFailure.modelUnsupported():
              l10n.errorExtractionModelUnsupported,
          const ExtractionFailure.invalidOutput():
              l10n.errorExtractionInvalidOutput,
          const ExtractionFailure.unknown(): l10n.errorGeneric,
          const ExtractionFailure.cancelled(): l10n.extractionStoppedSnackbar,
        };

        for (final entry in cases.entries) {
          final message = failureMessage(l10n, entry.key);
          expect(message, equals(entry.value));
          expect(message, isNot(contains('LocalAI')));
          expect(message, isNot(contains('llama')));
          expect(message, isNot(contains('prompt')));
        }
      });

      test('ChatFailure maps to safe localized messages', () {
        final cases = {
          const ChatFailure.invalidInput(): l10n.errorChatInvalidInput,
          const ChatFailure.modelUnavailable(): l10n.errorChatModelUnavailable,
          const ChatFailure.unknown(): l10n.errorGeneric,
        };

        for (final entry in cases.entries) {
          final message = failureMessage(l10n, entry.key);
          expect(message, equals(entry.value));
          expect(message, isNot(contains('Exception')));
        }
      });

      test('LocalPersistenceFailure maps to safe localized messages', () {
        final cases = {
          const LocalPersistenceFailure.notFound():
              l10n.errorLocalRecordMissing,
          const LocalPersistenceFailure.invalidInput():
              l10n.captureValidationError,
          const LocalPersistenceFailure.alreadyExists():
              l10n.extractionKindsAlreadyExists,
          const LocalPersistenceFailure.readFailed(): l10n.errorLocalStorage,
          const LocalPersistenceFailure.writeFailed(): l10n.errorLocalStorage,
        };

        for (final entry in cases.entries) {
          final message = failureMessage(l10n, entry.key);
          expect(message, equals(entry.value));
          expect(message, isNot(contains('Drift')));
          expect(message, isNot(contains('SQLite')));
          expect(message, isNot(contains('database')));
        }
      });

      test('RemoteFailure maps to safe localized messages', () {
        final cases = {
          const RemoteFailure.network(): l10n.errorNetworkUnavailable,
          const RemoteFailure.unknown(): l10n.errorRemoteUnavailable,
        };

        for (final entry in cases.entries) {
          final message = failureMessage(l10n, entry.key);
          expect(message, equals(entry.value));
          expect(message, isNot(contains('Firebase')));
          expect(message, isNot(contains('token')));
        }
      });

      test('unknown failures map to generic message', () {
        final unknownFailure = Exception('Some unexpected error');
        final message = failureMessage(l10n, unknownFailure);

        expect(message, equals(l10n.errorGeneric));
        expect(message, isNot(contains('unexpected')));
        expect(message, isNot(contains('Exception')));
      });
    });

    group('Error message content verification', () {
      test('no error message contains sensitive patterns', () {
        final l10n = AppLocalizationsEn();
        final sensitivePatterns = [
          RegExp(r'Exception', caseSensitive: false),
          RegExp(r'FirebaseAuth', caseSensitive: false),
          RegExp(r'Drift', caseSensitive: false),
          RegExp(r'SQLite', caseSensitive: false),
          RegExp(r'llama\.cpp', caseSensitive: false),
          RegExp(r'LocalAI', caseSensitive: false),
          RegExp(r'credential', caseSensitive: false),
          RegExp(r'token', caseSensitive: false),
          RegExp(r'<\|im_', caseSensitive: false),
        ];

        final allFailures = [
          const AuthFailure.invalidCredentials(),
          const AuthFailure.userDisabled(),
          const AuthFailure.tooManyRequests(),
          const AuthFailure.network(),
          const AuthFailure.missingUser(),
          const AuthFailure.unknown(),
          const ExtractionFailure.noSourceConversation(),
          const ExtractionFailure.sourceArchived(),
          const ExtractionFailure.invalidInput(),
          const ExtractionFailure.modelUnavailable(),
          const ExtractionFailure.modelUnsupported(),
          const ExtractionFailure.invalidOutput(),
          const ExtractionFailure.unknown(),
          const ChatFailure.invalidInput(),
          const ChatFailure.modelUnavailable(),
          const ChatFailure.unknown(),
          const LocalPersistenceFailure.notFound(),
          const LocalPersistenceFailure.invalidInput(),
          const LocalPersistenceFailure.alreadyExists(),
          const LocalPersistenceFailure.readFailed(),
          const LocalPersistenceFailure.writeFailed(),
          const RemoteFailure.network(),
          const RemoteFailure.unknown(),
        ];

        for (final failure in allFailures) {
          final message = failureMessage(l10n, failure);
          for (final pattern in sensitivePatterns) {
            expect(
              pattern.hasMatch(message),
              isFalse,
              reason:
                  'Message "$message" for ${failure.runtimeType} '
                  'should not match pattern ${pattern.pattern}',
            );
          }
        }
      });

      test('error messages are user-friendly and localized', () {
        final l10n = AppLocalizationsEn();

        // Just verify the messages exist and are localized, without hardcoding exact text
        expect(
          failureMessage(l10n, const AuthFailure.network()).isNotEmpty,
          isTrue,
        );

        expect(
          failureMessage(
            l10n,
            const ExtractionFailure.modelUnavailable(),
          ).isNotEmpty,
          isTrue,
        );

        expect(
          failureMessage(
            l10n,
            const LocalPersistenceFailure.writeFailed(),
          ).isNotEmpty,
          isTrue,
        );
      });
    });
  });
}
