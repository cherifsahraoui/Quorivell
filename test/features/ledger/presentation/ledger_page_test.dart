import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/extraction_kinds/domain/entities/extraction_item_kind.dart';
import 'package:quorivell/features/ledger/data/providers/ledger_providers.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';
import 'package:quorivell/features/ledger/domain/repositories/ledger_repository.dart';
import 'package:quorivell/features/ledger/presentation/pages/ledger_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';
import '../../../helpers/extraction_kind_catalog.dart';

LedgerItem _item(
  String id,
  String statement, {
  String kind = LedgerItemKind.commitment,
  LedgerItemStatus status = LedgerItemStatus.open,
  String? owner = 'Alex',
  DateTime? dueDate,
}) => LedgerItem(
  id: id,
  userId: 'user-1',
  kind: kind,
  statement: statement,
  status: status,
  owner: owner,
  dueDate: dueDate,
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

class _FakeLedgerRepository implements LedgerRepository {
  _FakeLedgerRepository(this._items);

  final Stream<List<LedgerItem>> _items;
  final updated = <({String id, LedgerItemStatus status})>[];
  final deleted = <String>[];
  String? throwOnDeleteId;

  @override
  Stream<List<LedgerItem>> watchItems({
    String? kind,
    Set<LedgerItemStatus>? statuses,
    int limit = 100,
    int offset = 0,
  }) => _items;

  @override
  Stream<List<LedgerItem>> watchOpenCommitments({
    int limit = 100,
    int offset = 0,
  }) => _items;

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
  }) async {
    updated.add((id: id, status: status));
  }

  @override
  Future<void> delete(String id) async {
    if (id == throwOnDeleteId) {
      throw const LocalPersistenceFailure.writeFailed();
    }
    deleted.add(id);
  }
}

Future<void> _pumpLedgerPage(
  WidgetTester tester,
  Stream<List<LedgerItem>> items, {
  List<ExtractionItemKind>? catalog,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...extractionKindCatalogOverrides(catalog),
        ledgerRepositoryProvider.overrideWithValue(
          _FakeLedgerRepository(items),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: LedgerPage()),
      ),
    ),
  );
}

void main() {
  testWidgets('shows a loading state before the inbox emits', (tester) async {
    await _pumpLedgerPage(tester, StreamController<List<LedgerItem>>().stream);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no ledger items', (
    tester,
  ) async {
    await _pumpLedgerPage(tester, Stream.value(const <LedgerItem>[]));
    await tester.pumpAndSettle();

    expect(find.text('Your ledger is ready.'), findsOneWidget);
    expect(find.byTooltip('Add a ledger item'), findsOneWidget);
  });

  testWidgets('shows a localized error state when the inbox fails', (
    tester,
  ) async {
    await _pumpLedgerPage(
      tester,
      Stream<List<LedgerItem>>.error(
        const LocalPersistenceFailure.readFailed(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ledger unavailable.'), findsOneWidget);
  });

  testWidgets('lists commitments with a checkbox and owner', (tester) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([_item('a', 'Send the checklist.')]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Send the checklist.'), findsOneWidget);
    expect(find.text('Owner: Alex'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byTooltip('Add a ledger item'), findsOneWidget);
  });

  testWidgets('shows commitment due date with time', (tester) async {
    final dueDate = DateTime(2026, 9, 10, 15, 30);
    await _pumpLedgerPage(
      tester,
      Stream.value([_item('a', 'Send the checklist.', dueDate: dueDate)]),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Sep 10, 2026'), findsOneWidget);
    expect(find.textContaining('3:30'), findsOneWidget);
  });

  testWidgets('hides due date on decisions even if present', (tester) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item(
          'd1',
          'We chose option B.',
          kind: LedgerItemKind.decision,
          owner: null,
          dueDate: DateTime(2026, 9, 10, 15, 30),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Sep 10, 2026'), findsNothing);
  });

  testWidgets('lists decisions with a seal icon and no checkbox', (
    tester,
  ) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item(
          'd1',
          'We chose option B.',
          kind: LedgerItemKind.decision,
          owner: null,
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('We chose option B.'), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);
    expect(find.byIcon(Icons.verified_outlined), findsWidgets);
  });

  testWidgets('filters the list through the controller', (tester) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item('a', 'Send the checklist.'),
        _item('b', 'Book the venue.'),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'venue');
    await tester.pumpAndSettle();

    expect(find.text('Book the venue.'), findsOneWidget);
    expect(find.text('Send the checklist.'), findsNothing);
  });

  testWidgets('shows a no-matches message for an unmatched search', (
    tester,
  ) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([_item('a', 'Send the checklist.')]),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nothing matches this');
    await tester.pumpAndSettle();

    expect(find.text('No matching ledger items.'), findsOneWidget);
  });

  testWidgets('kind filter can show decisions only', (tester) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item('c1', 'Send the checklist.'),
        _item(
          'd1',
          'We chose option B.',
          kind: LedgerItemKind.decision,
          owner: null,
        ),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Decision'));
    await tester.pumpAndSettle();

    expect(find.text('We chose option B.'), findsOneWidget);
    expect(find.text('Send the checklist.'), findsNothing);
  });

  testWidgets('kind filters hide disabled kinds', (tester) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item('c1', 'Send the checklist.'),
        _item(
          'd1',
          'We chose option B.',
          kind: LedgerItemKind.decision,
          owner: null,
        ),
      ]),
      catalog: [
        testExtractionKind(
          slug: 'decision',
          displayName: 'Decision',
          enabledForExtraction: false,
          isBuiltIn: true,
          sortOrder: 0,
        ),
        testExtractionKind(
          slug: 'commitment',
          displayName: 'Commitment',
          behavior: ExtractionKindBehavior.completable,
          datePolicy: ExtractionKindFieldPolicy.optional,
          enabledForExtraction: true,
          isBuiltIn: true,
          sortOrder: 1,
        ),
        testExtractionKind(
          slug: 'grocery',
          displayName: 'Grocery',
          enabledForExtraction: true,
          sortOrder: 2,
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilterChip, 'Commitment'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Grocery'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Decision'), findsNothing);
  });

  testWidgets('filter chips and kind segments meet the 48dp tap target', (
    tester,
  ) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([_item('a', 'Send the checklist.')]),
    );
    await tester.pumpAndSettle();

    final openChip = tester.getSize(find.widgetWithText(FilterChip, 'Open'));
    expect(openChip.height, greaterThanOrEqualTo(48));
    expect(openChip.width, greaterThanOrEqualTo(48));

    final kindFilter = tester.getSize(
      find.widgetWithText(FilterChip, 'Decision'),
    );
    expect(kindFilter.height, greaterThanOrEqualTo(48));
  });

  testWidgets('clears search, restores the list, and returns focus', (
    tester,
  ) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item('a', 'Send the checklist.'),
        _item('b', 'Book the venue.'),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'venue');
    await tester.pumpAndSettle();
    expect(find.text('Send the checklist.'), findsNothing);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();

    expect(find.text('Send the checklist.'), findsOneWidget);
    expect(find.text('Book the venue.'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      isEmpty,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).focusNode?.hasFocus,
      isTrue,
    );
  });

  testWidgets('enters selection mode from the Select button', (tester) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item('a', 'Send the checklist.'),
        _item(
          'd1',
          'We chose option B.',
          kind: LedgerItemKind.decision,
          owner: null,
        ),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();

    expect(find.text('Select items'), findsOneWidget); // subtitle at 0 selected
    expect(find.text('Done'), findsOneWidget);
    expect(find.byTooltip('Delete selected'), findsOneWidget);
    // Both items show selection checkboxes (decision included).
    expect(find.byType(Checkbox), findsNWidgets(2));
    // Swipe/dismiss affordance is disabled in selection mode.
    expect(find.byType(Dismissible), findsNothing);
  });

  testWidgets('toggles selection and bulk-deletes after confirm', (
    tester,
  ) async {
    final repo = _FakeLedgerRepository(
      Stream.value([
        _item('a', 'Send the checklist.'),
        _item('b', 'Book the venue.'),
      ]),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...extractionKindCatalogOverrides(),
          ledgerRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: LedgerPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send the checklist.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book the venue.'));
    await tester.pumpAndSettle();

    expect(find.text('2 selected'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();

    expect(find.text('Remove 2 ledger items?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(repo.deleted, ['a', 'b']);
    expect(find.text('Send the checklist.'), findsNothing);
    expect(find.text('Book the venue.'), findsNothing);
    expect(find.byTooltip('Select items'), findsOneWidget); // exited selection
  });

  testWidgets('Done exits selection mode without deleting', (tester) async {
    final repo = _FakeLedgerRepository(
      Stream.value([_item('a', 'Send the checklist.')]),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...extractionKindCatalogOverrides(),
          ledgerRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: LedgerPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send the checklist.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(repo.deleted, isEmpty);
    expect(find.byTooltip('Select items'), findsOneWidget);
    expect(find.byTooltip('Delete selected'), findsNothing);
    expect(find.byType(Dismissible), findsOneWidget);
  });

  testWidgets('Select all toggles every visible item', (tester) async {
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item('a', 'Send the checklist.'),
        _item('b', 'Book the venue.'),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select all'));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear selection'));
    await tester.pumpAndSettle();
    expect(find.text('Select items'), findsOneWidget);
    expect(find.byTooltip('Select all'), findsOneWidget);
  });

  testWidgets('partial bulk delete keeps remaining selection', (tester) async {
    final repo = _FakeLedgerRepository(
      Stream.value([
        _item('a', 'Send the checklist.'),
        _item('b', 'Book the venue.'),
      ]),
    )..throwOnDeleteId = 'b';
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...extractionKindCatalogOverrides(),
          ledgerRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: LedgerPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Select all'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(repo.deleted, ['a']);
    expect(find.text('Send the checklist.'), findsNothing);
    expect(find.text('Book the venue.'), findsOneWidget);
    expect(find.text('1 selected'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(
      find.text('Could not delete the selected ledger items. Try again.'),
      findsOneWidget,
    );
  });

  testWidgets('completable custom kinds show a checkbox; record kinds do not', (
    tester,
  ) async {
    final catalog = [
      ...builtInExtractionKinds(),
      testExtractionKind(
        slug: 'groceries',
        displayName: 'Groceries',
        behavior: ExtractionKindBehavior.completable,
        datePolicy: ExtractionKindFieldPolicy.optional,
        ownerPolicy: ExtractionKindFieldPolicy.none,
        sortOrder: 2,
      ),
      testExtractionKind(
        slug: 'insight',
        displayName: 'Insight',
        behavior: ExtractionKindBehavior.record,
        sortOrder: 3,
      ),
    ];
    await _pumpLedgerPage(
      tester,
      Stream.value([
        _item('g1', 'Buy milk.', kind: 'groceries', owner: null),
        _item('i1', 'Keep the weekly review.', kind: 'insight', owner: null),
      ]),
      catalog: catalog,
    );
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsWidgets);
    expect(find.text('Insight'), findsWidgets);
    expect(find.text('Buy milk.'), findsOneWidget);
    expect(find.text('Keep the weekly review.'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
  });
}
