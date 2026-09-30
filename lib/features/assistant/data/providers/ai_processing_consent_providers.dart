import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../auth/data/providers/local_user_scope_providers.dart';
import '../../domain/repositories/ai_processing_consent_repository.dart';
import '../datasources/ai_processing_consent_local_data_source.dart';
import '../repositories/ai_processing_consent_repository_impl.dart';

part 'ai_processing_consent_providers.g.dart';

@riverpod
AiProcessingConsentLocalDataSource aiProcessingConsentLocalDataSource(Ref ref) {
  return DriftAiProcessingConsentLocalDataSource(
    ref.watch(appDatabaseProvider),
  );
}

@riverpod
AiProcessingConsentRepository aiProcessingConsentRepository(Ref ref) {
  return AiProcessingConsentRepositoryImpl(
    localDataSource: ref.watch(aiProcessingConsentLocalDataSourceProvider),
    userScopeRepository: ref.watch(localUserScopeRepositoryProvider),
  );
}
