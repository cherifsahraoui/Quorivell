import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/account/data/providers/debug_ai_settings_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/features/account/presentation/pages/extraction_settings_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

UserPreference _preference({
  String? chatSystemPromptOverride,
  String? extractionPromptOverride,
  String? extractionSystemPromptOverride,
}) {
  return UserPreference(
    id: 'app',
    userId: 'user-1',
    themeMode: AppearanceThemeMode.system,
    localePreference: AppLocalePreference.system,
    chatSystemPromptOverride: chatSystemPromptOverride,
    extractionPromptOverride: extractionPromptOverride,
    extractionSystemPromptOverride: extractionSystemPromptOverride,
    createdAt: DateTime.utc(2026, 9, 12),
    updatedAt: DateTime.utc(2026, 9, 12),
  );
}

class _StubDebugAiSettings extends DebugAiSettingsController {
  _StubDebugAiSettings({this.preference, this.error, this.pending});

  UserPreference? preference;
  final Object? error;
  final Completer<UserPreference?>? pending;
  String? lastChat;
  String? lastExtraction;
  String? lastSystem;

  @override
  Future<UserPreference?> build() async {
    if (pending != null) return pending!.future;
    if (error != null) throw error!;
    return preference;
  }

  @override
  Future<void> savePromptOverrides({
    required String? chatSystemPromptOverride,
    required String? extractionPromptOverride,
    required String? extractionSystemPromptOverride,
  }) async {
    lastChat = chatSystemPromptOverride;
    lastExtraction = extractionPromptOverride;
    lastSystem = extractionSystemPromptOverride;
    preference = (preference ?? _preference()).copyWith(
      chatSystemPromptOverride: chatSystemPromptOverride,
      extractionPromptOverride: extractionPromptOverride,
      extractionSystemPromptOverride: extractionSystemPromptOverride,
    );
    state = AsyncValue.data(preference);
  }
}

Future<void> _pumpSettingsPage(
  WidgetTester tester, {
  required _StubDebugAiSettings settings,
}) {
  tester.view.physicalSize = const Size(400, 2800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/account/extraction',
    routes: [
      GoRoute(
        path: '/account',
        builder: (context, state) => const Scaffold(body: Text('account')),
        routes: [
          GoRoute(
            path: 'extraction',
            builder: (context, state) => const ExtractionSettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/review/kinds',
        builder: (context, state) => const Scaffold(body: Text('kinds')),
      ),
      GoRoute(
        path: '/account/model',
        builder: (context, state) => const Scaffold(body: Text('model')),
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

Finder _promptField(Key key) {
  return find.descendant(of: find.byKey(key), matching: find.byType(TextField));
}

void main() {
  testWidgets('shows a loading state while extraction settings are read', (
    tester,
  ) async {
    await _pumpSettingsPage(
      tester,
      settings: _StubDebugAiSettings(pending: Completer()),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows a localized error when settings cannot be read', (
    tester,
  ) async {
    await _pumpSettingsPage(
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
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('shows default prompt editors when no overrides are stored', (
    tester,
  ) async {
    await _pumpSettingsPage(tester, settings: _StubDebugAiSettings());
    await tester.pumpAndSettle();

    expect(find.text('Extraction settings'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(
      find.textContaining('stay on this device until you sign in'),
      findsOneWidget,
    );
  });

  testWidgets('saves typed prompt overrides with debug off', (tester) async {
    final settings = _StubDebugAiSettings(preference: _preference());
    await _pumpSettingsPage(tester, settings: settings);
    await tester.pumpAndSettle();

    for (final (key, value) in [
      (
        const ValueKey('extraction_settings_chat_prompt'),
        'Stay on this device.',
      ),
      (
        const ValueKey('extraction_settings_system_prompt'),
        'Return JSON only.',
      ),
      (
        const ValueKey('extraction_settings_user_prompt'),
        'Extract only.\n\n{conversation}',
      ),
    ]) {
      final field = _promptField(key);
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.enterText(field, value);
    }
    await tester.ensureVisible(find.text('Save overrides'));
    await tester.tap(find.text('Save overrides'));
    await tester.pumpAndSettle();

    expect(settings.lastChat, 'Stay on this device.');
    expect(settings.lastSystem, 'Return JSON only.');
    expect(settings.lastExtraction, 'Extract only.\n\n{conversation}');
    expect(find.text('Extraction overrides saved.'), findsOneWidget);
    expect(find.text('account'), findsOneWidget);
  });

  testWidgets('reset to default returns to the account tab', (tester) async {
    final settings = _StubDebugAiSettings(
      preference: _preference(
        chatSystemPromptOverride: 'Custom chat',
        extractionSystemPromptOverride: 'Custom system',
      ),
    );
    await _pumpSettingsPage(tester, settings: settings);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Reset all to defaults'));
    await tester.tap(find.text('Reset all to defaults'));
    await tester.pumpAndSettle();

    expect(find.text('Prompts restored to defaults.'), findsOneWidget);
    expect(find.text('account'), findsOneWidget);
  });

  testWidgets('fills the explicit chat system prompt preset', (tester) async {
    final settings = _StubDebugAiSettings(preference: _preference());
    await _pumpSettingsPage(tester, settings: settings);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Use explicit chat tone'));
    await tester.tap(find.text('Use explicit chat tone'));
    await tester.pumpAndSettle();

    final chatField = tester.widget<TextField>(find.byType(TextField).at(0));
    expect(chatField.controller?.text, contains('match that tone freely'));
    expect(find.textContaining('Uncensored catalog model'), findsOneWidget);
    expect(
      find.text(
        'Explicit chat tone filled in — tap Save overrides to keep it.',
      ),
      findsOneWidget,
    );

    // Let the snackbar dismiss so the sticky Save button is hittable.
    await tester.pump(const Duration(milliseconds: 4100));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save overrides'));
    await tester.tap(find.text('Save overrides'));
    await tester.pumpAndSettle();

    expect(settings.lastChat, contains('match that tone freely'));
  });

  testWidgets('opens model settings from the explicit chat note', (
    tester,
  ) async {
    await _pumpSettingsPage(tester, settings: _StubDebugAiSettings());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Open model settings'));
    await tester.tap(find.text('Open model settings'));
    await tester.pumpAndSettle();

    expect(find.text('model'), findsOneWidget);
  });
}
