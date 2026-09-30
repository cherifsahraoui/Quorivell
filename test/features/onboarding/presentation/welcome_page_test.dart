import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/ai/local_model_providers.dart';
import 'package:quorivell/core/ai/local_model_store.dart';
import 'package:quorivell/core/platform/background_work_constraint_service.dart';
import 'package:quorivell/features/assistant/presentation/controllers/review_controller.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _StubStore extends LocalModelStore {
  _StubStore({required bool ready})
    : _ready = ready,
      super(resolveDocumentsDirectory: () async => Directory.systemTemp);

  final bool _ready;

  @override
  Future<bool> isReady({bool hashIfNeeded = true}) async => _ready;

  @override
  Future<bool> hasModelFile() async => false;
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

class _FixedInstallController extends LocalModelInstallController {
  _FixedInstallController({required bool ready}) : _ready = ready;

  final bool _ready;

  @override
  Future<LocalModelInstallSnapshot> build() async {
    return LocalModelInstallSnapshot(isReady: _ready);
  }
}

void main() {
  Future<void> pumpWelcome(
    WidgetTester tester, {
    VoidCallback? onComplete,
    VoidCallback? onTourSeen,
    bool modelReady = false,
    int pendingReviewCount = 0,
    BackgroundWorkConstraintService? backgroundWork,
  }) {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(
          path: '/welcome',
          builder: (context, state) => WelcomePage(
            onComplete: onComplete ?? () {},
            onTourSeen: onTourSeen,
          ),
        ),
        GoRoute(
          path: '/model-setup',
          builder: (context, state) =>
              const Scaffold(body: Text('model-setup')),
        ),
        GoRoute(
          path: '/ledger',
          builder: (context, state) => const Scaffold(body: Text('ledger')),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => const Scaffold(body: Text('review')),
        ),
      ],
    );

    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          localModelStoreProvider.overrideWithValue(
            _StubStore(ready: modelReady),
          ),
          localModelInstallControllerProvider.overrideWith(
            () => _FixedInstallController(ready: modelReady),
          ),
          pendingReviewCountProvider.overrideWithValue(pendingReviewCount),
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

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('welcome and tour pages fit landscape without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpWelcome(tester);
    await settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Welcome to Quorivell.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Capture Effortlessly.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Choose what to extract.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Chat with Local AI.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Privacy First. Locally.'), findsOneWidget);
  });

  testWidgets('7-inch tablet welcome uses split layout without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(600, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpWelcome(tester);
    await settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Welcome to Quorivell.'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Capture Effortlessly.'), findsOneWidget);
  });

  testWidgets('10-inch tablet welcome uses split layout without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1280);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpWelcome(tester);
    await settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Welcome to Quorivell.'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Capture Effortlessly.'), findsOneWidget);
  });

  testWidgets('shows the welcome brand page', (tester) async {
    await pumpWelcome(tester);
    await settle(tester);

    expect(find.text('Welcome to Quorivell.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('You know the app already?'), findsOneWidget);
    expect(find.text('Skip onboarding'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
    expect(find.text('Next'), findsNothing);
  });

  testWidgets('moves through capture, extract, chat, and privacy pages', (
    tester,
  ) async {
    await pumpWelcome(tester);
    await settle(tester);

    await tester.tap(find.text('Get Started'));
    await settle(tester);
    expect(find.text('Capture Effortlessly.'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text('Choose what to extract.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text('Chat with Local AI.'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text('Privacy First. Locally.'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Install the on-device model.'), findsNothing);
  });

  testWidgets('finishing the tour without a model opens model setup', (
    tester,
  ) async {
    var completed = false;
    var tourSeen = false;
    await pumpWelcome(
      tester,
      onComplete: () => completed = true,
      onTourSeen: () => tourSeen = true,
    );
    await settle(tester);

    await tester.tap(find.text('Get Started'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    expect(completed, isTrue);
    expect(tourSeen, isTrue);
    expect(find.text('model-setup'), findsOneWidget);
  });

  testWidgets('finishing the tour with a ready model opens ledger', (
    tester,
  ) async {
    var completed = false;
    await pumpWelcome(
      tester,
      onComplete: () => completed = true,
      modelReady: true,
    );
    await settle(tester);

    await tester.tap(find.text('Get Started'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    expect(completed, isTrue);
    expect(find.text('ledger'), findsOneWidget);
  });

  testWidgets('finishing the tour with pending reviews opens review', (
    tester,
  ) async {
    var completed = false;
    await pumpWelcome(
      tester,
      onComplete: () => completed = true,
      modelReady: true,
      pendingReviewCount: 1,
    );
    await settle(tester);

    await tester.tap(find.text('Get Started'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    expect(completed, isTrue);
    expect(find.text('review'), findsOneWidget);
  });

  testWidgets(
    'finishing the tour reminds about Restricted before model setup',
    (tester) async {
      var completed = false;
      await pumpWelcome(
        tester,
        onComplete: () => completed = true,
        backgroundWork: _FakeBackgroundWorkConstraintService(
          isBackgroundRestricted: true,
        ),
      );
      await settle(tester);

      await tester.tap(find.text('Get Started'));
      await settle(tester);
      await tester.tap(find.text('Next'));
      await settle(tester);
      await tester.tap(find.text('Next'));
      await settle(tester);
      await tester.tap(find.text('Next'));
      await settle(tester);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(find.text('Privacy First. Locally.'), findsOneWidget);
      expect(completed, isFalse);
      expect(find.text('model-setup'), findsNothing);
      expect(
        find.text(l10n.backgroundRestrictionReminderTitle),
        findsOneWidget,
      );
      expect(
        find.text(l10n.backgroundRestrictionReminderModelInstallBody),
        findsOneWidget,
      );

      await tester.tap(find.text(l10n.backgroundWorkReminderContinue));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('model-setup'), findsOneWidget);
      expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
    },
  );

  testWidgets('sign in locally opens model setup when the model is missing', (
    tester,
  ) async {
    var completed = false;
    var tourSeen = false;
    await pumpWelcome(
      tester,
      onComplete: () => completed = true,
      onTourSeen: () => tourSeen = true,
    );
    await settle(tester);

    await tester.tap(find.text('Skip onboarding'));
    await settle(tester);

    expect(completed, isTrue);
    expect(tourSeen, isTrue);
    expect(find.text('model-setup'), findsOneWidget);
  });

  testWidgets('tour is reported seen only after finishing onboarding', (
    tester,
  ) async {
    var tourSeen = false;
    await pumpWelcome(tester, onTourSeen: () => tourSeen = true);
    await settle(tester);

    await tester.tap(find.text('Get Started'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);

    expect(find.text('Privacy First. Locally.'), findsOneWidget);
    expect(tourSeen, isFalse);

    await tester.tap(find.text('Continue'));
    await settle(tester);

    expect(tourSeen, isTrue);
  });
}
