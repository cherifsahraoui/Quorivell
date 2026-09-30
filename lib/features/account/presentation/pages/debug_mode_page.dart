import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/providers/debug_ai_settings_providers.dart';

class DebugModePage extends ConsumerWidget {
  const DebugModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = ref.watch(debugAiSettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountDebugModePageTitle),
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
      body: settings.when(
        loading: () => const LoadingState(),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              failureMessage(l10n, error),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        data: (prefs) {
          final enabled = prefs?.debugModeEnabled ?? false;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Card(
                child: SwitchListTile(
                  value: enabled,
                  onChanged: (value) async {
                    try {
                      await ref
                          .read(debugAiSettingsControllerProvider.notifier)
                          .setEnabled(value);
                    } catch (error) {
                      if (!context.mounted) return;
                      showAppSnackBar(
                        context,
                        content: Text(failureMessage(l10n, error)),
                      );
                    }
                  },
                  title: Text(l10n.accountDebugModeToggleTitle),
                  subtitle: Text(l10n.accountDebugModeToggleSubtitle),
                  secondary: Icon(
                    Icons.bug_report_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              InfoCard(
                icon: Icons.lock_outline,
                title: l10n.accountDebugModePrivacyTitle,
                subtitle: l10n.accountDebugModePrivacyNote,
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.tune_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                title: Text(l10n.extractionSettingsAccountLabel),
                subtitle: Text(l10n.extractionSettingsAccountSubtitle),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => context.push('/account/extraction'),
              ),
            ],
          );
        },
      ),
    );
  }
}
