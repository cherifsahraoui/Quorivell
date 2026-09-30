import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../auth/data/providers/local_user_scope_providers.dart';
import '../../domain/entities/extraction_item_kind.dart';
import '../../domain/repositories/extraction_item_kind_repository.dart';
import '../datasources/extraction_item_kind_local_data_source.dart';
import '../repositories/extraction_item_kind_repository_impl.dart';

part 'extraction_item_kind_providers.g.dart';

@riverpod
ExtractionItemKindLocalDataSource extractionItemKindLocalDataSource(Ref ref) {
  return DriftExtractionItemKindLocalDataSource(ref.watch(appDatabaseProvider));
}

@riverpod
ExtractionItemKindRepository extractionItemKindRepository(Ref ref) {
  return ExtractionItemKindRepositoryImpl(
    localDataSource: ref.watch(extractionItemKindLocalDataSourceProvider),
    userScopeRepository: ref.watch(localUserScopeRepositoryProvider),
    database: ref.watch(appDatabaseProvider),
  );
}

@riverpod
Stream<List<ExtractionItemKind>> extractionItemKinds(Ref ref) {
  return ref.watch(extractionItemKindRepositoryProvider).watchAll();
}

@riverpod
Stream<List<ExtractionItemKind>> enabledExtractionItemKinds(Ref ref) {
  return ref.watch(extractionItemKindRepositoryProvider).watchEnabled();
}
