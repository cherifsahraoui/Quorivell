import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/assistant/presentation/widgets/confirm_stop_extraction_dialog.dart';
import 'package:quorivell/l10n/app_localizations.dart';

void main() {
  Future<void> pumpHost(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => confirmStopExtraction(context),
                child: const Text('open'),
              );
            },
          ),
        ),
      ),
    );
  }

  testWidgets('keep extracting dismisses the warning', (tester) async {
    await pumpHost(tester);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Stop extraction?'), findsOneWidget);
    await tester.tap(find.text('Keep extracting'));
    await tester.pumpAndSettle();
    expect(find.text('Stop extraction?'), findsNothing);
  });

  testWidgets('stop confirms the warning', (tester) async {
    await pumpHost(tester);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();
    expect(find.text('Stop extraction?'), findsNothing);
  });
}
