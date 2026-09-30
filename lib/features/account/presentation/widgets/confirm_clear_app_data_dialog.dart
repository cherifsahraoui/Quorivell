import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm permanently deleting local app content.
///
/// Returns `true` only when the destructive action is confirmed.
Future<bool> confirmClearAppData(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final colorScheme = Theme.of(context).colorScheme;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.accountDebugClearAppDataTitle),
        content: Text(l10n.accountDebugClearAppDataBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.accountDebugClearAppDataCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.accountDebugClearAppDataConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
