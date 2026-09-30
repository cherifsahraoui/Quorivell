import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'onboarding_skeleton_line.dart';
import 'onboarding_status_chip.dart';

class OnboardingExtractPreview extends StatelessWidget {
  const OnboardingExtractPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: _ExtractCard(
                title: l10n.reviewKindCommitment,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: const SizedBox(height: AppSpacing.sm),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: const SizedBox(height: AppSpacing.sm),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ExtractCard(
                title: l10n.reviewKindDecision,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OnboardingStatusChip(
                    label: l10n.onboardingExtracted,
                    background: colorScheme.tertiary,
                    foreground: colorScheme.onTertiary,
                    selected: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExtractCard extends StatelessWidget {
  const _ExtractCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            const OnboardingSkeletonLine(widthFactor: 0.9),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}
