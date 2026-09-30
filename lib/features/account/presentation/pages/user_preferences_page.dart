import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/providers/locale_preference_providers.dart';
import '../../data/providers/theme_preference_providers.dart';
import '../../domain/entities/user_preference.dart';

/// Unified account preferences: appearance theme and UI language.
class UserPreferencesPage extends ConsumerWidget {
  const UserPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themePreference = ref.watch(themeModePreferenceProvider);
    final localePreference = ref.watch(localePreferenceControllerProvider);
    final selectedTheme = themePreference.asData?.value ?? ThemeMode.system;
    final selectedLocale =
        localePreference.asData?.value ?? AppLocalePreference.system;
    final isLoading = themePreference.isLoading || localePreference.isLoading;
    final hasError = themePreference.hasError || localePreference.hasError;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountUserPreferencesLabel),
        leading: BackButton(
          onPressed: () {
            final router = GoRouter.maybeOf(context);
            if (router != null) {
              if (router.canPop()) {
                router.pop();
              } else {
                router.go('/account');
              }
              return;
            }
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: isLoading
          ? const LoadingState()
          : hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.errorLocalStorage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  l10n.accountThemeLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.accountThemeDetailsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: RadioGroup<ThemeMode>(
                    groupValue: selectedTheme,
                    onChanged: (mode) {
                      if (mode == null) return;
                      ref
                          .read(themeModePreferenceProvider.notifier)
                          .setThemeMode(mode);
                    },
                    child: Column(
                      children: [
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.system,
                          title: Text(l10n.accountThemeSystem),
                          subtitle: Text(l10n.accountThemeSystemDescription),
                          selected: selectedTheme == ThemeMode.system,
                          secondary: Icon(
                            Icons.brightness_auto_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Divider(),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.light,
                          title: Text(l10n.accountThemeLight),
                          selected: selectedTheme == ThemeMode.light,
                          secondary: Icon(
                            Icons.light_mode_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Divider(),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.dark,
                          title: Text(l10n.accountThemeDark),
                          selected: selectedTheme == ThemeMode.dark,
                          secondary: Icon(
                            Icons.dark_mode_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.accountLanguageLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.accountLanguageDetailsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: RadioGroup<AppLocalePreference>(
                    groupValue: selectedLocale,
                    onChanged: (preference) {
                      if (preference == null) return;
                      ref
                          .read(localePreferenceControllerProvider.notifier)
                          .setLocalePreference(preference);
                    },
                    child: Column(
                      children: [
                        RadioListTile<AppLocalePreference>(
                          value: AppLocalePreference.system,
                          title: Text(l10n.accountLanguageSystem),
                          subtitle: Text(l10n.accountLanguageSystemDescription),
                          selected:
                              selectedLocale == AppLocalePreference.system,
                          secondary: Icon(
                            Icons.language_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Divider(),
                        RadioListTile<AppLocalePreference>(
                          value: AppLocalePreference.en,
                          title: Text(l10n.accountLanguageEnglish),
                          selected: selectedLocale == AppLocalePreference.en,
                          secondary: Icon(
                            Icons.translate_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Divider(),
                        RadioListTile<AppLocalePreference>(
                          value: AppLocalePreference.de,
                          title: Text(l10n.accountLanguageGerman),
                          selected: selectedLocale == AppLocalePreference.de,
                          secondary: Icon(
                            Icons.translate_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Divider(),
                        RadioListTile<AppLocalePreference>(
                          value: AppLocalePreference.ar,
                          title: Text(l10n.accountLanguageArabic),
                          selected: selectedLocale == AppLocalePreference.ar,
                          secondary: Icon(
                            Icons.translate_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
