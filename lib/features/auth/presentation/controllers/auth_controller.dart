import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/auth_providers.dart';
import '../../domain/entities/auth_user.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<AuthUser?> build() => null;

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}
