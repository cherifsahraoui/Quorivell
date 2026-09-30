import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm removing an extraction run from history.
///
/// Returns `true` only when the destructive action is confirmed.
Future<bool> confirmDeleteExtractionRun(BuildContext context) {
  return confirmDeleteExtractionRuns(context, count: 1);
}

/// Asks the user to confirm removing one or more extraction runs.
Future<bool> confirmDeleteExtractionRuns(
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
          isBulk
              ? l10n.extractionHistoryBulkDeleteTitle(count)
              : l10n.extractionHistoryDeleteTitle,
        ),
        content: Text(
          isBulk
              ? l10n.extractionHistoryBulkDeleteBody
              : l10n.extractionHistoryDeleteBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.extractionHistoryDeleteCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.extractionHistoryDeleteConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
