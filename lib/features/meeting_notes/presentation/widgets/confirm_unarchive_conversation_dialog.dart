import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm restoring an archived conversation to Active.
///
/// Returns `true` only when restore is confirmed.
Future<bool> confirmUnarchiveConversation(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.conversationUnarchiveTitle),
        content: Text(l10n.conversationUnarchiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.conversationDeleteCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.conversationUnarchiveConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
