import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/config/firebase_bootstrap.dart';

Future<void> _noAppCheck() async {}

void main() {
  test(
    'initializes Firebase and App Check when no app is registered',
    () async {
      var initializeCalls = 0;
      var appCheckCalls = 0;

      await FirebaseBootstrap.initialize(
        isInitialized: () => false,
        initializeApp: () async => initializeCalls++,
        activateAppCheck: () async => appCheckCalls++,
      );

      expect(initializeCalls, 1);
      expect(appCheckCalls, 1);
    },
  );

  test(
    'does not initialize Firebase when an app is already registered',
    () async {
      var initializeCalls = 0;
      var appCheckCalls = 0;

      await FirebaseBootstrap.initialize(
        isInitialized: () => true,
        initializeApp: () async => initializeCalls++,
        activateAppCheck: () async => appCheckCalls++,
      );

      expect(initializeCalls, 0);
      expect(appCheckCalls, 0);
    },
  );

  test('maps unsupported configuration to a typed failure', () async {
    await expectLater(
      FirebaseBootstrap.initialize(
        isInitialized: () => false,
        initializeApp: () async => throw UnsupportedError('missing options'),
        activateAppCheck: _noAppCheck,
      ),
      throwsA(
        isA<FirebaseBootstrapException>().having(
          (failure) => failure.kind,
          'kind',
          FirebaseBootstrapFailureKind.configuration,
        ),
      ),
    );
  });

  test('maps initialization errors to a typed failure', () async {
    await expectLater(
      FirebaseBootstrap.initialize(
        isInitialized: () => false,
        initializeApp: () async => throw StateError('initialization failed'),
        activateAppCheck: _noAppCheck,
      ),
      throwsA(
        isA<FirebaseBootstrapException>().having(
          (failure) => failure.kind,
          'kind',
          FirebaseBootstrapFailureKind.initialization,
        ),
      ),
    );
  });

  test('maps App Check activation errors to a typed failure', () async {
    await expectLater(
      FirebaseBootstrap.initialize(
        isInitialized: () => false,
        initializeApp: () async {},
        activateAppCheck: () async => throw StateError('attestation failed'),
      ),
      throwsA(
        isA<FirebaseBootstrapException>().having(
          (failure) => failure.kind,
          'kind',
          FirebaseBootstrapFailureKind.attestation,
        ),
      ),
    );
  });

  test('a typed failure never exposes the underlying cause as copy', () {
    const failure = FirebaseBootstrapException(
      kind: FirebaseBootstrapFailureKind.attestation,
      cause: 'internal detail',
    );

    expect(failure.toString(), isNot(contains('internal detail')));
  });
}
