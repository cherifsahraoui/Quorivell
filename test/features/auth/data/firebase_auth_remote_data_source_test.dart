import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/auth/data/datasources/firebase_auth_remote_data_source.dart';

class _FakeUser implements User {
  _FakeUser({required this.uid, this.email, this.displayName});

  @override
  final String uid;

  @override
  final String? email;

  @override
  final String? displayName;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Not exercised by this test.');
}

class _FakeUserCredential implements UserCredential {
  _FakeUserCredential(this.user);

  @override
  final User? user;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Not exercised by this test.');
}

class _FakeFirebaseAuth implements FirebaseAuth {
  _FakeFirebaseAuth({this.onSignIn, this.onSignOut});

  final Future<UserCredential> Function()? onSignIn;
  final Future<void> Function()? onSignOut;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => onSignIn!();

  @override
  Future<void> signOut() async => onSignOut?.call();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Not exercised by this test.');
}

FirebaseAuthRemoteDataSource _dataSourceThrowing(String code) {
  return FirebaseAuthRemoteDataSource(
    _FakeFirebaseAuth(
      onSignIn: () async => throw FirebaseAuthException(code: code),
    ),
  );
}

void main() {
  const email = 'reviewer@example.test';
  const password = 'not-a-real-password';

  test('returns a Firebase-free DTO for a successful sign-in', () async {
    final dataSource = FirebaseAuthRemoteDataSource(
      _FakeFirebaseAuth(
        onSignIn: () async => _FakeUserCredential(
          _FakeUser(uid: 'uid-1', email: email, displayName: 'Reviewer'),
        ),
      ),
    );

    final user = await dataSource.signIn(email: email, password: password);

    expect(user.id, 'uid-1');
    expect(user.email, email);
    expect(user.displayName, 'Reviewer');
    expect(user.toDomain().id, 'uid-1');
  });

  test('maps a credential without a user to a typed failure', () async {
    final dataSource = FirebaseAuthRemoteDataSource(
      _FakeFirebaseAuth(onSignIn: () async => _FakeUserCredential(null)),
    );

    await expectLater(
      dataSource.signIn(email: email, password: password),
      throwsA(isA<AuthMissingUserFailure>()),
    );
  });

  group('maps FirebaseAuthException to a typed AuthFailure', () {
    const cases = <String, AuthFailure>{
      'invalid-credential': AuthFailure.invalidCredentials(),
      'invalid-email': AuthFailure.invalidCredentials(),
      'user-not-found': AuthFailure.invalidCredentials(),
      'wrong-password': AuthFailure.invalidCredentials(),
      'user-disabled': AuthFailure.userDisabled(),
      'too-many-requests': AuthFailure.tooManyRequests(),
      'network-request-failed': AuthFailure.network(),
      'something-unexpected': AuthFailure.unknown(),
    };

    for (final entry in cases.entries) {
      test(entry.key, () async {
        await expectLater(
          _dataSourceThrowing(
            entry.key,
          ).signIn(email: email, password: password),
          throwsA(entry.value),
        );
      });
    }
  });

  test('never lets a FirebaseAuthException escape sign-out', () async {
    final dataSource = FirebaseAuthRemoteDataSource(
      _FakeFirebaseAuth(
        onSignOut: () async =>
            throw FirebaseAuthException(code: 'network-request-failed'),
      ),
    );

    await expectLater(
      dataSource.signOut(),
      throwsA(const AuthFailure.network()),
    );
  });
}
