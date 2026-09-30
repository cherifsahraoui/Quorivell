import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/layout/adaptive_content_width.dart';
import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/platform/background_work_constraint_dialogs.dart';
import '../../../../core/routing/post_setup_home.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../assistant/presentation/controllers/review_controller.dart';
import '../controllers/local_model_install_controller.dart';
import '../onboarding_assets.dart';
import '../widgets/onboarding_capture_preview.dart';
import '../widgets/onboarding_chat_tip.dart';
import '../widgets/onboarding_extract_preview.dart';
import '../widgets/onboarding_page_body.dart';
import '../widgets/onboarding_privacy_tip.dart';
import '../widgets/onboarding_welcome_body.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({required this.onComplete, this.onTourSeen, super.key});

  final VoidCallback onComplete;

  /// Fired once the welcome + tour screens have been shown.
  /// Lets the next cold start skip the tour and open only the model gate
  /// (or capture when the on-device model is already ready).
  final VoidCallback? onTourSeen;

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  static const _pageCount = 5;
  static const _tourCount = 4;
  static const _lastTourIndex = _pageCount - 1;

  late final PageController _pageController;
  late int _pageIndex;
  bool _didReportTourSeen = false;
  var _finishInFlight = false;

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isWelcome => _pageIndex == 0;
  bool get _isLastTourPage => _pageIndex == _lastTourIndex;

  void _reportTourSeenIfNeeded() {
    if (_didReportTourSeen) {
      return;
    }
    _didReportTourSeen = true;
    widget.onTourSeen?.call();
  }

  Future<void> _goTo(int index) {
    return _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finishTour(BuildContext context) async {
    if (_finishInFlight) {
      return;
    }
    _finishInFlight = true;
    // Read readiness before marking the tour seen — marking seen refreshes the
    // router and may dispose this page before an awaited future would complete.
    final modelReady =
        ref.read(localModelInstallControllerProvider).asData?.value.isReady ??
        false;
    if (!modelReady) {
      await showBackgroundWorkModelInstallReminder(context: context, ref: ref);
      if (!context.mounted) {
        return;
      }
    }
    _reportTourSeenIfNeeded();
    widget.onComplete();
    if (!context.mounted) {
      return;
    }
    if (!modelReady) {
      context.go('/model-setup');
      return;
    }
    context.go(
      PostSetupHome.locationForPendingCount(
        ref.read(pendingReviewCountProvider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLightMode = theme.brightness == Brightness.light;
    // Keep install status warm so finishing the tour can route immediately.
    ref.watch(localModelInstallControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: AdaptiveContentWidth(
          child: Column(
            children: [
              Expanded(
                child: Semantics(
                  label: l10n.onboardingPageSemantics(
                    _pageIndex + 1,
                    _pageCount,
                  ),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _pageIndex = index);
                    },
                    children: [
                      OnboardingWelcomeBody(
                        onGetStarted: () => _goTo(1),
                        onSignInLocally: () => unawaited(_finishTour(context)),
                      ),
                      OnboardingPageBody(
                        illustrationAsset: isLightMode
                            ? OnboardingAssets.capture
                            : OnboardingAssets.captureDark,
                        illustrationLabel:
                            l10n.onboardingCaptureIllustrationSemantics,
                        clipIllustration: false,
                        illustrationFit: BoxFit.cover,
                        illustrationAlignment: Alignment.topCenter,
                        midAccessory: const OnboardingCaptureWaveform(),
                        title: l10n.onboardingCaptureTitle,
                        body: l10n.onboardingCaptureBody,
                        bottomAccessory: const OnboardingCapturePreview(),
                      ),
                      OnboardingPageBody(
                        illustrationAsset: OnboardingAssets.extract,
                        illustrationLabel:
                            l10n.onboardingExtractIllustrationSemantics,
                        title: l10n.onboardingExtractTitle,
                        body: l10n.onboardingExtractBody,
                        bottomAccessory: const OnboardingExtractPreview(),
                      ),
                      OnboardingPageBody(
                        illustrationAsset: OnboardingAssets.chat,
                        illustrationLabel:
                            l10n.onboardingChatIllustrationSemantics,
                        illustrationFit: BoxFit.cover,
                        illustrationAlignment: Alignment.center,
                        title: l10n.onboardingChatTitle,
                        body: l10n.onboardingChatBody,
                        bottomAccessory: const OnboardingChatTip(),
                      ),
                      OnboardingPageBody(
                        illustrationAsset: OnboardingAssets.privacy,
                        illustrationLabel:
                            l10n.onboardingPrivacyIllustrationSemantics,
                        title: l10n.onboardingPrivacyTitle,
                        body: l10n.onboardingPrivacyBody,
                        bottomAccessory: const OnboardingPrivacyTip(),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isWelcome)
                Builder(
                  builder: (context) {
                    final size = MediaQuery.sizeOf(context);
                    final short = size.height < AppBreakpoints.compactMax;
                    final wide = size.width >= AppBreakpoints.compactMax;
                    final compactChrome = short || wide;
                    final bottomPadding = compactChrome
                        ? AppSpacing.sm
                        : AppSpacing.lg;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        short ? AppSpacing.xs : 0,
                        AppSpacing.lg,
                        bottomPadding,
                      ),
                      child: _TourFooter(
                        index: _pageIndex - 1,
                        count: _tourCount,
                        isLastPage: _isLastTourPage,
                        activeColor: colorScheme.primary,
                        inactiveColor: colorScheme.outlineVariant,
                        onNext: _isLastTourPage
                            ? () => unawaited(_finishTour(context))
                            : () => _goTo(_pageIndex + 1),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TourFooter extends StatelessWidget {
  const _TourFooter({
    required this.index,
    required this.count,
    required this.isLastPage,
    required this.activeColor,
    required this.inactiveColor,
    required this.onNext,
  });

  final int index;
  final int count;
  final bool isLastPage;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nextLabel = isLastPage
        ? l10n.onboardingContinueToApp
        : l10n.onboardingNext;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _PageIndicator(
            count: count,
            index: index,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),
        FilledButton(onPressed: onNext, child: Text(nextLabel)),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: AppSpacing.md,
              height: AppSpacing.md,
              decoration: BoxDecoration(
                color: i == index ? activeColor : inactiveColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
