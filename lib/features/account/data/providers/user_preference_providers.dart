import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../auth/data/providers/local_user_scope_providers.dart';
import '../../domain/repositories/user_preference_repository.dart';
import '../datasources/user_preference_local_data_source.dart';
import '../repositories/user_preference_repository_impl.dart';

part 'user_preference_providers.g.dart';

@Riverpod(keepAlive: true)
UserPreferenceLocalDataSource userPreferenceLocalDataSource(Ref ref) {
  return DriftUserPreferenceLocalDataSource(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
UserPreferenceRepository userPreferenceRepository(Ref ref) {
  return UserPreferenceRepositoryImpl(
    ref.watch(userPreferenceLocalDataSourceProvider),
    ref.watch(localUserScopeRepositoryProvider),
  );
}
