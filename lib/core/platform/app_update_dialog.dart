import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_spacing.dart';
import 'app_update_check.dart';
import 'open_external_url.dart';

Future<void> showAppUpdateAvailableDialog({
  required BuildContext context,
  required WidgetRef ref,
  required AppUpdateAvailability availability,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        icon: const Icon(Icons.system_update_alt_outlined),
        title: Text(l10n.appUpdateAvailableTitle),
        content: SingleChildScrollView(
          child: Text(
            l10n.appUpdateAvailableBody(
              availability.latestVersion,
              availability.installedVersion,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(appUpdatePromptControllerProvider.notifier)
                  .snooze(version: availability.latestVersion);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(l10n.appUpdateLater),
          ),
          FilledButton(
            onPressed: () async {
              await openExternalUrl(Uri.parse(availability.storeUrl));
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(l10n.appUpdateOpenStore),
          ),
        ],
      );
    },
  );
}
