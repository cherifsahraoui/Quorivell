import 'package:flutter/material.dart';

import '../layout/shell_bottom_inset.dart';
import '../theme/app_spacing.dart';

/// Sticky primary action that stays at the bottom of a form page body.
///
/// Matches Capture’s save chrome: surface strip + hairline + filled button.
/// Place as the trailing child of a [Column] with an [Expanded] scroll view
/// so the control stays visible while editing and rides above the keyboard
/// when the shell scaffold resizes.
///
/// On Capture / Chat, [AppShell] already clears the raised Ledger FAB (nav
/// growth) via [ShellFabClearance]. On Review / Ledger / Account the body
/// extends under the notch, so extra gap is added here. Skip the gap while the
/// keyboard is open — the FAB is covered anyway and the save control should
/// sit tight above the IME.
class StickyPrimaryActionBar extends StatefulWidget {
  const StickyPrimaryActionBar({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.clearRaisedFab = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  /// Extra bottom gap so the raised Ledger FAB does not cover the button.
  ///
  /// Ignored when [ShellFabClearance] reports the shell already reserved that
  /// space (Capture / Chat). Prefer leaving this true so Account / Review /
  /// Ledger forms clear the floating Ledger control.
  final bool clearRaisedFab;

  /// IME bottom inset that survives a parent [Scaffold] consuming viewInsets.
  ///
  /// [AppShell] wraps tab bodies in a [Scaffold] with a bottom nav, so nested
  /// form scaffolds always see [MediaQuery.viewInsets] as zero. Walk ancestor
  /// [MediaQuery] widgets, then fall back to platform [FlutterView] metrics.
  @visibleForTesting
  static double imeBottomInset(BuildContext context) {
    final inherited = MediaQuery.viewInsetsOf(context).bottom;
    if (inherited > 0) return inherited;

    var ancestorInset = 0.0;
    context.visitAncestorElements((element) {
      final widget = element.widget;
      if (widget is MediaQuery) {
        final bottom = widget.data.viewInsets.bottom;
        if (bottom > ancestorInset) ancestorInset = bottom;
      }
      return true;
    });
    if (ancestorInset > 0) return ancestorInset;

    return MediaQueryData.fromView(View.of(context)).viewInsets.bottom;
  }

  @override
  State<StickyPrimaryActionBar> createState() => _StickyPrimaryActionBarState();
}

class _StickyPrimaryActionBarState extends State<StickyPrimaryActionBar>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Parent [AppShell] Scaffold clears [MediaQuery.viewInsets] for the body,
    // so aspect-scoped MediaQuery dependents never see the IME open. Rebuild
    // from platform metrics instead.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final keyboardOpen = StickyPrimaryActionBar.imeBottomInset(context) > 0;
    final shellReservesFab = ShellFabClearance.maybeOf(context);
    // Transparent gap below the painted strip — Material already has md bottom
    // padding, so only the FAB protrusion is needed (not full listFabClearance).
    final fabGap = widget.clearRaisedFab && !keyboardOpen && !shellReservesFab
        ? ShellBottomInset.stickyFabGap(context)
        : 0.0;

    final Widget button;
    if (widget.isLoading) {
      button = FilledButton.icon(
        onPressed: null,
        icon: SizedBox.square(
          dimension: AppSpacing.lg - AppSpacing.xs,
          child: const ExcludeSemantics(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        label: Text(widget.label),
      );
    } else if (widget.icon != null) {
      button = FilledButton.icon(
        onPressed: widget.onPressed,
        icon: Icon(widget.icon),
        label: Text(widget.label),
      );
    } else {
      button = FilledButton(
        onPressed: widget.onPressed,
        child: Text(widget.label),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, color: colorScheme.outlineVariant),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: SizedBox(width: double.infinity, child: button),
              ),
            ],
          ),
        ),
        if (fabGap > 0) SizedBox(height: fabGap),
      ],
    );
  }
}
