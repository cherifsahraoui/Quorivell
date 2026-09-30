import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/misc.dart' show Override;

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/extraction_kinds/data/providers/extraction_item_kind_providers.dart';
import 'package:quorivell/features/extraction_kinds/domain/entities/extraction_item_kind.dart';
import 'package:quorivell/features/extraction_kinds/domain/repositories/extraction_item_kind_repository.dart';
import 'package:quorivell/features/extraction_kinds/presentation/pages/extraction_kind_edit_page.dart';
import 'package:quorivell/features/extraction_kinds/presentation/pages/extraction_kinds_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

import '../../../helpers/extraction_kind_catalog.dart';
import '../../../helpers/layout_overflow.dart';

class _FakeKindsRepository implements ExtractionItemKindRepository {
  _FakeKindsRepository(this.items, {this.enableError});

  List<ExtractionItemKind> items;
  final Object? enableError;
  final enabledCalls = <({String id, bool enabled})>[];
  final archivedIds = <String>[];

  @override
  Stream<List<ExtractionItemKind>> watchAll({
    int limit = 100,
    int offset = 0,
  }) => Stream.value(items);

  @override
  Stream<List<ExtractionItemKind>> watchEnabled({
    int limit = 100,
    int offset = 0,
  }) => Stream.value([
    for (final kind in items)
      if (kind.enabledForExtraction) kind,
  ]);

  @override
  Future<List<ExtractionItemKind>> listAll() async => items;

  @override
  Future<List<ExtractionItemKind>> listEnabled() async => [
    for (final kind in items)
      if (kind.enabledForExtraction) kind,
  ];

  @override
  Future<ExtractionItemKind> create({
    required String displayName,
    String? extractionHint,
    required ExtractionKindBehavior behavior,
    required ExtractionKindFieldPolicy datePolicy,
    required ExtractionKindFieldPolicy notePolicy,
    required ExtractionKindFieldPolicy ownerPolicy,
    required bool enabledForExtraction,
    List<ExtractionTeachingExample> teachingExamples = const [],
    String? slug,
  }) async => throw UnimplementedError();

  @override
  Future<ExtractionItemKind> update(ExtractionItemKind kind) async => kind;

  @override
  Future<void> setEnabled({required String id, required bool enabled}) async {
    enabledCalls.add((id: id, enabled: enabled));
    if (enableError != null) throw enableError!;
  }

  @override
  Future<void> archive(String id) async {
    archivedIds.add(id);
  }

  @override
  Future<void> resetBuiltIns() async {}
}

Future<void> _pumpKindsPage(
  WidgetTester tester, {
  required List<Override> overrides,
  String location = '/review/kinds',
}) {
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(
        path: '/review/kinds',
        builder: (context, state) => const ExtractionKindsPage(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const ExtractionKindEditPage(),
          ),
        ],
      ),
    ],
  );

  return tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
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
  testWidgets('shows a loading state before kinds emit', (tester) async {
    final pending = StreamController<List<ExtractionItemKind>>();
    addTearDown(pending.close);
    await _pumpKindsPage(
      tester,
      overrides: [
        extractionItemKindsProvider.overrideWith((ref) => pending.stream),
      ],
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an empty state when the catalog has no rows', (
    tester,
  ) async {
    await _pumpKindsPage(
      tester,
      overrides: extractionKindCatalogOverrides(const []),
    );
    await tester.pumpAndSettle();

    expect(find.text('No kinds yet'), findsOneWidget);
    expect(find.text('Add kind'), findsWidgets);
  });

  testWidgets('shows a localized error when the catalog cannot be read', (
    tester,
  ) async {
    await _pumpKindsPage(
      tester,
      overrides: [
        extractionItemKindsProvider.overrideWith(
          (ref) => Stream<List<ExtractionItemKind>>.error(
            const LocalPersistenceFailure.readFailed(),
          ),
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(
      find.text('This device could not save or read your local records.'),
      findsOneWidget,
    );
  });

  testWidgets('lists built-in kinds and opens the info sheet', (tester) async {
    await _pumpKindsPage(tester, overrides: extractionKindCatalogOverrides());
    await tester.pumpAndSettle();

    expect(find.text('Decision'), findsOneWidget);
    expect(find.text('Commitment'), findsOneWidget);
    expect(find.text('Built-in example'), findsWidgets);

    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
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
  });

  testWidgets('cannot disable the last enabled kind', (tester) async {
    final onlyDecision = [
      testExtractionKind(
        slug: 'decision',
        displayName: 'Decision',
        isBuiltIn: true,
      ),
    ];
    final repo = _FakeKindsRepository(
      onlyDecision,
      enableError: const LocalPersistenceFailure.invalidInput(),
    );
    await _pumpKindsPage(
      tester,
      overrides: [
        ...extractionKindCatalogOverrides(onlyDecision),
        extractionItemKindRepositoryProvider.overrideWithValue(repo),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(
      find.text('Keep at least one kind enabled for the next extract.'),
      findsOneWidget,
    );
  });

  testWidgets('lists enabled kinds before disabled ones', (tester) async {
    final mixed = [
      testExtractionKind(
        slug: 'names',
        displayName: 'Names',
        enabledForExtraction: false,
        sortOrder: 0,
      ),
      testExtractionKind(
        slug: 'decision',
        displayName: 'Decision',
        isBuiltIn: true,
        enabledForExtraction: true,
        sortOrder: 2,
      ),
      testExtractionKind(
        slug: 'commitment',
        displayName: 'Commitment',
        isBuiltIn: true,
        enabledForExtraction: true,
        sortOrder: 3,
      ),
    ];
    await _pumpKindsPage(
      tester,
      overrides: extractionKindCatalogOverrides(mixed),
    );
    await tester.pumpAndSettle();

    final decisionY = tester.getTopLeft(find.text('Decision')).dy;
    final namesY = tester.getTopLeft(find.text('Names')).dy;
    expect(decisionY, lessThan(namesY));
  });

  testWidgets('long-press deletes a custom kind after confirm', (tester) async {
    final custom = testExtractionKind(
      slug: 'groceries',
      displayName: 'Groceries',
      isBuiltIn: false,
    );
    final catalog = [...builtInExtractionKinds(), custom];
    final repo = _FakeKindsRepository(catalog);
    await _pumpKindsPage(
      tester,
      overrides: [
        ...extractionKindCatalogOverrides(catalog),
        extractionItemKindRepositoryProvider.overrideWithValue(repo),
      ],
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Groceries'));
    await tester.pumpAndSettle();

    expect(find.text('Remove this kind?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();

    expect(repo.archivedIds, ['groceries']);
    expect(find.text('Groceries'), findsNothing);
  });

  testWidgets('swiping left deletes a custom kind after confirm', (
    tester,
  ) async {
    final custom = testExtractionKind(
      slug: 'groceries',
      displayName: 'Groceries',
      isBuiltIn: false,
    );
    final catalog = [...builtInExtractionKinds(), custom];
    final repo = _FakeKindsRepository(catalog);
    await _pumpKindsPage(
      tester,
      overrides: [
        ...extractionKindCatalogOverrides(catalog),
        extractionItemKindRepositoryProvider.overrideWithValue(repo),
      ],
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Remove this kind?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();

    expect(repo.archivedIds, ['groceries']);
    expect(find.text('Groceries'), findsNothing);
  });

  testWidgets('select mode bulk-removes custom kinds only', (tester) async {
    final custom = testExtractionKind(
      slug: 'groceries',
      displayName: 'Groceries',
      isBuiltIn: false,
    );
    final catalog = [...builtInExtractionKinds(), custom];
    final repo = _FakeKindsRepository(catalog);
    await _pumpKindsPage(
      tester,
      overrides: [
        ...extractionKindCatalogOverrides(catalog),
        extractionItemKindRepositoryProvider.overrideWithValue(repo),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsOneWidget);
    // Built-ins + custom each show a checkbox; only custom is enabled.
    expect(find.byType(Checkbox), findsNWidgets(catalog.length));
    expect(find.byType(Dismissible), findsNothing);

    await tester.tap(find.byTooltip('Select all'));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsAtLeastNWidgets(1));

    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();
    expect(find.text('Remove this kind?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();

    expect(repo.archivedIds, ['groceries']);
    expect(find.text('Groceries'), findsNothing);
  });

  testWidgets('long-press on a built-in kind does not open delete', (
    tester,
  ) async {
    await _pumpKindsPage(tester, overrides: extractionKindCatalogOverrides());
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Decision'));
    await tester.pumpAndSettle();

    expect(find.text('Remove this kind?'), findsNothing);
    expect(find.byType(Dismissible), findsNothing);
  });

  testWidgets('new kind page fills Groceries from the template', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpKindsPage(
      tester,
      location: '/review/kinds/new',
      overrides: extractionKindCatalogOverrides(),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start from a template'), findsOneWidget);
    await tester.tap(find.text('Groceries'));
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsWidgets);
    expect(find.textContaining('short names'), findsOneWidget);
    expect(find.text('Teaching examples'), findsOneWidget);
    expect(find.text('Example of the two fields'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Ledger title'), findsWidgets);
    expect(find.text('Evidence quote'), findsWidgets);
    expect(find.text('Conversation line'), findsNothing);
    // Groceries starter fills the max of three samples — no room to add more.
    expect(find.text('Insert sample example'), findsNothing);
    expect(find.text('Add example'), findsNothing);
  });

  testWidgets('back with typed text asks to discard or save', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpKindsPage(
      tester,
      location: '/review/kinds/new',
      overrides: extractionKindCatalogOverrides(),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Groceries list');
    await tester.pump();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Unsaved changes'), findsOneWidget);
    expect(
      find.text('Leave without saving? Your edits will be lost.'),
      findsOneWidget,
    );
    expect(find.text('Discard'), findsOneWidget);
    expect(find.text('Save'), findsWidgets);
    expect(find.text('Keep editing'), findsOneWidget);

    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();

    expect(find.text('Unsaved changes'), findsNothing);
    expect(find.text('New kind'), findsOneWidget);
    expect(find.text('Groceries list'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(find.text('New kind'), findsNothing);
  });

  testWidgets('empty new kind leaves without a warning', (tester) async {
    await _pumpKindsPage(
      tester,
      location: '/review/kinds/new',
      overrides: extractionKindCatalogOverrides(),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Unsaved changes'), findsNothing);
    expect(find.text('New kind'), findsNothing);
  });
}
