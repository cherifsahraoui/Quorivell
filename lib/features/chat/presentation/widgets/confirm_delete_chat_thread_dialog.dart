import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm hiding a local AI chat thread.
///
/// Returns `true` only when the destructive action is confirmed.
Future<bool> confirmDeleteChatThread(BuildContext context) {
  return confirmDeleteChatThreads(context, count: 1);
}

/// Asks the user to confirm removing one or more chat threads.
Future<bool> confirmDeleteChatThreads(
  BuildContext context, {
  required int count,
}) async {
  final l10n = AppLocalizations.of(context);
  final colorScheme = Theme.of(context).colorScheme;
  final isBulk = count > 1;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          isBulk ? l10n.chatBulkDeleteTitle(count) : l10n.chatDeleteTitle,
        ),
        content: Text(isBulk ? l10n.chatBulkDeleteBody : l10n.chatDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.chatDeleteCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.chatDeleteConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
