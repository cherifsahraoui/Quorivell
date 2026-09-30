import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/extraction_kinds/domain/entities/extraction_item_kind.dart';
import 'package:quorivell/features/ledger/data/providers/ledger_providers.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';
import 'package:quorivell/features/ledger/domain/repositories/ledger_repository.dart';
import 'package:quorivell/features/ledger/presentation/pages/ledger_create_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';
import '../../../helpers/extraction_kind_catalog.dart';

class _FakeLedgerRepository implements LedgerRepository {
  final created = <LedgerItem>[];
  Object? createError;

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
  }) async {
    if (createError != null) {
      throw createError!;
    }
    final item = LedgerItem(
      id: 'manual-1',
      userId: 'user-1',
      kind: kind,
      statement: statement,
      status: LedgerItemStatus.open,
      owner: owner,
      dueDate: dueDate,
      createdAt: DateTime.utc(2026, 9, 7),
      updatedAt: DateTime.utc(2026, 9, 7),
    );
    created.add(item);
    return item;
  }

  @override
  Future<void> updateStatus({
    required String id,
    required LedgerItemStatus status,
  }) async {}

  @override
  Future<void> delete(String id) async {}
}

Future<void> _pumpCreatePage(
  WidgetTester tester, {
  required LedgerRepository repository,
  String initialKind = LedgerItemKind.commitment,
}) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/ledger/new',
    routes: [
      GoRoute(
        path: '/ledger',
        builder: (context, state) => const Scaffold(body: Text('ledger-home')),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) =>
                LedgerCreatePage(initialKind: initialKind),
          ),
        ],
      ),
    ],
  );

  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...extractionKindCatalogOverrides(),
        ledgerRepositoryProvider.overrideWithValue(repository),
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

Finder _addButton() => find.byIcon(Icons.add);

void main() {
  testWidgets('keeps save disabled until a statement is entered', (
    tester,
  ) async {
    await _pumpCreatePage(tester, repository: _FakeLedgerRepository());
    await tester.pumpAndSettle();

    await tester.ensureVisible(_addButton());
    final disabled = tester.widget<FilledButton>(
      find.ancestor(of: _addButton(), matching: find.byType(FilledButton)),
    );
    expect(disabled.onPressed, isNull);

    await tester.enterText(find.byType(TextField).first, 'Send the checklist.');
    await tester.pump();

    await tester.ensureVisible(_addButton());
    final enabled = tester.widget<FilledButton>(
      find.ancestor(of: _addButton(), matching: find.byType(FilledButton)),
    );
    expect(enabled.onPressed, isNotNull);
    expect(find.text('Set due date (optional)'), findsOneWidget);
  });

  testWidgets('hides due date for a decision', (tester) async {
    await _pumpCreatePage(
      tester,
      repository: _FakeLedgerRepository(),
      initialKind: LedgerItemKind.decision,
    );
    await tester.pumpAndSettle();

    expect(find.text('Set due date (optional)'), findsNothing);
  });

  testWidgets('item type dropdown shows only enabled kinds', (tester) async {
    final repository = _FakeLedgerRepository();
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/ledger/new',
      routes: [
        GoRoute(
          path: '/ledger',
          builder: (context, state) =>
              const Scaffold(body: Text('ledger-home')),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) =>
                  const LedgerCreatePage(initialKind: LedgerItemKind.decision),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...extractionKindCatalogOverrides([
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
          ]),
          ledgerRepositoryProvider.overrideWithValue(repository),
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
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    expect(find.text('Commitment').hitTestable(), findsWidgets);
    expect(find.text('Grocery').hitTestable(), findsWidgets);
    expect(find.text('Decision').hitTestable(), findsNothing);
  });

  testWidgets('saves a commitment and returns to the ledger', (tester) async {
    final repository = _FakeLedgerRepository();
    await _pumpCreatePage(tester, repository: repository);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Send the checklist.');
    await tester.enterText(find.byType(TextField).at(1), 'Alex');
    await tester.pump();
    await tester.ensureVisible(_addButton());
    await tester.tap(_addButton());
    await tester.pumpAndSettle();

    expect(find.text('ledger-home'), findsOneWidget);
    expect(repository.created, hasLength(1));
    expect(repository.created.single.kind, LedgerItemKind.commitment);
    expect(repository.created.single.statement, 'Send the checklist.');
    expect(repository.created.single.owner, 'Alex');
  });

  testWidgets('shows a localized error when create fails', (tester) async {
    final repository = _FakeLedgerRepository()
      ..createError = const LocalPersistenceFailure.writeFailed();
    await _pumpCreatePage(tester, repository: repository);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Send the checklist.');
    await tester.pump();
    await tester.ensureVisible(_addButton());
    await tester.tap(_addButton());
    await tester.pumpAndSettle();

    expect(
      find.text('Could not add the ledger item. Try again.'),
      findsOneWidget,
    );
    expect(find.text('Add to ledger'), findsOneWidget);
  });

  testWidgets('back with typed text asks to discard or save', (tester) async {
    final repository = _FakeLedgerRepository();
    await _pumpCreatePage(tester, repository: repository);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Send the checklist.');
    await tester.pump();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Unsaved changes'), findsOneWidget);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(find.text('ledger-home'), findsOneWidget);
    expect(repository.created, isEmpty);
  });
}
