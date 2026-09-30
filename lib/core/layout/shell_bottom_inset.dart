import 'package:flutter/material.dart';

import 'app_breakpoints.dart';
import '../theme/app_spacing.dart';

/// Whether content under [AppShell] is already clear of the raised Ledger FAB.
///
/// True when Capture / Chat grow the nav chrome, or on navigation-rail layouts.
/// Review / Ledger / Account extend the body under the notched bar instead, so
/// sticky bars and list helpers add their own FAB gap on those tabs.
class ShellFabClearance extends InheritedWidget {
  const ShellFabClearance({
    required this.reservesClearance,
    required super.child,
    super.key,
  });

  final bool reservesClearance;

  static bool maybeOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ShellFabClearance>()
            ?.reservesClearance ??
        false;
  }

  @override
  bool updateShouldNotify(ShellFabClearance oldWidget) =>
      reservesClearance != oldWidget.reservesClearance;
}

/// Shared bottom-chrome metrics for the raised Ledger FAB + bottom nav.
///
/// [AppShell] keeps its private layout in sync with these values. Phone tabs
/// that omit nav FAB clearance extend the body under the notch (transparent
/// raised Ledger control); list helpers and sticky bars supply scroll / action
/// clearance. Kind-control height helpers remain for widgets outside the shell.
abstract final class ShellBottomInset {
  static const double barHeight = 72;
  static const double fabRadius = 28;
  static const double fabRingPadding = AppSpacing.xs;

  /// Outer radius of the ringed center control (matches the bar notch).
  static const double fabOuterRadius = fabRadius + fabRingPadding;

  /// Height budget for a kind SegmentedButton / Switch / dropdown row.
  static const double kindControlHeight = AppSpacing.xxl;

  /// FAB protrusion + breathing room (nav growth or shell body pad).
  static const double raisedFabPad = fabOuterRadius + AppSpacing.md;

  /// Extra scroll padding so the last list row clears the raised Ledger FAB.
  ///
  /// Returns 0 on rail layouts and when [ShellFabClearance] already reserved
  /// space (shell nav growth or shell body pad).
  static double listFabClearance(BuildContext context) {
    if (appWindowSizeOf(context).useNavigationRail) return 0;
    if (ShellFabClearance.maybeOf(context)) return 0;
    return raisedFabPad;
  }

  /// Gap below a sticky primary action when the shell did not reserve FAB space.
  ///
  /// Smaller than [listFabClearance]: the action strip already has md padding
  /// under the button, so only the raised control’s protrusion is needed.
  static double stickyFabGap(BuildContext context) {
    if (appWindowSizeOf(context).useNavigationRail) return 0;
    if (ShellFabClearance.maybeOf(context)) return 0;
    return fabOuterRadius;
  }

  /// Forever-reusable padding for screens that show kind controls near the
  /// bottom chrome (Review kind toggle, Extraction kinds switches, etc.).
  ///
  /// When [ShellFabClearance] already cleared the raised FAB (nav growth or
  /// rail), returns 0 — content ending at the body bottom is already above the
  /// control. Otherwise adds FAB protrusion plus a kind-row budget.
  static double kindControlsClearance(BuildContext context) {
    if (appWindowSizeOf(context).useNavigationRail) return 0;
    if (ShellFabClearance.maybeOf(context)) return 0;
    return fabOuterRadius + kindControlHeight + AppSpacing.md;
  }

  /// Bottom margin for floating SnackBars so they sit above the raised FAB.
  static double snackBarBottom(BuildContext context) {
    if (appWindowSizeOf(context).useNavigationRail) {
      return AppSpacing.md + MediaQuery.viewPaddingOf(context).bottom;
    }
    return fabOuterRadius + AppSpacing.sm;
  }

  /// List padding that preserves [base] while adding permanent FAB clearance.
  static EdgeInsets listPadding(
    BuildContext context, {
    EdgeInsets base = const EdgeInsets.all(AppSpacing.lg),
  }) {
    return base.copyWith(bottom: base.bottom + listFabClearance(context));
  }

  /// List padding that clears the raised FAB **and** a kind control row.
  static EdgeInsets kindControlsPadding(
    BuildContext context, {
    EdgeInsets base = const EdgeInsets.all(AppSpacing.lg),
  }) {
    return base.copyWith(bottom: base.bottom + kindControlsClearance(context));
  }
}
