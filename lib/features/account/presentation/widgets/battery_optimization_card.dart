import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/platform/background_work_constraint_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class BatteryOptimizationCard extends ConsumerWidget {
  const BatteryOptimizationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final constraintsAsync = ref.watch(
      backgroundWorkConstraintControllerProvider,
    );

    return constraintsAsync.maybeWhen(
      data: (constraints) {
        final visual = switch (constraints.accountCardKind) {
          BackgroundWorkAccountCardKind.hidden => null,
          BackgroundWorkAccountCardKind.restricted => _CardVisual(
            title: l10n.accountBatteryGuidanceRestrictedTitle,
            body: l10n.accountBatteryGuidanceRestrictedBody,
            icon: Icons.battery_alert_outlined,
            cardColor: colorScheme.errorContainer,
            contentColor: colorScheme.onErrorContainer,
            bodyColor: colorScheme.onErrorContainer,
            emphasizedAction: true,
          ),
          BackgroundWorkAccountCardKind.oemAllowlist => _CardVisual(
            title: l10n.accountBatteryGuidanceOemTitle,
            body: l10n.accountBatteryGuidanceOemBody,
            icon: Icons.phonelink_setup_outlined,
            cardColor: colorScheme.secondaryContainer,
            contentColor: colorScheme.onSecondaryContainer,
            bodyColor: colorScheme.onSecondaryContainer,
            emphasizedAction: true,
          ),
          BackgroundWorkAccountCardKind.batterySaver => _CardVisual(
            title: l10n.accountBatteryGuidanceBatterySaverTitle,
            body: l10n.accountBatteryGuidanceBatterySaverBody,
            icon: Icons.battery_saver_outlined,
            cardColor: colorScheme.tertiaryContainer,
            contentColor: colorScheme.onTertiaryContainer,
            bodyColor: colorScheme.onTertiaryContainer,
            emphasizedAction: true,
          ),
          BackgroundWorkAccountCardKind.informational => _CardVisual(
            title: l10n.accountBatteryGuidanceTitle,
            body: l10n.accountBatteryGuidanceBody,
            icon: Icons.battery_std_outlined,
            contentColor: colorScheme.onSurface,
            bodyColor: colorScheme.onSurfaceVariant,
            emphasizedAction: false,
          ),
        };
        if (visual == null) {
          return const SizedBox.shrink();
        }

        return _BatteryOptimizationCardBody(
          visual: visual,
          openSettingsLabel: l10n.accountBatteryGuidanceOpenSettings,
          onOpenSettings: () => ref
              .read(backgroundWorkConstraintControllerProvider.notifier)
              .openSettingsAndRefresh(),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _CardVisual {
  const _CardVisual({
    required this.title,
    required this.body,
    required this.icon,
    this.cardColor,
    required this.contentColor,
    required this.bodyColor,
    required this.emphasizedAction,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color? cardColor;
  final Color contentColor;
  final Color bodyColor;
  final bool emphasizedAction;
}

class _BatteryOptimizationCardBody extends StatelessWidget {
  const _BatteryOptimizationCardBody({
    required this.visual,
    required this.openSettingsLabel,
    required this.onOpenSettings,
  });

  final _CardVisual visual;
  final String openSettingsLabel;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final action = visual.emphasizedAction
        ? FilledButton.icon(
            onPressed: onOpenSettings,
            icon: const Icon(Icons.settings),
            label: Text(openSettingsLabel),
          )
        : OutlinedButton.icon(
            onPressed: onOpenSettings,
            icon: const Icon(Icons.settings),
            label: Text(openSettingsLabel),
          );

    return Card(
      color: visual.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(visual.icon, color: visual.contentColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    visual.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: visual.contentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              visual.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: visual.bodyColor,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            action,
          ],
        ),
      ),
    );
  }
}
