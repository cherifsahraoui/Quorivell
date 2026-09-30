import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../../auth/domain/repositories/local_user_scope_repository.dart';
import '../../domain/entities/source_conversation.dart';
import '../../domain/repositories/source_conversation_repository.dart';
import '../datasources/source_conversation_local_data_source.dart';

class SourceConversationRepositoryImpl implements SourceConversationRepository {
  SourceConversationRepositoryImpl({
    required SourceConversationLocalDataSource localDataSource,
    required LocalUserScopeRepository localUserScopeRepository,
    Uuid? uuid,
    DateTime Function()? now,
  }) : _localDataSource = localDataSource,
       _localUserScopeRepository = localUserScopeRepository,
       _uuid = uuid ?? const Uuid(),
       _now = now ?? (() => DateTime.now().toUtc());

  final SourceConversationLocalDataSource _localDataSource;
  final LocalUserScopeRepository _localUserScopeRepository;
  final Uuid _uuid;
  final DateTime Function() _now;

  @override
  Future<SourceConversation> capture(String content) {
    return guardLocalWrite(() async {
      final normalizedContent = content.trim();
      if (normalizedContent.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }

      final userScope = await _localUserScopeRepository.getOrCreate();
      final timestamp = _now();
      final conversation = SourceConversation(
        id: _uuid.v4(),
        userId: userScope.id,
        content: normalizedContent,
        sourceRevision: 1,
        createdAt: timestamp,
        updatedAt: timestamp,
      );
      await _localDataSource.insert(
        SourceConversationsCompanion.insert(
          id: conversation.id,
          userId: conversation.userId,
          content: conversation.content,
          sourceRevision: conversation.sourceRevision,
          createdAt: conversation.createdAt.millisecondsSinceEpoch,
          updatedAt: conversation.updatedAt.millisecondsSinceEpoch,
        ),
      );
      return conversation;
    });
  }

  @override
  Future<SourceConversation?> latest() => guardLocalRead(() async {
    final row = await _localDataSource.latest();
    return row == null ? null : _fromRow(row);
  });

  @override
  Future<List<SourceConversation>> listActive({
    int? limit,
    bool newestFirst = true,
  }) => guardLocalRead(() async {
    final rows = await _localDataSource.listActive(
      limit: limit,
      newestFirst: newestFirst,
    );
    return rows.map(_fromRow).toList();
  });

  @override
  Stream<List<SourceConversation>> watchAll({
    int limit = sourceConversationPageSize,
    int offset = 0,
    bool archivedOnly = false,
  }) {
    return guardLocalStream(
      () => _localDataSource
          .watchAll(limit: limit, offset: offset, archivedOnly: archivedOnly)
          .map((rows) => rows.map(_fromRow).toList()),
    );
  }

  @override
  Future<SourceConversation?> find(String id) => guardLocalRead(() async {
    final row = await _localDataSource.findById(id);
    return row == null ? null : _fromRow(row);
  });

  @override
  Future<void> delete(String id) {
    return guardLocalWrite(() async {
      final normalizedId = id.trim();
      if (normalizedId.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      await _localDataSource.markDeleted(
        id: normalizedId,
        updatedAt: _now().millisecondsSinceEpoch,
      );
    });
  }

  @override
  Future<void> archive(String id) {
    return guardLocalWrite(() async {
      final normalizedId = id.trim();
      if (normalizedId.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      await _localDataSource.markArchived(
        id: normalizedId,
        updatedAt: _now().millisecondsSinceEpoch,
      );
    });
  }

  @override
  Future<void> unarchive(String id) {
    return guardLocalWrite(() async {
      final normalizedId = id.trim();
      if (normalizedId.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      await _localDataSource.markUnarchived(
        id: normalizedId,
        updatedAt: _now().millisecondsSinceEpoch,
      );
    });
  }

  SourceConversation _fromRow(SourceConversationRow row) => SourceConversation(
    id: row.id,
    userId: row.userId,
    content: row.content,
    sourceRevision: row.sourceRevision,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt, isUtc: true),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt, isUtc: true),
    isArchived: row.isArchived,
  );
}
