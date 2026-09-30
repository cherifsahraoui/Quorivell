import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'onboarding_skeleton_line.dart';

class OnboardingCaptureWaveform extends StatelessWidget {
  const OnboardingCaptureWaveform({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppSpacing.xl,
            child: CustomPaint(
              painter: _WaveformPainter(color: colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        CircleAvatar(
          radius: AppSpacing.lg,
          backgroundColor: colorScheme.primary,
          child: Icon(Icons.mic, color: colorScheme.onPrimary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SizedBox(
            height: AppSpacing.xl,
            child: CustomPaint(
              painter: _WaveformPainter(color: colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingCapturePreview extends StatelessWidget {
  const OnboardingCapturePreview({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const _WindowDots(),
                const Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: AppSpacing.md,
                          color: colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          l10n.onboardingLocalOnly,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const OnboardingSkeletonLine(widthFactor: 0.92),
            const SizedBox(height: AppSpacing.sm),
            const OnboardingSkeletonLine(widthFactor: 0.78),
            const SizedBox(height: AppSpacing.sm),
            const OnboardingSkeletonLine(widthFactor: 0.64),
          ],
        ),
      ),
    );
  }
}

class _WindowDots extends StatelessWidget {
  const _WindowDots();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;

    return Row(
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const SizedBox(width: AppSpacing.sm, height: AppSpacing.sm),
          ),
        ],
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  const _WaveformPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height / 2;
    const waves = 3;
    final segment = size.width / (waves * 2);
    path.moveTo(0, midY);
    for (var i = 0; i < waves; i++) {
      final x1 = segment * (i * 2 + 1);
      final x2 = segment * (i * 2 + 2);
      final dir = i.isEven ? -1.0 : 1.0;
      path.quadraticBezierTo(x1, midY + dir * size.height * 0.4, x2, midY);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
