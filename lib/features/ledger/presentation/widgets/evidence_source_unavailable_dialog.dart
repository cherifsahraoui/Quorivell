import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Explains that ledger evidence can no longer open a deleted source.
Future<void> showEvidenceSourceUnavailableDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.ledgerEvidenceSourceDeletedTitle),
        content: Text(l10n.ledgerEvidenceSourceDeletedBody),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.ledgerEvidenceSourceDeletedDismiss),
          ),
        ],
      );
    },
  );
}
