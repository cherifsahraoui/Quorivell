import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../dtos/auth_user_dto.dart';
import 'auth_remote_data_source.dart';

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  const FirebaseAuthRemoteDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<AuthUserDto> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure.missingUser();
      }
      return AuthUserDto(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
      );
    } on FirebaseAuthException catch (error) {
      throw _mapAuthException(error);
    } on FirebaseException catch (_) {
      throw const AuthFailure.unknown();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _mapAuthException(error);
    } on FirebaseException catch (_) {
      throw const AuthFailure.unknown();
    }
  }

  AuthFailure _mapAuthException(FirebaseAuthException error) =>
      switch (error.code) {
        'invalid-credential' ||
        'invalid-email' ||
        'user-not-found' ||
        'wrong-password' => const AuthFailure.invalidCredentials(),
        'user-disabled' => const AuthFailure.userDisabled(),
        'too-many-requests' => const AuthFailure.tooManyRequests(),
        'network-request-failed' => const AuthFailure.network(),
        _ => const AuthFailure.unknown(),
      };
}
