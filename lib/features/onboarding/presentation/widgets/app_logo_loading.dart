import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/constants.dart';
import '../onboarding_assets.dart';

/// Centered Quorivell mark with a soft 3D spin used while the app boots.
///
/// Respects [MediaQuery.disableAnimationsOf] — reduced-motion users get a
/// still logo instead of a continuous ticker.
class AppLogoLoading extends StatefulWidget {
  const AppLogoLoading({
    required this.semanticLabel,
    this.size = Constants.welcomeScreenIconSize,
    super.key,
  });

  final String semanticLabel;
  final double size;

  @override
  State<AppLogoLoading> createState() => _AppLogoLoadingState();
}

class _AppLogoLoadingState extends State<AppLogoLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final mark = Image.asset(
      OnboardingAssets.icon,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      semanticLabel: widget.semanticLabel,
      excludeFromSemantics: true,
    );

    return Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xl,
          horizontal: AppSpacing.lg,
        ),
        child: SizedBox(
          height: widget.size * 1.7,
          width: widget.size * 1.7,
          child: reduceMotion
              ? Center(child: mark)
              : AnimatedBuilder(
                  animation: _controller,
                  child: mark,
                  builder: (context, child) {
                    final t = _controller.value;
                    final breathe = 1.0 + (0.045 * math.sin(t * 2 * math.pi));
                    final floatY = AppSpacing.sm * math.sin(t * 2 * math.pi);
                    final glowAlpha =
                        0.12 + (0.1 * (0.5 + 0.5 * math.sin(t * 2 * math.pi)));

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: breathe * 1.25,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  colorScheme.primary.withValues(
                                    alpha: glowAlpha,
                                  ),
                                  colorScheme.primary.withValues(alpha: 0),
                                ],
                              ),
                            ),
                            child: SizedBox.square(dimension: widget.size),
                          ),
                        ),
                        Transform.rotate(
                          angle: -t * 2 * math.pi,
                          child: CustomPaint(
                            size: Size.square(widget.size * 1.55),
                            painter: _BootOrbitPainter(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                              trackColor: colorScheme.outlineVariant.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, floatY),
                          child: Transform.scale(
                            scale: breathe,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.0012)
                                ..rotateY(t * 2 * math.pi),
                              child: child,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _BootOrbitPainter extends CustomPainter {
  _BootOrbitPainter({required this.color, required this.trackColor});

  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final accent = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 0.55,
      false,
      accent,
    );
  }

  @override
  bool shouldRepaint(covariant _BootOrbitPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.trackColor != trackColor;
  }
}
