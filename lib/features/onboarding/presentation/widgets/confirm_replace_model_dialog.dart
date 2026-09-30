import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm replacing the installed GGUF with a new download.
///
/// Returns `true` only when replacement is confirmed.
Future<bool> confirmReplaceInstalledModel(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final colorScheme = Theme.of(context).colorScheme;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.accountModelReplaceTitle),
        content: Text(l10n.accountModelReplaceBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.accountModelReplaceCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.accountModelReplaceConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
