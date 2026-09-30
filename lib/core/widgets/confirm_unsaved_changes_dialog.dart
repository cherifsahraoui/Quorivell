import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Result of the unsaved-changes leave confirmation.
enum UnsavedChangesAction {
  /// Stay on the form.
  keepEditing,

  /// Leave without persisting.
  discard,

  /// Persist, then leave (caller runs save).
  save,
}

/// Asks whether to discard, save, or keep editing when a form has unsaved work.
///
/// Returns [UnsavedChangesAction.keepEditing] if the dialog is dismissed.
Future<UnsavedChangesAction> confirmUnsavedChanges(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final colorScheme = Theme.of(context).colorScheme;
  final result = await showDialog<UnsavedChangesAction>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.unsavedChangesTitle),
        content: Text(l10n.unsavedChangesBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(
              dialogContext,
            ).pop(UnsavedChangesAction.keepEditing),
            child: Text(l10n.unsavedChangesKeepEditing),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            onPressed: () =>
                Navigator.of(dialogContext).pop(UnsavedChangesAction.discard),
            child: Text(l10n.unsavedChangesDiscard),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(UnsavedChangesAction.save),
            child: Text(l10n.unsavedChangesSave),
          ),
        ],
      );
    },
  );
  return result ?? UnsavedChangesAction.keepEditing;
}
