import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/account/presentation/widgets/privacy_and_processing_section.dart';
import 'package:quorivell/l10n/app_localizations.dart';

Future<void> _pumpStatusCard(
  WidgetTester tester, {
  required VoidCallback onOpenPrivacyPolicy,
}) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: PrivacyAndProcessingStatusCard(
          onOpenPrivacyPolicy: onOpenPrivacyPolicy,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows on-device processing and sync-off status', (tester) async {
    await _pumpStatusCard(tester, onOpenPrivacyPolicy: () {});
    await tester.pumpAndSettle();

    expect(find.text('Processing'), findsOneWidget);
    expect(find.text('On this device'), findsOneWidget);
    expect(
      find.text(
        'Extraction runs locally. Source conversations do not leave this device.',
      ),
      findsOneWidget,
    );
    expect(find.text('Sync'), findsOneWidget);
    expect(find.text('Off'), findsOneWidget);
    expect(
      find.text(
        'Your records stay on this device. Account sync is not available yet.',
      ),
      findsOneWidget,
    );
    expect(find.text('Privacy policy'), findsOneWidget);
  });

  testWidgets('opens the privacy policy from the status card', (tester) async {
    var opened = false;
    await _pumpStatusCard(
      tester,
      onOpenPrivacyPolicy: () {
        opened = true;
      },
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy policy'));
    await tester.pump();

    expect(opened, isTrue);
  });
}
