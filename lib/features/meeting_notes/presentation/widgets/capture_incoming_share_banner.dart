import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// Inline callout when Capture was opened from an Android share.
class CaptureIncomingShareBanner extends StatelessWidget {
  const CaptureIncomingShareBanner({
    required this.title,
    required this.body,
    required this.discardLabel,
    this.onDiscard,
    super.key,
  });

  final String title;
  final String body;
  final String discardLabel;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    Icons.share_outlined,
                    size: AppSpacing.lg,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        body,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: OutlinedButton(
                onPressed: onDiscard,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(AppSpacing.xxl, AppSpacing.xxl),
                ),
                child: Text(discardLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
