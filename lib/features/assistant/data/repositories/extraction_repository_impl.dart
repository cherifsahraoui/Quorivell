import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/ai/extraction_kind_prompt_spec.dart';
import '../../../../core/ai/local_ai_service.dart';
import '../../../../core/ai/local_model_store.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../../auth/domain/repositories/local_user_scope_repository.dart';
import '../../../extraction_kinds/domain/extraction_kind_prompt_mapping.dart';
import '../../../extraction_kinds/domain/repositories/extraction_item_kind_repository.dart';
import '../../domain/entities/extraction_job.dart';
import '../../domain/entities/extraction_progress.dart';
import '../../domain/entities/extraction_run.dart';
import '../../domain/entities/review_candidate.dart';
import '../../domain/repositories/extraction_repository.dart';
import '../../domain/repositories/extraction_run_repository.dart';
import '../datasources/extraction_local_data_source.dart';

class ExtractionRepositoryImpl implements ExtractionRepository {
  ExtractionRepositoryImpl({
    required ExtractionLocalDataSource localDataSource,
    required LocalUserScopeRepository userScopeRepository,
    required LocalAIService aiService,
    required LocalAICopy copy,
    ExtractionItemKindRepository? kindRepository,
    LocalAICopy Function(List<ExtractionKindPromptSpec> kinds)? copyForKinds,
    ExtractionRunRepository? runRepository,
    LocalModelStore? modelStore,
    Uuid? uuid,
    DateTime Function()? now,
  }) : _localDataSource = localDataSource,
       _userScopeRepository = userScopeRepository,
       _aiService = aiService,
       _copy = copy,
       _kindRepository = kindRepository,
       _copyForKinds = copyForKinds,
       _runRepository = runRepository,
       _modelStore = modelStore,
       _uuid = uuid ?? const Uuid(),
       _now = now ?? (() => DateTime.now().toUtc());

  final ExtractionLocalDataSource _localDataSource;
  final LocalUserScopeRepository _userScopeRepository;
  final LocalAIService _aiService;
  final LocalAICopy _copy;
  final ExtractionItemKindRepository? _kindRepository;
  final LocalAICopy Function(List<ExtractionKindPromptSpec> kinds)?
  _copyForKinds;
  final ExtractionRunRepository? _runRepository;
  final LocalModelStore? _modelStore;
  final Uuid _uuid;
  final DateTime Function() _now;
  var _cancelRequested = false;

  @override
  Stream<List<ReviewCandidate>> watchPending({
    int limit = reviewQueuePageSize,
    int offset = 0,
  }) {
    return guardLocalStream(() async* {
      final user = await _userScopeRepository.getOrCreate();
      yield* _localDataSource
          .watchPending(userId: user.id, limit: limit, offset: offset)
          .map((rows) => rows.map(_fromRow).toList());
    });
  }

  @override
  Stream<List<ReviewCandidate>> watchRejected({
    int limit = reviewQueuePageSize,
    int offset = 0,
  }) {
    return guardLocalStream(() async* {
      final user = await _userScopeRepository.getOrCreate();
      yield* _localDataSource
          .watchRejected(userId: user.id, limit: limit, offset: offset)
          .map((rows) => rows.map(_fromRow).toList());
    });
  }

  @override
  Future<List<ReviewCandidate>> extract(String sourceConversationId) async {
    final source = await guardLocalRead(
      () => _localDataSource.findSourceConversation(sourceConversationId),
    );
    if (source == null) {
      throw const ExtractionFailure.noSourceConversation();
    }

    final startedAt = _now();
    final copy = await _copyForExtract();
    final LocalAIResponse response;
    try {
      response = await _aiService.extract(
        LocalAIRequest(text: source.content, copy: copy),
      );
    } on LocalAIException catch (error) {
      await _recordRunSafely(
        source: source,
        startedAt: startedAt,
        success: false,
        copy: copy,
      );
      throw _mapLocalAIException(error);
    } on AppFailure {
      await _recordRunSafely(
        source: source,
        startedAt: startedAt,
        success: false,
        copy: copy,
      );
      rethrow;
    } on Object {
      await _recordRunSafely(
        source: source,
        startedAt: startedAt,
        success: false,
        copy: copy,
      );
      throw const ExtractionFailure.unknown();
    }

    final timestamp = _now().millisecondsSinceEpoch;
    final candidates = response.candidates
        .map(
          (candidate) => ExtractionCandidateRow(
            id: _uuid.v4(),
            userId: source.userId,
            sourceConversationId: source.id,
            sourceRevision: source.sourceRevision,
            kind: candidate.kind,
            statement: candidate.statement,
            owner: candidate.owner,
            dueDate: candidate.dueDate?.millisecondsSinceEpoch,
            quoteStart: candidate.evidence.quoteStart,
            quoteEnd: candidate.evidence.quoteEnd,
            quoteSnippet: candidate.evidence.quoteSnippet,
            reviewStatus: ReviewStatus.pending.name,
            createdAt: timestamp,
            updatedAt: timestamp,
            isDeleted: false,
            syncStatus: 0,
          ),
        )
        .toList();

    await guardLocalWrite(() async {
      await _localDataSource.insertCandidates(candidates);
      await _localDataSource.archiveSourceConversation(
        id: source.id,
        updatedAt: timestamp,
      );
    });
    await _recordRunSafely(
      source: source,
      startedAt: startedAt,
      success: true,
      copy: copy,
    );
    return candidates.map(_fromRow).toList();
  }

  @override
  Stream<ExtractionProgressUpdate> extractChunked(
    String sourceConversationId,
  ) async* {
    final source = await guardLocalRead(
      () => _localDataSource.findSourceConversation(sourceConversationId),
    );
    if (source == null) {
      await _clearJobQuietly();
      throw const ExtractionFailure.noSourceConversation();
    }
    if (source.isArchived) {
      await _clearJobQuietly();
      throw const ExtractionFailure.sourceArchived();
    }

    if (_cancelRequested) {
      await _clearJobQuietly();
      throw const ExtractionFailure.cancelled();
    }

    var job = await loadActiveJob();
    if (job != null &&
        (job.sourceConversationId != source.id ||
            job.sourceRevision != source.sourceRevision)) {
      await _clearJobQuietly();
      job = null;
    }
    job ??= ExtractionJob(
      sourceConversationId: source.id,
      sourceRevision: source.sourceRevision,
      startTime: _now(),
    );
    await upsertJob(job);

    final copy = await _copyForExtract();
    ExtractionProgressUpdate? lastUpdate;
    try {
      await for (final event in _extractChunkedInternal(
        source,
        job,
        copy: copy,
      )) {
        if (_cancelRequested) {
          await _clearJobQuietly();
          throw const ExtractionFailure.cancelled();
        }
        lastUpdate = event;
        yield event;
      }

      if (_cancelRequested) {
        await _clearJobQuietly();
        throw const ExtractionFailure.cancelled();
      }

      final completedJob = await loadActiveJob() ?? job;
      final candidatesFound =
          lastUpdate?.progress.candidatesFound ?? completedJob.candidatesFound;

      await guardLocalWrite(() async {
        await _localDataSource.archiveSourceConversation(
          id: source.id,
          updatedAt: _now().millisecondsSinceEpoch,
        );
      });

      await _recordRunSafely(
        source: source,
        startedAt: completedJob.startTime,
        success: true,
        copy: copy,
      );

      await _promoteOrClearAfterConversationSuccess(
        completedJob: completedJob.copyWith(candidatesFound: candidatesFound),
      );
    } on ExtractionCancelledFailure {
      await _clearJobQuietly();
      rethrow;
    } on LocalAIException catch (error) {
      if (error.code == 'cancelled' || _cancelRequested) {
        await _clearJobQuietly();
        throw const ExtractionFailure.cancelled();
      }
      await _recordRunSafely(
        source: source,
        startedAt: job.startTime,
        success: false,
        copy: copy,
      );
      await _clearJobQuietly();
      throw _mapLocalAIException(error);
    } on AppFailure {
      await _recordRunSafely(
        source: source,
        startedAt: job.startTime,
        success: false,
        copy: copy,
      );
      await _clearJobQuietly();
      rethrow;
    } on Object {
      if (_cancelRequested) {
        await _clearJobQuietly();
        throw const ExtractionFailure.cancelled();
      }
      await _recordRunSafely(
        source: source,
        startedAt: job.startTime,
        success: false,
        copy: copy,
      );
      await _clearJobQuietly();
      throw const ExtractionFailure.unknown();
    }
  }

  Stream<ExtractionProgressUpdate> _extractChunkedInternal(
    SourceConversationRow source,
    ExtractionJob job, {
    required LocalAICopy copy,
  }) async* {
    final chunkTimings = [...job.chunkTimings];
    var totalCandidates = job.candidatesFound;
    final skipChunks = job.completedChunkCount;
    final existing = await guardLocalRead(
      () => _localDataSource.findCandidatesForSource(source.id),
    );
    final seenKeys = {
      for (final row in existing) _candidateDedupKeyFromRow(row),
    };

    await for (final chunkResult in _streamChunkedExtraction(
      source,
      skipChunks: skipChunks,
      copy: copy,
    )) {
      if (_cancelRequested) {
        throw const LocalAIException('cancelled', 'Extraction was cancelled.');
      }
      final chunkSeconds = chunkResult.chunkDurationMs / 1000.0;
      chunkTimings.add(chunkSeconds);

      final timestamp = _now().millisecondsSinceEpoch;
      final candidateRows = <ExtractionCandidateRow>[];
      for (final candidate in chunkResult.candidates) {
        final row = ExtractionCandidateRow(
          id: _uuid.v4(),
          userId: source.userId,
          sourceConversationId: source.id,
          sourceRevision: source.sourceRevision,
          kind: candidate.kind,
          statement: candidate.statement,
          owner: candidate.owner,
          dueDate: candidate.dueDate?.millisecondsSinceEpoch,
          quoteStart: candidate.evidence.quoteStart,
          quoteEnd: candidate.evidence.quoteEnd,
          quoteSnippet: candidate.evidence.quoteSnippet,
          reviewStatus: ReviewStatus.pending.name,
          createdAt: timestamp,
          updatedAt: timestamp,
          isDeleted: false,
          syncStatus: 0,
        );
        if (seenKeys.add(_candidateDedupKeyFromRow(row))) {
          candidateRows.add(row);
        }
      }

      if (candidateRows.isNotEmpty) {
        await guardLocalWrite(
          () => _localDataSource.insertCandidates(candidateRows),
        );
      }

      totalCandidates += candidateRows.length;
      final domainCandidates = candidateRows.map(_fromRow).toList();

      final progress = ExtractionProgress(
        currentChunk: chunkResult.chunkIndex,
        totalChunks: chunkResult.totalChunks,
        candidatesFound: totalCandidates,
        chunkTimings: List.unmodifiable(chunkTimings),
        startTime: job.startTime,
        endTime: chunkResult.chunkIndex == chunkResult.totalChunks
            ? _now()
            : null,
        batchIndex: job.batchIndex,
        batchTotal: job.batchTotal <= 0 ? 1 : job.batchTotal,
      );

      await upsertJob(
        job.copyWith(
          completedChunkCount: chunkResult.chunkIndex,
          totalChunks: chunkResult.totalChunks,
          candidatesFound: totalCandidates,
          chunkTimings: progress.chunkTimings,
        ),
      );

      yield ExtractionProgressUpdate(
        progress: progress,
        newCandidates: domainCandidates,
      );
    }
  }

  Stream<ExtractionChunkResult> _streamChunkedExtraction(
    SourceConversationRow source, {
    required int skipChunks,
    required LocalAICopy copy,
  }) {
    final controller = StreamController<ExtractionChunkResult>();

    _aiService
        .extractChunked(
          LocalAIRequest(text: source.content, copy: copy),
          skipChunks: skipChunks,
          onChunk: (chunk) {
            if (_cancelRequested || controller.isClosed) return;
            controller.add(chunk);
          },
        )
        .then((_) {
          if (controller.isClosed) return;
          if (_cancelRequested) {
            controller.addError(
              const LocalAIException('cancelled', 'Extraction was cancelled.'),
            );
          }
          controller.close();
        })
        .catchError((Object error) {
          if (controller.isClosed) return;
          controller.addError(error);
          controller.close();
        });

    return controller.stream;
  }

  @override
  Future<ExtractionJob?> loadActiveJob() {
    return guardLocalRead(() async {
      final row = await _localDataSource.loadActiveJob();
      return row == null ? null : _jobFromRow(row);
    });
  }

  @override
  Future<void> upsertJob(ExtractionJob job) {
    if (_cancelRequested) {
      return Future<void>.value();
    }
    return guardLocalWrite(() async {
      // Re-check inside the write: a cancel can clear the row between the
      // outer guard and this body; writing again would revive a stopped job
      // and force the user to Stop a second time.
      if (_cancelRequested) return;
      final now = _now().millisecondsSinceEpoch;
      final existing = await _localDataSource.loadActiveJob();
      if (_cancelRequested) return;
      await _localDataSource.upsertJob(
        ExtractionJobRow(
          id: kActiveExtractionJobId,
          sourceConversationId: job.sourceConversationId,
          sourceRevision: job.sourceRevision,
          completedChunkCount: job.completedChunkCount,
          totalChunks: job.totalChunks,
          candidatesFound: job.candidatesFound,
          startTimeMs: job.startTime.millisecondsSinceEpoch,
          chunkTimingsJson: jsonEncode(job.chunkTimings),
          progressTitle: job.progressTitle,
          progressBody: job.progressBody,
          completionTitle: job.completionTitle,
          queuedSourceConversationIdsJson: jsonEncode(
            job.queuedSourceConversationIds,
          ),
          batchIndex: job.batchIndex,
          batchTotal: job.batchTotal <= 0 ? 1 : job.batchTotal,
          createdAt: existing?.createdAt ?? now,
          updatedAt: now,
        ),
      );
      if (_cancelRequested) {
        await _localDataSource.clearJob();
      }
    });
  }

  @override
  Future<void> clearJob() => _clearJobQuietly();

  @override
  Future<void> prepareRun() async {
    _cancelRequested = false;
    _aiService.prepareExtraction();
  }

  @override
  Future<void> cancelActive() async {
    _cancelRequested = true;
    try {
      await _aiService.cancelExtraction();
    } on Object {
      // Generation may already have finished.
    }
    await _clearJobQuietly();
  }

  /// History must not fail the extract path.
  Future<void> _recordRunSafely({
    required SourceConversationRow source,
    required DateTime startedAt,
    required bool success,
    required LocalAICopy copy,
  }) async {
    try {
      await _persistExtractionRun(
        source: source,
        startedAt: startedAt,
        success: success,
        copy: copy,
      );
    } on Object {
      // Best-effort aggregate row only.
    }
  }

  /// Persists an extraction run record with privacy-safe aggregates.
  Future<void> _persistExtractionRun({
    required SourceConversationRow source,
    required DateTime startedAt,
    required bool success,
    required LocalAICopy copy,
  }) async {
    final runRepo = _runRepository;
    if (runRepo == null) return;

    final endTime = _now();
    final durationMs = endTime
        .difference(startedAt)
        .inMilliseconds
        .clamp(0, 86400000)
        .toInt();

    var modelId = _aiService.modelId;
    String? modelDisplayName;
    try {
      final store = _modelStore;
      if (store != null) {
        final identity = await store.readInstalledIdentity();
        if (identity != null) {
          modelId = identity.modelId;
          final fileName = identity.fileName.trim();
          if (fileName.isNotEmpty && fileName != modelId) {
            modelDisplayName = fileName;
          }
        }
      }
    } on Object {
      // Model identity fetch is best-effort
    }

    final candidates = await guardLocalRead(
      () => _localDataSource.findCandidatesForSource(source.id),
    );
    var acceptedCount = 0;
    var rejectedCount = 0;
    var pendingCount = 0;
    final kindCounts = <String, int>{};
    // Only count candidates produced by *this* run. Re-extract after unarchive
    // leaves prior rows on the same source id / revision; including them makes
    // Results pending (and kind totals) look wrong on history detail.
    final startedMs = startedAt.millisecondsSinceEpoch;
    final endMs = endTime.millisecondsSinceEpoch;

    for (final candidate in candidates) {
      if (candidate.sourceRevision != source.sourceRevision) continue;
      if (candidate.createdAt < startedMs || candidate.createdAt > endMs) {
        continue;
      }
      kindCounts[candidate.kind] = (kindCounts[candidate.kind] ?? 0) + 1;

      if (candidate.reviewStatus == 'accepted') {
        acceptedCount++;
      } else if (candidate.reviewStatus == 'rejected') {
        rejectedCount++;
      } else if (candidate.reviewStatus == 'pending') {
        pendingCount++;
      }
    }

    final run = ExtractionRun(
      id: _uuid.v4(),
      userId: source.userId,
      sourceConversationId: source.id,
      sourceConversationTitle: null,
      modelId: modelId,
      modelDisplayName: modelDisplayName,
      startedAt: startedAt,
      completedAt: endTime,
      status: success
          ? ExtractionRunStatus.success
          : ExtractionRunStatus.failure,
      durationMs: durationMs,
      enabledKindSlugs: copy.enabledKindSlugs.toList()..sort(),
      kindCounts: kindCounts,
      acceptedCount: acceptedCount,
      rejectedCount: rejectedCount,
      pendingCount: pendingCount,
    );

    await runRepo.createRun(run);
  }

  /// After one conversation finishes, either clear the job or advance to the
  /// next queued active source so process-death resume can continue the batch.
  Future<void> _promoteOrClearAfterConversationSuccess({
    required ExtractionJob completedJob,
  }) async {
    if (_cancelRequested) {
      await _clearJobQuietly();
      return;
    }
    final remaining = [...completedJob.queuedSourceConversationIds];
    while (remaining.isNotEmpty) {
      final nextId = remaining.removeAt(0);
      final next = await guardLocalRead(
        () => _localDataSource.findSourceConversation(nextId),
      );
      if (next == null || next.isArchived) {
        continue;
      }
      final nextBatchIndex = completedJob.batchTotal - remaining.length - 1;
      await upsertJob(
        ExtractionJob(
          sourceConversationId: next.id,
          sourceRevision: next.sourceRevision,
          candidatesFound: completedJob.candidatesFound,
          startTime: completedJob.startTime,
          progressTitle: completedJob.progressTitle,
          progressBody: completedJob.progressBody,
          completionTitle: completedJob.completionTitle,
          queuedSourceConversationIds: remaining,
          batchIndex: nextBatchIndex < 0 ? 0 : nextBatchIndex,
          batchTotal: completedJob.batchTotal <= 0
              ? 1
              : completedJob.batchTotal,
        ),
      );
      return;
    }
    await _clearJobQuietly();
  }

  Future<void> _clearJobQuietly() {
    return guardLocalWrite(_localDataSource.clearJob);
  }

  String _candidateDedupKeyFromRow(ExtractionCandidateRow row) =>
      '${row.kind}:${row.statement.trim().toLowerCase()}:'
      '${row.quoteStart}:${row.quoteSnippet}';

  ExtractionJob _jobFromRow(ExtractionJobRow row) {
    return ExtractionJob(
      id: row.id,
      sourceConversationId: row.sourceConversationId,
      sourceRevision: row.sourceRevision,
      completedChunkCount: row.completedChunkCount,
      totalChunks: row.totalChunks,
      candidatesFound: row.candidatesFound,
      startTime: DateTime.fromMillisecondsSinceEpoch(
        row.startTimeMs,
        isUtc: true,
      ),
      chunkTimings: _decodeChunkTimings(row.chunkTimingsJson),
      progressTitle: row.progressTitle,
      progressBody: row.progressBody,
      completionTitle: row.completionTitle,
      queuedSourceConversationIds: _decodeQueuedIds(
        row.queuedSourceConversationIdsJson,
      ),
      batchIndex: row.batchIndex,
      batchTotal: row.batchTotal <= 0 ? 1 : row.batchTotal,
    );
  }

  List<String> _decodeQueuedIds(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return const [];
      return [
        for (final value in decoded)
          if (value is String && value.trim().isNotEmpty) value,
      ];
    } on Object {
      return const [];
    }
  }

  List<double> _decodeChunkTimings(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return const [];
      return [
        for (final value in decoded)
          if (value is num) value.toDouble(),
      ];
    } on Object {
      return const [];
    }
  }

  @override
  Future<void> updateReview(ReviewCandidate candidate) {
    return guardLocalWrite(() async {
      final statement = candidate.statement.trim();
      if (statement.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }

      await _localDataSource.updateReview(
        candidateId: candidate.id,
        values: ExtractionCandidatesCompanion(
          kind: Value(candidate.kind),
          statement: Value(statement),
          owner: Value(candidate.owner),
          dueDate: Value(candidate.dueDate?.millisecondsSinceEpoch),
          note: Value(candidate.note),
          reviewStatus: Value(candidate.reviewStatus.name),
          updatedAt: Value(_now().millisecondsSinceEpoch),
        ),
      );
    });
  }

  @override
  Future<void> deletePending(String candidateId) {
    return guardLocalWrite(
      () => _localDataSource.markDeleted(
        candidateId: candidateId,
        updatedAt: _now().millisecondsSinceEpoch,
      ),
    );
  }

  ExtractionFailure _mapLocalAIException(LocalAIException error) =>
      switch (error.code) {
        'invalid-input' => const ExtractionFailure.invalidInput(),
        'unavailable' => const ExtractionFailure.modelUnavailable(),
        'unsupported-codec' => const ExtractionFailure.modelUnsupported(),
        'invalid-output' => const ExtractionFailure.invalidOutput(),
        'cancelled' => const ExtractionFailure.cancelled(),
        _ => const ExtractionFailure.unknown(),
      };

  ReviewCandidate _fromRow(ExtractionCandidateRow row) {
    return ReviewCandidate(
      id: row.id,
      userId: row.userId,
      sourceConversationId: row.sourceConversationId,
      sourceRevision: row.sourceRevision,
      kind: row.kind,
      statement: row.statement,
      owner: row.owner,
      dueDate: row.dueDate != null
          ? DateTime.fromMillisecondsSinceEpoch(row.dueDate!, isUtc: true)
          : null,
      note: row.note,
      quoteStart: row.quoteStart,
      quoteEnd: row.quoteEnd,
      quoteSnippet: row.quoteSnippet,
      reviewStatus: ReviewStatus.values.byName(row.reviewStatus),
    );
  }

  Future<LocalAICopy> _copyForExtract() async {
    final repo = _kindRepository;
    final factory = _copyForKinds;
    if (repo == null || factory == null) {
      return _copy;
    }
    final enabled = await repo.listEnabled();
    final specs = enabled.isEmpty
        ? defaultBuiltInKindSpecs()
        : [for (final kind in enabled) promptSpecFromKind(kind)];
    return factory(specs);
  }
}
