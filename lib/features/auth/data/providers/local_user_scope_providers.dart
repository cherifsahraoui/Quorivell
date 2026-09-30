import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../domain/entities/local_user_scope.dart';
import '../../domain/repositories/local_user_scope_repository.dart';
import '../datasources/local_user_scope_local_data_source.dart';
import '../repositories/local_user_scope_repository_impl.dart';

part 'local_user_scope_providers.g.dart';

@riverpod
LocalUserScopeLocalDataSource localUserScopeLocalDataSource(Ref ref) {
  return DriftLocalUserScopeLocalDataSource(ref.watch(appDatabaseProvider));
}

@riverpod
LocalUserScopeRepository localUserScopeRepository(Ref ref) {
  return LocalUserScopeRepositoryImpl(
    ref.watch(localUserScopeLocalDataSourceProvider),
  );
}

@riverpod
Future<LocalUserScope> localUserScope(Ref ref) {
  return ref.watch(localUserScopeRepositoryProvider).getOrCreate();
}
