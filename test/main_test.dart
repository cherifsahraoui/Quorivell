import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/config/firebase_bootstrap.dart';
import 'package:quorivell/main.dart';

void main() {
  test('skips Firebase entirely when the build opts out', () async {
    var initializeCalls = 0;

    await bootstrapFirebase(
      enabled: false,
      initialize: () async => initializeCalls++,
    );

    expect(initializeCalls, 0);
  });

  test('initializes Firebase when the build opts in', () async {
    var initializeCalls = 0;

    await bootstrapFirebase(
      enabled: true,
      initialize: () async => initializeCalls++,
    );

    expect(initializeCalls, 1);
  });

  test(
    'still starts the local-only app when Firebase is unconfigured',
    () async {
      await expectLater(
        bootstrapFirebase(
          enabled: true,
          initialize: () async => throw const FirebaseBootstrapException(
            kind: FirebaseBootstrapFailureKind.configuration,
          ),
        ),
        completes,
      );
    },
  );

  test(
    'still starts the local-only app when App Check cannot activate',
    () async {
      await expectLater(
        bootstrapFirebase(
          enabled: true,
          initialize: () async => throw const FirebaseBootstrapException(
            kind: FirebaseBootstrapFailureKind.attestation,
          ),
        ),
        completes,
      );
    },
  );
}
