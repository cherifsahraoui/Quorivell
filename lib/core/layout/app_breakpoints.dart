import 'package:flutter/material.dart';

/// Material 3 window-size breakpoints used across Quorivell.
///
/// Width classes map to the Play Store device buckets we ship:
/// - compact (&lt; 600): phone
/// - medium (600–839): typical 7" tablet
/// - expanded (≥ 840): typical 10" tablet / large landscape
abstract final class AppBreakpoints {
  static const double compactMax = 600;
  static const double mediumMax = 840;

  /// Readable column width for form-heavy pages on large tablets.
  static const double contentMaxWidth = 840;

  /// Wider column for list-heavy pages on 10" class devices.
  static const double contentMaxWidthExpanded = 1080;
}

enum AppWindowSize { compact, medium, expanded }

extension AppWindowSizeX on AppWindowSize {
  bool get isCompact => this == AppWindowSize.compact;
  bool get isMedium => this == AppWindowSize.medium;
  bool get isExpanded => this == AppWindowSize.expanded;
  bool get useNavigationRail => !isCompact;
}

AppWindowSize appWindowSizeForWidth(double width) {
  if (width < AppBreakpoints.compactMax) {
    return AppWindowSize.compact;
  }
  if (width < AppBreakpoints.mediumMax) {
    return AppWindowSize.medium;
  }
  return AppWindowSize.expanded;
}

AppWindowSize appWindowSizeOf(BuildContext context) {
  return appWindowSizeForWidth(MediaQuery.sizeOf(context).width);
}

/// Whether the available area is wide enough for a split (side-by-side) layout.
bool appUsesSplitLayout(BoxConstraints constraints) {
  return constraints.maxWidth >= AppBreakpoints.compactMax ||
      constraints.maxWidth > constraints.maxHeight;
}
