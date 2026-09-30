import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm removing a custom extraction kind.
///
/// Returns `true` only when the destructive action is confirmed.
Future<bool> confirmDeleteExtractionKind(BuildContext context) {
  return confirmDeleteExtractionKinds(context, count: 1);
}

/// Asks the user to confirm removing one or more custom extraction kinds.
Future<bool> confirmDeleteExtractionKinds(
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
              ? l10n.extractionKindsBulkDeleteTitle(count)
              : l10n.extractionKindsDeleteTitle,
        ),
        content: Text(
          isBulk
              ? l10n.extractionKindsBulkDeleteBody
              : l10n.extractionKindsDeleteBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.extractionKindsDeleteCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.extractionKindsDeleteConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
