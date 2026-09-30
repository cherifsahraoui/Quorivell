import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/account/data/providers/debug_ai_settings_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/features/account/presentation/pages/debug_mode_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

UserPreference _preference({bool debugModeEnabled = false}) {
  return UserPreference(
    id: 'app',
    userId: 'user-1',
    themeMode: AppearanceThemeMode.system,
    localePreference: AppLocalePreference.system,
    debugModeEnabled: debugModeEnabled,
    createdAt: DateTime.utc(2026, 9, 12),
    updatedAt: DateTime.utc(2026, 9, 12),
  );
}

class _StubDebugAiSettings extends DebugAiSettingsController {
  _StubDebugAiSettings({this.preference, this.error, this.pending});

  UserPreference? preference;
  final Object? error;
  final Completer<UserPreference?>? pending;
  final enabledCalls = <bool>[];

  @override
  Future<UserPreference?> build() async {
    if (pending != null) return pending!.future;
    if (error != null) throw error!;
    return preference;
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    enabledCalls.add(enabled);
    preference = (preference ?? _preference()).copyWith(
      debugModeEnabled: enabled,
    );
    state = AsyncValue.data(preference);
  }
}

Future<void> _pumpDebugPage(
  WidgetTester tester, {
  required _StubDebugAiSettings settings,
}) {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/account/debug',
    routes: [
      GoRoute(
        path: '/account',
        builder: (context, state) => const Scaffold(body: Text('account')),
        routes: [
          GoRoute(
            path: 'debug',
            builder: (context, state) => const DebugModePage(),
          ),
          GoRoute(
            path: 'extraction',
            builder: (context, state) =>
                const Scaffold(body: Text('extraction-settings')),
          ),
        ],
      ),
    ],
  );

  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        debugAiSettingsControllerProvider.overrideWith(() => settings),
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

void main() {
  testWidgets('shows a loading state while debug settings are read', (
    tester,
  ) async {
    await _pumpDebugPage(
      tester,
      settings: _StubDebugAiSettings(pending: Completer()),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows a localized error when debug settings cannot be read', (
    tester,
  ) async {
    await _pumpDebugPage(
      tester,
      settings: _StubDebugAiSettings(
        error: const LocalPersistenceFailure.readFailed(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('This device could not save or read your local records.'),
      findsOneWidget,
    );
    expect(find.text('On-device prompts'), findsNothing);
  });

  testWidgets('hides prompt editors and links to extraction settings', (
    tester,
  ) async {
    await _pumpDebugPage(tester, settings: _StubDebugAiSettings());
    await tester.pumpAndSettle();

    expect(find.text('Debug mode'), findsWidgets);
    expect(find.text('Enable debug mode'), findsOneWidget);
    expect(find.text('Stays on this device'), findsOneWidget);
    expect(find.text('On-device prompts'), findsNothing);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Extraction settings'), findsOneWidget);
  });

  testWidgets('debug on still keeps prompt editors on Extraction settings', (
    tester,
  ) async {
    await _pumpDebugPage(
      tester,
      settings: _StubDebugAiSettings(
        preference: _preference(debugModeEnabled: true),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNothing);
    expect(find.text('On-device prompts'), findsNothing);
    expect(find.text('Extraction settings'), findsOneWidget);
  });

  testWidgets('opens extraction settings from debug', (tester) async {
    await _pumpDebugPage(tester, settings: _StubDebugAiSettings());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Extraction settings'));
    await tester.pumpAndSettle();

    expect(find.text('extraction-settings'), findsOneWidget);
  });
}
