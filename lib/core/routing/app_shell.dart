import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/assistant/presentation/controllers/review_controller.dart';
import '../../features/assistant/presentation/widgets/global_extraction_progress_overlay.dart';
import '../../features/chat/presentation/controllers/chat_conversation_visible_controller.dart';
import '../../features/chat/presentation/controllers/unread_chat_count_controller.dart';
import '../../features/chat/presentation/widgets/chat_visibility_host.dart';
import '../../features/meeting_notes/presentation/widgets/share_intent_host.dart';
import '../../l10n/app_localizations.dart';
import '../layout/adaptive_content_width.dart';
import '../layout/app_breakpoints.dart';
import '../layout/shell_bottom_inset.dart';
import '../platform/app_update_startup_host.dart';
import '../platform/notification_permission_startup_host.dart';
import '../theme/app_spacing.dart';
import '../theme/brand_assets.dart';
import 'notification_launch.dart';
import 'post_setup_home.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  /// Center-docked primary tab (Ledger).
  static const int ledgerBranchIndex = 2;

  /// Review tab index in the shell destination list.
  static const int reviewBranchIndex = 1;

  /// Capture tab — keeps FAB clearance for the sticky save bar.
  static const int captureBranchIndex = 0;

  /// Chat tab — keeps FAB clearance for the composer.
  static const int chatBranchIndex = 3;

  /// Tabs with a permanent bottom chrome that must clear the raised Ledger FAB.
  static bool reservesFabClearance(int branchIndex) =>
      branchIndex == captureBranchIndex || branchIndex == chatBranchIndex;

  static List<_ShellDestination> _destinations(
    AppLocalizations l10n, {
    required int pendingReviewCount,
    required int unreadChatCount,
  }) => [
    _ShellDestination(
      label: l10n.navCapture,
      icon: Icons.edit_note_outlined,
      selectedIcon: Icons.edit_note,
    ),
    _ShellDestination(
      label: l10n.navReview,
      icon: Icons.fact_check_outlined,
      selectedIcon: Icons.fact_check,
      badgeCount: pendingReviewCount,
      badgeSemanticsLabel: pendingReviewCount > 0
          ? l10n.navReviewPendingSemantics(pendingReviewCount)
          : null,
    ),
    _ShellDestination(
      label: l10n.navLedger,
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
      prominent: true,
    ),
    _ShellDestination(
      label: l10n.navChat,
      icon: Icons.auto_awesome_outlined,
      selectedIcon: Icons.auto_awesome,
      badgeCount: unreadChatCount,
      badgeSemanticsLabel: unreadChatCount > 0
          ? l10n.navChatUnreadSemantics(unreadChatCount)
          : null,
    ),
    _ShellDestination(
      label: l10n.navAccount,
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  /// Opens [index], always at that branch's root (not a nested push).
  ///
  /// Re-entering Account from another tab after Preferences must show Account
  /// again, not leave the nested preferences route active. Re-entering Chat
  /// keeps the current thread so an in-flight reply can finish in the
  /// background; use New chat to start over.
  void _goToBranchRoot(WidgetRef ref, int index) {
    ref
        .read(chatConversationVisibleControllerProvider.notifier)
        .setVisible(index == AppShell.chatBranchIndex);
    navigationShell.goBranch(index, initialLocation: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingReviewCountProvider) ?? 0;
    final unreadChatCount = ref.watch(unreadChatCountControllerProvider);
    final destinations = _destinations(
      AppLocalizations.of(context),
      pendingReviewCount: pendingCount,
      unreadChatCount: unreadChatCount,
    );
    final windowSize = appWindowSizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    // Rail layouts have no raised FAB. Phone Capture / Chat grow the nav so
    // sticky chrome sits on a surface strip. Review / Ledger / Account extend
    // the body under the notched bar so the raised Ledger control floats over
    // page content (no opaque horizontal fill); list helpers clear the FAB.
    final navReservesFabClearance =
        windowSize.useNavigationRail ||
        AppShell.reservesFabClearance(navigationShell.currentIndex);
    final extendBodyUnderFab =
        !windowSize.useNavigationRail &&
        !AppShell.reservesFabClearance(navigationShell.currentIndex);
    final body = SafeArea(
      child: ShellFabClearance(
        reservesClearance: navReservesFabClearance,
        child: AdaptiveContentWidth(child: navigationShell),
      ),
    );

    if (windowSize.useNavigationRail) {
      return Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      right: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                        width: 1,
                      ),
                    ),
                  ),
                  child: NavigationRail(
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: (index) =>
                        _goToBranchRoot(ref, index),
                    labelType: windowSize.isExpanded
                        ? NavigationRailLabelType.all
                        : NavigationRailLabelType.selected,
                    leading: const SizedBox(height: AppSpacing.md),
                    destinations: [
                      for (final item in destinations)
                        NavigationRailDestination(
                          icon: _ShellDestinationIcon(
                            destination: item,
                            selected: false,
                          ),
                          selectedIcon: _ShellDestinationIcon(
                            destination: item,
                            selected: true,
                          ),
                          label: Text(item.label),
                        ),
                    ],
                  ),
                ),
                Expanded(child: body),
              ],
            ),
            const GlobalExtractionProgressOverlay(),
            const AppUpdateStartupHost(),
            const NotificationPermissionStartupHost(),
            const NotificationLaunchHost(),
            const ChatVisibilityHost(),
            const ShareIntentHost(),
          ],
        ),
      );
    }

    // Keep the Ledger control in a layer above the Scaffold so its raised
    // half stays tappable on tabs that omit FAB clearance (Review / Account).
    // Inside [bottomNavigationBar] alone, overflow paints over the body but
    // loses hit testing to the body scroll view.
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final ledger = destinations[AppShell.ledgerBranchIndex];
    return Stack(
      children: [
        Scaffold(
          // Transparent notch around the raised Ledger control when there is no
          // Capture save bar / Chat composer strip above it.
          extendBody: extendBodyUnderFab,
          body: Stack(
            children: [
              body,
              const GlobalExtractionProgressOverlay(),
              const AppUpdateStartupHost(),
              const NotificationPermissionStartupHost(),
              const NotificationLaunchHost(),
              const ChatVisibilityHost(),
              const ShareIntentHost(),
            ],
          ),
          bottomNavigationBar: _ShellBottomNav(
            destinations: destinations,
            selectedIndex: navigationShell.currentIndex,
            // Only Capture / Chat grow the nav; other tabs use extendBody.
            reserveFabClearance: navReservesFabClearance,
            onDestinationSelected: (index) => _goToBranchRoot(ref, index),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom:
                  bottomInset +
                  _ShellBottomNav.barHeight -
                  _ShellBottomNav.centerOuterRadius,
            ),
            child: _CenterNavButton(
              label: ledger.label,
              selected:
                  navigationShell.currentIndex == AppShell.ledgerBranchIndex,
              radius: _ShellBottomNav.centerRadius,
              ringPadding: _ShellBottomNav.centerRingPadding,
              onTap: () => _goToBranchRoot(ref, AppShell.ledgerBranchIndex),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShellDestination {
  const _ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.prominent = false,
    this.badgeCount = 0,
    this.badgeSemanticsLabel,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool prominent;
  final int badgeCount;
  final String? badgeSemanticsLabel;
}

/// Notched bottom bar for side shell destinations.
///
/// Ledger sits in a semicircle cutout and is rendered by [AppShell] in a
/// layer above the Scaffold so the raised control stays tappable when
/// [reserveFabClearance] is false (Review / Ledger / Account).
///
/// [reserveFabClearance] keeps body content below the raised FAB (Capture /
/// Chat sticky chrome) with a surface strip in the nav. Other tabs omit that
/// gap and [AppShell] sets [Scaffold.extendBody] so page content shows through
/// the notch; list / sticky helpers clear the raised control themselves.
class _ShellBottomNav extends StatelessWidget {
  const _ShellBottomNav({
    required this.destinations,
    required this.selectedIndex,
    required this.reserveFabClearance,
    required this.onDestinationSelected,
  });

  final List<_ShellDestination> destinations;
  final int selectedIndex;
  final bool reserveFabClearance;
  final ValueChanged<int> onDestinationSelected;

  static const double barHeight = ShellBottomInset.barHeight;
  static const double centerRadius = ShellBottomInset.fabRadius;
  static const double centerRingPadding = ShellBottomInset.fabRingPadding;
  static const double _centerGapPadding = AppSpacing.md;

  /// Outer radius of the ringed center control (fits the bar notch).
  static const double centerOuterRadius = ShellBottomInset.fabOuterRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final left = <(int, _ShellDestination)>[
      for (var i = 0; i < destinations.length; i++)
        if (!destinations[i].prominent) (i, destinations[i]),
    ];
    final leftItems = left.take(left.length ~/ 2).toList();
    final rightItems = left.skip(left.length ~/ 2).toList();
    final fabClearance = reserveFabClearance ? centerOuterRadius : 0.0;

    return SizedBox(
      height: barHeight + fabClearance + bottomInset,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: colorScheme.surface,
          elevation: 4,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
          surfaceTintColor: colorScheme.surfaceTint,
          shape: _NotchedBottomBarShape(
            notchRadius: centerOuterRadius,
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.55),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SizedBox(
              height: barHeight,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (final (index, item) in leftItems)
                          Expanded(
                            child: _SideNavItem(
                              destination: item,
                              selected: selectedIndex == index,
                              onTap: () => onDestinationSelected(index),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: centerOuterRadius * 2 + _centerGapPadding),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (final (index, item) in rightItems)
                          Expanded(
                            child: _SideNavItem(
                              destination: item,
                              selected: selectedIndex == index,
                              onTap: () => onDestinationSelected(index),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Semicircle cutout along the top edge for the center-docked Ledger control.
class _NotchedBottomBarShape extends ShapeBorder {
  const _NotchedBottomBarShape({
    required this.notchRadius,
    this.side = BorderSide.none,
  });

  final double notchRadius;
  final BorderSide side;

  static const double _cornerRadius = AppRadius.lg;
  static const double _notchMargin = AppSpacing.sm;
  static const double _notchCurveDepth = 6;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final centerX = rect.width / 2;
    final corner = _cornerRadius;
    final margin = _notchMargin;
    final curveDepth = _notchCurveDepth;

    path.moveTo(rect.left, rect.top + corner);
    path.quadraticBezierTo(rect.left, rect.top, rect.left + corner, rect.top);
    path.lineTo(centerX - notchRadius - margin - curveDepth, rect.top);
    path.quadraticBezierTo(
      centerX - notchRadius - margin,
      rect.top,
      centerX - notchRadius - margin,
      rect.top + curveDepth,
    );
    path.arcToPoint(
      Offset(centerX + notchRadius + margin, rect.top + curveDepth),
      radius: Radius.circular(notchRadius + 2),
      clockwise: false,
    );
    path.quadraticBezierTo(
      centerX + notchRadius + margin,
      rect.top,
      centerX + notchRadius + margin + curveDepth,
      rect.top,
    );
    path.lineTo(rect.right - corner, rect.top);
    path.quadraticBezierTo(rect.right, rect.top, rect.right, rect.top + corner);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) {
      return;
    }
    canvas.drawPath(
      getOuterPath(rect, textDirection: textDirection),
      side.toPaint()..style = PaintingStyle.stroke,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return _NotchedBottomBarShape(
      notchRadius: notchRadius * t,
      side: side.scale(t),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _ShellDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = selected ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final badgeLabel = PostSetupHome.badgeLabel(destination.badgeCount);
    final icon = Icon(
      selected ? destination.selectedIcon : destination.icon,
      color: color,
      size: AppSpacing.lg,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: destination.badgeSemanticsLabel ?? destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.primaryContainer.withValues(alpha: 0.55)
                      : colorScheme.surface.withValues(alpha: 0),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: ExcludeSemantics(
                  child: Badge(
                    isLabelVisible: badgeLabel != null,
                    label: badgeLabel == null ? null : Text(badgeLabel),
                    child: icon,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ExcludeSemantics(
                child: Text(
                  destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterNavButton extends StatelessWidget {
  const _CenterNavButton({
    required this.label,
    required this.selected,
    required this.radius,
    required this.ringPadding,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double radius;
  final double ringPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fill = selected ? colorScheme.primary : colorScheme.primaryContainer;
    final iconColor = selected
        ? colorScheme.onPrimary
        : colorScheme.onPrimaryContainer;
    final totalSize = (radius + ringPadding) * 2;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: AnimatedScale(
        scale: selected ? 1.06 : 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: SizedBox.square(
          dimension: totalSize,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(ringPadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.secondary,
                ),
                child: CircleAvatar(
                  radius: radius,
                  backgroundColor: fill,
                  child: SvgPicture.asset(
                    BrandAssets.iconSvg,
                    width: AppSpacing.lg,
                    height: AppSpacing.lg,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellDestinationIcon extends StatelessWidget {
  const _ShellDestinationIcon({
    required this.destination,
    required this.selected,
  });

  final _ShellDestination destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (!destination.prominent) {
      final badgeLabel = PostSetupHome.badgeLabel(destination.badgeCount);
      final icon = Icon(selected ? destination.selectedIcon : destination.icon);
      if (badgeLabel == null) {
        return icon;
      }
      return Badge(label: Text(badgeLabel), child: icon);
    }

    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = colorScheme.onSurface;

    return SizedBox.square(
      dimension: AppSpacing.xl,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            BrandAssets.iconSvg,
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
