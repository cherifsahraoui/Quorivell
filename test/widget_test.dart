import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/ai/local_model_providers.dart';
import 'package:quorivell/core/ai/local_model_store.dart';
import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/database/database_providers.dart';
import 'package:quorivell/core/routing/app_router.dart';
import 'package:quorivell/core/routing/app_shell.dart';
import 'package:quorivell/features/account/data/providers/theme_preference_providers.dart';
import 'package:quorivell/features/assistant/presentation/controllers/review_controller.dart';
import 'package:quorivell/features/onboarding/data/providers/onboarding_providers.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/l10n/app_localizations.dart';
import 'package:quorivell/main.dart';

class _StubStore extends LocalModelStore {
  _StubStore()
    : super(resolveDocumentsDirectory: () async => Directory.systemTemp);

  @override
  Future<bool> isReady({bool hashIfNeeded = true}) async => true;

  @override
  Future<bool> hasModelFile() async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({'has_seen_welcome': true});
  });

  Future<void> pumpUntilShell(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() async {
      if (tester.binding.inTest) {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 1));
      }
      await database.close();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localModelStoreProvider.overrideWithValue(_StubStore()),
          pendingReviewCountProvider.overrideWithValue(0),
        ],
        child: const AiFlutterApp(),
      ),
    );
    await tester.pump();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(AiFlutterApp)),
    );
    await container.read(onboardingStateProvider.future);
    await container.read(modelSetupStateProvider.future);
    await container.read(localModelInstallControllerProvider.future);
    await container.read(themeModePreferenceProvider.future);
    for (var i = 0; i < 80; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.byType(AppShell).evaluate().isNotEmpty) {
        container.read(appRouterProvider).go('/capture');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        return;
      }
    }
    fail('Timed out waiting for the app shell');
  }

  testWidgets('renders the local conversation capture flow', (tester) async {
    await pumpUntilShell(tester);

    expect(find.byType(Scaffold), findsWidgets);
    expect(find.text('Capture'), findsWidgets);
    // Website URL field + conversation body.
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Save locally'), findsOneWidget);
    expect(find.byIcon(Icons.login), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('exposes the five foundation destinations', (tester) async {
    await pumpUntilShell(tester);

    expect(find.byType(AppShell), findsOneWidget);
    expect(find.text('Capture'), findsWidgets);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.bySemanticsLabel('Ledger'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  test('provides English, German, and Arabic app locales', () {
    expect(
      AppLocalizations.supportedLocales,
      containsAll(const [Locale('en'), Locale('de'), Locale('ar')]),
    );
  });
}
