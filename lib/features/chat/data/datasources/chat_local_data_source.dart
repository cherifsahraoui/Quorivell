import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/repositories/chat_repository.dart';

abstract interface class ChatLocalDataSource {
  Stream<List<ChatThreadRow>> watchThreads({
    required String userId,
    int limit,
    int offset,
  });

  Stream<ChatThreadRow?> watchThread({
    required String userId,
    required String id,
  });

  Stream<List<ChatMessageRow>> watchMessages({
    required String userId,
    required String threadId,
    int limit,
    int offset,
  });

  Future<List<ChatMessageRow>> listMessages({
    required String userId,
    required String threadId,
  });

  Future<ChatThreadRow?> findThread({
    required String userId,
    required String id,
  });

  Future<void> insertThread(ChatThreadsCompanion thread);

  Future<void> insertMessage(ChatMessagesCompanion message);

  Future<void> touchThread({
    required String id,
    required String userId,
    required int updatedAt,
    String? modelId,
    bool updateModelId = false,
  });

  /// Soft-deletes the thread and all of its messages. Returns `false` when
  /// no matching non-deleted thread exists.
  Future<bool> markThreadDeleted({
    required String id,
    required String userId,
    required int updatedAt,
  });
}

class DriftChatLocalDataSource implements ChatLocalDataSource {
  DriftChatLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Stream<List<ChatThreadRow>> watchThreads({
    required String userId,
    int limit = chatThreadPageSize,
    int offset = 0,
  }) {
    final query = _database.select(_database.chatThreads)
      ..where((row) => row.userId.equals(userId))
      ..where((row) => row.isDeleted.equals(false))
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
      ..limit(limit, offset: offset);
    return query.watch();
  }

  @override
  Stream<ChatThreadRow?> watchThread({
    required String userId,
    required String id,
  }) {
    return (_database.select(_database.chatThreads)
          ..where((row) => row.id.equals(id))
          ..where((row) => row.userId.equals(userId))
          ..where((row) => row.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  @override
  Stream<List<ChatMessageRow>> watchMessages({
    required String userId,
    required String threadId,
    int limit = chatMessagePageSize,
    int offset = 0,
  }) {
    final query = _database.select(_database.chatMessages)
      ..where((row) => row.userId.equals(userId))
      ..where((row) => row.threadId.equals(threadId))
      ..where((row) => row.isDeleted.equals(false))
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)])
      ..limit(limit, offset: offset);
    return query.watch();
  }

  @override
  Future<List<ChatMessageRow>> listMessages({
    required String userId,
    required String threadId,
  }) {
    return (_database.select(_database.chatMessages)
          ..where((row) => row.userId.equals(userId))
          ..where((row) => row.threadId.equals(threadId))
          ..where((row) => row.isDeleted.equals(false))
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)])
          ..limit(chatMessagePageSize))
        .get();
  }

  @override
  Future<ChatThreadRow?> findThread({
    required String userId,
    required String id,
  }) {
    return (_database.select(_database.chatThreads)
          ..where((row) => row.id.equals(id))
          ..where((row) => row.userId.equals(userId))
          ..where((row) => row.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  @override
  Future<void> insertThread(ChatThreadsCompanion thread) {
    return _database.into(_database.chatThreads).insert(thread);
  }

  @override
  Future<void> insertMessage(ChatMessagesCompanion message) {
    return _database.into(_database.chatMessages).insert(message);
  }

  @override
  Future<void> touchThread({
    required String id,
    required String userId,
    required int updatedAt,
    String? modelId,
    bool updateModelId = false,
  }) {
    return (_database.update(_database.chatThreads)
          ..where((row) => row.id.equals(id))
          ..where((row) => row.userId.equals(userId)))
        .write(
          ChatThreadsCompanion(
            updatedAt: Value(updatedAt),
            modelId: updateModelId ? Value(modelId) : const Value.absent(),
            syncStatus: const Value(0),
          ),
        );
  }

  @override
  Future<bool> markThreadDeleted({
    required String id,
    required String userId,
    required int updatedAt,
  }) {
    return _database.transaction(() async {
      final updated =
          await (_database.update(_database.chatThreads)
                ..where((row) => row.id.equals(id))
                ..where((row) => row.userId.equals(userId))
                ..where((row) => row.isDeleted.equals(false)))
              .write(
                ChatThreadsCompanion(
                  isDeleted: const Value(true),
                  updatedAt: Value(updatedAt),
                  syncStatus: const Value(0),
                ),
              );
      if (updated == 0) return false;
      await (_database.update(_database.chatMessages)
            ..where((row) => row.threadId.equals(id))
            ..where((row) => row.userId.equals(userId)))
          .write(
            ChatMessagesCompanion(
              isDeleted: const Value(true),
              updatedAt: Value(updatedAt),
              syncStatus: const Value(0),
            ),
          );
      return true;
    });
  }
}
