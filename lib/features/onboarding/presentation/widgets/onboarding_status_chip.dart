import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class OnboardingStatusChip extends StatelessWidget {
  const OnboardingStatusChip({
    required this.label,
    required this.background,
    required this.foreground,
    this.selected = false,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? background : background.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected ? foreground : background,
          ),
        ),
      ),
    );
  }
}
