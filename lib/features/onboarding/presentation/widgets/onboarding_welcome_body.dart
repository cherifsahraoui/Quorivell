import 'package:flutter/material.dart';
import 'package:quorivell/core/theme/constants.dart';

import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../onboarding_assets.dart';
import 'onboarding_asset_image.dart';

class OnboardingWelcomeBody extends StatelessWidget {
  const OnboardingWelcomeBody({
    required this.onGetStarted,
    required this.onSignInLocally,
    super.key,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onSignInLocally;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isLightMode = brightness == Brightness.light;

    return LayoutBuilder(
      builder: (context, constraints) {
        final split = appUsesSplitLayout(constraints);
        final short = constraints.maxHeight < AppBreakpoints.compactMax;
        final verticalPad = short ? AppSpacing.sm : AppSpacing.xxl;
        final scale = short
            ? (constraints.maxHeight / 420).clamp(0.55, 0.85)
            : (split ? 1.15 : 1.0);
        final iconSize = Constants.welcomeScreenIconSize * scale;
        final titleSize = Constants.welcomeScreenTitleSize * scale;
        final minBodyHeight = (constraints.maxHeight - verticalPad * 2).clamp(
          0.0,
          double.infinity,
        );

        final getStarted = FilledButton(
          onPressed: onGetStarted,
          child: Text(l10n.welcomeGetStartedButton),
        );

        final signInRow = Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              l10n.welcomeAlreadyUser,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: onSignInLocally,
              child: Text(
                l10n.welcomeSignInLocally,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        );

        final brand = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnboardingAssetImage(
              asset: OnboardingAssets.icon,
              semanticLabel: l10n.onboardingLogoSemantics,
              height: iconSize,
              setBackgroundColor: false,
            ),
            SizedBox(height: short ? AppSpacing.sm : AppSpacing.md),
            OnboardingAssetImage(
              asset: isLightMode
                  ? OnboardingAssets.title
                  : OnboardingAssets.titleDark,
              semanticLabel: l10n.onboardingWordmarkSemantics,
              height: titleSize,
              setBackgroundColor: false,
            ),
          ],
        );

        final copy = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.welcomeTitle,
              style:
                  (short
                          ? theme.textTheme.headlineSmall
                          : theme.textTheme.headlineMedium)
                      ?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: short ? AppSpacing.md : AppSpacing.xl),
            Text(
              l10n.welcomeBody,
              style:
                  (short
                          ? theme.textTheme.bodyLarge
                          : theme.textTheme.titleMedium)
                      ?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          ],
        );

        final content = split
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        brand,
                        SizedBox(height: short ? AppSpacing.md : AppSpacing.lg),
                        SizedBox(width: double.infinity, child: getStarted),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        copy,
                        SizedBox(height: short ? AppSpacing.md : AppSpacing.lg),
                        Center(child: signInRow),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  brand,
                  SizedBox(height: short ? AppSpacing.md : AppSpacing.xl),
                  copy,
                  SizedBox(height: short ? AppSpacing.md : AppSpacing.xl),
                  SizedBox(width: double.infinity, child: getStarted),
                  const SizedBox(height: AppSpacing.sm),
                  signInRow,
                ],
              );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: verticalPad,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minBodyHeight),
            child: content,
          ),
        );
      },
    );
  }
}
