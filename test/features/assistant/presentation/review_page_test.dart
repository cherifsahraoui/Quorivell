import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/account/data/providers/debug_ai_settings_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/core/platform/background_work_constraint_service.dart';
import 'package:quorivell/features/assistant/data/providers/extraction_providers.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_job.dart';
import 'package:quorivell/features/assistant/domain/entities/review_candidate.dart';
import 'package:quorivell/features/assistant/domain/repositories/extraction_repository.dart';
import 'package:quorivell/features/assistant/presentation/pages/review_page.dart';
import 'package:quorivell/features/ledger/data/providers/ledger_providers.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';
import 'package:quorivell/features/ledger/domain/repositories/ledger_repository.dart';
import '../../../helpers/extraction_kind_catalog.dart';
import '../../../helpers/layout_overflow.dart';
import 'package:quorivell/features/meeting_notes/data/providers/source_conversation_providers.dart';
import 'package:quorivell/features/meeting_notes/domain/entities/source_conversation.dart';
import 'package:quorivell/features/meeting_notes/domain/repositories/source_conversation_repository.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/l10n/app_localizations.dart';

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

final _secondCandidate = ReviewCandidate(
  id: 'candidate-2',
  userId: 'user-1',
  sourceConversationId: 'source-1',
  sourceRevision: 1,
  kind: ReviewCandidateKind.decision,
  statement: 'Jordan will share the timeline.',
  owner: 'Jordan',
  dueDate: null,
  quoteStart: 40,
  quoteEnd: 72,
  quoteSnippet: 'Jordan promised the timeline Friday.',
  reviewStatus: ReviewStatus.pending,
);

List<String> _statementFieldTexts(WidgetTester tester) {
  return tester
      .widgetList<TextField>(find.byType(TextField))
      .map((field) => field.controller?.text ?? '')
      .where((text) => text.isNotEmpty)
      .toList();
}

class _FakeExtractionRepository implements ExtractionRepository {
  _FakeExtractionRepository({
    Stream<List<ReviewCandidate>>? pending,
    Stream<List<ReviewCandidate>>? rejected,
  }) : _pending = pending ?? const Stream.empty(),
       _rejected = rejected ?? const Stream.empty();

  final Stream<List<ReviewCandidate>> _pending;
  final Stream<List<ReviewCandidate>> _rejected;
  final updated = <ReviewCandidate>[];
  final extracted = <String>[];
  final deletedIds = <String>[];

  @override
  Stream<List<ReviewCandidate>> watchPending({
    int limit = 100,
    int offset = 0,
  }) => _pending;

  @override
  Stream<List<ReviewCandidate>> watchRejected({
    int limit = 100,
    int offset = 0,
  }) => _rejected;

  @override
  Future<List<ReviewCandidate>> extract(String sourceConversationId) async {
    extracted.add(sourceConversationId);
    return const [];
  }

  @override
  Stream<ExtractionProgressUpdate> extractChunked(
    String sourceConversationId,
  ) async* {
    extracted.add(sourceConversationId);
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
  Future<void> updateReview(ReviewCandidate candidate) async =>
      updated.add(candidate);

  @override
  Future<void> deletePending(String candidateId) async {
    deletedIds.add(candidateId);
  }
}

class _FakeSourceConversationRepository
    implements SourceConversationRepository {
  _FakeSourceConversationRepository({
    this.hasLatest = false,
    this.watchActiveEvenIfLatestMissing = false,
  });

  final bool hasLatest;

  /// When true, the empty-state stream looks active but [latest] is null.
  final bool watchActiveEvenIfLatestMissing;

  SourceConversation get _active => SourceConversation(
    id: 'source-1',
    userId: 'user-1',
    content: 'Alex will send the checklist.',
    sourceRevision: 1,
    createdAt: DateTime.utc(2026, 9, 7),
    updatedAt: DateTime.utc(2026, 9, 7),
  );

  @override
  Future<SourceConversation> capture(String content, {String? sourceUrl}) async =>
      throw UnimplementedError();

  @override
  Future<SourceConversation?> latest() async => hasLatest ? _active : null;

  @override
  Future<List<SourceConversation>> listActive({
    int? limit,
    bool newestFirst = true,
  }) async {
    if (!hasLatest) {
      return const [];
    }
    return [_active];
  }

  @override
  Stream<List<SourceConversation>> watchAll({
    int limit = 50,
    int offset = 0,
    bool archivedOnly = false,
  }) {
    if (archivedOnly) {
      return Stream.value(const <SourceConversation>[]);
    }
    if (hasLatest || watchActiveEvenIfLatestMissing) {
      return Stream.value([_active]);
    }
    return Stream.value(const <SourceConversation>[]);
  }

  @override
  Future<SourceConversation?> find(String id) async =>
      id == _active.id && hasLatest ? _active : null;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> archive(String id) async {}

  @override
  Future<void> unarchive(String id) async {}
}

class _FakeLedgerRepository implements LedgerRepository {
  final accepted = <({String id, String statement, String kind})>[];

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
    accepted.add((id: candidateId, statement: statement, kind: kind));
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

class _StubDebugAiSettings extends DebugAiSettingsController {
  _StubDebugAiSettings({this.preference});

  final UserPreference? preference;

  @override
  Future<UserPreference?> build() async => preference;
}

UserPreference _debugOnPreference() => UserPreference(
  id: 'app',
  userId: 'user-1',
  themeMode: AppearanceThemeMode.system,
  localePreference: AppLocalePreference.system,
  debugModeEnabled: true,
  extractionKindsIntroDismissed: true,
  createdAt: DateTime.utc(2026, 9, 12),
  updatedAt: DateTime.utc(2026, 9, 12),
);

UserPreference _defaultPreference() => UserPreference(
  id: 'app',
  userId: 'user-1',
  themeMode: AppearanceThemeMode.system,
  localePreference: AppLocalePreference.system,
  extractionKindsIntroDismissed: true,
  createdAt: DateTime.utc(2026, 9, 12),
  updatedAt: DateTime.utc(2026, 9, 12),
);

class _ReadyInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: true);
  }
}

class _MissingInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: false);
  }
}

class _FakeBackgroundWorkConstraintService
    implements BackgroundWorkConstraintService {
  _FakeBackgroundWorkConstraintService({this.isBackgroundRestricted = false});

  final bool isBackgroundRestricted;
  var openSettingsCount = 0;

  @override
  Future<BackgroundWorkConstraints> read() async {
    return BackgroundWorkConstraints(
      isBackgroundRestricted: isBackgroundRestricted,
      isPowerSaveMode: false,
      isIgnoringBatteryOptimizations: !isBackgroundRestricted,
    );
  }

  @override
  Future<void> openSettings() async {
    openSettingsCount += 1;
  }
}

Future<void> _pumpReviewPage(
  WidgetTester tester, {
  required ExtractionRepository extraction,
  SourceConversationRepository? conversations,
  LedgerRepository? ledger,
  LocalModelInstallController? install,
  BackgroundWorkConstraintService? backgroundWork,
  bool debugModeEnabled = false,
  Duration ledgerHandoffDelay = Duration.zero,
  String initialLocation = '/review',
}) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/review',
        builder: (context, state) =>
            Scaffold(body: ReviewPage(ledgerHandoffDelay: ledgerHandoffDelay)),
        routes: [
          GoRoute(
            path: 'rejected',
            builder: (context, state) =>
                const Scaffold(body: Text('rejected-history')),
          ),
        ],
      ),
      GoRoute(
        path: '/ledger',
        builder: (context, state) => const Scaffold(body: Text('ledger')),
      ),
      GoRoute(
        path: '/capture',
        builder: (context, state) => const Scaffold(body: Text('capture')),
      ),
      GoRoute(
        path: '/account/model',
        builder: (context, state) =>
            const Scaffold(body: Text('model-details')),
      ),
    ],
  );

  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...extractionKindCatalogOverrides(),
        extractionRepositoryProvider.overrideWithValue(extraction),
        sourceConversationRepositoryProvider.overrideWithValue(
          conversations ?? _FakeSourceConversationRepository(),
        ),
        ledgerRepositoryProvider.overrideWithValue(
          ledger ?? _FakeLedgerRepository(),
        ),
        localModelInstallControllerProvider.overrideWith(
          () => install ?? _ReadyInstallController(),
        ),
        debugAiSettingsControllerProvider.overrideWith(
          () => _StubDebugAiSettings(
            preference: debugModeEnabled
                ? _debugOnPreference()
                : _defaultPreference(),
          ),
        ),
        if (backgroundWork != null)
          backgroundWorkConstraintServiceProvider.overrideWithValue(
            backgroundWork,
          ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
}

void main() {
  testWidgets('shows a loading state before the queue emits', (tester) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: StreamController<List<ReviewCandidate>>().stream,
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('shows the empty state with an extract action', (tester) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream.value(const <ReviewCandidate>[]),
      ),
      conversations: _FakeSourceConversationRepository(hasLatest: true),
    );
    await tester.pumpAndSettle();

    expect(find.text('No candidates waiting for review.'), findsOneWidget);
    expect(find.text('Extract'), findsOneWidget);
  });

  testWidgets(
    'opens conversation-shape help when launched from a zero-result notification',
    (tester) async {
      await _pumpReviewPage(
        tester,
        initialLocation: '/review?teach=1',
        extraction: _FakeExtractionRepository(
          pending: Stream.value(const <ReviewCandidate>[]),
        ),
        conversations: _FakeSourceConversationRepository(hasLatest: true),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing explicit to extract'), findsOneWidget);
    },
  );

  testWidgets('prompts Capture when no active conversation exists', (
    tester,
  ) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream.value(const <ReviewCandidate>[]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Capture a conversation first.'), findsOneWidget);
    expect(find.text('Go to Capture'), findsOneWidget);
    expect(find.text('Extract'), findsNothing);

    await tester.tap(find.text('Go to Capture'));
    await tester.pumpAndSettle();
    expect(find.text('capture'), findsOneWidget);
  });

  testWidgets('opens rejected history from the review header', (tester) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream.value(const <ReviewCandidate>[]),
      ),
      conversations: _FakeSourceConversationRepository(hasLatest: true),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byTooltip('View rejected suggestions and extraction history'),
    );
    await tester.pumpAndSettle();

    expect(find.text('rejected-history'), findsOneWidget);
  });

  testWidgets(
    'kinds info sheet scrolls without overflowing on a compact phone',
    (tester) async {
      await _pumpReviewPage(
        tester,
        extraction: _FakeExtractionRepository(
          pending: Stream.value(const <ReviewCandidate>[]),
        ),
        conversations: _FakeSourceConversationRepository(hasLatest: true),
      );
      await tester.pumpAndSettle();

      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1;
      await tester.pump();

      await expectNoLayoutOverflow(() async {
        await tester.tap(find.byTooltip('How kinds work'));
        await tester.pumpAndSettle();
      });

      expect(find.text('What to look for'), findsOneWidget);
      expect(
        find.textContaining('Decision and Commitment are the built-in example'),
        findsOneWidget,
      );
    },
  );

  testWidgets('shows a localized error state when the queue fails', (
    tester,
  ) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream<List<ReviewCandidate>>.error(
          const LocalPersistenceFailure.readFailed(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Review queue unavailable.'), findsOneWidget);
  });

  testWidgets('renders a candidate with its evidence and owner', (
    tester,
  ) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream.value([_candidate]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Decision'), findsOneWidget);
    expect(find.text('Commitment'), findsOneWidget);
    expect(find.text('Set due date (optional)'), findsOneWidget);
    expect(find.text('Owner: Alex'), findsOneWidget);
    expect(
      find.text('Evidence: “Alex will send the checklist.”'),
      findsOneWidget,
    );
    expect(find.text('Source JSON'), findsNothing);
  });

  testWidgets('shows candidate JSON when debug mode is on', (tester) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream.value([_candidate]),
      ),
      debugModeEnabled: true,
    );
    await tester.pumpAndSettle();

    expect(find.text('Source JSON'), findsOneWidget);
    await tester.tap(find.text('Source JSON'));
    await tester.pumpAndSettle();
    expect(find.textContaining('"statement":'), findsOneWidget);
    expect(find.textContaining('"quoteSnippet":'), findsOneWidget);
  });

  testWidgets('accepting a candidate reaches the ledger with edits', (
    tester,
  ) async {
    final ledger = _FakeLedgerRepository();
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream.value([_candidate]),
      ),
      ledger: ledger,
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).first,
      'Alex will send the agenda.',
    );
    final accept = find.text('Accept');
    await tester.dragUntilVisible(
      accept,
      find.byType(Scrollable).first,
      const Offset(0, -300),
    );
    await tester.tap(accept);
    await tester.pumpAndSettle();

    expect(ledger.accepted, [
      (
        id: 'candidate-1',
        statement: 'Alex will send the agenda.',
        kind: LedgerItemKind.commitment,
      ),
    ]);
  });

  testWidgets(
    'toggling kind to decision hides due date and accepts as decision',
    (tester) async {
      final ledger = _FakeLedgerRepository();
      await _pumpReviewPage(
        tester,
        extraction: _FakeExtractionRepository(
          pending: Stream.value([_candidate]),
        ),
        ledger: ledger,
      );
      await tester.pumpAndSettle();

      expect(find.text('Set due date (optional)'), findsOneWidget);

      await tester.tap(find.text('Decision'));
      await tester.pumpAndSettle();

      expect(find.text('Set due date (optional)'), findsNothing);

      await tester.dragUntilVisible(
        find.text('Accept'),
        find.byType(Scrollable).first,
        const Offset(0, -300),
      );
      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      expect(ledger.accepted, [
        (
          id: 'candidate-1',
          statement: 'Alex will send the checklist.',
          kind: LedgerItemKind.decision,
        ),
      ]);
    },
  );

  testWidgets('toggling kind to commitment shows the due date control', (
    tester,
  ) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream.value([_secondCandidate]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Set due date (optional)'), findsNothing);

    await tester.tap(find.text('Commitment'));
    await tester.pumpAndSettle();

    expect(find.text('Set due date (optional)'), findsOneWidget);
  });

  testWidgets('rejecting a candidate records the new review status', (
    tester,
  ) async {
    final extraction = _FakeExtractionRepository(
      pending: Stream.value([_candidate]),
    );
    await _pumpReviewPage(tester, extraction: extraction);
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('Reject'),
      find.byType(Scrollable).first,
      const Offset(0, -300),
    );
    await tester.tap(find.text('Reject'));
    await tester.pumpAndSettle();

    expect(extraction.updated.single.reviewStatus, ReviewStatus.rejected);
  });

  testWidgets('extracts from the latest capture and reports an empty result', (
    tester,
  ) async {
    final extraction = _FakeExtractionRepository(
      pending: Stream.value(const <ReviewCandidate>[]),
    );
    await _pumpReviewPage(
      tester,
      extraction: extraction,
      conversations: _FakeSourceConversationRepository(hasLatest: true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Extract'));
    await tester.pumpAndSettle();

    expect(extraction.extracted, ['source-1']);
    expect(find.text('Nothing explicit to extract'), findsOneWidget);
    expect(
      find.text(
        'Alex explicitly committed to delivering the API documentation by October 15th',
      ),
      findsWidgets,
    );
    expect(
      find.text('the team officially decided to proceed with Option A'),
      findsWidgets,
    );
    expect(
      find.text(
        'Mark mentioned he might look into the database performance issues',
      ),
      findsWidgets,
    );
    expect(find.text('Commitment'), findsOneWidget);
    expect(find.text('Decision'), findsOneWidget);
    expect(find.text('Not extracted'), findsOneWidget);
  });

  testWidgets(
    'shows a Restricted reminder before extract and continues after dismiss',
    (tester) async {
      final extraction = _FakeExtractionRepository(
        pending: Stream.value(const <ReviewCandidate>[]),
      );
      final backgroundWork = _FakeBackgroundWorkConstraintService(
        isBackgroundRestricted: true,
      );
      await _pumpReviewPage(
        tester,
        extraction: extraction,
        conversations: _FakeSourceConversationRepository(hasLatest: true),
        backgroundWork: backgroundWork,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Extract'));
      await tester.pumpAndSettle();

      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(
        find.text(l10n.backgroundRestrictionReminderTitle),
        findsOneWidget,
      );
      expect(extraction.extracted, isEmpty);

      await tester.tap(find.text(l10n.backgroundWorkReminderContinue));
      await tester.pumpAndSettle();

      expect(extraction.extracted, ['source-1']);
      expect(backgroundWork.openSettingsCount, 0);
      expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
    },
  );

  testWidgets(
    'navigates to Capture when extract finds no active conversation',
    (tester) async {
      await _pumpReviewPage(
        tester,
        extraction: _FakeExtractionRepository(
          pending: Stream.value(const <ReviewCandidate>[]),
        ),
        conversations: _FakeSourceConversationRepository(
          watchActiveEvenIfLatestMissing: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Extract'), findsOneWidget);

      await tester.tap(find.text('Extract'));
      await tester.pumpAndSettle();

      expect(find.text('Capture a source conversation first.'), findsOneWidget);
      expect(find.text('capture'), findsOneWidget);
    },
  );

  testWidgets('blocks extract when no on-device model is configured', (
    tester,
  ) async {
    final extraction = _FakeExtractionRepository(
      pending: Stream.value(const <ReviewCandidate>[]),
    );
    await _pumpReviewPage(
      tester,
      extraction: extraction,
      conversations: _FakeSourceConversationRepository(hasLatest: true),
      install: _MissingInstallController(),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Extract'));
    await tester.pumpAndSettle();

    expect(find.text('Configure the on-device model'), findsOneWidget);
    expect(extraction.extracted, isEmpty);

    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(extraction.extracted, isEmpty);
  });

  testWidgets(
    'shows a completion handoff then opens the ledger after the last reject',
    (tester) async {
      final pending = StreamController<List<ReviewCandidate>>();
      addTearDown(pending.close);

      await _pumpReviewPage(
        tester,
        extraction: _FakeExtractionRepository(pending: pending.stream),
        ledgerHandoffDelay: const Duration(milliseconds: 500),
      );
      pending.add([_candidate]);
      await tester.pumpAndSettle();

      expect(find.text('Commitment'), findsOneWidget);

      pending.add(const []);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('All caught up'), findsOneWidget);
      expect(find.text('Opening your ledger…'), findsOneWidget);
      expect(find.text('View ledger'), findsOneWidget);
      expect(find.text('ledger'), findsNothing);

      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('ledger'), findsOneWidget);
    },
  );

  testWidgets(
    'opens the ledger immediately when View ledger is tapped during handoff',
    (tester) async {
      final pending = StreamController<List<ReviewCandidate>>();
      addTearDown(pending.close);

      await _pumpReviewPage(
        tester,
        extraction: _FakeExtractionRepository(pending: pending.stream),
        ledgerHandoffDelay: const Duration(seconds: 5),
      );
      pending.add([_candidate]);
      await tester.pumpAndSettle();

      pending.add(const []);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('All caught up'), findsOneWidget);

      await tester.tap(find.text('View ledger'));
      await tester.pumpAndSettle();

      expect(find.text('ledger'), findsOneWidget);
    },
  );

  testWidgets('does not hand off when review opens already empty', (
    tester,
  ) async {
    await _pumpReviewPage(
      tester,
      extraction: _FakeExtractionRepository(
        pending: Stream.value(const <ReviewCandidate>[]),
      ),
      ledgerHandoffDelay: const Duration(milliseconds: 50),
    );
    await tester.pumpAndSettle();

    expect(find.text('Capture a conversation first.'), findsOneWidget);
    expect(find.text('All caught up'), findsNothing);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(find.text('ledger'), findsNothing);
    expect(find.text('Go to Capture'), findsOneWidget);
  });

  testWidgets(
    'keeps remaining card statement when the pending queue shrinks from the front',
    (tester) async {
      final pending = StreamController<List<ReviewCandidate>>();
      addTearDown(pending.close);

      await _pumpReviewPage(
        tester,
        extraction: _FakeExtractionRepository(pending: pending.stream),
      );
      pending.add([_candidate, _secondCandidate]);
      await tester.pumpAndSettle();

      expect(_statementFieldTexts(tester).first, _candidate.statement);

      pending.add([_secondCandidate]);
      await tester.pumpAndSettle();

      expect(_statementFieldTexts(tester), [_secondCandidate.statement]);
      expect(
        find.text('Evidence: “Jordan promised the timeline Friday.”'),
        findsOneWidget,
      );
      expect(
        find.text('Evidence: “Alex will send the checklist.”'),
        findsNothing,
      );
      expect(find.text('Owner: Jordan'), findsOneWidget);
      expect(find.text('Owner: Alex'), findsNothing);
    },
  );

  testWidgets(
    'accepting the first card does not leave its statement on the next card',
    (tester) async {
      final pending = StreamController<List<ReviewCandidate>>();
      addTearDown(pending.close);
      final ledger = _FakeLedgerRepository();

      await _pumpReviewPage(
        tester,
        extraction: _FakeExtractionRepository(pending: pending.stream),
        ledger: ledger,
      );
      pending.add([_candidate, _secondCandidate]);
      await tester.pumpAndSettle();

      final accept = find.text('Accept').first;
      await tester.dragUntilVisible(
        accept,
        find.byType(Scrollable).first,
        const Offset(0, -300),
      );
      await tester.tap(accept);
      await tester.pumpAndSettle();

      expect(ledger.accepted, [
        (
          id: 'candidate-1',
          statement: 'Alex will send the checklist.',
          kind: LedgerItemKind.commitment,
        ),
      ]);

      pending.add([_secondCandidate]);
      await tester.pumpAndSettle();

      expect(_statementFieldTexts(tester), [_secondCandidate.statement]);
      expect(
        find.text('Evidence: “Jordan promised the timeline Friday.”'),
        findsOneWidget,
      );
      expect(
        find.text('Evidence: “Alex will send the checklist.”'),
        findsNothing,
      );
    },
  );
}
