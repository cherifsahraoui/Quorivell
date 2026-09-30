import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/ai/local_model_providers.dart';
import 'package:quorivell/core/ai/local_model_store.dart';
import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/database/database_providers.dart';
import 'package:quorivell/core/routing/app_router.dart';
import 'package:quorivell/features/assistant/presentation/controllers/review_controller.dart';
import 'package:quorivell/features/onboarding/presentation/pages/boot_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _StubStore extends LocalModelStore {
  _StubStore({required bool ready, this.delay = Duration.zero})
    : _ready = ready,
      super(resolveDocumentsDirectory: () async => Directory.systemTemp);

  final bool _ready;
  final Duration delay;

  @override
  Future<bool> isReady({bool hashIfNeeded = true}) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return _ready;
  }

  @override
  Future<bool> hasModelFile() async => false;
}

/// Verifies an on-disk GGUF before marking ready — mirrors returning-user boot.
class _VerifyingStore extends LocalModelStore {
  _VerifyingStore()
    : super(resolveDocumentsDirectory: () async => Directory.systemTemp);

  @override
  Future<bool> isReady({bool hashIfNeeded = true}) async {
    if (!hashIfNeeded) {
      return false;
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<bool> hasModelFile() async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;

  setUpAll(() {
    // One shared executor for the file: appRouter listens to
    // ExtractionResumeController → appDatabase. Per-test AppDatabase.open()
    // reuses the on-disk file and trips Drift's multiple-database warning.
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDownAll(() => database.close());

  /// Must run in the test body (not only [addTearDown]): flutter_test unmounts
  /// the tree and asserts `!timersPending` before package:test tearDowns run.
  /// Drift schedules [Timer.run] when query streams cancel.
  Future<void> disposeScope(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }

  Future<void> pumpUntilOffBoot(WidgetTester tester) async {
    // Boot uses a repeating AnimationController — avoid pumpAndSettle.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.byKey(BootPage.pageKey).evaluate().isEmpty) {
        await tester.pump();
        return;
      }
    }
    fail('Timed out waiting to leave the boot screen');
  }

  Future<void> pumpApp(
    WidgetTester tester, {
    required bool tourSeen,
    required bool modelReady,
    bool modelSetupCompleted = false,
    int pendingReviewCount = 0,
    LocalModelStore? store,
    Duration? settleDelay,
  }) async {
    SharedPreferences.setMockInitialValues({
      if (tourSeen) 'has_seen_welcome': true,
      if (modelSetupCompleted) 'has_completed_model_setup': true,
    });

    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localModelStoreProvider.overrideWithValue(
            store ?? _StubStore(ready: modelReady),
          ),
          pendingReviewCountProvider.overrideWithValue(pendingReviewCount),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pump();
    if (settleDelay != null) {
      await tester.pump(settleDelay);
    }
    await pumpUntilOffBoot(tester);
  }

  testWidgets('first launch shows the welcome tour', (tester) async {
    await pumpApp(tester, tourSeen: false, modelReady: false);

    expect(find.text('Welcome to Quorivell.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Install the on-device model.'), findsNothing);
    expect(find.byKey(BootPage.pageKey), findsNothing);
    await disposeScope(tester);
  });

  testWidgets(
    'returning user with incomplete model only sees the download page',
    (tester) async {
      await pumpApp(tester, tourSeen: true, modelReady: false);

      expect(find.text('Welcome to Quorivell.'), findsNothing);
      expect(find.text('Get Started'), findsNothing);
      expect(find.text('Capture Effortlessly.'), findsNothing);
      expect(find.text('Install the on-device model.'), findsOneWidget);
      expect(find.text('Configure later'), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
      expect(find.byType(PageView), findsNothing);
      expect(find.byKey(BootPage.pageKey), findsNothing);
      await disposeScope(tester);
    },
  );

  testWidgets('returning user with ready model opens ledger', (tester) async {
    await pumpApp(tester, tourSeen: true, modelReady: true);

    final router = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    ).read(appRouterProvider);

    expect(router.state.matchedLocation, '/ledger');
    expect(find.text('Welcome to Quorivell.'), findsNothing);
    expect(find.text('Install the on-device model.'), findsNothing);
    // Nav Ledger control is icon-only (semantics label); page header also uses
    // navLedger once Drift streams resolve.
    expect(find.bySemanticsLabel('Ledger'), findsAtLeastNWidgets(1));
    expect(find.text('Capture'), findsOneWidget);
    expect(find.byKey(BootPage.pageKey), findsNothing);
    await disposeScope(tester);
  });

  testWidgets(
    'returning user with pending reviews opens review instead of ledger',
    (tester) async {
      await pumpApp(
        tester,
        tourSeen: true,
        modelReady: true,
        pendingReviewCount: 2,
      );

      final router = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      ).read(appRouterProvider);

      expect(router.state.matchedLocation, '/review');
      expect(find.byKey(BootPage.pageKey), findsNothing);
      expect(find.text('Install the on-device model.'), findsNothing);
      await disposeScope(tester);
    },
  );

  testWidgets('returning user who deferred model setup can open the app', (
    tester,
  ) async {
    await pumpApp(
      tester,
      tourSeen: true,
      modelReady: false,
      modelSetupCompleted: true,
    );

    final router = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    ).read(appRouterProvider);

    expect(find.text('Install the on-device model.'), findsNothing);
    expect(router.state.matchedLocation, '/ledger');
    expect(find.bySemanticsLabel('Ledger'), findsAtLeastNWidgets(1));
    await disposeScope(tester);
  });

  testWidgets('boot screen covers slow model readiness checks', (tester) async {
    SharedPreferences.setMockInitialValues({'has_seen_welcome': true});
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localModelStoreProvider.overrideWithValue(
            _StubStore(ready: true, delay: const Duration(milliseconds: 250)),
          ),
          pendingReviewCountProvider.overrideWithValue(0),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.byKey(BootPage.pageKey), findsOneWidget);
    expect(find.text('Install the on-device model.'), findsNothing);
    expect(find.bySemanticsLabel('Ledger'), findsNothing);

    await tester.pump(const Duration(milliseconds: 300));
    await pumpUntilOffBoot(tester);

    final router = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    ).read(appRouterProvider);

    expect(find.byKey(BootPage.pageKey), findsNothing);
    expect(router.state.matchedLocation, '/ledger');
    expect(find.bySemanticsLabel('Ledger'), findsAtLeastNWidgets(1));
    expect(find.text('Install the on-device model.'), findsNothing);
    await disposeScope(tester);
  });

  testWidgets(
    'boot screen covers model hash verification without flashing setup',
    (tester) async {
      SharedPreferences.setMockInitialValues({'has_seen_welcome': true});
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            localModelStoreProvider.overrideWithValue(_VerifyingStore()),
            pendingReviewCountProvider.overrideWithValue(0),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final router = ref.watch(appRouterProvider);
              return MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          ),
        ),
      );

      await tester.pump();
      // Prefs resolve first; model file is present so install enters verifying.
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byKey(BootPage.pageKey), findsOneWidget);
      expect(find.text('Install the on-device model.'), findsNothing);

      await tester.pump(const Duration(milliseconds: 250));
      await pumpUntilOffBoot(tester);

      final router = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      ).read(appRouterProvider);

      expect(find.byKey(BootPage.pageKey), findsNothing);
      expect(router.state.matchedLocation, '/ledger');
      expect(find.bySemanticsLabel('Ledger'), findsAtLeastNWidgets(1));
      expect(find.text('Install the on-device model.'), findsNothing);
      await disposeScope(tester);
    },
  );
}
