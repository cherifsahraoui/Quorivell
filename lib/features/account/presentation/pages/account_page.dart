import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ai/local_model_store.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/platform/app_package_info.dart';
import '../../../../core/platform/open_external_url.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/data/providers/onboarding_providers.dart';
import '../../../onboarding/presentation/controllers/local_model_install_controller.dart';
import '../../data/providers/locale_preference_providers.dart';
import '../../data/providers/theme_preference_providers.dart';
import '../../domain/entities/user_preference.dart';
import '../controllers/clear_app_data_controller.dart';
import '../widgets/android_incoming_actions_card.dart';
import '../widgets/battery_optimization_card.dart';
import '../widgets/confirm_clear_app_data_dialog.dart';
import '../widgets/notification_permission_card.dart';
import '../widgets/privacy_and_processing_section.dart';
import '../../../../core/layout/shell_bottom_inset.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SectionHeader(
            title: l10n.accountTitle,
            subtitle: l10n.accountSubtitle,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              l10n.accountSectionPreferences,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              child: Column(
                children: [
                  const _AccountUserPreferencesTile(),
                  const Divider(),
                  const _AccountExtractionSettingsTile(),
                  const Divider(),
                  const _AccountDebugModeTile(),
                  const Divider(),
                  const _AccountModelTile(),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(
          child: PrivacyAndProcessingSection(
            onOpenPrivacyPolicy: () {
              openExternalUrl(Uri.parse(AppConfig.privacyPolicyUrl));
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: NotificationPermissionCard(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: BatteryOptimizationCard(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              l10n.accountSectionAbout,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AndroidIncomingActionsCard(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(child: _AccountVersionTile()),
          ),
        ),
        if (kDebugMode) ...[
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                l10n.accountSectionDebug,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.delete_forever_outlined,
                        color: colorScheme.error,
                      ),
                      title: Text(l10n.accountDebugClearAppData),
                      subtitle: Text(l10n.accountDebugClearAppDataSubtitle),
                      onTap: () async {
                        final confirmed = await confirmClearAppData(context);
                        if (!confirmed || !context.mounted) return;
                        try {
                          await ref
                              .read(clearAppDataControllerProvider.notifier)
                              .clearUserContent();
                          if (!context.mounted) return;
                          showAppSnackBar(
                            context,
                            content: Text(l10n.accountDebugClearAppDataDone),
                          );
                        } catch (error) {
                          if (!context.mounted) return;
                          showAppSnackBar(
                            context,
                            content: Text(failureMessage(l10n, error)),
                          );
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      title: Text(l10n.accountDebugClearPreferences),
                      subtitle: Text(l10n.accountDebugClearPreferencesSubtitle),
                      onTap: () async {
                        await ref
                            .read(onboardingStateProvider.notifier)
                            .clearLocalPreferences();
                        await ref
                            .read(themeModePreferenceProvider.notifier)
                            .clear();
                        await ref
                            .read(localePreferenceControllerProvider.notifier)
                            .clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.xxl + ShellBottomInset.listFabClearance(context),
          ),
        ),
      ],
    );
  }
}

class _AccountVersionTile extends ConsumerWidget {
  const _AccountVersionTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final version = ref.watch(appPackageVersionProvider);

    return ListTile(
      leading: Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant),
      title: Text(l10n.accountVersionLabel),
      subtitle: version.when(
        data: (value) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            l10n.accountVersionValue(value.versionName),
            textDirection: TextDirection.ltr,
          ),
        ),
        loading: () => const Align(
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
            widthFactor: 0.4,
            child: LinearProgressIndicator(),
          ),
        ),
        error: (_, _) => Text(l10n.accountVersionUnavailable),
      ),
    );
  }
}

class _AccountUserPreferencesTile extends ConsumerWidget {
  const _AccountUserPreferencesTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode =
        ref.watch(themeModePreferenceProvider).asData?.value ??
        ThemeMode.system;
    final localePreference =
        ref.watch(localePreferenceControllerProvider).asData?.value ??
        AppLocalePreference.system;
    final themeLabel = switch (themeMode) {
      ThemeMode.light => l10n.accountThemeLight,
      ThemeMode.dark => l10n.accountThemeDark,
      ThemeMode.system => l10n.accountThemeSystem,
    };
    final languageLabel = switch (localePreference) {
      AppLocalePreference.system => l10n.accountLanguageSystem,
      AppLocalePreference.en => l10n.accountLanguageEnglish,
      AppLocalePreference.de => l10n.accountLanguageGerman,
      AppLocalePreference.ar => l10n.accountLanguageArabic,
    };

    return ListTile(
      leading: Icon(Icons.tune_outlined, color: colorScheme.onSurfaceVariant),
      title: Text(l10n.accountUserPreferencesLabel),
      subtitle: Text(
        l10n.accountUserPreferencesSubtitle(themeLabel, languageLabel),
      ),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: () => context.push('/account/preferences'),
    );
  }
}

class _AccountExtractionSettingsTile extends StatelessWidget {
  const _AccountExtractionSettingsTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(Icons.tune_outlined, color: colorScheme.onSurfaceVariant),
      title: Text(l10n.extractionSettingsAccountLabel),
      subtitle: Text(l10n.extractionSettingsAccountSubtitle),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: () => context.push('/account/extraction'),
    );
  }
}

class _AccountDebugModeTile extends StatelessWidget {
  const _AccountDebugModeTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        Icons.bug_report_outlined,
        color: colorScheme.onSurfaceVariant,
      ),
      title: Text(l10n.accountDebugModeLabel),
      subtitle: Text(l10n.accountDebugModeSubtitle),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: () => context.push('/account/debug'),
    );
  }
}

class _AccountModelTile extends ConsumerWidget {
  const _AccountModelTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final snapshot = ref
        .watch(localModelInstallControllerProvider)
        .asData
        ?.value;
    final subtitle = snapshot?.isReady == true
        ? switch (snapshot?.origin) {
            LocalModelOrigin.download => l10n.accountModelOriginDownload,
            LocalModelOrigin.import => l10n.accountModelOriginImport,
            null => l10n.accountModelStatusReady,
          }
        : l10n.accountModelNotConfigured;

    return ListTile(
      leading: Icon(Icons.memory_outlined, color: colorScheme.onSurfaceVariant),
      title: Text(l10n.accountModelDetailsLabel),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: () => context.push('/account/model'),
    );
  }
}
