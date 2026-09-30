import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Asks the user to confirm permanently hiding a captured conversation.
///
/// When [warnLedgerLinks] is true (archived sources linked from the ledger),
/// the body explains that evidence deep-links will stop working.
///
/// Returns `true` only when the destructive action is confirmed.
Future<bool> confirmDeleteConversation(
  BuildContext context, {
  bool warnLedgerLinks = false,
}) {
  return confirmDeleteConversations(
    context,
    count: 1,
    warnLedgerLinks: warnLedgerLinks,
  );
}

/// Asks the user to confirm removing one or more captured conversations.
Future<bool> confirmDeleteConversations(
  BuildContext context, {
  required int count,
  bool warnLedgerLinks = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final colorScheme = Theme.of(context).colorScheme;
  final isBulk = count > 1;
  final String body;
  if (warnLedgerLinks) {
    body = isBulk
        ? l10n.conversationBulkDeleteBodyWithLedgerLinks
        : l10n.conversationDeleteBodyWithLedgerLinks;
  } else {
    body = isBulk
        ? l10n.conversationBulkDeleteBody
        : l10n.conversationDeleteBody;
  }
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          isBulk
              ? l10n.conversationBulkDeleteTitle(count)
              : l10n.conversationDeleteTitle,
        ),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.conversationDeleteCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.conversationDeleteConfirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
