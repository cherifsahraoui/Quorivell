import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/platform/notification_permission_prompt.dart';
import '../../../../core/platform/notification_permission_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class NotificationPermissionCard extends ConsumerWidget {
  const NotificationPermissionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final permission = ref.watch(notificationPermissionControllerProvider);
    final decisionAsync = ref.watch(
      notificationPermissionPromptDecisionControllerProvider,
    );

    return permission.maybeWhen(
      data: (status) {
        final decision =
            decisionAsync.asData?.value ??
            NotificationPermissionPromptDecision.neverAsked;

        switch (status) {
          case NotificationPermissionStatus.granted:
          case NotificationPermissionStatus.notApplicable:
            return const SizedBox.shrink();

          case NotificationPermissionStatus.permanentlyDenied:
            return Card(
              color: colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_off,
                          color: colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.accountNotificationPermissionDeniedTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.accountNotificationPermissionDeniedBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.icon(
                      onPressed: () async {
                        await ref
                            .read(
                              notificationPermissionControllerProvider.notifier,
                            )
                            .openSettings();
                      },
                      icon: const Icon(Icons.settings),
                      label: Text(
                        l10n.accountNotificationPermissionOpenSettings,
                      ),
                    ),
                  ],
                ),
              ),
            );

          case NotificationPermissionStatus.denied:
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications, color: colorScheme.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.accountNotificationPermissionTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.accountNotificationPermissionBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.accountNotificationPermissionReason,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.icon(
                      onPressed: () async {
                        await ref
                            .read(
                              notificationPermissionControllerProvider.notifier,
                            )
                            .enableFromUi();
                      },
                      icon: const Icon(Icons.notifications_active),
                      label: Text(l10n.accountNotificationPermissionAllow),
                    ),
                    if (decision ==
                        NotificationPermissionPromptDecision.neverAsked) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: () async {
                          await ref
                              .read(
                                notificationPermissionControllerProvider
                                    .notifier,
                              )
                              .defer();
                        },
                        child: Text(l10n.accountNotificationPermissionNotNow),
                      ),
                    ],
                  ],
                ),
              ),
            );
        }
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
