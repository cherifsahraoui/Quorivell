import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import 'controllers/local_model_install_controller.dart';

enum LocalModelGateResult { ready, dismissed, configure }

/// Returns [LocalModelGateResult.ready] when a verified on-device model is
/// installed. Otherwise shows a dialog so the user can open model setup.
Future<LocalModelGateResult> ensureLocalModelConfigured({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final snapshot = await ref.read(localModelInstallControllerProvider.future);
  if (snapshot.isReady) return LocalModelGateResult.ready;
  if (!context.mounted) return LocalModelGateResult.dismissed;

  final l10n = AppLocalizations.of(context);
  final configure = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.localModelRequiredTitle),
        content: Text(l10n.localModelRequiredBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.localModelRequiredDismiss),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.localModelRequiredConfigure),
          ),
        ],
      );
    },
  );

  return configure == true
      ? LocalModelGateResult.configure
      : LocalModelGateResult.dismissed;
}
