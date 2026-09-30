import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm removing a ledger item from this device.
Future<bool> confirmDeleteLedgerItem(BuildContext context) {
  return confirmDeleteLedgerItems(context, count: 1);
}

/// Asks the user to confirm removing one or more ledger items.
Future<bool> confirmDeleteLedgerItems(
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
          isBulk ? l10n.ledgerBulkDeleteTitle(count) : l10n.ledgerDeleteTitle,
        ),
        content: Text(
          isBulk ? l10n.ledgerBulkDeleteBody : l10n.ledgerDeleteBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.ledgerDeleteCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.ledgerDeleteConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
