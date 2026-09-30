import '../entities/local_user_scope.dart';

abstract interface class LocalUserScopeRepository {
  Future<LocalUserScope> getOrCreate();
}
