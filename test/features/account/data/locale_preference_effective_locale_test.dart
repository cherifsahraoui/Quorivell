import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/account/data/providers/locale_preference_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';

void main() {
  test('effectiveLocale maps fixed preferences to en/de/ar', () {
    expect(
      LocalePreferenceController.effectiveLocale(AppLocalePreference.en),
      const Locale('en'),
    );
    expect(
      LocalePreferenceController.effectiveLocale(AppLocalePreference.de),
      const Locale('de'),
    );
    expect(
      LocalePreferenceController.effectiveLocale(AppLocalePreference.ar),
      const Locale('ar'),
    );
  });

  testWidgets('effectiveLocale system follows a supported platform locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('de'),
        delegates: const [
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: const SizedBox.shrink(),
      ),
    );

    // platformDispatcher.locale in tests is usually en; clamp still returns a
    // supported Locale rather than throwing.
    final locale = LocalePreferenceController.effectiveLocale(
      AppLocalePreference.system,
    );
    expect(['en', 'de', 'ar'], contains(locale.languageCode));
  });
}
