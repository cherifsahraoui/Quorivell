import 'package:flutter/material.dart';

import '../layout/shell_bottom_inset.dart';
import '../theme/app_spacing.dart';

/// Shows a floating [SnackBar] that clears the shell bottom nav + Ledger FAB.
///
/// Prefer this over raw [ScaffoldMessenger.showSnackBar] on shell tabs so error
/// and success toasts never hide under the raised center control.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showAppSnackBar(
  BuildContext context, {
  required Widget content,
  SnackBarAction? action,
  Duration duration = const Duration(milliseconds: 4000),
  bool clearMaterialBanners = false,
}) {
  final messenger = ScaffoldMessenger.of(context);
  if (clearMaterialBanners) {
    messenger.clearMaterialBanners();
  }
  messenger.clearSnackBars();
  return messenger.showSnackBar(
    SnackBar(
      content: content,
      action: action,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        ShellBottomInset.snackBarBottom(context),
      ),
    ),
  );
}
