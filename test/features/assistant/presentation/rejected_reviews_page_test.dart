import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/assistant/data/providers/extraction_providers.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_job.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_run.dart';
import 'package:quorivell/features/assistant/domain/entities/review_candidate.dart';
import 'package:quorivell/features/assistant/domain/repositories/extraction_repository.dart';
import 'package:quorivell/features/assistant/domain/repositories/extraction_run_repository.dart';
import 'package:quorivell/features/assistant/presentation/pages/rejected_reviews_page.dart';
import 'package:quorivell/features/ledger/data/providers/ledger_providers.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';
import 'package:quorivell/features/ledger/domain/repositories/ledger_repository.dart';
import 'package:quorivell/l10n/app_localizations.dart';
import '../../../helpers/extraction_kind_catalog.dart';

final _rejectedCommitment = ReviewCandidate(
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
  reviewStatus: ReviewStatus.rejected,
);

final _rejectedDecision = ReviewCandidate(
  id: 'candidate-2',
  userId: 'user-1',
  sourceConversationId: 'source-1',
  sourceRevision: 1,
  kind: ReviewCandidateKind.decision,
  statement: 'We will ship option A.',
  owner: null,
  dueDate: null,
  quoteStart: 0,
  quoteEnd: 22,
  quoteSnippet: 'We will ship option A.',
  reviewStatus: ReviewStatus.rejected,
);

class _FakeExtractionRepository implements ExtractionRepository {
  _FakeExtractionRepository({Stream<List<ReviewCandidate>>? rejected})
    : _rejected = rejected ?? Stream.value([_rejectedCommitment]);

  final Stream<List<ReviewCandidate>> _rejected;
  final deletedIds = <String>[];

  @override
  Stream<List<ReviewCandidate>> watchPending({
    int limit = 100,
    int offset = 0,
  }) => const Stream.empty();

  @override
  Stream<List<ReviewCandidate>> watchRejected({
    int limit = 100,
    int offset = 0,
  }) => _rejected;

  @override
  Future<List<ReviewCandidate>> extract(String sourceConversationId) async =>
      const [];

  @override
  Stream<ExtractionProgressUpdate> extractChunked(
    String sourceConversationId,
  ) async* {
    // Stub for tests
  }

  @override
  Future<ExtractionJob?> loadActiveJob() async => null;

  @override
  Future<void> upsertJob(ExtractionJob job) async {}

  @override
  Future<void> clearJob() async {}

  @override
  Future<void> prepareRun() async {}

  @override
  Future<void> cancelActive() async {}

  @override
  Future<void> updateReview(ReviewCandidate candidate) async {}

  @override
  Future<void> deletePending(String candidateId) async {
    deletedIds.add(candidateId);
  }
}

class _FakeExtractionRunRepository implements ExtractionRunRepository {
  _FakeExtractionRunRepository({Stream<List<ExtractionRun>>? runs})
    : _runs = runs ?? Stream.value(const <ExtractionRun>[]);

  final Stream<List<ExtractionRun>> _runs;
  final deletedIds = <String>[];

  @override
  Stream<List<ExtractionRun>> watchRuns({int limit = 50, int offset = 0}) =>
      _runs;

  @override
  Future<void> createRun(ExtractionRun run) async {}

  @override
  Future<void> deleteRun(String runId) async {
    deletedIds.add(runId);
  }
}

final _successfulRun = ExtractionRun(
  id: 'run-1',
  userId: 'user-1',
  modelId: 'Qwen2.5-1.5B-Instruct-Q4_K_M',
  startedAt: DateTime.utc(2026, 9, 16, 8),
  completedAt: DateTime.utc(2026, 9, 16, 8, 1),
  status: ExtractionRunStatus.success,
  durationMs: 12500,
  kindCounts: {'decision': 2, 'commitment': 1},
);

class _FakeLedgerRepository implements LedgerRepository {
  final accepted = <({String id, String statement, DateTime? dueDate})>[];

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
    accepted.add((id: candidateId, statement: statement, dueDate: dueDate));
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

Widget _wrap({
  required ExtractionRepository extraction,
  LedgerRepository? ledger,
  ExtractionRunRepository? runs,
}) => ProviderScope(
  overrides: [
    ...extractionKindCatalogOverrides(),
    extractionRepositoryProvider.overrideWithValue(extraction),
    extractionRunRepositoryProvider.overrideWithValue(
      runs ?? _FakeExtractionRunRepository(),
    ),
    if (ledger != null) ledgerRepositoryProvider.overrideWithValue(ledger),
  ],
  child: MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: const RejectedReviewsPage(),
  ),
);

void main() {
  testWidgets('shows rejected suggestions', (tester) async {
    await tester.pumpWidget(_wrap(extraction: _FakeExtractionRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Review history'), findsOneWidget);
    expect(find.text('Rejected'), findsWidgets);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Alex will send the checklist.'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no rejected suggestions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        extraction: _FakeExtractionRepository(
          rejected: Stream.value(const <ReviewCandidate>[]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No rejected suggestions.'), findsOneWidget);
  });

  testWidgets('shows an error state when the stream fails', (tester) async {
    await tester.pumpWidget(
      _wrap(
        extraction: _FakeExtractionRepository(
          rejected: Stream<List<ReviewCandidate>>.error(
            const LocalPersistenceFailure.readFailed(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rejected suggestions unavailable.'), findsOneWidget);
  });

  testWidgets('confirms and soft-deletes a rejected suggestion', (
    tester,
  ) async {
    final extraction = _FakeExtractionRepository();
    await tester.pumpWidget(_wrap(extraction: extraction));
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Alex will send the checklist.'));
    await tester.pumpAndSettle();

    expect(find.text('Delete this suggestion?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(extraction.deletedIds, ['candidate-1']);
    expect(find.text('Alex will send the checklist.'), findsNothing);
  });

  testWidgets(
    'tap opens accept dialog for a commitment with due date control',
    (tester) async {
      await tester.pumpWidget(_wrap(extraction: _FakeExtractionRepository()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alex will send the checklist.'));
      await tester.pumpAndSettle();

      expect(find.text('Accept suggestion'), findsOneWidget);
      expect(find.text('Set due date (optional)'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
    },
  );

  testWidgets('accept dialog hides due date control for decisions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        extraction: _FakeExtractionRepository(
          rejected: Stream.value([_rejectedDecision]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('We will ship option A.'));
    await tester.pumpAndSettle();

    expect(find.text('Accept suggestion'), findsOneWidget);
    expect(find.text('Set due date (optional)'), findsNothing);
  });

  testWidgets('accepting a rejected suggestion reaches the ledger', (
    tester,
  ) async {
    final ledger = _FakeLedgerRepository();
    await tester.pumpWidget(
      _wrap(extraction: _FakeExtractionRepository(), ledger: ledger),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Alex will send the checklist.'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Accept'));
    await tester.pumpAndSettle();

    expect(ledger.accepted, [
      (
        id: 'candidate-1',
        statement: 'Alex will send the checklist.',
        dueDate: null,
      ),
    ]);
    expect(find.text('Alex will send the checklist.'), findsNothing);
    expect(find.text('Suggestion added to your ledger.'), findsOneWidget);
  });

  testWidgets('shows an empty extraction history tab', (tester) async {
    await tester.pumpWidget(_wrap(extraction: _FakeExtractionRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('No extraction runs yet.'), findsOneWidget);
  });

  testWidgets('shows extraction run stats on the history tab', (tester) async {
    await tester.pumpWidget(
      _wrap(
        extraction: _FakeExtractionRepository(),
        runs: _FakeExtractionRunRepository(
          runs: Stream.value([_successfulRun]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('Qwen2.5-1.5B-Instruct-Q4_K_M'), findsOneWidget);
    expect(find.text('Took 12.5s'), findsOneWidget);
    expect(find.text('Decision: 2'), findsOneWidget);
    expect(find.text('Commitment: 1'), findsOneWidget);
  });

  testWidgets('shows an error state when extraction history fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        extraction: _FakeExtractionRepository(),
        runs: _FakeExtractionRunRepository(
          runs: Stream<List<ExtractionRun>>.error(
            const LocalPersistenceFailure.readFailed(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('Extraction history unavailable.'), findsOneWidget);
  });

  testWidgets('shows a loading indicator while extraction history loads', (
    tester,
  ) async {
    final controller = StreamController<List<ExtractionRun>>();
    addTearDown(controller.close);

    await tester.pumpWidget(
      _wrap(
        extraction: _FakeExtractionRepository(),
        runs: _FakeExtractionRunRepository(runs: controller.stream),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('History'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    expect(find.bySemanticsLabel('Loading'), findsAtLeastNWidgets(1));
  });

  testWidgets('select mode bulk-deletes rejected suggestions', (tester) async {
    final extraction = _FakeExtractionRepository(
      rejected: Stream.value([_rejectedCommitment, _rejectedDecision]),
    );
    await tester.pumpWidget(_wrap(extraction: extraction));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsOneWidget);
    expect(find.byType(Checkbox), findsNWidgets(2));
    expect(find.byType(Dismissible), findsNothing);

    await tester.tap(find.byTooltip('Select all'));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();
    expect(find.text('Delete 2 suggestions?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(extraction.deletedIds, ['candidate-1', 'candidate-2']);
  });

  testWidgets('select mode bulk-deletes extraction runs', (tester) async {
    final runs = _FakeExtractionRunRepository(
      runs: Stream.value([
        _successfulRun,
        ExtractionRun(
          id: 'run-2',
          userId: 'user-1',
          modelId: 'Qwen2.5-1.5B-Instruct-Q4_K_M',
          startedAt: DateTime.utc(2026, 9, 17, 8),
          completedAt: DateTime.utc(2026, 9, 17, 8, 1),
          status: ExtractionRunStatus.success,
          durationMs: 8000,
          kindCounts: const {'decision': 1},
        ),
      ]),
    );
    await tester.pumpWidget(
      _wrap(extraction: _FakeExtractionRepository(), runs: runs),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Select all'));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();
    expect(find.text('Delete 2 extraction runs?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(runs.deletedIds, ['run-1', 'run-2']);
  });
}
