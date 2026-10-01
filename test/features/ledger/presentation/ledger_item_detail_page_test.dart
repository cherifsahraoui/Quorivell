import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/features/account/data/providers/debug_ai_settings_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/features/ledger/data/providers/ledger_providers.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';
import 'package:quorivell/features/ledger/domain/repositories/ledger_repository.dart';
import 'package:quorivell/features/ledger/presentation/pages/ledger_item_detail_page.dart';
import '../../../helpers/extraction_kind_catalog.dart';
import 'package:quorivell/features/meeting_notes/data/providers/source_conversation_providers.dart';
import 'package:quorivell/features/meeting_notes/domain/entities/source_conversation.dart';
import 'package:quorivell/features/meeting_notes/domain/repositories/source_conversation_repository.dart';
import 'package:quorivell/l10n/app_localizations.dart';

final _decision = LedgerItem(
  id: 'd1',
  userId: 'user-1',
  kind: LedgerItemKind.decision,
  statement: 'We chose option B.',
  status: LedgerItemStatus.open,
  owner: null,
  dueDate: DateTime(2026, 9, 10, 15, 30),
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

final _commitment = LedgerItem(
  id: 'c1',
  userId: 'user-1',
  kind: LedgerItemKind.commitment,
  statement: 'Alex will send the checklist.',
  status: LedgerItemStatus.open,
  owner: 'Alex',
  dueDate: DateTime(2026, 9, 10, 15, 30),
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

final _manual = LedgerItem(
  id: 'm1',
  userId: 'user-1',
  kind: LedgerItemKind.commitment,
  statement: 'Follow up next week.',
  status: LedgerItemStatus.open,
  owner: null,
  dueDate: null,
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

final _evidence = EvidenceReference(
  id: 'ev-1',
  ledgerItemId: 'd1',
  sourceConversationId: 'src-1',
  sourceRevision: 1,
  quoteStart: 0,
  quoteEnd: 18,
  quoteSnippet: 'We chose option B.',
);

final _source = SourceConversation(
  id: 'src-1',
  userId: 'user-1',
  content: 'We chose option B. Everyone agreed.',
  sourceRevision: 1,
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
  isArchived: true,
);

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
  createdAt: DateTime.utc(2026, 9, 12),
  updatedAt: DateTime.utc(2026, 9, 12),
);

class _FakeLedgerRepository implements LedgerRepository {
  _FakeLedgerRepository(this._items);

  final Map<String, LedgerItem> _items;

  @override
  Stream<List<LedgerItem>> watchItems({
    String? kind,
    Set<LedgerItemStatus>? statuses,
    int limit = 100,
    int offset = 0,
  }) => Stream.value(_items.values.toList());

  @override
  Stream<List<LedgerItem>> watchOpenCommitments({
    int limit = 100,
    int offset = 0,
  }) => const Stream.empty();

  @override
  Stream<LedgerItem?> watchById(String id) => Stream.value(_items[id]);

  @override
  Stream<List<EvidenceReference>> watchEvidence(String ledgerItemId) =>
      Stream.value(
        ledgerItemId == _decision.id || ledgerItemId == _commitment.id
            ? [_evidence.copyWith(ledgerItemId: ledgerItemId)]
            : const [],
      );

  @override
  Future<LedgerItem> acceptCandidate({
    required String candidateId,
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
  }) async => throw UnimplementedError();

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

class _FakeSourceConversationRepository
    implements SourceConversationRepository {
  _FakeSourceConversationRepository(this._conversations);

  final List<SourceConversation> _conversations;

  @override
  Future<SourceConversation> capture(String content, {String? sourceUrl}) async =>
      throw UnimplementedError();

  @override
  Future<SourceConversation?> latest() async => null;

  @override
  Future<List<SourceConversation>> listActive({
    int? limit,
    bool newestFirst = true,
  }) async => const [];

  @override
  Stream<List<SourceConversation>> watchAll({
    int limit = 50,
    int offset = 0,
    bool archivedOnly = false,
  }) => const Stream.empty();

  @override
  Future<SourceConversation?> find(String id) async {
    for (final conversation in _conversations) {
      if (conversation.id == id) return conversation;
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

Future<void> _pumpDetail(
  WidgetTester tester,
  String itemId, {
  List<SourceConversation> sources = const [],
  void Function(GoRouterState state)? onSourceOpened,
  bool debugModeEnabled = false,
}) {
  final router = GoRouter(
    initialLocation: '/ledger/items/$itemId',
    routes: [
      GoRoute(
        path: '/ledger/items/:itemId',
        builder: (context, state) =>
            LedgerItemDetailPage(itemId: state.pathParameters['itemId']!),
      ),
      GoRoute(
        path: '/capture/sources/:sourceId',
        builder: (context, state) {
          onSourceOpened?.call(state);
          return Scaffold(
            body: Text(
              'source:${state.pathParameters['sourceId']}'
              ':${state.uri.queryParameters['quoteStart']}'
              '-${state.uri.queryParameters['quoteEnd']}',
            ),
          );
        },
      ),
    ],
  );

  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...extractionKindCatalogOverrides(),
        ledgerRepositoryProvider.overrideWithValue(
          _FakeLedgerRepository({
            _decision.id: _decision,
            _commitment.id: _commitment,
            _manual.id: _manual,
          }),
        ),
        sourceConversationRepositoryProvider.overrideWithValue(
          _FakeSourceConversationRepository(sources),
        ),
        debugAiSettingsControllerProvider.overrideWith(
          () => _StubDebugAiSettings(
            preference: debugModeEnabled ? _debugOnPreference() : null,
          ),
        ),
      ],
      child: MaterialApp.router(
        locale: const Locale('en'),
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
  testWidgets('shows statement and evidence on the detail page', (
    tester,
  ) async {
    await _pumpDetail(tester, 'd1', sources: [_source]);
    await tester.pumpAndSettle();

    expect(find.text('We chose option B.'), findsWidgets);
    expect(find.text('Evidence'), findsOneWidget);
    expect(find.text('Ledger item JSON'), findsNothing);
    expect(find.text('Evidence JSON'), findsNothing);
  });

  testWidgets('shows item and evidence JSON when debug mode is on', (
    tester,
  ) async {
    await _pumpDetail(tester, 'd1', sources: [_source], debugModeEnabled: true);
    await tester.pumpAndSettle();

    expect(find.text('Ledger item JSON'), findsOneWidget);
    expect(find.text('Evidence JSON'), findsOneWidget);
    await tester.tap(find.text('Ledger item JSON'));
    await tester.pumpAndSettle();
    expect(find.textContaining('"statement":'), findsWidgets);
  });

  testWidgets('shows commitment due date with time', (tester) async {
    await _pumpDetail(tester, 'c1', sources: [_source]);
    await tester.pumpAndSettle();

    expect(find.textContaining('Sep 10, 2026'), findsOneWidget);
    expect(find.textContaining('3:30'), findsOneWidget);
  });

  testWidgets('commitment status chip meets the 48dp tap target', (
    tester,
  ) async {
    await _pumpDetail(tester, 'c1', sources: [_source]);
    await tester.pumpAndSettle();

    final chip = tester.getSize(find.widgetWithText(FilterChip, 'Open'));
    expect(chip.height, greaterThanOrEqualTo(48));
    expect(chip.width, greaterThanOrEqualTo(48));
  });

  testWidgets('hides due date on decisions even if present', (tester) async {
    await _pumpDetail(tester, 'd1', sources: [_source]);
    await tester.pumpAndSettle();

    expect(find.textContaining('Sep 10, 2026'), findsNothing);
  });

  testWidgets('shows not-found when the item is missing', (tester) async {
    await _pumpDetail(tester, 'missing');
    await tester.pumpAndSettle();

    expect(
      find.text('This ledger item is no longer available.'),
      findsOneWidget,
    );
  });

  testWidgets('explains missing evidence on a user-authored item', (
    tester,
  ) async {
    await _pumpDetail(tester, 'm1');
    await tester.pumpAndSettle();

    expect(
      find.text('You added this item. No conversation evidence is attached.'),
      findsOneWidget,
    );
  });

  testWidgets('opens the archived conversation with quote offsets', (
    tester,
  ) async {
    GoRouterState? opened;
    await _pumpDetail(
      tester,
      'd1',
      sources: [_source],
      onSourceOpened: (state) => opened = state,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('We chose option B.').last);
    await tester.pumpAndSettle();

    expect(opened?.pathParameters['sourceId'], 'src-1');
    expect(opened?.uri.queryParameters['quoteStart'], '0');
    expect(opened?.uri.queryParameters['quoteEnd'], '18');
    expect(opened?.uri.queryParameters['quoteSnippet'], 'We chose option B.');
    expect(find.text('source:src-1:0-18'), findsOneWidget);
  });

  testWidgets('shows a dialog when the evidence source was deleted', (
    tester,
  ) async {
    await _pumpDetail(tester, 'd1');
    await tester.pumpAndSettle();

    await tester.tap(find.text('We chose option B.').last);
    await tester.pumpAndSettle();

    expect(find.text('Conversation unavailable'), findsOneWidget);
    expect(
      find.text(
        'The archived conversation linked to this evidence was deleted, '
        'so the original text can no longer be opened.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    expect(find.text('Conversation unavailable'), findsNothing);
  });
}
