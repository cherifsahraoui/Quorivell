import 'package:flutter/material.dart';

import '../layout/shell_bottom_inset.dart';
import '../theme/app_spacing.dart';

/// Shared screen shell that keeps content clear of local and shell FABs.
///
/// Under [AppShell], raised Ledger FAB clearance is already applied via nav
/// growth on Capture / Chat ([ShellFabClearance]). On Review / Ledger / Account
/// the body extends under the notch, so this scaffold adds list FAB clearance
/// (and space for a page-local [floatingActionButton] when present).
///
/// Prefer this over hand-rolled bottom padding on nested shell routes.
class QuorivellScaffold extends StatelessWidget {
  const QuorivellScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.reserveFabClearance = true,
    this.clearKindControls = false,
    this.fabClearance,
    super.key,
  });

  /// Space so list content can scroll clear of a page-local extended FAB.
  ///
  /// Sized to the control (~48) plus Material’s default FAB margin (~16).
  static const double localFabClearance = AppSpacing.xxl + AppSpacing.md;

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final bool reserveFabClearance;

  /// When true, bottom inset also clears a kind control row (Switch /
  /// SegmentedButton) above the raised Ledger FAB — only when the shell has
  /// not already reserved that space.
  final bool clearKindControls;
  final double? fabClearance;

  /// Bottom inset for list / scroll content under shell + local FABs.
  static double contentBottomInset({
    required BuildContext context,
    bool reserveFabClearance = true,
    bool hasLocalFab = false,
    bool clearKindControls = false,
    double? fabClearance,
  }) {
    if (!reserveFabClearance) return AppSpacing.lg;
    if (fabClearance != null) return fabClearance;

    final shell = clearKindControls
        ? ShellBottomInset.kindControlsClearance(context)
        : ShellBottomInset.listFabClearance(context);

    if (hasLocalFab) return shell + localFabClearance;
    if (shell > 0) return shell + AppSpacing.lg;
    // Shell already cleared the raised FAB; keep a small breathing room.
    return AppSpacing.lg;
  }

  /// Convenient [EdgeInsets] for [ListView] / [CustomScrollView] padding when
  /// the page is *not* wrapped in [QuorivellScaffold] (shell body tabs).
  static EdgeInsets scrollPadding({
    required BuildContext context,
    double horizontal = AppSpacing.lg,
    double top = 0,
    bool reserveFabClearance = true,
    bool hasLocalFab = false,
    bool clearKindControls = false,
    double? fabClearance,
  }) {
    return EdgeInsets.fromLTRB(
      horizontal,
      top,
      horizontal,
      contentBottomInset(
        context: context,
        reserveFabClearance: reserveFabClearance,
        hasLocalFab: hasLocalFab,
        clearKindControls: clearKindControls,
        fabClearance: fabClearance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLocalFab = floatingActionButton != null;
    final bottom = contentBottomInset(
      context: context,
      reserveFabClearance: reserveFabClearance,
      hasLocalFab: hasLocalFab,
      clearKindControls: clearKindControls,
      fabClearance: fabClearance,
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: body,
      ),
    );
  }
}
