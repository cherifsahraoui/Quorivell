import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/account/domain/entities/user_preference.dart';

UserPreference _preference() => UserPreference(
  id: 'app',
  userId: 'user-1',
  themeMode: AppearanceThemeMode.dark,
  localePreference: AppLocalePreference.de,
  createdAt: DateTime.utc(2026, 9, 12),
  updatedAt: DateTime.utc(2026, 9, 12),
);

void main() {
  test('compares by value', () {
    expect(_preference(), _preference());
  });

  test('round-trips through json', () {
    expect(UserPreference.fromJson(_preference().toJson()), _preference());
  });

  test('copyWith can switch appearance without touching identity', () {
    final updated = _preference().copyWith(
      themeMode: AppearanceThemeMode.light,
      localePreference: AppLocalePreference.ar,
    );

    expect(updated.themeMode, AppearanceThemeMode.light);
    expect(updated.localePreference, AppLocalePreference.ar);
    expect(updated.debugModeEnabled, isFalse);
    expect(updated.chatSystemPromptOverride, isNull);
    expect(updated.id, 'app');
    expect(updated.userId, 'user-1');
  });

  test('copyWith stores debug mode and prompt overrides', () {
    final updated = _preference().copyWith(
      debugModeEnabled: true,
      chatSystemPromptOverride: 'Stay on this device.',
      extractionPromptOverride: 'Extract only.\n\n{conversation}',
      extractionSystemPromptOverride: 'Return JSON only.',
    );

    expect(updated.debugModeEnabled, isTrue);
    expect(updated.chatSystemPromptOverride, 'Stay on this device.');
    expect(updated.extractionPromptOverride, 'Extract only.\n\n{conversation}');
    expect(updated.extractionSystemPromptOverride, 'Return JSON only.');
    expect(UserPreference.fromJson(updated.toJson()), updated);
  });
}
