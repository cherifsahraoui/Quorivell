import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/ai/local_ai_service.dart';
import 'package:quorivell/core/ai/local_model_spec.dart';
import 'package:quorivell/core/ai/local_model_store.dart';
import 'package:quorivell/core/platform/background_work_constraint_service.dart';
import 'package:quorivell/features/account/presentation/pages/model_details_page.dart';
import 'package:quorivell/features/assistant/data/providers/extraction_providers.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _RecordingDownloadController extends LocalModelInstallController {
  _RecordingDownloadController(this._snapshot);

  final LocalModelInstallSnapshot _snapshot;
  var downloads = 0;

  @override
  Future<LocalModelInstallSnapshot> build() async => _snapshot;

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

class _UnrestrictedBackgroundWork implements BackgroundWorkConstraintService {
  @override
  Future<BackgroundWorkConstraints> read() async {
    return const BackgroundWorkConstraints(
      isBackgroundRestricted: false,
      isPowerSaveMode: false,
      isIgnoringBatteryOptimizations: true,
    );
  }

  @override
  Future<void> openSettings() async {}
}

class _SnapshotInstallController extends LocalModelInstallController {
  _SnapshotInstallController(this._snapshot);

  final LocalModelInstallSnapshot _snapshot;

  @override
  Future<LocalModelInstallSnapshot> build() async => _snapshot;
}

class _FakeAiService implements LocalAIService {
  @override
  String get modelId => 'test-model';

  @override
  int get maxInputCharacters => LocalAIRequest.maxInputCharacters;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<LocalAIResponse> extract(LocalAIRequest request) async {
    return const LocalAIResponse(modelId: 'test-model', candidates: []);
  }

  @override
  Future<LocalAIResponse> extractChunked(
    LocalAIRequest request, {
    void Function(ExtractionChunkResult chunk)? onChunk,
    int skipChunks = 0,
  }) async {
    return const LocalAIResponse(modelId: 'test-model', candidates: []);
  }

  @override
  Future<String> chat(
    LocalChatRequest request, {
    void Function(String token)? onToken,
  }) async => '';

  @override
  Future<void> stopChat() async {}

  @override
  void prepareExtraction() {}

  @override
  Future<void> cancelExtraction() async {}

  @override
  Future<void> dispose() async {}
}

const _l10nDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

ProviderScope _scope({
  required LocalModelInstallSnapshot snapshot,
  required Widget child,
  LocalModelInstallController? controller,
  BackgroundWorkConstraintService? backgroundWork,
}) {
  return ProviderScope(
    overrides: [
      localModelInstallControllerProvider.overrideWith(
        () => controller ?? _SnapshotInstallController(snapshot),
      ),
      localAIServiceProvider.overrideWithValue(_FakeAiService()),
      if (backgroundWork != null)
        backgroundWorkConstraintServiceProvider.overrideWithValue(
          backgroundWork,
        ),
    ],
    child: child,
  );
}

void _setWideSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(400, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pumpDetails(
  WidgetTester tester, {
  required LocalModelInstallSnapshot snapshot,
  LocalModelInstallController? controller,
  BackgroundWorkConstraintService? backgroundWork,
}) {
  _setWideSurface(tester);

  return tester.pumpWidget(
    _scope(
      snapshot: snapshot,
      controller: controller,
      backgroundWork: backgroundWork,
      child: const MaterialApp(
        localizationsDelegates: _l10nDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ModelDetailsPage(),
      ),
    ),
  );
}

Future<GoRouter> _pumpDetailsOnAccountRoute(
  WidgetTester tester, {
  required LocalModelInstallSnapshot snapshot,
}) async {
  _setWideSurface(tester);
  final router = GoRouter(
    initialLocation: '/account/model',
    routes: [
      GoRoute(
        path: '/account',
        builder: (context, state) => const Scaffold(body: Text('Account home')),
        routes: [
          GoRoute(
            path: 'model',
            builder: (context, state) => const ModelDetailsPage(),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    _scope(
      snapshot: snapshot,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: _l10nDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  return router;
}

void main() {
  testWidgets('shows an empty state when no model is installed', (
    tester,
  ) async {
    await _pumpDetails(
      tester,
      snapshot: const LocalModelInstallSnapshot(isReady: false),
    );
    await tester.pumpAndSettle();

    expect(find.text('Configure the on-device model'), findsOneWidget);
    expect(find.text('Download on-device model'), findsWidgets);
    expect(find.text('Select model file'), findsOneWidget);
    expect(find.text('Change model'), findsNothing);
  });

  testWidgets('shows downloaded origin for the app default model', (
    tester,
  ) async {
    await _pumpDetails(
      tester,
      snapshot: const LocalModelInstallSnapshot(
        isReady: true,
        origin: LocalModelOrigin.download,
        installedBytes: 1120000000,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ready for local AI'), findsOneWidget);
    expect(find.text('Downloaded by the app'), findsWidgets);
    expect(find.text('Qwen2.5-1.5B-Instruct-Q4_K_M'), findsOneWidget);
    expect(find.text('Change model'), findsOneWidget);
    expect(find.text('Save model file'), findsOneWidget);
    expect(find.text('Delete model'), findsOneWidget);
    expect(find.text('Download on-device model'), findsNothing);
  });

  testWidgets('shows imported origin for a user-selected file', (tester) async {
    await _pumpDetails(
      tester,
      snapshot: const LocalModelInstallSnapshot(
        isReady: true,
        origin: LocalModelOrigin.import,
        installedBytes: 5000000,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Selected from a file'), findsWidgets);
    expect(find.text('5 MB'), findsOneWidget);
  });

  testWidgets('change model reveals download and file picker actions', (
    tester,
  ) async {
    await _pumpDetails(
      tester,
      snapshot: const LocalModelInstallSnapshot(
        isReady: true,
        origin: LocalModelOrigin.download,
        installedModelId: 'Qwen2.5-1.5B-Instruct-Q4_K_M',
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Change model'));
    await tester.pumpAndSettle();

    expect(find.text('Current model'), findsOneWidget);
    expect(find.text('Already installed'), findsOneWidget);
    expect(find.text('Download on-device model'), findsWidgets);
    expect(find.text('Select model file'), findsOneWidget);
    expect(find.text('Keep current model'), findsOneWidget);
  });

  testWidgets('shows a blocking loader while preparing a picked file', (
    tester,
  ) async {
    await _pumpDetails(
      tester,
      snapshot: const LocalModelInstallSnapshot(
        isReady: true,
        isPicking: true,
        origin: LocalModelOrigin.download,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Preparing the selected model.'), findsOneWidget);
    expect(
      find.text('Getting the file ready. Copying will start next.'),
      findsOneWidget,
    );
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Select model file'), findsNothing);
    expect(find.text('Change model'), findsNothing);
    expect(find.text('Delete model'), findsNothing);
    expect(find.text('Download on-device model'), findsNothing);
  });

  testWidgets('back during picking returns to the account screen', (
    tester,
  ) async {
    await _pumpDetailsOnAccountRoute(
      tester,
      snapshot: const LocalModelInstallSnapshot(
        isReady: true,
        isPicking: true,
        origin: LocalModelOrigin.download,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Preparing the selected model.'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Account home'), findsOneWidget);
    expect(find.byType(ModelDetailsPage), findsNothing);
  });

  testWidgets('back during copy import returns to the account screen', (
    tester,
  ) async {
    await _pumpDetailsOnAccountRoute(
      tester,
      snapshot: const LocalModelInstallSnapshot(
        isReady: false,
        isImporting: true,
        progress: 0.4,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BackButton), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Account home'), findsOneWidget);
    expect(find.byType(ModelDetailsPage), findsNothing);
  });

  testWidgets('shows export progress while saving the model file', (
    tester,
  ) async {
    await _pumpDetails(
      tester,
      snapshot: const LocalModelInstallSnapshot(
        isReady: true,
        isExporting: true,
        progress: 0.4,
        receivedBytes: 400,
        totalBytes: 1000,
        origin: LocalModelOrigin.download,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saving model file…'), findsOneWidget);
    expect(find.text('Stop saving'), findsOneWidget);
    expect(find.text('Save model file'), findsNothing);
    expect(find.text('Change model'), findsNothing);
    expect(find.text('Delete model'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('delete confirmation removes the ready details', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pumpDetails(
      tester,
      snapshot: const LocalModelInstallSnapshot(
        isReady: true,
        origin: LocalModelOrigin.download,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete model'));
    await tester.pumpAndSettle();
    expect(find.text('Delete the on-device model?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Ready for local AI'), findsOneWidget);
  });

  testWidgets(
    'replacing a catalog model warns that the current GGUF is removed',
    (tester) async {
      const snapshot = LocalModelInstallSnapshot(
        isReady: true,
        origin: LocalModelOrigin.download,
        installedModelId: 'Qwen2.5-1.5B-Instruct-Q4_K_M',
      );
      final install = _RecordingDownloadController(snapshot);
      await _pumpDetails(
        tester,
        snapshot: snapshot,
        controller: install,
        backgroundWork: _UnrestrictedBackgroundWork(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change model'));
      await tester.pumpAndSettle();
      final download = find.text('Download on-device model').first;
      await tester.scrollUntilVisible(download, 400);
      await tester.pumpAndSettle();
      await tester.tap(download);
      await tester.pumpAndSettle();

      expect(find.text('Replace the on-device model?'), findsOneWidget);
      expect(
        find.text(
          'Downloading another model removes the current one from this device immediately. Local AI stays off until the new download finishes.',
        ),
        findsOneWidget,
      );
      expect(install.downloads, 0);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Replace the on-device model?'), findsNothing);
      expect(install.downloads, 0);

      await tester.scrollUntilVisible(download, 400);
      await tester.pumpAndSettle();
      await tester.tap(download);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Replace'));
      await tester.pumpAndSettle();
      expect(install.downloads, 1);
    },
  );
}
