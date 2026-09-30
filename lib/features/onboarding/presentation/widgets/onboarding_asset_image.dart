import 'package:flutter/material.dart';
import 'package:quorivell/core/theme/constants.dart';

class OnboardingAssetImage extends StatelessWidget {
  const OnboardingAssetImage({
    required this.asset,
    required this.semanticLabel,
    this.width,
    this.height,
    this.setBackgroundColor = true,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    super.key,
  });

  final String asset;
  final String semanticLabel;
  final double? width;
  final double? height;
  final bool setBackgroundColor;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: setBackgroundColor
          ? Constants.welcomeScreenBackgroundColor
          : Colors.transparent,
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        semanticLabel: semanticLabel,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
