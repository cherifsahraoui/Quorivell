import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Default page size for conversation history.
///
/// History grows without bound, so every listing query is paged rather than
/// streaming the whole table into memory.
const int sourceConversationPageSize = 50;

abstract interface class SourceConversationLocalDataSource {
  Future<void> insert(SourceConversationsCompanion conversation);

  /// Newest non-deleted, non-archived conversation — the next extract target.
  Future<SourceConversationRow?> latest();

  /// Non-deleted, non-archived captures for extract chooser / extract-all.
  ///
  /// When [limit] is null, returns every matching row.
  Future<List<SourceConversationRow>> listActive({
    int? limit,
    bool newestFirst,
  });

  /// Watches non-deleted conversations, newest first.
  ///
  /// When [archivedOnly] is false, only active (not yet extracted) rows are
  /// returned. When true, only archived rows are returned.
  Stream<List<SourceConversationRow>> watchAll({
    int limit,
    int offset,
    bool archivedOnly,
  });

  Future<SourceConversationRow?> findById(String id);
  Future<void> markDeleted({required String id, required int updatedAt});
  Future<void> markArchived({required String id, required int updatedAt});

  Future<void> markUnarchived({required String id, required int updatedAt});
}

class DriftSourceConversationLocalDataSource
    implements SourceConversationLocalDataSource {
  DriftSourceConversationLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Future<void> insert(SourceConversationsCompanion conversation) {
    return _database.into(_database.sourceConversations).insert(conversation);
  }

  @override
  Future<SourceConversationRow?> latest() =>
      (_database.select(_database.sourceConversations)
            ..where((row) => row.isDeleted.equals(false))
            ..where((row) => row.isArchived.equals(false))
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
            ..limit(1))
          .getSingleOrNull();

  @override
  Future<List<SourceConversationRow>> listActive({
    int? limit,
    bool newestFirst = true,
  }) {
    final query = _database.select(_database.sourceConversations)
      ..where((row) => row.isDeleted.equals(false))
      ..where((row) => row.isArchived.equals(false))
      ..orderBy([
        (row) => newestFirst
            ? OrderingTerm.desc(row.updatedAt)
            : OrderingTerm.asc(row.updatedAt),
      ]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.get();
  }

  @override
  Stream<List<SourceConversationRow>> watchAll({
    int limit = sourceConversationPageSize,
    int offset = 0,
    bool archivedOnly = false,
  }) =>
      (_database.select(_database.sourceConversations)
            ..where((row) => row.isDeleted.equals(false))
            ..where((row) => row.isArchived.equals(archivedOnly))
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
            ..limit(limit, offset: offset))
          .watch();

  @override
  Future<SourceConversationRow?> findById(String id) =>
      (_database.select(_database.sourceConversations)
            ..where((row) => row.id.equals(id))
            ..where((row) => row.isDeleted.equals(false)))
          .getSingleOrNull();

  @override
  Future<void> markDeleted({required String id, required int updatedAt}) async {
    await (_database.update(
      _database.sourceConversations,
    )..where((row) => row.id.equals(id))).write(
      SourceConversationsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  @override
  Future<void> markArchived({
    required String id,
    required int updatedAt,
  }) async {
    await (_database.update(
      _database.sourceConversations,
    )..where((row) => row.id.equals(id))).write(
      SourceConversationsCompanion(
        isArchived: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  @override
  Future<void> markUnarchived({
    required String id,
    required int updatedAt,
  }) async {
    final existing = await findById(id);
    final nextRevision = (existing?.sourceRevision ?? 0) + 1;
    await (_database.update(
      _database.sourceConversations,
    )..where((row) => row.id.equals(id))).write(
      SourceConversationsCompanion(
        isArchived: const Value(false),
        // New extract must not share prior candidates for run Result counts.
        sourceRevision: Value(nextRevision),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
