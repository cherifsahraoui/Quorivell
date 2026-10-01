import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/core/platform/extraction_platform_service.dart';
import 'package:quorivell/features/account/data/providers/locale_preference_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/features/assistant/data/providers/extraction_providers.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_job.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_progress.dart';
import 'package:quorivell/features/assistant/domain/entities/review_candidate.dart';
import 'package:quorivell/features/assistant/domain/repositories/extraction_repository.dart';
import 'package:quorivell/features/assistant/presentation/controllers/review_controller.dart';
import 'package:quorivell/features/chat/presentation/controllers/chat_generation_hold_controller.dart';
import 'package:quorivell/features/ledger/data/providers/ledger_providers.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';
import 'package:quorivell/features/ledger/domain/repositories/ledger_repository.dart';
import 'package:quorivell/features/meeting_notes/data/providers/source_conversation_providers.dart';
import 'package:quorivell/features/meeting_notes/domain/entities/source_conversation.dart';
import 'package:quorivell/features/meeting_notes/domain/repositories/source_conversation_repository.dart';

import '../../../helpers/extraction_kind_catalog.dart';

final _candidate = ReviewCandidate(
  id: 'candidate-1',
  userId: 'user-1',
  sourceConversationId: 'source-1',
  sourceRevision: 1,
  kind: ReviewCandidateKind.commitment,
  statement: 'Alex will send the checklist.',
  owner: 'Alex',
  dueDate: null,
  quoteStart: 0,
  quoteEnd: 29,
  quoteSnippet: 'Alex will send the checklist.',
  reviewStatus: ReviewStatus.pending,
);

class _FakeSourceConversationRepository
    implements SourceConversationRepository {
  _FakeSourceConversationRepository({this.hasLatest = false, this.actives});

  final bool hasLatest;
  final List<SourceConversation>? actives;

  SourceConversation get _active => SourceConversation(
    id: 'source-1',
    userId: 'user-1',
    content: 'Alex will send the checklist.',
    sourceRevision: 1,
    createdAt: DateTime.utc(2026, 9, 7),
    updatedAt: DateTime.utc(2026, 9, 7),
  );

  List<SourceConversation> get _activeList {
    if (actives != null) return actives!;
    if (hasLatest) return [_active];
    return const [];
  }

  @override
  Future<SourceConversation> capture(String content, {String? sourceUrl}) async =>
      throw UnimplementedError();

  @override
  Future<SourceConversation?> latest() async =>
      _activeList.isEmpty ? null : _activeList.last;

  @override
  Future<List<SourceConversation>> listActive({
    int? limit,
    bool newestFirst = true,
  }) async {
    final items = [..._activeList];
    if (!newestFirst) {
      // Tests store oldest→newest when building [actives]; reverse for newest.
      return items;
    }
    return items.reversed.toList();
  }

  @override
  Stream<List<SourceConversation>> watchAll({
    int limit = 50,
    int offset = 0,
    bool archivedOnly = false,
  }) => const Stream.empty();

  @override
  Future<SourceConversation?> find(String id) async {
    for (final item in _activeList) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> archive(String id) async {}

  @override
  Future<void> unarchive(String id) async {}
}

class _FakeExtractionRepository implements ExtractionRepository {
  _FakeExtractionRepository({this.failure, this.chunkedUpdates = const []});

  final ExtractionFailure? failure;
  final List<ExtractionProgressUpdate> chunkedUpdates;
  final extracted = <String>[];
  final updated = <ReviewCandidate>[];
  final deletedIds = <String>[];
  ExtractionJob? job;
  var clearJobCount = 0;
  var cancelCount = 0;

  @override
  Future<List<ReviewCandidate>> extract(String sourceConversationId) async {
    extracted.add(sourceConversationId);
    if (failure != null) throw failure!;
    return const [];
  }

  @override
  Stream<ExtractionProgressUpdate> extractChunked(
    String sourceConversationId,
  ) async* {
    extracted.add(sourceConversationId);
    if (failure != null) {
      job = null;
      clearJobCount += 1;
      throw failure!;
    }
    final skip = job?.completedChunkCount ?? 0;
    final remaining = chunkedUpdates.skip(skip);
    for (final update in remaining) {
      job = job?.copyWith(
        completedChunkCount: update.progress.currentChunk,
        totalChunks: update.progress.totalChunks,
        candidatesFound: update.progress.candidatesFound,
        chunkTimings: update.progress.chunkTimings,
      );
      yield update;
    }

    final completed = job;
    if (completed == null) {
      return;
    }
    final queued = [...completed.queuedSourceConversationIds];
    if (queued.isEmpty) {
      job = null;
      return;
    }
    final nextId = queued.removeAt(0);
    final nextBatchIndex = completed.batchTotal - queued.length - 1;
    job = ExtractionJob(
      sourceConversationId: nextId,
      sourceRevision: 1,
      candidatesFound: completed.candidatesFound,
      startTime: completed.startTime,
      progressTitle: completed.progressTitle,
      progressBody: completed.progressBody,
      completionTitle: completed.completionTitle,
      queuedSourceConversationIds: queued,
      batchIndex: nextBatchIndex < 0 ? 0 : nextBatchIndex,
      batchTotal: completed.batchTotal <= 0 ? 1 : completed.batchTotal,
    );
  }

  @override
  Future<ExtractionJob?> loadActiveJob() async => job;

  @override
  Future<void> upsertJob(ExtractionJob value) async {
    job = value;
  }

  @override
  Future<void> clearJob() async {
    clearJobCount += 1;
    job = null;
  }

  @override
  Future<void> prepareRun() async {}

  @override
  Future<void> cancelActive() async {
    cancelCount += 1;
    job = null;
    clearJobCount += 1;
  }

  @override
  Stream<List<ReviewCandidate>> watchPending({
    int limit = 100,
    int offset = 0,
  }) => Stream.value([_candidate]);

  @override
  Stream<List<ReviewCandidate>> watchRejected({
    int limit = 100,
    int offset = 0,
  }) => const Stream.empty();

  @override
  Future<void> updateReview(ReviewCandidate candidate) async =>
      updated.add(candidate);

  @override
  Future<void> deletePending(String candidateId) async {
    deletedIds.add(candidateId);
  }
}

class _GatedExtractionRepository extends _FakeExtractionRepository {
  _GatedExtractionRepository({required this.gate, super.chunkedUpdates});

  final Completer<void> gate;

  @override
  Future<void> cancelActive() async {
    await super.cancelActive();
    if (!gate.isCompleted) {
      gate.complete();
    }
  }

  @override
  Stream<ExtractionProgressUpdate> extractChunked(
    String sourceConversationId,
  ) async* {
    await gate.future;
    if (cancelCount > 0) {
      throw const ExtractionFailure.cancelled();
    }
    yield* super.extractChunked(sourceConversationId);
  }
}

/// Holds [cancelActive] open so tests can assert the FGS stop happens first.
class _SlowCancelExtractionRepository extends _FakeExtractionRepository {
  _SlowCancelExtractionRepository({
    required this.extractGate,
    required this.cancelHold,
    super.chunkedUpdates,
  });

  final Completer<void> extractGate;
  final Completer<void> cancelHold;

  @override
  Future<void> cancelActive() async {
    cancelCount += 1;
    await cancelHold.future;
    job = null;
    if (!extractGate.isCompleted) {
      extractGate.complete();
    }
  }

  @override
  Stream<ExtractionProgressUpdate> extractChunked(
    String sourceConversationId,
  ) async* {
    await extractGate.future;
    if (cancelCount > 0) {
      throw const ExtractionFailure.cancelled();
    }
    yield* super.extractChunked(sourceConversationId);
  }
}

class _RecordingExtractionPlatformService implements ExtractionPlatformService {
  final starts = <(String, String)>[];
  final startDestinations = <String>[];
  final progress = <({int current, int total})>[];
  final completions = <(String, String)>[];
  final completionDestinations = <String>[];
  var stopCount = 0;
  var foregroundServiceRunning = false;

  @override
  Future<void> startForegroundService(
    String title,
    String body, {
    String destination = '',
  }) async {
    starts.add((title, body));
    startDestinations.add(destination);
    foregroundServiceRunning = true;
  }

  @override
  Future<void> updateForegroundServiceProgress({
    required int current,
    required int total,
    String? title,
    String? body,
  }) async {
    progress.add((current: current, total: total));
  }

  @override
  Future<void> stopForegroundService() async {
    stopCount += 1;
    foregroundServiceRunning = false;
  }

  @override
  Future<void> showCompletionNotification(
    String title,
    String body, {
    String destination = '',
  }) async {
    completions.add((title, body));
    completionDestinations.add(destination);
    foregroundServiceRunning = false;
  }

  @override
  Future<String?> consumeLaunchDestination() async => null;

  @override
  Stream<String> get launchDestinations => const Stream.empty();

  @override
  Future<bool> isForegroundServiceRunning() async => foregroundServiceRunning;
}

class _FakeLedgerRepository implements LedgerRepository {
  final accepted = <({String id, String kind, DateTime? dueDate})>[];

  @override
  Stream<List<LedgerItem>> watchItems({
    String? kind,
    Set<LedgerItemStatus>? statuses,
    int limit = 100,
    int offset = 0,
  }) => const Stream.empty();

  @override
  Stream<List<LedgerItem>> watchOpenCommitments({
    int limit = 100,
    int offset = 0,
  }) => const Stream.empty();

  @override
  Stream<LedgerItem?> watchById(String id) => Stream.value(null);

  @override
  Stream<List<EvidenceReference>> watchEvidence(String ledgerItemId) =>
      const Stream.empty();

  @override
  Future<LedgerItem> acceptCandidate({
    required String candidateId,
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
  }) async {
    accepted.add((id: candidateId, kind: kind, dueDate: dueDate));
    return LedgerItem(
      id: 'item-1',
      userId: 'user-1',
      kind: kind,
      statement: statement,
      status: LedgerItemStatus.open,
      owner: owner,
      dueDate: dueDate,
      createdAt: DateTime.utc(2026, 9, 7),
      updatedAt: DateTime.utc(2026, 9, 7),
    );
  }

  @override
  Future<LedgerItem> createManual({
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
    bool allowsDueDate = true,
  }) async => throw UnimplementedError();

  @override
  Future<void> updateStatus({
    required String id,
    required LedgerItemStatus status,
  }) async {}

  @override
  Future<void> delete(String id) async {}
}

class _EnLocalePreference extends LocalePreferenceController {
  @override
  Future<AppLocalePreference> build() async => AppLocalePreference.en;
}

ProviderContainer _container({
  SourceConversationRepository? conversations,
  ExtractionRepository? extraction,
  LedgerRepository? ledger,
  ExtractionPlatformService? platform,
}) {
  return ProviderContainer.test(
    overrides: [
      ...extractionKindCatalogOverrides(),
      sourceConversationRepositoryProvider.overrideWithValue(
        conversations ?? _FakeSourceConversationRepository(),
      ),
      extractionRepositoryProvider.overrideWithValue(
        extraction ?? _FakeExtractionRepository(),
      ),
      ledgerRepositoryProvider.overrideWithValue(
        ledger ?? _FakeLedgerRepository(),
      ),
      localePreferenceControllerProvider.overrideWith(_EnLocalePreference.new),
      if (platform != null)
        extractionPlatformServiceProvider.overrideWithValue(platform),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('streams the pending review queue', () async {
    final container = _container();
    container.listen(reviewQueueControllerProvider, (_, _) {});

    final candidates = await container.read(
      reviewQueueControllerProvider.future,
    );

    expect(candidates.single.id, 'candidate-1');
  });

  test('reports a missing capture as a typed failure', () async {
    final container = _container();

    await container
        .read(reviewActionsControllerProvider.notifier)
        .extractLatest();

    expect(
      container.read(reviewActionsControllerProvider).error,
      const ExtractionFailure.noSourceConversation(),
    );
  });

  test('extracts from the latest capture', () async {
    final extraction = _FakeExtractionRepository();
    final container = _container(
      conversations: _FakeSourceConversationRepository(hasLatest: true),
      extraction: extraction,
    );

    await container
        .read(reviewActionsControllerProvider.notifier)
        .extractLatest();

    expect(extraction.extracted, ['source-1']);
    expect(container.read(reviewActionsControllerProvider).hasError, isFalse);
    expect(container.read(reviewActionsControllerProvider).value, 0);
  });

  test('surfaces an extraction failure without throwing', () async {
    final container = _container(
      conversations: _FakeSourceConversationRepository(hasLatest: true),
      extraction: _FakeExtractionRepository(
        failure: const ExtractionFailure.modelUnavailable(),
      ),
    );

    await container
        .read(reviewActionsControllerProvider.notifier)
        .extractLatest();

    expect(
      container.read(reviewActionsControllerProvider).error,
      const ExtractionFailure.modelUnavailable(),
    );
  });

  test('accepts a candidate through the ledger repository', () async {
    final ledger = _FakeLedgerRepository();
    final container = _container(ledger: ledger);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .accept(_candidate);

    expect(ledger.accepted, [
      (id: 'candidate-1', kind: LedgerItemKind.commitment, dueDate: null),
    ]);
  });

  test('accepts a kind correction as a decision without due date', () async {
    final ledger = _FakeLedgerRepository();
    final container = _container(ledger: ledger);
    final dueDate = DateTime.utc(2026, 9, 10, 15, 30);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .accept(
          _candidate.copyWith(
            kind: ReviewCandidateKind.decision,
            dueDate: dueDate,
          ),
        );

    expect(ledger.accepted, [
      (id: 'candidate-1', kind: LedgerItemKind.decision, dueDate: null),
    ]);
  });

  test('records a correction as a still-pending candidate', () async {
    final extraction = _FakeExtractionRepository();
    final container = _container(extraction: extraction);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .saveCorrection(
          _candidate.copyWith(statement: 'Alex will send the agenda.'),
        );

    expect(extraction.updated.single.statement, 'Alex will send the agenda.');
    expect(extraction.updated.single.reviewStatus, ReviewStatus.pending);
  });

  test('records a changed review status', () async {
    final extraction = _FakeExtractionRepository();
    final container = _container(extraction: extraction);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .changeStatus(_candidate, ReviewStatus.rejected);

    expect(extraction.updated.single.reviewStatus, ReviewStatus.rejected);
  });

  test('soft-deletes a candidate by id', () async {
    final extraction = _FakeExtractionRepository();
    final container = _container(extraction: extraction);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .deleteCandidate('candidate-1');

    expect(extraction.deletedIds, ['candidate-1']);
  });

  test('chunked extraction drives an ongoing progress notification', () async {
    final platform = _RecordingExtractionPlatformService();
    final start = DateTime.utc(2026, 9, 14);
    final extraction = _FakeExtractionRepository(
      chunkedUpdates: [
        ExtractionProgressUpdate(
          progress: ExtractionProgress(
            currentChunk: 1,
            totalChunks: 3,
            candidatesFound: 1,
            chunkTimings: const [0.2],
            startTime: start,
          ),
          newCandidates: const [],
        ),
        ExtractionProgressUpdate(
          progress: ExtractionProgress(
            currentChunk: 3,
            totalChunks: 3,
            candidatesFound: 2,
            chunkTimings: const [0.2, 0.2, 0.2],
            startTime: start,
          ),
          newCandidates: const [],
        ),
      ],
    );
    final container = _container(
      conversations: _FakeSourceConversationRepository(hasLatest: true),
      extraction: extraction,
      platform: platform,
    );

    await container
        .read(reviewActionsControllerProvider.notifier)
        .extractSourcesChunked(
          sourceConversationIds: const ['source-1'],
          progressTitle: 'Extraction in progress',
          progressBody: 'Processing',
          completionTitle: 'Extraction complete',
          completionBody: (count) => '$count found',
        );

    expect(platform.starts, [('Extraction in progress', 'Processing')]);
    expect(platform.progress, [
      (current: 0, total: 1),
      (current: 1, total: 3),
      (current: 3, total: 3),
    ]);
    expect(platform.completions, [('Extraction complete', '2 found')]);
    expect(platform.startDestinations, ['/review']);
    expect(platform.completionDestinations, ['/review']);
    expect(platform.stopCount, 1);
    expect(container.read(reviewActionsControllerProvider).value, 2);
  });

  test('zero-candidate completion opens ledger', () async {
    final platform = _RecordingExtractionPlatformService();
    final container = _container(
      conversations: _FakeSourceConversationRepository(hasLatest: true),
      extraction: _FakeExtractionRepository(),
      platform: platform,
    );

    await container
        .read(reviewActionsControllerProvider.notifier)
        .extractSourcesChunked(
          sourceConversationIds: const ['source-1'],
          progressTitle: 'Extraction in progress',
          progressBody: 'Processing',
          completionTitle: 'Extraction complete',
          completionBody: (count) => '$count found',
        );

    expect(platform.startDestinations, ['/review']);
    expect(platform.completionDestinations, ['/ledger']);
    expect(container.read(reviewActionsControllerProvider).value, 0);
  });

  test('extraction running survives dropping overlay listeners', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(
      extractionRunningControllerProvider,
      (_, _) {},
    );
    container.read(extractionRunningControllerProvider.notifier).start();
    container
        .read(extractionProgressControllerProvider.notifier)
        .updateProgress(
          ExtractionProgress(
            currentChunk: 1,
            totalChunks: 4,
            candidatesFound: 0,
            chunkTimings: const [],
            startTime: DateTime.utc(2026, 9, 14),
          ),
        );
    sub.close();

    expect(container.read(extractionRunningControllerProvider), isTrue);
    expect(
      container.read(extractionProgressControllerProvider)?.currentChunk,
      1,
    );
  });

  test('chunked extract without a capture does not start the FGS', () async {
    final platform = _RecordingExtractionPlatformService();
    final container = _container(platform: platform);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .extractSourcesChunked(
          sourceConversationIds: const [],
          progressTitle: 'Extraction in progress',
          progressBody: 'Processing',
          completionTitle: 'Extraction complete',
          completionBody: (count) => '$count found',
        );

    expect(platform.starts, isEmpty);
    expect(platform.stopCount, 0);
    expect(
      container.read(reviewActionsControllerProvider).error,
      const ExtractionFailure.noSourceConversation(),
    );
    expect(container.read(extractionRunningControllerProvider), isFalse);
  });

  test('does not double-start when extraction is already running', () async {
    final platform = _RecordingExtractionPlatformService();
    final extraction = _FakeExtractionRepository();
    final container = _container(
      conversations: _FakeSourceConversationRepository(hasLatest: true),
      extraction: extraction,
      platform: platform,
    );
    container.read(extractionRunningControllerProvider.notifier).start();

    await container
        .read(reviewActionsControllerProvider.notifier)
        .extractSourcesChunked(
          sourceConversationIds: const ['source-1'],
          progressTitle: 'Extraction in progress',
          progressBody: 'Processing',
          completionTitle: 'Extraction complete',
          completionBody: (count) => '$count found',
        );

    expect(extraction.extracted, isEmpty);
    expect(platform.starts, isEmpty);
    expect(container.read(extractionRunningControllerProvider), isTrue);
  });

  test('resumes remaining chunks and restores overlay progress', () async {
    final platform = _RecordingExtractionPlatformService();
    final start = DateTime.utc(2026, 9, 14);
    final extraction =
        _FakeExtractionRepository(
            chunkedUpdates: [
              ExtractionProgressUpdate(
                progress: ExtractionProgress(
                  currentChunk: 1,
                  totalChunks: 3,
                  candidatesFound: 1,
                  chunkTimings: const [0.2],
                  startTime: start,
                ),
                newCandidates: const [],
              ),
              ExtractionProgressUpdate(
                progress: ExtractionProgress(
                  currentChunk: 2,
                  totalChunks: 3,
                  candidatesFound: 1,
                  chunkTimings: const [0.2, 0.2],
                  startTime: start,
                ),
                newCandidates: const [],
              ),
              ExtractionProgressUpdate(
                progress: ExtractionProgress(
                  currentChunk: 3,
                  totalChunks: 3,
                  candidatesFound: 2,
                  chunkTimings: const [0.2, 0.2, 0.2],
                  startTime: start,
                ),
                newCandidates: const [],
              ),
            ],
          )
          ..job = ExtractionJob(
            sourceConversationId: 'source-1',
            sourceRevision: 1,
            completedChunkCount: 2,
            totalChunks: 3,
            candidatesFound: 1,
            startTime: start,
            chunkTimings: const [0.2, 0.2],
            progressTitle: 'Extraction in progress',
            progressBody: 'Processing',
            completionTitle: 'Extraction complete',
          );
    final container = _container(extraction: extraction, platform: platform);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .resumeInterruptedExtraction(completionBody: (count) => '$count found');

    expect(extraction.extracted, ['source-1']);
    expect(platform.starts, [('Extraction in progress', 'Processing')]);
    expect(platform.progress, [(current: 2, total: 3), (current: 3, total: 3)]);
    expect(platform.completions, [('Extraction complete', '2 found')]);
    expect(platform.stopCount, 1);
    expect(extraction.job, isNull);
    expect(container.read(reviewActionsControllerProvider).value, 2);
    expect(container.read(extractionRunningControllerProvider), isFalse);
  });

  test('resume shows the overlay before extractChunked yields', () async {
    final start = DateTime.utc(2026, 9, 14);
    final gate = Completer<void>();
    final platform = _RecordingExtractionPlatformService();
    final extraction =
        _GatedExtractionRepository(
            gate: gate,
            chunkedUpdates: [
              ExtractionProgressUpdate(
                progress: ExtractionProgress(
                  currentChunk: 1,
                  totalChunks: 1,
                  candidatesFound: 0,
                  chunkTimings: const [0.1],
                  startTime: start,
                ),
                newCandidates: const [],
              ),
            ],
          )
          ..job = ExtractionJob(
            sourceConversationId: 'source-1',
            startTime: start,
            progressTitle: 'Extraction in progress',
            progressBody: 'Processing',
            completionTitle: 'Extraction complete',
          );
    final container = _container(extraction: extraction, platform: platform);

    final done = container
        .read(reviewActionsControllerProvider.notifier)
        .resumeInterruptedExtraction(completionBody: (_) => '');
    await Future<void>.delayed(Duration.zero);

    expect(container.read(extractionRunningControllerProvider), isTrue);
    expect(container.read(extractionProgressControllerProvider), isNotNull);

    gate.complete();
    await done;
    expect(container.read(extractionRunningControllerProvider), isFalse);
  });

  test('boot resume controller restores a persisted job', () async {
    final start = DateTime.utc(2026, 9, 14);
    final platform = _RecordingExtractionPlatformService();
    final extraction =
        _FakeExtractionRepository(
            chunkedUpdates: [
              ExtractionProgressUpdate(
                progress: ExtractionProgress(
                  currentChunk: 1,
                  totalChunks: 1,
                  candidatesFound: 0,
                  chunkTimings: const [0.1],
                  startTime: start,
                ),
                newCandidates: const [],
              ),
            ],
          )
          ..job = ExtractionJob(
            sourceConversationId: 'source-1',
            startTime: start,
            progressTitle: 'Extraction in progress',
            progressBody: 'Processing',
            completionTitle: 'Extraction complete',
          );
    final container = _container(extraction: extraction, platform: platform);
    container.listen(extractionResumeControllerProvider, (_, _) {});
    for (var i = 0; i < 20 && extraction.extracted.isEmpty; i++) {
      await Future<void>.delayed(Duration.zero);
    }

    expect(extraction.extracted, ['source-1']);
    expect(platform.starts, isNotEmpty);
  });

  test('stops a zombie FGS when Dart has no job to resume', () async {
    final platform = _RecordingExtractionPlatformService()
      ..foregroundServiceRunning = true;
    final extraction = _FakeExtractionRepository();
    final container = _container(extraction: extraction, platform: platform);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .resumeInterruptedExtraction(completionBody: (_) => '');

    expect(extraction.extracted, isEmpty);
    expect(platform.stopCount, 1);
    expect(platform.foregroundServiceRunning, isFalse);
  });

  test('does not stop FGS when chat generation holds it', () async {
    final platform = _RecordingExtractionPlatformService()
      ..foregroundServiceRunning = true;
    final extraction = _FakeExtractionRepository();
    final container = _container(extraction: extraction, platform: platform);
    container
        .read(chatGenerationHoldControllerProvider.notifier)
        .setActive(true);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .resumeInterruptedExtraction(completionBody: (_) => '');

    expect(platform.stopCount, 0);
    expect(platform.foregroundServiceRunning, isTrue);
  });

  test(
    'dismisses a leftover progress notification when the native service is dead',
    () async {
      final platform = _RecordingExtractionPlatformService()
        ..foregroundServiceRunning = false;
      final extraction = _FakeExtractionRepository();
      final container = _container(extraction: extraction, platform: platform);

      await container
          .read(reviewActionsControllerProvider.notifier)
          .resumeInterruptedExtraction(completionBody: (_) => '');

      expect(extraction.extracted, isEmpty);
      expect(platform.stopCount, 1);
    },
  );

  test('resume hides a stale overlay when the job is already gone', () async {
    final platform = _RecordingExtractionPlatformService()
      ..foregroundServiceRunning = false;
    final extraction = _FakeExtractionRepository();
    final container = _container(extraction: extraction, platform: platform);
    container.read(extractionRunningControllerProvider.notifier).start();
    container
        .read(extractionProgressControllerProvider.notifier)
        .updateProgress(
          ExtractionProgress(
            currentChunk: 2,
            totalChunks: 3,
            candidatesFound: 1,
            chunkTimings: const [],
            startTime: DateTime.utc(2026, 9, 14),
          ),
        );

    await container
        .read(reviewActionsControllerProvider.notifier)
        .resumeInterruptedExtraction(completionBody: (_) => '');

    expect(extraction.extracted, isEmpty);
    expect(container.read(extractionRunningControllerProvider), isFalse);
    expect(container.read(extractionProgressControllerProvider), isNull);
    expect(platform.stopCount, 1);
  });

  test(
    'boot resume clears a stale overlay when nothing is in flight',
    () async {
      final platform = _RecordingExtractionPlatformService();
      final extraction = _FakeExtractionRepository();
      final container = _container(extraction: extraction, platform: platform);
      container.read(extractionRunningControllerProvider.notifier).start();
      container
          .read(extractionProgressControllerProvider.notifier)
          .updateProgress(
            ExtractionProgress(
              currentChunk: 1,
              totalChunks: 1,
              candidatesFound: 0,
              chunkTimings: const [],
              startTime: DateTime.utc(2026, 9, 14),
            ),
          );
      container.listen(extractionResumeControllerProvider, (_, _) {});
      for (
        var i = 0;
        i < 20 && container.read(extractionRunningControllerProvider);
        i++
      ) {
        await Future<void>.delayed(Duration.zero);
      }

      expect(container.read(extractionRunningControllerProvider), isFalse);
      expect(container.read(extractionProgressControllerProvider), isNull);
      expect(platform.stopCount, 1);
    },
  );

  test('resume no-ops when this isolate is already extracting', () async {
    final platform = _RecordingExtractionPlatformService()
      ..foregroundServiceRunning = true;
    final extraction = _FakeExtractionRepository()
      ..job = ExtractionJob(
        sourceConversationId: 'source-1',
        startTime: DateTime.utc(2026, 9, 14),
      );
    final container = _container(extraction: extraction, platform: platform);
    container.read(extractionRunningControllerProvider.notifier).start();
    container
        .read(extractionProgressControllerProvider.notifier)
        .updateProgress(
          ExtractionProgress(
            currentChunk: 1,
            totalChunks: 4,
            candidatesFound: 0,
            chunkTimings: const [],
            startTime: DateTime.utc(2026, 9, 14),
          ),
        );

    await container
        .read(reviewActionsControllerProvider.notifier)
        .resumeInterruptedExtraction(completionBody: (_) => '');

    expect(extraction.extracted, isEmpty);
    expect(platform.starts, isEmpty);
    expect(platform.stopCount, 0);
    expect(container.read(extractionRunningControllerProvider), isTrue);
    expect(
      container.read(extractionProgressControllerProvider)?.currentChunk,
      1,
    );
  });

  test('clears a resumable job when the model is missing', () async {
    final platform = _RecordingExtractionPlatformService();
    final extraction =
        _FakeExtractionRepository(
            failure: const ExtractionFailure.modelUnavailable(),
          )
          ..job = ExtractionJob(
            sourceConversationId: 'source-1',
            startTime: DateTime.utc(2026, 9, 14),
            progressTitle: 'Extraction in progress',
            progressBody: 'Processing',
          );
    final container = _container(extraction: extraction, platform: platform);

    await container
        .read(reviewActionsControllerProvider.notifier)
        .resumeInterruptedExtraction(completionBody: (_) => '');

    expect(extraction.extracted, ['source-1']);
    expect(extraction.job, isNull);
    expect(platform.stopCount, 1);
    expect(
      container.read(reviewActionsControllerProvider).error,
      const ExtractionFailure.modelUnavailable(),
    );
  });

  test('extract-all runs each active capture sequentially', () async {
    final platform = _RecordingExtractionPlatformService();
    final older = SourceConversation(
      id: 'source-old',
      userId: 'user-1',
      content: 'Older capture.',
      sourceRevision: 1,
      createdAt: DateTime.utc(2026, 9, 6),
      updatedAt: DateTime.utc(2026, 9, 6),
    );
    final newer = SourceConversation(
      id: 'source-new',
      userId: 'user-1',
      content: 'Newer capture.',
      sourceRevision: 1,
      createdAt: DateTime.utc(2026, 9, 7),
      updatedAt: DateTime.utc(2026, 9, 7),
    );
    final start = DateTime.utc(2026, 9, 14);
    final extraction = _FakeExtractionRepository(
      chunkedUpdates: [
        ExtractionProgressUpdate(
          progress: ExtractionProgress(
            currentChunk: 1,
            totalChunks: 1,
            candidatesFound: 1,
            chunkTimings: const [0.1],
            startTime: start,
          ),
          newCandidates: const [],
        ),
      ],
    );
    final container = _container(
      conversations: _FakeSourceConversationRepository(actives: [older, newer]),
      extraction: extraction,
      platform: platform,
    );

    await container
        .read(reviewActionsControllerProvider.notifier)
        .extractSourcesChunked(
          sourceConversationIds: const ['source-old', 'source-new'],
          progressTitle: 'Extraction in progress',
          progressBody: 'Processing',
          completionTitle: 'Extraction complete',
          completionBody: (count) => '$count found',
        );

    expect(extraction.extracted, ['source-old', 'source-new']);
    expect(container.read(reviewActionsControllerProvider).value, 1);
    expect(platform.completions, [('Extraction complete', '1 found')]);
    expect(platform.stopCount, 1);
  });

  test(
    'cancelExtraction stops an in-flight job without a completion alert',
    () async {
      final platform = _RecordingExtractionPlatformService();
      final gate = Completer<void>();
      final start = DateTime.utc(2026, 9, 14);
      final extraction = _GatedExtractionRepository(
        gate: gate,
        chunkedUpdates: [
          ExtractionProgressUpdate(
            progress: ExtractionProgress(
              currentChunk: 1,
              totalChunks: 2,
              candidatesFound: 1,
              chunkTimings: const [0.1],
              startTime: start,
            ),
            newCandidates: const [],
          ),
        ],
      );
      final container = _container(
        conversations: _FakeSourceConversationRepository(hasLatest: true),
        extraction: extraction,
        platform: platform,
      );

      final done = container
          .read(reviewActionsControllerProvider.notifier)
          .extractSourcesChunked(
            sourceConversationIds: const ['source-1'],
            progressTitle: 'Extraction in progress',
            progressBody: 'Processing',
            completionTitle: 'Extraction complete',
            completionBody: (count) => '$count found',
          );
      await Future<void>.delayed(Duration.zero);

      expect(container.read(extractionRunningControllerProvider), isTrue);

      await container
          .read(reviewActionsControllerProvider.notifier)
          .cancelExtraction();
      // Shade drops in cancelExtraction itself — not only in the run finally
      // after llama cancel unwinds.
      expect(platform.stopCount, greaterThanOrEqualTo(1));
      expect(platform.foregroundServiceRunning, isFalse);
      await done;

      expect(extraction.cancelCount, 1);
      expect(extraction.job, isNull);
      expect(platform.completions, isEmpty);
      expect(platform.stopCount, greaterThanOrEqualTo(1));
      expect(container.read(extractionRunningControllerProvider), isFalse);
      expect(container.read(reviewActionsControllerProvider).hasError, isTrue);
      expect(
        container.read(reviewActionsControllerProvider).error,
        const ExtractionFailure.cancelled(),
      );
    },
  );

  test(
    'cancelExtraction dismisses the progress shade before cancelActive finishes',
    () async {
      final platform = _RecordingExtractionPlatformService();
      final extractGate = Completer<void>();
      final cancelHold = Completer<void>();
      final start = DateTime.utc(2026, 9, 14);
      final extraction = _SlowCancelExtractionRepository(
        extractGate: extractGate,
        cancelHold: cancelHold,
        chunkedUpdates: [
          ExtractionProgressUpdate(
            progress: ExtractionProgress(
              currentChunk: 1,
              totalChunks: 2,
              candidatesFound: 0,
              chunkTimings: const [0.1],
              startTime: start,
            ),
            newCandidates: const [],
          ),
        ],
      );
      final container = _container(
        conversations: _FakeSourceConversationRepository(hasLatest: true),
        extraction: extraction,
        platform: platform,
      );

      final done = container
          .read(reviewActionsControllerProvider.notifier)
          .extractSourcesChunked(
            sourceConversationIds: const ['source-1'],
            progressTitle: 'Extraction in progress',
            progressBody: 'Processing',
            completionTitle: 'Extraction complete',
            completionBody: (count) => '$count found',
          );
      await Future<void>.delayed(Duration.zero);

      final cancelFuture = container
          .read(reviewActionsControllerProvider.notifier)
          .cancelExtraction();
      await Future<void>.delayed(Duration.zero);

      expect(platform.stopCount, greaterThanOrEqualTo(1));
      expect(platform.foregroundServiceRunning, isFalse);
      expect(cancelHold.isCompleted, isFalse);

      cancelHold.complete();
      await cancelFuture;
      await done;

      expect(extraction.cancelCount, 1);
      expect(platform.completions, isEmpty);
    },
  );
}
