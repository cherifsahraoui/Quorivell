import '../entities/ai_chat_message.dart';
import '../entities/ai_chat_thread.dart';

/// Default page size for chat thread listings.
const int chatThreadPageSize = 100;

/// Default page size for messages in one thread.
const int chatMessagePageSize = 200;

abstract interface class ChatRepository {
  /// Newest threads first.
  Stream<List<AiChatThread>> watchThreads({int limit, int offset});

  Stream<AiChatThread?> watchThread(String id);

  /// Oldest messages first so the composer can append at the end.
  Stream<List<AiChatMessage>> watchMessages(
    String threadId, {
    int limit,
    int offset,
  });

  Future<List<AiChatMessage>> listMessages(String threadId);

  Future<AiChatThread> createThread({required String title, String? modelId});

  Future<AiChatMessage> appendMessage({
    required String threadId,
    required AiChatRole role,
    required String content,
    AiChatMessageStatus status = AiChatMessageStatus.complete,

    /// When set, updates the thread's recorded on-device model.
    String? modelId,
  });

  /// Records the on-device model last used for this thread (e.g. on retry).
  Future<void> updateThreadModelId({
    required String threadId,
    required String? modelId,
  });

  /// Soft-deletes the thread and its messages.
  Future<void> deleteThread(String id);
}
