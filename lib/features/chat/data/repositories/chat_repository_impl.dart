import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../../auth/domain/repositories/local_user_scope_repository.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/ai_chat_thread.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';

const int chatThreadTitleMaxLength = 80;

String chatThreadTitleFrom(String text) {
  final collapsed = text.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (collapsed.length <= chatThreadTitleMaxLength) return collapsed;
  return collapsed.substring(0, chatThreadTitleMaxLength);
}

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ChatLocalDataSource localDataSource,
    required LocalUserScopeRepository userScopeRepository,
    Uuid? uuid,
    DateTime Function()? now,
  }) : _localDataSource = localDataSource,
       _userScopeRepository = userScopeRepository,
       _uuid = uuid ?? const Uuid(),
       _now = now ?? (() => DateTime.now().toUtc());

  final ChatLocalDataSource _localDataSource;
  final LocalUserScopeRepository _userScopeRepository;
  final Uuid _uuid;
  final DateTime Function() _now;

  @override
  Stream<List<AiChatThread>> watchThreads({
    int limit = chatThreadPageSize,
    int offset = 0,
  }) {
    return guardLocalStream(() async* {
      final user = await _userScopeRepository.getOrCreate();
      yield* _localDataSource
          .watchThreads(userId: user.id, limit: limit, offset: offset)
          .map((rows) => rows.map(_threadFromRow).toList());
    });
  }

  @override
  Stream<AiChatThread?> watchThread(String id) {
    return guardLocalStream(() async* {
      final user = await _userScopeRepository.getOrCreate();
      yield* _localDataSource
          .watchThread(userId: user.id, id: id)
          .map((row) => row == null ? null : _threadFromRow(row));
    });
  }

  @override
  Stream<List<AiChatMessage>> watchMessages(
    String threadId, {
    int limit = chatMessagePageSize,
    int offset = 0,
  }) {
    return guardLocalStream(() async* {
      final user = await _userScopeRepository.getOrCreate();
      yield* _localDataSource
          .watchMessages(
            userId: user.id,
            threadId: threadId,
            limit: limit,
            offset: offset,
          )
          .map((rows) => rows.map(_messageFromRow).toList());
    });
  }

  @override
  Future<List<AiChatMessage>> listMessages(String threadId) {
    return guardLocalRead(() async {
      final user = await _userScopeRepository.getOrCreate();
      final rows = await _localDataSource.listMessages(
        userId: user.id,
        threadId: threadId,
      );
      return rows.map(_messageFromRow).toList();
    });
  }

  @override
  Future<AiChatThread> createThread({required String title, String? modelId}) {
    return guardLocalWrite(() async {
      final normalizedTitle = chatThreadTitleFrom(title);
      if (normalizedTitle.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      final user = await _userScopeRepository.getOrCreate();
      final timestamp = _now();
      final thread = AiChatThread(
        id: _uuid.v4(),
        userId: user.id,
        title: normalizedTitle,
        modelId: modelId,
        createdAt: timestamp,
        updatedAt: timestamp,
      );
      await _localDataSource.insertThread(
        ChatThreadsCompanion.insert(
          id: thread.id,
          userId: thread.userId,
          title: thread.title,
          modelId: Value(thread.modelId),
          createdAt: thread.createdAt.millisecondsSinceEpoch,
          updatedAt: thread.updatedAt.millisecondsSinceEpoch,
        ),
      );
      return thread;
    });
  }

  @override
  Future<AiChatMessage> appendMessage({
    required String threadId,
    required AiChatRole role,
    required String content,
    AiChatMessageStatus status = AiChatMessageStatus.complete,
    String? modelId,
  }) {
    return guardLocalWrite(() async {
      final normalizedThreadId = threadId.trim();
      final normalizedContent = content.trim();
      if (normalizedThreadId.isEmpty ||
          (normalizedContent.isEmpty && status != AiChatMessageStatus.error)) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      final user = await _userScopeRepository.getOrCreate();
      final thread = await _localDataSource.findThread(
        userId: user.id,
        id: normalizedThreadId,
      );
      if (thread == null) {
        throw const LocalPersistenceFailure.notFound();
      }
      final timestamp = _now();
      final message = AiChatMessage(
        id: _uuid.v4(),
        userId: user.id,
        threadId: normalizedThreadId,
        role: role,
        content: normalizedContent,
        status: status,
        createdAt: timestamp,
        updatedAt: timestamp,
      );
      await _localDataSource.insertMessage(
        ChatMessagesCompanion.insert(
          id: message.id,
          userId: message.userId,
          threadId: message.threadId,
          role: message.role.name,
          content: message.content,
          status: message.status.name,
          createdAt: message.createdAt.millisecondsSinceEpoch,
          updatedAt: message.updatedAt.millisecondsSinceEpoch,
        ),
      );
      await _localDataSource.touchThread(
        id: normalizedThreadId,
        userId: user.id,
        updatedAt: timestamp.millisecondsSinceEpoch,
        modelId: modelId,
        updateModelId: modelId != null,
      );
      return message;
    });
  }

  @override
  Future<void> updateThreadModelId({
    required String threadId,
    required String? modelId,
  }) {
    return guardLocalWrite(() async {
      final normalizedThreadId = threadId.trim();
      if (normalizedThreadId.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      final user = await _userScopeRepository.getOrCreate();
      final thread = await _localDataSource.findThread(
        userId: user.id,
        id: normalizedThreadId,
      );
      if (thread == null) {
        throw const LocalPersistenceFailure.notFound();
      }
      await _localDataSource.touchThread(
        id: normalizedThreadId,
        userId: user.id,
        updatedAt: _now().millisecondsSinceEpoch,
        modelId: modelId,
        updateModelId: true,
      );
    });
  }

  @override
  Future<void> deleteThread(String id) {
    return guardLocalWrite(() async {
      final normalizedId = id.trim();
      if (normalizedId.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      final user = await _userScopeRepository.getOrCreate();
      final deleted = await _localDataSource.markThreadDeleted(
        id: normalizedId,
        userId: user.id,
        updatedAt: _now().millisecondsSinceEpoch,
      );
      if (!deleted) {
        throw const LocalPersistenceFailure.notFound();
      }
    });
  }

  AiChatThread _threadFromRow(ChatThreadRow row) => AiChatThread(
    id: row.id,
    userId: row.userId,
    title: row.title,
    modelId: row.modelId,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt, isUtc: true),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt, isUtc: true),
  );

  AiChatMessage _messageFromRow(ChatMessageRow row) => AiChatMessage(
    id: row.id,
    userId: row.userId,
    threadId: row.threadId,
    role: AiChatRole.values.byName(row.role),
    content: row.content,
    status: AiChatMessageStatus.values.byName(row.status),
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt, isUtc: true),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt, isUtc: true),
  );
}
