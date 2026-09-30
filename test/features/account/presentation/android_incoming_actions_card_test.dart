import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/account/presentation/widgets/android_incoming_actions_card.dart';
import 'package:quorivell/l10n/app_localizations.dart';

Widget _app({required TargetPlatform platform}) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: AndroidIncomingActionsCard(platform: platform)),
  );
}

void main() {
  testWidgets('lists share and text-selection actions on Android', (
    tester,
  ) async {
    await tester.pumpWidget(_app(platform: TargetPlatform.android));

    expect(find.text('Android actions from other apps'), findsOneWidget);
    expect(find.textContaining('Capture in Quorivell'), findsOneWidget);
    expect(find.textContaining('Summarize with Quorivell'), findsOneWidget);
    expect(find.textContaining('overflow'), findsOneWidget);
  });

  testWidgets('hides the card on iOS', (tester) async {
    await tester.pumpWidget(_app(platform: TargetPlatform.iOS));

    expect(find.text('Android actions from other apps'), findsNothing);
    expect(find.byType(SizedBox), findsWidgets);
  });
}
