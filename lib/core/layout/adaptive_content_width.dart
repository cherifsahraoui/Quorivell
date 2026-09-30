import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

/// Centers [child] and caps its width on tablet / large screens.
///
/// Phone (compact) stays full-bleed. Medium and expanded sizes use
/// [AppBreakpoints.contentMaxWidth] so Capture / Account forms stay readable
/// on 7" and 10" tablets.
class AdaptiveContentWidth extends StatelessWidget {
  const AdaptiveContentWidth({required this.child, this.maxWidth, super.key});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final size = appWindowSizeOf(context);
    if (size.isCompact) {
      return child;
    }

    final cap =
        maxWidth ??
        (size.isExpanded
            ? AppBreakpoints.contentMaxWidthExpanded
            : AppBreakpoints.contentMaxWidth);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: cap),
        child: child,
      ),
    );
  }
}
