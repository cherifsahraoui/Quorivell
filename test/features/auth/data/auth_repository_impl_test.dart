import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quorivell/features/auth/data/dtos/auth_user_dto.dart';
import 'package:quorivell/features/auth/data/repositories/auth_repository_impl.dart';

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  _FakeAuthRemoteDataSource({this.result, this.error});

  final AuthUserDto? result;
  final Object? error;
  bool signedOut = false;

  @override
  Future<AuthUserDto> signIn({
    required String email,
    required String password,
  }) async {
    if (error != null) throw error!;
    return result!;
  }

  @override
  Future<void> signOut() async {
    if (error != null) throw error!;
    signedOut = true;
  }
}

void main() {
  const email = 'reviewer@example.test';
  const password = 'not-a-real-password';

  test('maps a data-source DTO to the domain entity', () async {
    final repository = AuthRepositoryImpl(
      _FakeAuthRemoteDataSource(
        result: const AuthUserDto(
          id: 'uid-1',
          email: email,
          displayName: 'Reviewer',
        ),
      ),
    );

    final user = await repository.signIn(email: email, password: password);

    expect(user.id, 'uid-1');
    expect(user.email, email);
    expect(user.displayName, 'Reviewer');
  });

  test('passes a typed AuthFailure through unchanged', () async {
    final repository = AuthRepositoryImpl(
      _FakeAuthRemoteDataSource(error: const AuthFailure.invalidCredentials()),
    );

    await expectLater(
      repository.signIn(email: email, password: password),
      throwsA(const AuthFailure.invalidCredentials()),
    );
  });

  test('never lets a StateError cross the repository boundary', () async {
    final repository = AuthRepositoryImpl(
      _FakeAuthRemoteDataSource(error: StateError('sign-in returned no user')),
    );

    await expectLater(
      repository.signIn(email: email, password: password),
      throwsA(allOf(isA<AuthFailure>(), isNot(isA<StateError>()))),
    );
  });

  test('signs out through the data source', () async {
    final dataSource = _FakeAuthRemoteDataSource();
    await AuthRepositoryImpl(dataSource).signOut();

    expect(dataSource.signedOut, isTrue);
  });
}
