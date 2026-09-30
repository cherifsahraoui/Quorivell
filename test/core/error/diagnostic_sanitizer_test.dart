import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/error/diagnostic_sanitizer.dart';

void main() {
  group('DiagnosticSanitizer', () {
    group('sanitize', () {
      test('returns (empty) for empty strings', () {
        expect(DiagnosticSanitizer.sanitize(''), equals('(empty)'));
      });

      test('redacts strings with sensitive patterns', () {
        final sensitiveInputs = [
          'password: mySecretPass',
          'Bearer token12345',
          'api-key: abcd1234',
          'firebase-auth-token: xyz',
          '<|im_start|>system',
          'assistant response here',
        ];

        for (final input in sensitiveInputs) {
          final result = DiagnosticSanitizer.sanitize(input);
          expect(
            result,
            equals('[REDACTED: sensitive content]'),
            reason: 'Failed to redact: $input',
          );
        }
      });

      test('truncates long content without sensitive patterns', () {
        final longText = 'A' * 100;
        final result = DiagnosticSanitizer.sanitize(longText);

        expect(result, startsWith('A' * 80));
        expect(result, endsWith('… [100 chars]'));
        expect(result.length, lessThan(longText.length));
      });

      test('returns short safe strings unchanged', () {
        final safeInputs = [
          'Model loaded successfully',
          'Extraction completed',
          'chunk 5/10',
        ];

        for (final input in safeInputs) {
          expect(
            DiagnosticSanitizer.sanitize(input),
            equals(input),
            reason: 'Should not modify: $input',
          );
        }
      });
    });

    group('sanitizeConversation', () {
      test('never logs actual conversation content', () {
        const sensitiveConversation = '''
Alice: We need to launch the new feature by Friday.
Bob: I'll have the code ready by Thursday. The password is admin123.
Alice: Perfect, let's review it together.
''';

        final result = DiagnosticSanitizer.sanitizeConversation(
          sensitiveConversation,
        );

        expect(
          result,
          equals('[conversation: ${sensitiveConversation.length} chars]'),
        );
        expect(result, isNot(contains('Alice')));
        expect(result, isNot(contains('Friday')));
        expect(result, isNot(contains('password')));
        expect(result, isNot(contains('admin123')));
      });

      test('works with empty conversation', () {
        expect(
          DiagnosticSanitizer.sanitizeConversation(''),
          equals('[conversation: 0 chars]'),
        );
      });
    });

    group('sanitizeEvidence', () {
      test('never logs actual quote content', () {
        const sensitiveQuote = 'Bob will deliver the secret key by EOD';

        final result = DiagnosticSanitizer.sanitizeEvidence(
          quoteSnippet: sensitiveQuote,
          quoteStart: 42,
          quoteEnd: 81,
        );

        expect(
          result,
          equals('[evidence: ${sensitiveQuote.length} chars at 42-81]'),
        );
        expect(result, isNot(contains('Bob')));
        expect(result, isNot(contains('secret')));
        expect(result, isNot(contains('key')));
      });

      test('only logs metadata, not content', () {
        final result = DiagnosticSanitizer.sanitizeEvidence(
          quoteSnippet: 'Any text here',
          quoteStart: 0,
          quoteEnd: 13,
        );

        expect(result, matches(r'^\[evidence: \d+ chars at \d+-\d+\]$'));
      });
    });

    group('sanitizePrompt', () {
      test('never logs actual prompt or system instructions', () {
        const sensitivePrompt = '''
<|im_start|>system
You are an extraction assistant. Extract decisions from the conversation below.
<|im_end|>
<|im_start|>user
Alice said the API key is xyz123 and Bob will handle deployment.
<|im_end|>
<|im_start|>assistant
''';

        final result = DiagnosticSanitizer.sanitizePrompt(sensitivePrompt);

        expect(result, equals('[prompt: ${sensitivePrompt.length} chars]'));
        expect(result, isNot(contains('<|im_start|>')));
        expect(result, isNot(contains('assistant')));
        expect(result, isNot(contains('API key')));
        expect(result, isNot(contains('xyz123')));
      });
    });

    group('sanitizeModelOutput', () {
      test(
        'never logs model output that might contain extracted statements',
        () {
          const modelOutput = '''
{"candidates": [
  {
    "kind": "commitment",
    "statement": "Bob will deploy the application",
    "owner": "Bob",
    "quoteSnippet": "Bob said he will deploy by Friday"
  }
]}
''';

          final result = DiagnosticSanitizer.sanitizeModelOutput(modelOutput);

          expect(result, equals('[model output: ${modelOutput.length} chars]'));
          expect(result, isNot(contains('Bob')));
          expect(result, isNot(contains('deploy')));
          expect(result, isNot(contains('Friday')));
        },
      );
    });

    group('sanitizeCredential', () {
      test('always returns REDACTED for any credential', () {
        expect(
          DiagnosticSanitizer.sanitizeCredential('password123'),
          equals('[REDACTED: credential]'),
        );
        expect(
          DiagnosticSanitizer.sanitizeCredential('firebase-token-abc'),
          equals('[REDACTED: credential]'),
        );
        expect(
          DiagnosticSanitizer.sanitizeCredential(''),
          equals('[REDACTED: credential]'),
        );
      });
    });

    group('sanitizeToken', () {
      test('always returns REDACTED for any token', () {
        expect(
          DiagnosticSanitizer.sanitizeToken('eyJhbGciOiJIUzI1NiIs...'),
          equals('[REDACTED: token]'),
        );
        expect(
          DiagnosticSanitizer.sanitizeToken('bearer-token-xyz'),
          equals('[REDACTED: token]'),
        );
        expect(
          DiagnosticSanitizer.sanitizeToken(''),
          equals('[REDACTED: token]'),
        );
      });
    });

    group('sanitizeException', () {
      test('sanitizes exception messages', () {
        final exception = Exception('Could not load model');
        final result = DiagnosticSanitizer.sanitizeException(exception);

        expect(result, equals('Could not load model'));
      });

      test('removes "Exception: " prefix', () {
        final exception = Exception('Something failed');
        final result = DiagnosticSanitizer.sanitizeException(exception);

        expect(result, isNot(startsWith('Exception: ')));
        expect(result, equals('Something failed'));
      });

      test('returns type name for non-Exception objects', () {
        final error = StateError('Bad state');
        final result = DiagnosticSanitizer.sanitizeException(error);

        expect(result, equals('StateError'));
      });

      test('does not leak sensitive data from exception messages', () {
        final exception = Exception('Auth failed with token: abc123');
        final result = DiagnosticSanitizer.sanitizeException(exception);

        expect(result, equals('[REDACTED: sensitive content]'));
      });
    });
  });

  group('safeLog and safeDebugLog', () {
    test('safeLog formats message with details', () {
      // These tests verify the function compiles and runs without error.
      // In a real scenario, you would capture debugPrint output to verify.
      expect(
        () => safeLog('Test message', {'key': 'value', 'count': 42}),
        returnsNormally,
      );
    });

    test('safeLog works without details', () {
      expect(() => safeLog('Simple message'), returnsNormally);
    });

    test('safeDebugLog works in debug mode', () {
      expect(
        () => safeDebugLog('Debug message', {'detail': 'info'}),
        returnsNormally,
      );
    });

    test('safeLog sanitizes string values in details', () {
      // Verify it doesn't throw when given sensitive data
      expect(
        () => safeLog('Message', {
          'conversation': 'Alice said the password is secret123',
          'token': 'bearer xyz',
        }),
        returnsNormally,
      );
    });
  });
}
