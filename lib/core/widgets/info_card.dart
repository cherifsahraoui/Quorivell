import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Reusable info card for displaying important contextual information.
class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.icon,
    required this.title,
    this.subtitle,
    this.color,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveColor = color ?? colorScheme.primary;

    final content = Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 24, color: effectiveColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Padding(
              // Optical center with the icon tile / title line.
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
