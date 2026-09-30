import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class OnboardingIllustrationStage extends StatelessWidget {
  const OnboardingIllustrationStage({
    required this.child,
    this.clipBottom = true,
    super.key,
  });

  final Widget child;
  final bool clipBottom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipPath(
      clipper: clipBottom ? const _HeroBottomCurveClipper() : null,
      child: ColoredBox(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        child: SizedBox.expand(child: child),
      ),
    );
  }
}

class _HeroBottomCurveClipper extends CustomClipper<Path> {
  const _HeroBottomCurveClipper();

  @override
  Path getClip(Size size) {
    final dip = AppSpacing.xxl;
    return Path()
      ..lineTo(0, size.height - dip)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width,
        size.height - dip,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
