import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// Account privacy section: local processing, sync-off status, policy link,
/// and the existing preparatory cloud-consent controls.
class PrivacyAndProcessingSection extends StatelessWidget {
  const PrivacyAndProcessingSection({
    required this.onOpenPrivacyPolicy,
    super.key,
  });

  final VoidCallback onOpenPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.accountSectionPrivacy,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.accountPrivacyBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          PrivacyAndProcessingStatusCard(
            onOpenPrivacyPolicy: onOpenPrivacyPolicy,
          ),
          // TODO: Add back when cloud AI processing is enabled
          // const SizedBox(height: AppSpacing.sm),
          // const Card(
          //   child: Padding(
          //     padding: EdgeInsets.all(AppSpacing.md),
          //     child: AiProcessingConsentPanel(),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class PrivacyAndProcessingStatusCard extends StatelessWidget {
  const PrivacyAndProcessingStatusCard({
    required this.onOpenPrivacyPolicy,
    super.key,
  });

  final VoidCallback onOpenPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        children: [
          _StatusRow(
            icon: Icons.phonelink_lock_outlined,
            label: l10n.accountProcessingStatusLabel,
            value: l10n.accountProcessingStatusValue,
            body: l10n.accountProcessingStatusBody,
          ),
          const Divider(),
          _StatusRow(
            icon: Icons.cloud_off_outlined,
            label: l10n.accountSyncStatusLabel,
            value: l10n.accountSyncStatusValue,
            body: l10n.accountSyncStatusBody,
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.policy_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
            title: Text(l10n.accountPrivacyLabel),
            trailing: Icon(
              Icons.open_in_new,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: onOpenPrivacyPolicy,
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.body,
  });

  final IconData icon;
  final String label;
  final String value;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
