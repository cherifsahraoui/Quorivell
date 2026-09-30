import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signIn(email: email, password: password);
      return user.toDomain();
    } on AuthFailure {
      rethrow;
    } on Object {
      throw const AuthFailure.unknown();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } on AuthFailure {
      rethrow;
    } on Object {
      throw const AuthFailure.unknown();
    }
  }
}
