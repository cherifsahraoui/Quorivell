import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/extraction_job.dart';

/// Default page size for the pending review queue.
const int reviewQueuePageSize = 100;

abstract interface class ExtractionLocalDataSource {
  Stream<List<ExtractionCandidateRow>> watchPending({
    required String userId,
    int limit,
    int offset,
  });

  Stream<List<ExtractionCandidateRow>> watchRejected({
    required String userId,
    int limit,
    int offset,
  });

  Stream<List<ExtractionRunRow>> watchRuns({
    required String userId,
    int limit,
    int offset,
  });

  Future<SourceConversationRow?> findSourceConversation(String id);

  Future<void> insertCandidates(List<ExtractionCandidateRow> candidates);

  Future<void> insertRun(ExtractionRunRow run);

  /// Archives a source conversation after it has been used for extraction.
  Future<void> archiveSourceConversation({
    required String id,
    required int updatedAt,
  });

  Future<void> updateReview({
    required String candidateId,
    required ExtractionCandidatesCompanion values,
  });

  Future<void> markDeleted({
    required String candidateId,
    required int updatedAt,
  });

  Future<void> markRunDeleted({required String runId, required int updatedAt});

  Future<List<ExtractionCandidateRow>> findCandidatesForSource(
    String sourceConversationId,
  );

  /// Live candidate rows for a source (pending / accepted / rejected).
  Stream<List<ExtractionCandidateRow>> watchCandidatesForSource(
    String sourceConversationId,
  );

  Future<ExtractionJobRow?> loadActiveJob();

  Future<void> upsertJob(ExtractionJobRow row);

  Future<void> clearJob();
}

class DriftExtractionLocalDataSource implements ExtractionLocalDataSource {
  DriftExtractionLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Stream<List<ExtractionCandidateRow>> watchPending({
    required String userId,
    int limit = reviewQueuePageSize,
    int offset = 0,
  }) =>
      (_database.select(_database.extractionCandidates)
            ..where((row) => row.userId.equals(userId))
            ..where((row) => row.reviewStatus.equals('pending'))
            ..where((row) => row.isDeleted.equals(false))
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)])
            ..limit(limit, offset: offset))
          .watch();

  @override
  Stream<List<ExtractionCandidateRow>> watchRejected({
    required String userId,
    int limit = reviewQueuePageSize,
    int offset = 0,
  }) =>
      (_database.select(_database.extractionCandidates)
            ..where((row) => row.userId.equals(userId))
            ..where((row) => row.reviewStatus.equals('rejected'))
            ..where((row) => row.isDeleted.equals(false))
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
            ..limit(limit, offset: offset))
          .watch();

  @override
  Stream<List<ExtractionRunRow>> watchRuns({
    required String userId,
    int limit = reviewQueuePageSize,
    int offset = 0,
  }) =>
      (_database.select(_database.extractionRuns)
            ..where((row) => row.userId.equals(userId))
            ..where((row) => row.isDeleted.equals(false))
            ..orderBy([(row) => OrderingTerm.desc(row.completedAt)])
            ..limit(limit, offset: offset))
          .watch();

  @override
  Future<SourceConversationRow?> findSourceConversation(String id) =>
      (_database.select(_database.sourceConversations)
            ..where((row) => row.id.equals(id))
            ..where((row) => row.isDeleted.equals(false)))
          .getSingleOrNull();

  @override
  Future<void> insertCandidates(List<ExtractionCandidateRow> candidates) {
    return _database.batch((batch) {
      batch.insertAll(_database.extractionCandidates, candidates);
    });
  }

  @override
  Future<void> insertRun(ExtractionRunRow run) {
    return _database.into(_database.extractionRuns).insert(run);
  }

  @override
  Future<void> archiveSourceConversation({
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
  Future<void> updateReview({
    required String candidateId,
    required ExtractionCandidatesCompanion values,
  }) async {
    await (_database.update(
      _database.extractionCandidates,
    )..where((row) => row.id.equals(candidateId))).write(values);
  }

  @override
  Future<void> markDeleted({
    required String candidateId,
    required int updatedAt,
  }) async {
    await (_database.update(
      _database.extractionCandidates,
    )..where((row) => row.id.equals(candidateId))).write(
      ExtractionCandidatesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  @override
  Future<void> markRunDeleted({
    required String runId,
    required int updatedAt,
  }) async {
    await (_database.update(
      _database.extractionRuns,
    )..where((row) => row.id.equals(runId))).write(
      ExtractionRunsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  @override
  Future<List<ExtractionCandidateRow>> findCandidatesForSource(
    String sourceConversationId,
  ) {
    return (_database.select(_database.extractionCandidates)
          ..where(
            (row) => row.sourceConversationId.equals(sourceConversationId),
          )
          ..where((row) => row.isDeleted.equals(false)))
        .get();
  }

  @override
  Stream<List<ExtractionCandidateRow>> watchCandidatesForSource(
    String sourceConversationId,
  ) {
    return (_database.select(_database.extractionCandidates)
          ..where(
            (row) => row.sourceConversationId.equals(sourceConversationId),
          )
          ..where((row) => row.isDeleted.equals(false)))
        .watch();
  }

  @override
  Future<ExtractionJobRow?> loadActiveJob() {
    return (_database.select(
      _database.extractionJobs,
    )..where((row) => row.id.equals(kActiveExtractionJobId))).getSingleOrNull();
  }

  @override
  Future<void> upsertJob(ExtractionJobRow row) {
    return _database.into(_database.extractionJobs).insertOnConflictUpdate(row);
  }

  @override
  Future<void> clearJob() {
    return (_database.delete(
      _database.extractionJobs,
    )..where((row) => row.id.equals(kActiveExtractionJobId))).go();
  }
}
