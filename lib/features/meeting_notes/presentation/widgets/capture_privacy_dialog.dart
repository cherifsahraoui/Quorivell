import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Explains that capture uses on-device AI by default and that cloud access
/// is opt-in (not available yet).
Future<void> showCapturePrivacyDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.welcomeFeature1Title),
        content: Text(l10n.capturePrivacyDialogBody),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.capturePrivacyDialogDismiss),
          ),
        ],
      );
    },
  );
}
