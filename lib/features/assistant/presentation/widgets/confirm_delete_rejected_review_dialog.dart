import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm permanently hiding a rejected review suggestion.
///
/// Returns `true` only when the destructive action is confirmed.
Future<bool> confirmDeleteRejectedReview(BuildContext context) {
  return confirmDeleteRejectedReviews(context, count: 1);
}

/// Asks the user to confirm removing one or more rejected suggestions.
Future<bool> confirmDeleteRejectedReviews(
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
              ? l10n.reviewRejectedBulkDeleteTitle(count)
              : l10n.reviewRejectedDeleteTitle,
        ),
        content: Text(
          isBulk
              ? l10n.reviewRejectedBulkDeleteBody
              : l10n.reviewRejectedDeleteBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.reviewRejectedDeleteCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.reviewRejectedDeleteConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
