import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Reusable empty state widget for consistent empty/zero states.
///
/// Portrait: stacked icon + copy. Short viewports: icon on the left and copy
/// on the right, with reduced top padding. Scrolls when the allocated height
/// is tight (safe inside [SliverFillRemaining] when `hasScrollBody: true`).
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
    this.actionIcon = Icons.add,
    this.isActionLoading = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? action;
  final String? actionLabel;
  final IconData actionIcon;
  final bool isActionLoading;

  /// Below this height, switch to the compact horizontal layout.
  static const double compactHeightBreakpoint = 360;

  /// Whether this viewport should use the icon-left / copy-right layout.
  static bool useCompactLayout(
    BuildContext context, [
    BoxConstraints? constraints,
  ]) {
    final size = MediaQuery.sizeOf(context);
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape ||
        size.width > size.height;
    final viewShort = size.height < compactHeightBreakpoint;
    final constraintShort =
        constraints != null &&
        constraints.maxHeight.isFinite &&
        constraints.maxHeight > 0 &&
        constraints.maxHeight < compactHeightBreakpoint;
    return landscape || viewShort || constraintShort;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = useCompactLayout(context, constraints);
        final hasBoundedHeight = constraints.maxHeight.isFinite;
        final content = compact
            ? _buildHorizontal(theme, colorScheme)
            : _buildVertical(theme, colorScheme);

        final aligned = Align(
          alignment: compact ? Alignment.centerLeft : Alignment.center,
          child: content,
        );

        if (!hasBoundedHeight) {
          return aligned;
        }

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: aligned,
          ),
        );
      },
    );
  }

  Widget _buildIcon(ColorScheme colorScheme, {required bool compact}) {
    final iconPad = compact ? AppSpacing.sm : AppSpacing.xl;
    final iconSize = compact ? AppSpacing.xl : AppSpacing.xxl + AppSpacing.sm;
    return Container(
      padding: EdgeInsets.all(iconPad),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: iconSize, color: colorScheme.primary),
    );
  }

  Widget? _buildAction() {
    if (action == null || actionLabel == null) {
      return null;
    }
    return FilledButton.icon(
      onPressed: isActionLoading ? null : action,
      icon: isActionLoading
          ? SizedBox.square(
              dimension: AppSpacing.lg - AppSpacing.xs,
              child: const ExcludeSemantics(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : Icon(actionIcon),
      label: Text(actionLabel!),
    );
  }

  Widget _buildVertical(ThemeData theme, ColorScheme colorScheme) {
    final actionButton = _buildAction();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(colorScheme, compact: false),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionButton != null) ...[
              const SizedBox(height: AppSpacing.xl),
              actionButton,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontal(ThemeData theme, ColorScheme colorScheme) {
    final actionButton = _buildAction();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcon(colorScheme, compact: true),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                  if (actionButton != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    actionButton,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
