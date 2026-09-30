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
import '../../data/providers/onboarding_providers.dart';
import '../controllers/local_model_install_controller.dart';
import '../widgets/onboarding_model_download_body.dart';

/// Standalone on-device model install gate (not part of the welcome tour).
class ModelDownloadPage extends ConsumerStatefulWidget {
  const ModelDownloadPage({super.key});

  @override
  ConsumerState<ModelDownloadPage> createState() => _ModelDownloadPageState();
}

class _ModelDownloadPageState extends ConsumerState<ModelDownloadPage> {
  final _scrollController = ScrollController();
  var _didPromptBackgroundWork = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_promptBackgroundWorkIfNeeded());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _promptBackgroundWorkIfNeeded() async {
    if (!mounted || _didPromptBackgroundWork) {
      return;
    }
    final install = ref.read(localModelInstallControllerProvider);
    if (install.isLoading && !install.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_promptBackgroundWorkIfNeeded());
      });
      return;
    }
    final snapshot = install.asData?.value;
    if (snapshot == null ||
        snapshot.isReady ||
        snapshot.isBusy ||
        snapshot.isVerifying ||
        snapshot.isPicking) {
      return;
    }
    _didPromptBackgroundWork = true;
    await showBackgroundWorkModelInstallReminder(context: context, ref: ref);
  }

  void _enterApp(BuildContext context) {
    if (ref.read(localModelInstallControllerProvider).value?.isReady != true) {
      return;
    }
    context.go(
      PostSetupHome.locationForPendingCount(
        ref.read(pendingReviewCountProvider),
      ),
    );
  }

  Future<void> _configureLater(BuildContext context) async {
    await ref.read(modelSetupStateProvider.notifier).markCompleted();
    if (!context.mounted) return;
    context.go(
      PostSetupHome.locationForPendingCount(
        ref.read(pendingReviewCountProvider),
      ),
    );
  }

  void _continueAfterSuccessfulInstall() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _enterApp(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final install = ref.watch(localModelInstallControllerProvider);
    final modelReady = install.value?.isReady == true;
    final isPicking = install.value?.isPicking ?? false;
    final isChecking =
        install.isLoading || (install.value?.isVerifying ?? false);
    final isPreparing = isChecking || isPicking;
    final preparingTitle = isPicking
        ? l10n.onboardingModelPickingTitle
        : l10n.onboardingModelCheckingTitle;
    final preparingBody = isPicking
        ? l10n.onboardingModelPickingBody
        : l10n.onboardingModelCheckingBody;

    ref.listen(localModelInstallControllerProvider, (previous, next) {
      final wasBusy = previous?.asData?.value.isBusy ?? false;
      final wasVerifying = previous?.asData?.value.isVerifying ?? false;
      final isReady = next.asData?.value.isReady ?? false;
      if ((wasBusy || wasVerifying) && isReady) {
        _continueAfterSuccessfulInstall();
      }
      final error = next.asData?.value.error;
      if (error != null && error != previous?.asData?.value.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_scrollController.hasClients) return;
          _scrollController.jumpTo(0);
        });
      }
    });

    final size = MediaQuery.sizeOf(context);
    final short = size.height < AppBreakpoints.compactMax;
    final wide = size.width >= AppBreakpoints.compactMax;
    final compactChrome = short || wide;
    final titleStyle =
        (compactChrome
                ? theme.textTheme.headlineSmall
                : theme.textTheme.displaySmall)
            ?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            );
    final bodyStyle =
        (compactChrome
                ? theme.textTheme.titleSmall
                : theme.textTheme.titleMedium)
            ?.copyWith(color: colorScheme.onSurface);
    final buttonLabelStyle =
        (compactChrome
                ? theme.textTheme.headlineSmall
                : theme.textTheme.titleMedium)
            ?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            );

    return Scaffold(
      body: SafeArea(
        child: AdaptiveContentWidth(
          child: Column(
            children: [
              Expanded(
                child: Semantics(
                  label: isPreparing
                      ? preparingTitle
                      : l10n.onboardingModelTitle,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        controller: _scrollController,
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          compactChrome ? AppSpacing.md : AppSpacing.xl,
                          AppSpacing.lg,
                          AppSpacing.lg,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight:
                                constraints.maxHeight -
                                (compactChrome
                                    ? AppSpacing.md
                                    : AppSpacing.xl) -
                                AppSpacing.lg,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                isPreparing
                                    ? preparingTitle
                                    : l10n.onboardingModelTitle,
                                style: titleStyle,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: compactChrome
                                    ? AppSpacing.md
                                    : AppSpacing.lg,
                              ),
                              Text(
                                isPreparing
                                    ? preparingBody
                                    : l10n.onboardingModelBody,
                                style: bodyStyle,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: compactChrome
                                    ? AppSpacing.lg
                                    : AppSpacing.xl,
                              ),
                              const OnboardingModelDownloadBody(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  short ? AppSpacing.xs : 0,
                  AppSpacing.lg,
                  compactChrome ? AppSpacing.sm : AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    // Continue only when ready: install auto-navigates, and
                    // while busy/idle the escape hatch is Configure later.
                    if (modelReady && !isPreparing) ...[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => _enterApp(context),
                          child: Text(
                            l10n.onboardingContinueToApp,
                            style: buttonLabelStyle,
                          ),
                        ),
                      ),
                    ],
                    if (!isPreparing && !modelReady) ...[
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => _configureLater(context),
                          child: Text(l10n.onboardingModelConfigureLater),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
