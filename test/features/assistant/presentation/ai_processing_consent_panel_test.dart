import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/assistant/data/providers/ai_processing_consent_providers.dart';
import 'package:quorivell/features/assistant/domain/entities/ai_processing_consent.dart';
import 'package:quorivell/features/assistant/domain/repositories/ai_processing_consent_repository.dart';
import 'package:quorivell/features/assistant/presentation/widgets/ai_processing_consent_panel.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _FakeAiProcessingConsentRepository
    implements AiProcessingConsentRepository {
  _FakeAiProcessingConsentRepository({this.pending, this.consent, this.error});

  final Completer<AiProcessingConsent>? pending;
  AiProcessingConsent? consent;
  final Object? error;
  AiProcessingConsentStatus? lastSaved;

  @override
  Future<AiProcessingConsent> load() {
    if (pending != null) return pending!.future;
    if (error != null) return Future.error(error!);
    return Future.value(consent!);
  }

  @override
  Future<AiProcessingConsent> save(AiProcessingConsentStatus status) async {
    lastSaved = status;
    consent = AiProcessingConsent(
      status: status,
      updatedAt: DateTime.utc(2026, 9, 8),
    );
    return consent!;
  }
}

Future<void> _pumpConsentPanel(
  WidgetTester tester,
  AiProcessingConsentRepository repository,
) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        aiProcessingConsentRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: AiProcessingConsentPanel()),
      ),
    ),
  );
}

void main() {
  testWidgets('shows a loading state before consent is read', (tester) async {
    await _pumpConsentPanel(
      tester,
      _FakeAiProcessingConsentRepository(pending: Completer()),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('asks for consent when none is stored', (tester) async {
    await _pumpConsentPanel(
      tester,
      _FakeAiProcessingConsentRepository(
        consent: AiProcessingConsent(
          status: AiProcessingConsentStatus.unknown,
          updatedAt: DateTime.utc(2026, 9, 7),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Cloud processing is off until you explicitly allow'),
      findsOneWidget,
    );
    expect(find.text('Allow cloud processing'), findsOneWidget);
    expect(find.text('Keep processing on this device'), findsOneWidget);
  });

  testWidgets('shows the granted state after an affirmative choice', (
    tester,
  ) async {
    final repository = _FakeAiProcessingConsentRepository(
      consent: AiProcessingConsent(
        status: AiProcessingConsentStatus.unknown,
        updatedAt: DateTime.utc(2026, 9, 7),
      ),
    );
    await _pumpConsentPanel(tester, repository);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Allow cloud processing'));
    await tester.pumpAndSettle();

    expect(repository.lastSaved, AiProcessingConsentStatus.granted);
    expect(
      find.textContaining('You allowed cloud processing.'),
      findsOneWidget,
    );
    expect(find.text('Withdraw cloud permission'), findsOneWidget);
  });

  testWidgets('shows the declined state and keeps extract ungated', (
    tester,
  ) async {
    await _pumpConsentPanel(
      tester,
      _FakeAiProcessingConsentRepository(
        consent: AiProcessingConsent(
          status: AiProcessingConsentStatus.declined,
          updatedAt: DateTime.utc(2026, 9, 7),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('You kept processing on this device.'),
      findsOneWidget,
    );
    expect(find.text('Allow cloud processing'), findsOneWidget);
  });

  testWidgets('shows a localized error when consent cannot be read', (
    tester,
  ) async {
    await _pumpConsentPanel(
      tester,
      _FakeAiProcessingConsentRepository(
        error: const LocalPersistenceFailure.readFailed(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('This device could not save or read your local records.'),
      findsOneWidget,
    );
  });
}
