import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/database/database_providers.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/core/platform/app_package_info.dart';
import 'package:quorivell/features/account/data/providers/locale_preference_providers.dart';
import 'package:quorivell/features/account/data/providers/theme_preference_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/features/account/presentation/pages/account_page.dart';
import 'package:quorivell/features/assistant/data/providers/ai_processing_consent_providers.dart';
import 'package:quorivell/features/assistant/domain/entities/ai_processing_consent.dart';
import 'package:quorivell/features/assistant/domain/repositories/ai_processing_consent_repository.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _MissingInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: false);
  }
}

class _FakeAppPackageInfoSource implements AppPackageInfoSource {
  _FakeAppPackageInfoSource({this.pending, this.version, this.error});

  final Completer<AppPackageVersion>? pending;
  final AppPackageVersion? version;
  final Object? error;

  @override
  Future<AppPackageVersion> load() {
    if (pending != null) return pending!.future;
    if (error != null) return Future.error(error!);
    return Future.value(
      version ??
          const AppPackageVersion(versionName: '1.2.3', buildNumber: '45'),
    );
  }
}

class _FakeAiProcessingConsentRepository
    implements AiProcessingConsentRepository {
  _FakeAiProcessingConsentRepository({this.pending, this.consent, this.error});

  final Completer<AiProcessingConsent>? pending;
  AiProcessingConsent? consent;
  final Object? error;

  @override
  Future<AiProcessingConsent> load() {
    if (pending != null) return pending!.future;
    if (error != null) return Future.error(error!);
    return Future.value(
      consent ??
          AiProcessingConsent(
            status: AiProcessingConsentStatus.unknown,
            updatedAt: DateTime.utc(2026, 9, 14),
          ),
    );
  }

  @override
  Future<AiProcessingConsent> save(AiProcessingConsentStatus status) async {
    consent = AiProcessingConsent(
      status: status,
      updatedAt: DateTime.utc(2026, 9, 14),
    );
    return consent!;
  }
}

late AppDatabase database;

Future<void> _pumpAccountPage(
  WidgetTester tester, {
  AiProcessingConsentRepository? consentRepository,
  AppPackageInfoSource? packageInfoSource,
  Locale? locale,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: AccountPage()),
      ),
      GoRoute(
        path: '/account/preferences',
        builder: (context, state) =>
            const Scaffold(body: Text('user-preferences')),
      ),
      GoRoute(
        path: '/account/model',
        builder: (context, state) =>
            const Scaffold(body: Text('model-details')),
      ),
      GoRoute(
        path: '/account/debug',
        builder: (context, state) => const Scaffold(body: Text('debug-mode')),
      ),
    ],
  );
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        localModelInstallControllerProvider.overrideWith(
          () => _MissingInstallController(),
        ),
        appPackageInfoSourceProvider.overrideWithValue(
          packageInfoSource ?? _FakeAppPackageInfoSource(),
        ),
        if (consentRepository != null)
          aiProcessingConsentRepositoryProvider.overrideWithValue(
            consentRepository,
          ),
      ],
      child: MaterialApp.router(
        locale: locale,
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
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() => database.close());

  testWidgets('shows account preferences and about copy', (tester) async {
    await _pumpAccountPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('Account'), findsOneWidget);
    expect(
      find.text('Your local preferences, privacy, and app information.'),
      findsOneWidget,
    );
    expect(find.text('User preferences'), findsOneWidget);
    expect(find.text('System · System'), findsOneWidget);
    expect(find.text('Debug mode'), findsOneWidget);
    expect(
      find.text('Inspect findings as JSON and edit on-device AI prompts.'),
      findsOneWidget,
    );
    expect(find.text('On-device model'), findsOneWidget);
    expect(find.text('Not configured'), findsOneWidget);
    expect(
      find.text('Privacy and processing', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('On this device', skipOffstage: false), findsOneWidget);
    expect(find.text('Off', skipOffstage: false), findsOneWidget);
    expect(find.text('Privacy policy', skipOffstage: false), findsOneWidget);
    expect(find.text('Version', skipOffstage: false), findsOneWidget);
    expect(find.text('1.2.3', skipOffstage: false), findsOneWidget);
    expect(find.text('1.2.3+45'), findsNothing);
    expect(find.text('Developer', skipOffstage: false), findsOneWidget);
    expect(find.text('Clear app data', skipOffstage: false), findsOneWidget);
  });

  testWidgets('shows the version name without the Play build number', (
    tester,
  ) async {
    await _pumpAccountPage(
      tester,
      packageInfoSource: _FakeAppPackageInfoSource(
        version: const AppPackageVersion(
          versionName: '0.1.0',
          buildNumber: '16',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0.1.0', skipOffstage: false), findsOneWidget);
    expect(find.text('0.1.0+16'), findsNothing);
    expect(find.text('0.1.0+1'), findsNothing);
  });

  testWidgets('places the version on the start edge in Arabic', (tester) async {
    await _pumpAccountPage(tester, locale: const Locale('ar'));
    await tester.pumpAndSettle();

    final version = find.text('1.2.3', skipOffstage: false);
    expect(version, findsOneWidget);
    await tester.ensureVisible(version);
    await tester.pumpAndSettle();

    final align = tester.widget<Align>(
      find.ancestor(of: version, matching: find.byType(Align)).first,
    );
    expect(align.alignment, AlignmentDirectional.centerStart);
    final text = tester.widget<Text>(version);
    expect(text.textDirection, TextDirection.ltr);

    final versionBox = tester.getRect(version);
    final titleBox = tester.getRect(find.text('الإصدار'));
    expect((versionBox.right - titleBox.right).abs(), lessThan(16));
  });

  testWidgets('places the version on the start edge in English', (
    tester,
  ) async {
    await _pumpAccountPage(tester, locale: const Locale('en'));
    await tester.pumpAndSettle();

    final version = find.text('1.2.3', skipOffstage: false);
    expect(version, findsOneWidget);
    await tester.ensureVisible(version);
    await tester.pumpAndSettle();

    final align = tester.widget<Align>(
      find.ancestor(of: version, matching: find.byType(Align)).first,
    );
    expect(align.alignment, AlignmentDirectional.centerStart);

    final versionBox = tester.getRect(version);
    final titleBox = tester.getRect(find.text('Version'));
    expect((versionBox.left - titleBox.left).abs(), lessThan(16));
  });

  testWidgets('shows a loading indicator while the package version is read', (
    tester,
  ) async {
    await _pumpAccountPage(
      tester,
      packageInfoSource: _FakeAppPackageInfoSource(pending: Completer()),
    );
    await tester.pump();

    expect(
      find.byType(LinearProgressIndicator, skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('1.2.3+45'), findsNothing);
    expect(find.text('1.2.3'), findsNothing);
  });

  testWidgets(
    'shows unavailable copy when the package version cannot be read',
    (tester) async {
      await _pumpAccountPage(
        tester,
        packageInfoSource: _FakeAppPackageInfoSource(
          error: const LocalPersistenceFailure.readFailed(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unavailable', skipOffstage: false), findsOneWidget);
    },
  );

  testWidgets('shows the stored theme preference on the account row', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
    await _pumpAccountPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('Dark · System'), findsOneWidget);
  });

  testWidgets('opens user preferences from the account row', (tester) async {
    await _pumpAccountPage(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('User preferences'));
    await tester.pumpAndSettle();

    expect(find.text('user-preferences'), findsOneWidget);
  });

  testWidgets('opens model details from the account row', (tester) async {
    await _pumpAccountPage(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('On-device model'));
    await tester.pumpAndSettle();

    expect(find.text('model-details'), findsOneWidget);
  });

  testWidgets('opens debug mode from the account row', (tester) async {
    await _pumpAccountPage(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Debug mode'));
    await tester.pumpAndSettle();

    expect(find.text('debug-mode'), findsOneWidget);
  });

  testWidgets('shows a debug control that clears shared preferences', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'has_seen_welcome': true,
      'theme_mode': 'light',
    });
    await _pumpAccountPage(tester);
    await tester.pumpAndSettle();

    expect(kDebugMode, isTrue);
    final clearControl = find.text(
      'Clear shared preferences',
      skipOffstage: false,
    );
    expect(clearControl, findsOneWidget);
    await tester.ensureVisible(clearControl);
    await tester.pumpAndSettle();
    await tester.tap(clearControl);
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('has_seen_welcome'), isNull);
    expect(prefs.getString('theme_mode'), isNull);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(AccountPage)),
    );
    expect(
      container.read(themeModePreferenceProvider).asData?.value,
      ThemeMode.system,
    );
    expect(
      container.read(localePreferenceControllerProvider).asData?.value,
      AppLocalePreference.system,
    );
  });

  testWidgets('shows a debug control that clears app data after confirm', (
    tester,
  ) async {
    await database
        .into(database.sourceConversations)
        .insert(
          SourceConversationsCompanion.insert(
            id: 'source-1',
            userId: 'local-user',
            content: 'Synthetic conversation fixture.',
            sourceRevision: 1,
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    await database
        .into(database.ledgerItems)
        .insert(
          LedgerItemsCompanion.insert(
            id: 'ledger-1',
            userId: 'local-user',
            kind: 'commitment',
            statement: 'Synthetic commitment fixture.',
            status: 'open',
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    await _pumpAccountPage(tester);
    await tester.pumpAndSettle();

    expect(kDebugMode, isTrue);
    final clearControl = find.text('Clear app data', skipOffstage: false);
    expect(clearControl, findsOneWidget);
    await tester.ensureVisible(clearControl);
    await tester.pumpAndSettle();
    await tester.tap(clearControl);
    await tester.pumpAndSettle();

    expect(find.text('Clear app data?'), findsOneWidget);
    await tester.tap(find.text('Clear data'));
    await tester.pumpAndSettle();

    expect(find.text('App data cleared.'), findsOneWidget);
    expect(await database.select(database.sourceConversations).get(), isEmpty);
    expect(await database.select(database.ledgerItems).get(), isEmpty);
  });

  // Cloud-consent panel is commented out in PrivacyAndProcessingSection
  // until remote AI is enabled; keep these cases for that restore.
  testWidgets(
    'shows a loading state while processing consent is read',
    skip: true,
    (tester) async {
      await _pumpAccountPage(
        tester,
        consentRepository: _FakeAiProcessingConsentRepository(
          pending: Completer(),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets('shows preparatory consent controls on account', skip: true, (
    tester,
  ) async {
    await _pumpAccountPage(
      tester,
      consentRepository: _FakeAiProcessingConsentRepository(
        consent: AiProcessingConsent(
          status: AiProcessingConsentStatus.unknown,
          updatedAt: DateTime.utc(2026, 9, 14),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final consentCopy = find.textContaining(
      'Cloud processing is off until you explicitly allow',
      skipOffstage: false,
    );
    await tester.ensureVisible(consentCopy);
    expect(consentCopy, findsOneWidget);
    expect(find.text('Allow cloud processing'), findsOneWidget);
    expect(find.text('Keep processing on this device'), findsOneWidget);
  });

  testWidgets(
    'shows a localized error when processing consent cannot be read',
    skip: true,
    (tester) async {
      await _pumpAccountPage(
        tester,
        consentRepository: _FakeAiProcessingConsentRepository(
          error: const LocalPersistenceFailure.readFailed(),
        ),
      );
      await tester.pumpAndSettle();

      final errorCopy = find.text(
        'This device could not save or read your local records.',
        skipOffstage: false,
      );
      await tester.ensureVisible(errorCopy);
      expect(errorCopy, findsOneWidget);
    },
  );
}
