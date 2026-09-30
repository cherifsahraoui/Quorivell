import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../auth/data/providers/local_user_scope_providers.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/ai_chat_thread.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../repositories/chat_repository_impl.dart';

part 'chat_providers.g.dart';

@riverpod
ChatLocalDataSource chatLocalDataSource(Ref ref) {
  return DriftChatLocalDataSource(ref.watch(appDatabaseProvider));
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepositoryImpl(
    localDataSource: ref.watch(chatLocalDataSourceProvider),
    userScopeRepository: ref.watch(localUserScopeRepositoryProvider),
  );
}

@riverpod
Stream<List<AiChatThread>> chatThreads(Ref ref) {
  return ref.watch(chatRepositoryProvider).watchThreads();
}

@riverpod
Stream<AiChatThread?> chatThreadById(Ref ref, String id) {
  return ref.watch(chatRepositoryProvider).watchThread(id);
}

@riverpod
Stream<List<AiChatMessage>> chatMessages(Ref ref, String threadId) {
  return ref.watch(chatRepositoryProvider).watchMessages(threadId);
}
