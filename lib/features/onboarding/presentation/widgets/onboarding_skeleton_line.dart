import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class OnboardingSkeletonLine extends StatelessWidget {
  const OnboardingSkeletonLine({this.widthFactor = 1, super.key});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: AlignmentDirectional.centerStart,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const SizedBox(height: AppSpacing.sm),
      ),
    );
  }
}
