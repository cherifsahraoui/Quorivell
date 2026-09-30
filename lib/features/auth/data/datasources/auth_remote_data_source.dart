import '../dtos/auth_user_dto.dart';

/// Firebase-free contract for remote authentication.
///
/// Implementations own the SDK and must translate SDK exceptions into
/// `AuthFailure` before returning.
abstract interface class AuthRemoteDataSource {
  Future<AuthUserDto> signIn({required String email, required String password});
  Future<void> signOut();
}
