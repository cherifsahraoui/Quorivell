import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/l10n/local_ai_copy.dart';
import '../../domain/entities/user_preference.dart';
import 'user_preference_providers.dart';

part 'locale_preference_providers.g.dart';

/// Persisted UI locale preference. Defaults to [AppLocalePreference.system].
@Riverpod(keepAlive: true)
class LocalePreferenceController extends _$LocalePreferenceController {
  @override
  Future<AppLocalePreference> build() async {
    final stored = await ref.watch(userPreferenceRepositoryProvider).load();
    if (!ref.mounted) {
      return AppLocalePreference.system;
    }
    return stored?.localePreference ?? AppLocalePreference.system;
  }

  Future<void> setLocalePreference(AppLocalePreference preference) async {
    state = AsyncValue.data(preference);
    await ref
        .read(userPreferenceRepositoryProvider)
        .saveLocalePreference(preference);
  }

  Future<void> clear() async {
    await ref.read(userPreferenceRepositoryProvider).clear();
    if (!ref.mounted) {
      return;
    }
    state = const AsyncValue.data(AppLocalePreference.system);
  }

  /// Resolves the MaterialApp [Locale], or `null` to follow the device.
  static Locale? toMaterialLocale(AppLocalePreference preference) =>
      switch (preference) {
        AppLocalePreference.system => null,
        AppLocalePreference.en => const Locale('en'),
        AppLocalePreference.de => const Locale('de'),
        AppLocalePreference.ar => const Locale('ar'),
      };

  /// Locale used for UI strings and on-device AI prompts.
  ///
  /// [AppLocalePreference.system] follows the device language, clamped to a
  /// supported app locale (`en` / `de` / `ar`).
  static Locale effectiveLocale(AppLocalePreference preference) {
    final fixed = toMaterialLocale(preference);
    if (fixed != null) return fixed;
    return supportedAppLocale(
      WidgetsBinding.instance.platformDispatcher.locale,
    );
  }
}
