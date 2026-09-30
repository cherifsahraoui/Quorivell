import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_preference.dart';
import 'user_preference_providers.dart';

part 'theme_preference_providers.g.dart';

const legacyThemeModePrefsKey = 'theme_mode';

/// Persisted appearance preference. Defaults to [ThemeMode.system].
@Riverpod(keepAlive: true)
class ThemeModePreference extends _$ThemeModePreference {
  @override
  Future<ThemeMode> build() async {
    final stored = await ref.watch(userPreferenceRepositoryProvider).load();
    if (!ref.mounted) {
      return ThemeMode.system;
    }
    if (stored != null) {
      return _toMaterial(stored.themeMode);
    }

    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) {
      return ThemeMode.system;
    }
    if (!prefs.containsKey(legacyThemeModePrefsKey)) {
      return ThemeMode.system;
    }

    final migrated = _decode(prefs.getString(legacyThemeModePrefsKey));
    await ref
        .read(userPreferenceRepositoryProvider)
        .saveThemeMode(_fromMaterial(migrated));
    await prefs.remove(legacyThemeModePrefsKey);
    return migrated;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncValue.data(mode);
    await ref
        .read(userPreferenceRepositoryProvider)
        .saveThemeMode(_fromMaterial(mode));
  }

  Future<void> clear() async {
    await ref.read(userPreferenceRepositoryProvider).clear();
    if (!ref.mounted) {
      return;
    }
    state = const AsyncValue.data(ThemeMode.system);
  }

  static AppearanceThemeMode _fromMaterial(ThemeMode mode) => switch (mode) {
    ThemeMode.light => AppearanceThemeMode.light,
    ThemeMode.dark => AppearanceThemeMode.dark,
    ThemeMode.system => AppearanceThemeMode.system,
  };

  static ThemeMode _toMaterial(AppearanceThemeMode mode) => switch (mode) {
    AppearanceThemeMode.light => ThemeMode.light,
    AppearanceThemeMode.dark => ThemeMode.dark,
    AppearanceThemeMode.system => ThemeMode.system,
  };

  static ThemeMode _decode(String? raw) => switch (raw) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
