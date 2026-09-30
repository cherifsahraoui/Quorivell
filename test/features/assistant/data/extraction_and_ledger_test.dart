import 'dart:async';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/local_ai_service.dart';
import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/core/l10n/local_ai_copy.dart';
import 'package:quorivell/features/assistant/data/datasources/extraction_local_data_source.dart';
import 'package:quorivell/features/assistant/data/repositories/extraction_repository_impl.dart';
import 'package:quorivell/features/assistant/data/repositories/extraction_run_repository_impl.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_job.dart';
import 'package:quorivell/features/assistant/domain/entities/review_candidate.dart';
import 'package:quorivell/features/assistant/domain/repositories/extraction_repository.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';
import 'package:quorivell/features/ledger/data/datasources/ledger_local_data_source.dart';
import 'package:quorivell/features/ledger/data/repositories/ledger_repository_impl.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';

class _ThrowingLocalAIService implements LocalAIService {
  const _ThrowingLocalAIService(this.code);

  final String code;

  @override
  String get modelId => 'test-model';

  @override
  int get maxInputCharacters => LocalAIRequest.maxInputCharacters;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<LocalAIResponse> extract(LocalAIRequest request) async =>
      throw LocalAIException(code, 'Synthetic failure.');

  @override
  Future<LocalAIResponse> extractChunked(
    LocalAIRequest request, {
    void Function(ExtractionChunkResult chunk)? onChunk,
    int skipChunks = 0,
  }) async => throw LocalAIException(code, 'Synthetic failure.');

  @override
  Future<String> chat(
    LocalChatRequest request, {
    void Function(String token)? onToken,
  }) async => throw LocalAIException(code, 'Synthetic failure.');

  @override
  Future<void> stopChat() async {}

  @override
  void prepareExtraction() {}

  @override
  Future<void> cancelExtraction() async {}

  @override
  Future<void> dispose() async {}
}

class _ChunkedLocalAIService implements LocalAIService {
  _ChunkedLocalAIService({this.failAfterChunk, this.holdAfterChunk});

  final int? failAfterChunk;
  final Completer<void>? holdAfterChunk;
  final int totalChunks = 3;
  var skipChunksSeen = 0;
  var cancelled = false;

  @override
  String get modelId => 'test-model';

  @override
  int get maxInputCharacters => LocalAIRequest.maxInputCharacters;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<LocalAIResponse> extract(LocalAIRequest request) async {
    return const LocalAIResponse(modelId: 'test-model', candidates: []);
  }

  @override
  Future<LocalAIResponse> extractChunked(
    LocalAIRequest request, {
    void Function(ExtractionChunkResult chunk)? onChunk,
    int skipChunks = 0,
  }) async {
    skipChunksSeen = skipChunks;
    const statement = 'Alex will send the checklist.';
    const candidate = ExtractionCandidate(
      id: '1',
      kind: ExtractionCandidateKind.commitment,
      statement: statement,
      owner: 'Alex',
      dueDate: null,
      evidence: ExtractionEvidence(
        quoteStart: 0,
        quoteEnd: 29,
        quoteSnippet: statement,
      ),
    );
    for (var i = skipChunks; i < totalChunks; i++) {
      onChunk?.call(
        ExtractionChunkResult(
          chunkIndex: i + 1,
          totalChunks: totalChunks,
          candidates: i == 0 ? const [candidate] : const [],
          chunkDurationMs: 1,
        ),
      );
      if (i == skipChunks && holdAfterChunk != null) {
        await holdAfterChunk!.future;
      }
      if (cancelled) {
        throw const LocalAIException('cancelled', 'Extraction was cancelled.');
      }
      if (failAfterChunk != null && i + 1 == failAfterChunk) {
        throw const LocalAIException('unavailable', 'Synthetic failure.');
      }
    }
    return const LocalAIResponse(modelId: 'test-model', candidates: []);
  }

  @override
  Future<String> chat(
    LocalChatRequest request, {
    void Function(String token)? onToken,
  }) async => '';

  @override
  Future<void> stopChat() async {}

  @override
  void prepareExtraction() {}

  @override
  Future<void> cancelExtraction() async {
    cancelled = true;
    final hold = holdAfterChunk;
    if (hold != null && !hold.isCompleted) {
      hold.complete();
    }
  }

  @override
  Future<void> dispose() async {}
}

class _FakeLocalAIService implements LocalAIService {
  const _FakeLocalAIService();

  @override
  String get modelId => 'test-model';

  @override
  int get maxInputCharacters => LocalAIRequest.maxInputCharacters;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<LocalAIResponse> extract(LocalAIRequest request) async {
    const statement = 'Alex will send the checklist.';
    return const LocalAIResponse(
      modelId: 'test-model',
      candidates: [
        ExtractionCandidate(
          id: '1',
          kind: ExtractionCandidateKind.commitment,
          statement: statement,
          owner: 'Alex',
          dueDate: null,
          evidence: ExtractionEvidence(
            quoteStart: 0,
            quoteEnd: 29,
            quoteSnippet: statement,
          ),
        ),
      ],
    );
  }

  @override
  Future<LocalAIResponse> extractChunked(
    LocalAIRequest request, {
    void Function(ExtractionChunkResult chunk)? onChunk,
    int skipChunks = 0,
  }) async {
    return extract(request);
  }

  @override
  Future<String> chat(
    LocalChatRequest request, {
    void Function(String token)? onToken,
  }) async => '';

  @override
  Future<void> stopChat() async {}

  @override
  void prepareExtraction() {}

  @override
  Future<void> cancelExtraction() async {}

  @override
  Future<void> dispose() async {}
}

void main() {
  late AppDatabase database;
  late ExtractionRepositoryImpl extraction;
  late LedgerRepositoryImpl ledger;
  late String localUserId;

  ExtractionRepositoryImpl buildExtraction(LocalAIService aiService) {
    final userScope = LocalUserScopeRepositoryImpl(
      DriftLocalUserScopeLocalDataSource(database),
    );
    final localDataSource = DriftExtractionLocalDataSource(database);
    return ExtractionRepositoryImpl(
      localDataSource: localDataSource,
      userScopeRepository: userScope,
      aiService: aiService,
      copy: localAICopyForLocale(const Locale('en')),
      runRepository: ExtractionRunRepositoryImpl(
        localDataSource: localDataSource,
        userScopeRepository: userScope,
        now: () => DateTime.utc(2026, 9, 7),
      ),
      now: () => DateTime.utc(2026, 9, 7),
    );
  }

  Future<void> insertSource({String id = 'source-1'}) {
    return database
        .into(database.sourceConversations)
        .insert(
          SourceConversationsCompanion.insert(
            id: id,
            userId: localUserId,
            content: 'Alex will send the checklist.',
            sourceRevision: 1,
            createdAt: 1,
            updatedAt: 1,
          ),
        );
  }

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final userScope = LocalUserScopeRepositoryImpl(
      DriftLocalUserScopeLocalDataSource(database),
    );
    localUserId = (await userScope.getOrCreate()).id;
    extraction = buildExtraction(const _FakeLocalAIService());
    ledger = LedgerRepositoryImpl(
      localDataSource: DriftLedgerLocalDataSource(database),
      userScopeRepository: userScope,
      now: () => DateTime.utc(2026, 9, 7),
    );
  });

  tearDown(() => database.close());

  test('keeps evidence and unknown fields through review acceptance', () async {
    await insertSource();

    final candidates = await extraction.extract('source-1');

    expect(candidates, hasLength(1));
    expect(candidates.single.owner, 'Alex');
    expect(candidates.single.dueDate, isNull);
    expect(candidates.single.quoteSnippet, 'Alex will send the checklist.');
    expect(
      (await database.select(database.sourceConversations).get())
          .single
          .isArchived,
      isTrue,
    );
    final extractRuns = await database.select(database.extractionRuns).get();
    expect(extractRuns, hasLength(1));
    expect(extractRuns.single.status, 'success');
    expect(extractRuns.single.kindCountsJson, contains('commitment'));

    final item = await ledger.acceptCandidate(
      candidateId: candidates.single.id,
      kind: LedgerItemKind.commitment,
      statement: candidates.single.statement,
      owner: candidates.single.owner,
      dueDate: candidates.single.dueDate,
      kindDisplayNameSnapshot: 'Commitment',
    );

    expect(item.statement, 'Alex will send the checklist.');
    expect(await database.select(database.ledgerItems).get(), hasLength(1));
    expect(await database.select(database.evidence).get(), hasLength(1));
    expect(
      (await database.select(database.evidence).get()).single.quoteStart,
      0,
    );
    expect(
      (await database.select(database.extractionCandidates).get())
          .single
          .reviewStatus,
      'accepted',
    );
  });

  test('reports a missing source conversation as a typed failure', () async {
    await expectLater(
      extraction.extract('missing-source'),
      throwsA(const ExtractionFailure.noSourceConversation()),
    );
  });

  group('maps LocalAIException to a typed ExtractionFailure', () {
    const cases = <String, ExtractionFailure>{
      'invalid-input': ExtractionFailure.invalidInput(),
      'unavailable': ExtractionFailure.modelUnavailable(),
      'unsupported-codec': ExtractionFailure.modelUnsupported(),
      'invalid-output': ExtractionFailure.invalidOutput(),
      'something-else': ExtractionFailure.unknown(),
    };

    for (final entry in cases.entries) {
      test(entry.key, () async {
        await insertSource();
        final repository = buildExtraction(_ThrowingLocalAIService(entry.key));

        await expectLater(repository.extract('source-1'), throwsA(entry.value));
        expect(
          await database.select(database.extractionCandidates).get(),
          isEmpty,
        );
        expect(
          (await database.select(database.sourceConversations).get())
              .single
              .isArchived,
          isFalse,
        );
      });
    }
  });

  test('rejects an empty correction without writing', () async {
    await insertSource();
    final candidate = (await extraction.extract('source-1')).single;

    await expectLater(
      extraction.updateReview(candidate.copyWith(statement: '   ')),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
    expect(
      (await database.select(database.extractionCandidates).get())
          .single
          .statement,
      'Alex will send the checklist.',
    );
  });

  test('stores a correction and a changed review status', () async {
    await insertSource();
    final candidate = (await extraction.extract('source-1')).single;

    await extraction.updateReview(
      candidate.copyWith(
        statement: 'Alex will send the revised checklist.',
        kind: ReviewCandidateKind.decision,
        reviewStatus: ReviewStatus.deferred,
      ),
    );

    final row =
        (await database.select(database.extractionCandidates).get()).single;
    expect(row.statement, 'Alex will send the revised checklist.');
    expect(row.kind, 'decision');
    expect(row.reviewStatus, 'deferred');
    expect(row.dueDate, isNull);
  });

  test('watchPending is bounded by the requested limit', () async {
    await insertSource();
    await insertSource(id: 'source-2');
    await extraction.extract('source-1');
    await extraction.extract('source-2');

    final pending = await extraction.watchPending(limit: 1).first;

    expect(pending, hasLength(1));
  });

  test(
    'watchRejected lists rejected candidates and omits soft-deleted ones',
    () async {
      await insertSource();
      final candidate = (await extraction.extract('source-1')).single;

      await extraction.updateReview(
        candidate.copyWith(reviewStatus: ReviewStatus.rejected),
      );

      expect(await extraction.watchRejected().first, hasLength(1));

      await extraction.deletePending(candidate.id);

      expect(await extraction.watchRejected().first, isEmpty);
      expect(await extraction.watchPending().first, isEmpty);
    },
  );

  test('accepting an unknown candidate reports a typed failure', () async {
    await expectLater(
      ledger.acceptCandidate(
        candidateId: 'missing-candidate',
        kind: LedgerItemKind.commitment,
        statement: 'Anything.',
        owner: null,
        dueDate: null,
        kindDisplayNameSnapshot: 'Commitment',
      ),
      throwsA(const LocalPersistenceFailure.notFound()),
    );
  });

  test('chunked extract persists a job then clears it after archive', () async {
    await insertSource();
    final ai = _ChunkedLocalAIService();
    final repository = buildExtraction(ai);

    final updates = await repository.extractChunked('source-1').toList();

    expect(updates, hasLength(3));
    expect(updates.first.progress.currentChunk, 1);
    expect(updates.last.progress.currentChunk, 3);
    expect(await repository.loadActiveJob(), isNull);
    expect(
      (await database.select(database.sourceConversations).get())
          .single
          .isArchived,
      isTrue,
    );
    expect(
      await database.select(database.extractionCandidates).get(),
      hasLength(1),
    );
    final runs = await database.select(database.extractionRuns).get();
    expect(runs, hasLength(1));
    expect(runs.single.status, 'success');
    expect(runs.single.kindCountsJson, contains('commitment'));
    expect(runs.single.modelId, 'test-model');
  });

  test('chunked extract resumes from the persisted completed chunk', () async {
    await insertSource();
    final ai = _ChunkedLocalAIService();
    final repository = buildExtraction(ai);
    await repository.upsertJob(
      ExtractionJob(
        sourceConversationId: 'source-1',
        sourceRevision: 1,
        completedChunkCount: 1,
        totalChunks: 3,
        candidatesFound: 1,
        startTime: DateTime.utc(2026, 9, 7),
      ),
    );

    final updates = await repository.extractChunked('source-1').toList();

    expect(ai.skipChunksSeen, 1);
    expect(updates, hasLength(2));
    expect(updates.first.progress.currentChunk, 2);
    expect(await repository.loadActiveJob(), isNull);
    expect(
      (await database.select(database.sourceConversations).get())
          .single
          .isArchived,
      isTrue,
    );
  });

  test(
    'chunked extract keeps candidates and a job until a later failure',
    () async {
      await insertSource();
      final repository = buildExtraction(
        _ChunkedLocalAIService(failAfterChunk: 1),
      );

      await expectLater(
        repository.extractChunked('source-1').toList(),
        throwsA(const ExtractionFailure.modelUnavailable()),
      );

      expect(await repository.loadActiveJob(), isNull);
      expect(
        (await database.select(database.sourceConversations).get())
            .single
            .isArchived,
        isFalse,
      );
      expect(
        await database.select(database.extractionCandidates).get(),
        hasLength(1),
      );
      final runs = await database.select(database.extractionRuns).get();
      expect(runs, hasLength(1));
      expect(runs.single.status, 'failure');
    },
  );

  test('chunked extract fails typed when the source is archived', () async {
    await insertSource();
    await (database.update(database.sourceConversations)
          ..where((row) => row.id.equals('source-1')))
        .write(const SourceConversationsCompanion(isArchived: Value(true)));
    final repository = buildExtraction(_ChunkedLocalAIService());
    await repository.upsertJob(
      ExtractionJob(
        sourceConversationId: 'source-1',
        startTime: DateTime.utc(2026, 9, 7),
      ),
    );

    await expectLater(
      repository.extractChunked('source-1').toList(),
      throwsA(const ExtractionFailure.sourceArchived()),
    );
    expect(await repository.loadActiveJob(), isNull);
  });

  test('chunked extract fails typed when the source is gone', () async {
    final repository = buildExtraction(_ChunkedLocalAIService());
    await repository.upsertJob(
      ExtractionJob(
        sourceConversationId: 'missing-source',
        startTime: DateTime.utc(2026, 9, 7),
      ),
    );

    await expectLater(
      repository.extractChunked('missing-source').toList(),
      throwsA(const ExtractionFailure.noSourceConversation()),
    );
    expect(await repository.loadActiveJob(), isNull);
  });

  test(
    'cancelling chunked extract keeps candidates and does not archive',
    () async {
      await insertSource();
      final hold = Completer<void>();
      final ai = _ChunkedLocalAIService(holdAfterChunk: hold);
      final repository = buildExtraction(ai);

      Object? error;
      final events = <ExtractionProgressUpdate>[];
      final finished = Completer<void>();
      repository
          .extractChunked('source-1')
          .listen(
            events.add,
            onError: (Object e, StackTrace _) {
              error = e;
              if (!finished.isCompleted) finished.complete();
            },
            onDone: () {
              if (!finished.isCompleted) finished.complete();
            },
          );

      await Future<void>.delayed(Duration.zero);
      for (var i = 0; i < 20 && events.isEmpty; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(events, isNotEmpty);

      await repository.cancelActive();
      await finished.future;

      expect(error, const ExtractionFailure.cancelled());
      expect(await repository.loadActiveJob(), isNull);
      expect(
        (await database.select(database.sourceConversations).get())
            .single
            .isArchived,
        isFalse,
      );
      expect(
        await database.select(database.extractionCandidates).get(),
        hasLength(1),
      );
      expect(await database.select(database.extractionRuns).get(), isEmpty);
    },
  );
}
