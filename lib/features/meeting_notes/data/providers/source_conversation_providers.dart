import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../auth/data/providers/local_user_scope_providers.dart';
import '../../domain/entities/source_conversation.dart';
import '../../domain/repositories/source_conversation_repository.dart';
import '../datasources/source_conversation_local_data_source.dart';
import '../repositories/source_conversation_repository_impl.dart';

part 'source_conversation_providers.g.dart';

@riverpod
SourceConversationLocalDataSource sourceConversationLocalDataSource(Ref ref) {
  return DriftSourceConversationLocalDataSource(ref.watch(appDatabaseProvider));
}

@riverpod
SourceConversationRepository sourceConversationRepository(Ref ref) {
  return SourceConversationRepositoryImpl(
    localDataSource: ref.watch(sourceConversationLocalDataSourceProvider),
    localUserScopeRepository: ref.watch(localUserScopeRepositoryProvider),
  );
}

/// Active history when [archivedOnly] is false; archived when true.
@riverpod
Stream<List<SourceConversation>> sourceConversations(
  Ref ref,
  bool archivedOnly,
) {
  return ref
      .watch(sourceConversationRepositoryProvider)
      .watchAll(archivedOnly: archivedOnly);
}

@riverpod
Future<SourceConversation?> sourceConversationById(Ref ref, String id) {
  return ref.watch(sourceConversationRepositoryProvider).find(id);
}
