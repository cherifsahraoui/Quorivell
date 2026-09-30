import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/database/database_providers.dart';
import 'package:quorivell/features/account/data/datasources/user_preference_local_data_source.dart';
import 'package:quorivell/features/account/data/providers/locale_preference_providers.dart';
import 'package:quorivell/features/account/data/providers/theme_preference_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/features/account/presentation/pages/user_preferences_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

late AppDatabase database;

Future<void> _pumpPreferencesPage(WidgetTester tester) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const UserPreferencesPage(),
      ),
    ],
  );
  return tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() => database.close());

  testWidgets('shows system as the default theme and language selection', (
    tester,
  ) async {
    await _pumpPreferencesPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('User preferences'), findsOneWidget);
    expect(
      find.text(
        'Choose light, dark, or follow the system setting. System is the default.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Choose English, German, Arabic, or follow the system language. System is the default.',
      ),
      findsOneWidget,
    );

    final systemTheme = tester.widget<RadioListTile<ThemeMode>>(
      find.widgetWithText(RadioListTile<ThemeMode>, 'System'),
    );
    expect(systemTheme.selected, isTrue);
    expect(systemTheme.value, ThemeMode.system);

    final systemLocale = tester.widget<RadioListTile<AppLocalePreference>>(
      find.widgetWithText(RadioListTile<AppLocalePreference>, 'System').first,
    );
    expect(systemLocale.selected, isTrue);
    expect(systemLocale.value, AppLocalePreference.system);
  });

  testWidgets('persists a light theme selection', (tester) async {
    await _pumpPreferencesPage(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    final rows = await database.select(database.userPreferences).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, userPreferenceRowId);
    expect(rows.single.themeMode, 'light');
    expect(rows.single.localePreference, 'system');
    expect(rows.single.isDeleted, isFalse);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(UserPreferencesPage)),
    );
    expect(
      container.read(themeModePreferenceProvider).asData?.value,
      ThemeMode.light,
    );
  });

  testWidgets('persists an Arabic language selection', (tester) async {
    await _pumpPreferencesPage(tester);
    await tester.pumpAndSettle();

    final arabic = find.text('Arabic');
    await tester.ensureVisible(arabic);
    await tester.pumpAndSettle();
    await tester.tap(arabic);
    await tester.pumpAndSettle();

    final rows = await database.select(database.userPreferences).get();
    expect(rows, hasLength(1));
    expect(rows.single.localePreference, 'ar');
    expect(rows.single.themeMode, 'system');

    final container = ProviderScope.containerOf(
      tester.element(find.byType(UserPreferencesPage)),
    );
    expect(
      container.read(localePreferenceControllerProvider).asData?.value,
      AppLocalePreference.ar,
    );
  });

  testWidgets('restores a stored dark preference', (tester) async {
    SharedPreferences.setMockInitialValues({legacyThemeModePrefsKey: 'dark'});
    await _pumpPreferencesPage(tester);
    await tester.pumpAndSettle();

    final darkTile = tester.widget<RadioListTile<ThemeMode>>(
      find.widgetWithText(RadioListTile<ThemeMode>, 'Dark'),
    );
    expect(darkTile.selected, isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey(legacyThemeModePrefsKey), isFalse);
    final rows = await database.select(database.userPreferences).get();
    expect(rows, hasLength(1));
    expect(rows.single.themeMode, 'dark');
  });
}
