import 'package:flutter/material.dart';

import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/theme/app_spacing.dart';
import 'onboarding_asset_image.dart';
import 'onboarding_illustration_stage.dart';

class OnboardingPageBody extends StatelessWidget {
  const OnboardingPageBody({
    required this.illustrationAsset,
    required this.illustrationLabel,
    required this.title,
    this.body,
    this.midAccessory,
    this.bottomAccessory,
    this.clipIllustration = true,
    this.illustrationFit = BoxFit.fitWidth,
    this.illustrationAlignment = Alignment.center,
    super.key,
  });

  final String illustrationAsset;
  final String illustrationLabel;
  final String title;
  final String? body;
  final Widget? midAccessory;
  final Widget? bottomAccessory;
  final bool clipIllustration;
  final BoxFit illustrationFit;
  final Alignment illustrationAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final split = appUsesSplitLayout(constraints);
        final short = constraints.maxHeight < AppBreakpoints.compactMax;
        final illustration = OnboardingIllustrationStage(
          clipBottom: clipIllustration && !split,
          child: OnboardingAssetImage(
            asset: illustrationAsset,
            semanticLabel: illustrationLabel,
            width: double.infinity,
            height: double.infinity,
            fit: illustrationFit,
            alignment: illustrationAlignment,
            // Match the stage chrome; letterboxing would clash with the
            // fixed welcomeScreenBackgroundColor fill.
            setBackgroundColor: false,
          ),
        );
        final copy = _OnboardingCopyPanel(
          title: title,
          body: body,
          midAccessory: midAccessory,
          bottomAccessory: bottomAccessory,
          compact: split && short,
        );

        if (split) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 5, child: illustration),
              Expanded(flex: 6, child: copy),
            ],
          );
        }

        return Column(
          children: [
            Expanded(flex: 5, child: illustration),
            Expanded(flex: 4, child: copy),
          ],
        );
      },
    );
  }
}

class _OnboardingCopyPanel extends StatelessWidget {
  const _OnboardingCopyPanel({
    required this.title,
    required this.compact,
    this.body,
    this.midAccessory,
    this.bottomAccessory,
  });

  final String title;
  final String? body;
  final Widget? midAccessory;
  final Widget? bottomAccessory;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final titleStyle =
        (compact ? theme.textTheme.titleLarge : theme.textTheme.headlineSmall)
            ?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            );
    final bodyStyle =
        (compact ? theme.textTheme.bodyMedium : theme.textTheme.bodyLarge)
            ?.copyWith(color: colorScheme.onSurface);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            compact ? AppSpacing.sm : AppSpacing.md,
            AppSpacing.lg,
            compact ? AppSpacing.sm : AppSpacing.md,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (midAccessory != null) ...[
                  midAccessory!,
                  SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
                ],
                Text(title, style: titleStyle, textAlign: TextAlign.center),
                SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
                if (body != null) ...[
                  Text(body!, style: bodyStyle, textAlign: TextAlign.center),
                ],
                if (bottomAccessory != null) ...[
                  SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
                  bottomAccessory!,
                ],
                SizedBox(height: compact ? AppSpacing.md : AppSpacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }
}
