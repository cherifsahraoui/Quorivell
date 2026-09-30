import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/ai/local_model_providers.dart';
import 'package:quorivell/core/ai/local_model_spec.dart';
import 'package:quorivell/core/ai/local_model_store.dart';
import 'package:quorivell/core/platform/background_work_constraint_service.dart';
import 'package:quorivell/features/assistant/presentation/controllers/review_controller.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/features/onboarding/presentation/pages/model_download_page.dart';
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

class _ScriptedInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: false);
  }

  void finishImport() {
    state = const AsyncData(
      LocalModelInstallSnapshot(isReady: false, isImporting: true, progress: 1),
    );
    state = const AsyncData(LocalModelInstallSnapshot(isReady: true));
  }
}

class _ImportingInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(
      isReady: false,
      isImporting: true,
      progress: 0.4,
    );
  }
}

class _PickingInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: false, isPicking: true);
  }
}

class _VerifyingInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: false, isVerifying: true);
  }

  void finishVerify() {
    state = const AsyncData(LocalModelInstallSnapshot(isReady: true));
  }
}

class _FinalizingInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(
      isReady: false,
      isFinalizing: true,
      progress: 1,
    );
  }
}

class _FailedDownloadInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(
      isReady: false,
      error: LocalModelDownloadException(),
    );
  }
}

class _RecordingDownloadController extends LocalModelInstallController {
  var downloads = 0;

  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: false);
  }

  @override
  Future<void> download({
    LocalModelSpec? spec,
    String progressTitle = '',
    String progressBody = '',
    String Function(LocalModelInstallSnapshot snapshot)? progressBodyFor,
    String completionTitle = '',
    String completionBody = '',
  }) async {
    downloads += 1;
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

void main() {
  Future<void> pumpModelDownload(
    WidgetTester tester, {
    bool modelReady = false,
    int pendingReviewCount = 0,
    LocalModelInstallController? installController,
    BackgroundWorkConstraintService? backgroundWork,
    Size viewSize = const Size(400, 1200),
  }) {
    tester.view.physicalSize = viewSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/model-setup',
      routes: [
        GoRoute(
          path: '/model-setup',
          builder: (context, state) => const ModelDownloadPage(),
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
          pendingReviewCountProvider.overrideWithValue(pendingReviewCount),
          if (installController != null)
            localModelInstallControllerProvider.overrideWith(
              () => installController,
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

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets(
    'shows title, body, and download actions without an illustration',
    (tester) async {
      await pumpModelDownload(tester);
      await settle(tester);

      expect(find.text('Install the on-device model.'), findsOneWidget);
      expect(find.textContaining('Qwen 1.5B is recommended'), findsOneWidget);
      expect(find.text('Recommended models'), findsOneWidget);
      expect(find.text('Qwen2.5-1.5B-Instruct-Q4_K_M'), findsOneWidget);
      expect(find.text('Dolphin3.0-Qwen2.5-1.5B-Q4_K_M'), findsOneWidget);
      expect(find.textContaining('Apache-2.0'), findsWidgets);
      expect(find.byTooltip('Open model page'), findsWidgets);
      expect(find.text('Download on-device model'), findsWidgets);
      expect(find.text('Select model file'), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
      expect(find.text('Configure later'), findsOneWidget);
      expect(find.text('Welcome to Quorivell.'), findsNothing);
      expect(find.text('Get Started'), findsNothing);
      expect(find.text('Next'), findsNothing);
      expect(find.byType(PageView), findsNothing);
      expect(find.byType(Image), findsNothing);
    },
  );

  testWidgets('shows finalizing copy instead of a stuck 100% download', (
    tester,
  ) async {
    await pumpModelDownload(
      tester,
      installController: _FinalizingInstallController(),
    );
    await settle(tester);

    expect(find.text('Finalizing the model…'), findsOneWidget);
    expect(find.text('Stop download'), findsNothing);
    expect(find.text('Resume download'), findsNothing);
    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, isNull);
  });

  testWidgets('shows a download error above model selection', (tester) async {
    await pumpModelDownload(
      tester,
      installController: _FailedDownloadInstallController(),
      viewSize: const Size(400, 700),
    );
    await settle(tester);

    const errorCopy =
        'The model could not be downloaded. Check your connection and try again.';
    expect(find.text(errorCopy), findsOneWidget);
    expect(find.text('Recommended models'), findsOneWidget);

    final errorBottom = tester.getBottomLeft(find.text(errorCopy)).dy;
    final catalogTop = tester.getTopLeft(find.text('Recommended models')).dy;
    expect(errorBottom, lessThan(catalogTop));
    expect(find.text(errorCopy).hitTestable(), findsOneWidget);
  });

  testWidgets('hides continue until the model is ready', (tester) async {
    await pumpModelDownload(tester);
    await settle(tester);

    expect(find.text('Continue'), findsNothing);
    expect(find.text('Configure later'), findsOneWidget);
  });

  testWidgets('hides continue while importing a model', (tester) async {
    await pumpModelDownload(
      tester,
      installController: _ImportingInstallController(),
    );
    await settle(tester);

    expect(find.text('Continue'), findsNothing);
    expect(find.text('Configure later'), findsOneWidget);
  });

  testWidgets('continue opens ledger when the model is ready', (tester) async {
    await pumpModelDownload(tester, modelReady: true);
    await settle(tester);

    await tester.tap(find.text('Continue'));
    await settle(tester);

    expect(find.text('ledger'), findsOneWidget);
  });

  testWidgets('continue opens review when pending candidates exist', (
    tester,
  ) async {
    await pumpModelDownload(tester, modelReady: true, pendingReviewCount: 4);
    await settle(tester);

    await tester.tap(find.text('Continue'));
    await settle(tester);

    expect(find.text('review'), findsOneWidget);
  });

  testWidgets('hides download actions while verifying a stored model', (
    tester,
  ) async {
    await pumpModelDownload(
      tester,
      installController: _VerifyingInstallController(),
    );
    await settle(tester);

    expect(find.text('Checking the on-device model.'), findsOneWidget);
    expect(find.text('Download on-device model'), findsNothing);
    expect(find.text('Select model file'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('shows a blocking loader while preparing a picked file', (
    tester,
  ) async {
    await pumpModelDownload(
      tester,
      installController: _PickingInstallController(),
    );
    await settle(tester);

    expect(find.text('Preparing the selected model.'), findsOneWidget);
    expect(
      find.text('Getting the file ready. Copying will start next.'),
      findsOneWidget,
    );
    expect(find.text('Download on-device model'), findsNothing);
    expect(find.text('Select model file'), findsNothing);
    expect(find.text('Configure later'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('auto continues after verifying a stored model', (tester) async {
    final installController = _VerifyingInstallController();
    await pumpModelDownload(tester, installController: installController);
    await settle(tester);

    installController.finishVerify();
    await settle(tester);

    expect(find.text('ledger'), findsOneWidget);
  });

  testWidgets('auto continues after a successful model install', (
    tester,
  ) async {
    final installController = _ScriptedInstallController();
    await pumpModelDownload(tester, installController: installController);
    await settle(tester);

    installController.finishImport();
    await settle(tester);

    expect(find.text('ledger'), findsOneWidget);
  });

  testWidgets('shows a Restricted reminder on the model gate before download', (
    tester,
  ) async {
    final install = _RecordingDownloadController();
    final backgroundWork = _FakeBackgroundWorkConstraintService(
      isBackgroundRestricted: true,
    );
    await pumpModelDownload(
      tester,
      installController: install,
      backgroundWork: backgroundWork,
    );
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsOneWidget);
    expect(
      find.text(l10n.backgroundRestrictionReminderModelInstallBody),
      findsOneWidget,
    );
    expect(install.downloads, 0);

    await tester.tap(find.text(l10n.backgroundWorkReminderContinue));
    await tester.pumpAndSettle();

    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);

    await tester.tap(find.text('Download on-device model').first);
    await tester.pumpAndSettle();

    expect(install.downloads, 1);
    expect(backgroundWork.openSettingsCount, 0);
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
  });

  testWidgets('skips the background reminder when restrictions are off', (
    tester,
  ) async {
    final install = _RecordingDownloadController();
    await pumpModelDownload(
      tester,
      installController: install,
      backgroundWork: _FakeBackgroundWorkConstraintService(),
    );
    await settle(tester);

    await tester.tap(find.text('Download on-device model').first);
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
    expect(find.text(l10n.backgroundBatterySaverReminderTitle), findsNothing);
    expect(install.downloads, 1);
  });

  testWidgets('configure later opens ledger without a model', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpModelDownload(tester);
    await settle(tester);

    await tester.tap(find.text('Configure later'));
    await settle(tester);

    expect(find.text('ledger'), findsOneWidget);
  });
}
