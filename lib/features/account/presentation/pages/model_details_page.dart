import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ai/local_model_providers.dart';
import '../../../../core/ai/local_model_store.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/presentation/controllers/local_model_install_controller.dart';
import '../../../onboarding/presentation/widgets/local_model_download_stats.dart';
import '../../../onboarding/presentation/widgets/onboarding_model_download_body.dart';
import '../../../onboarding/presentation/widgets/recommended_model_catalog.dart';
import '../widgets/local_model_size_label.dart';

class ModelDetailsPage extends ConsumerStatefulWidget {
  const ModelDetailsPage({super.key});

  @override
  ConsumerState<ModelDetailsPage> createState() => _ModelDetailsPageState();
}

class _ModelDetailsPageState extends ConsumerState<ModelDetailsPage> {
  var _isChanging = false;

  void _goToAccount() {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.go('/account');
      return;
    }
    Navigator.maybeOf(context)?.maybePop();
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.accountModelDeleteTitle),
          content: Text(l10n.accountModelDeleteBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.accountModelDeleteCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.accountModelDeleteConfirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    await ref
        .read(localModelInstallControllerProvider.notifier)
        .deleteInstalled();
    if (mounted) {
      setState(() => _isChanging = false);
    }
  }

  Future<void> _saveLocally() async {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(localModelInstallControllerProvider.notifier);
    final saved = await notifier.exportInstalled(
      progressTitle: l10n.modelInstallExportNotificationTitle,
      progressBody: l10n.modelInstallExportNotificationBody,
      completionTitle: l10n.modelInstallExportNotificationTitle,
      completionBody: l10n.modelInstallExportCompleteNotificationBody,
    );
    if (!mounted) return;
    final error = ref.read(localModelInstallControllerProvider).value?.error;
    if (error is LocalModelExportException) {
      showAppSnackBar(
        context,
        content: Text(l10n.accountModelSaveLocallyError),
      );
      notifier.clearError();
      return;
    }
    if (saved) {
      showAppSnackBar(
        context,
        content: Text(l10n.accountModelSaveLocallySuccess),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final install = ref.watch(localModelInstallControllerProvider);
    final snapshot = install.value;
    final isPicking = snapshot?.isPicking ?? false;
    final isChecking =
        install.isLoading || (snapshot?.isVerifying ?? false) || isPicking;
    final isReady = snapshot?.isReady == true;
    final isBusy = snapshot?.isBusy == true;
    final isExporting = snapshot?.isExporting == true;
    final showInstall = !isReady || _isChanging || isBusy;

    ref.listen(localModelInstallControllerProvider, (previous, next) {
      final wasBusy = previous?.asData?.value.isBusy ?? false;
      final isReadyNow = next.asData?.value.isReady ?? false;
      if (wasBusy && isReadyNow && _isChanging) {
        setState(() => _isChanging = false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountModelDetailsTitle),
        leading: BackButton(onPressed: _goToAccount),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Offstage(
              offstage: isChecking,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      child: Text(
                        l10n.accountModelDetailsSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  if (isReady && !isBusy)
                    SliverToBoxAdapter(
                      child: _InstalledModelDetails(
                        snapshot: snapshot!,
                        onChange: (_isChanging || isExporting)
                            ? null
                            : () => setState(() => _isChanging = true),
                        onSaveLocally: (_isChanging || isExporting)
                            ? null
                            : _saveLocally,
                        onCancelExport: isExporting
                            ? () => ref
                                  .read(
                                    localModelInstallControllerProvider
                                        .notifier,
                                  )
                                  .cancelExport()
                            : null,
                        onDelete: (_isChanging || isExporting)
                            ? null
                            : _confirmDelete,
                      ),
                    )
                  else if (!isReady && !isBusy)
                    SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.memory_outlined,
                        title: l10n.accountModelEmptyTitle,
                        subtitle: l10n.accountModelEmptySubtitle,
                      ),
                    ),
                  if (isReady && _isChanging && !isBusy)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.md,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: () =>
                                setState(() => _isChanging = false),
                            child: Text(l10n.accountModelCancelChange),
                          ),
                        ),
                      ),
                    ),
                  if (showInstall || isPicking)
                    const SliverToBoxAdapter(
                      child: OnboardingModelDownloadBody(
                        allowReplaceWhenReady: true,
                      ),
                    )
                  else
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.xxl),
                    ),
                ],
              ),
            ),
          ),
          if (isChecking)
            Positioned.fill(
              child: ColoredBox(
                color: colorScheme.surface,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoadingState.inline(),
                        if (isPicking) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l10n.onboardingModelPickingTitle,
                            style: theme.textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.onboardingModelPickingBody,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InstalledModelDetails extends ConsumerWidget {
  const _InstalledModelDetails({
    required this.snapshot,
    required this.onChange,
    required this.onSaveLocally,
    required this.onCancelExport,
    required this.onDelete,
  });

  final LocalModelInstallSnapshot snapshot;
  final VoidCallback? onChange;
  final VoidCallback? onSaveLocally;
  final VoidCallback? onCancelExport;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spec = ref.watch(localModelSpecProvider);
    final originLabel = switch (snapshot.origin) {
      LocalModelOrigin.download => l10n.accountModelOriginDownload,
      LocalModelOrigin.import => l10n.accountModelOriginImport,
      null => l10n.accountModelOriginUnknown,
    };
    final size = snapshot.installedBytes;
    final isExporting = snapshot.isExporting;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoCard(
            icon: Icons.check_circle_outline,
            title: l10n.accountModelStatusReady,
            subtitle: originLabel,
            color: colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.accountModelNameLabel),
                  subtitle: Text(snapshot.installedModelId ?? spec.modelId),
                ),
                const Divider(),
                ListTile(
                  title: Text(l10n.accountModelFileLabel),
                  subtitle: Text(snapshot.installedFileName ?? spec.fileName),
                ),
                const Divider(),
                ListTile(
                  title: Text(l10n.accountModelOriginLabel),
                  subtitle: Text(originLabel),
                ),
                if (size != null) ...[
                  const Divider(),
                  ListTile(
                    title: Text(l10n.accountModelSizeLabel),
                    subtitle: Text(localModelSizeLabel(l10n, size)),
                  ),
                ],
                if (snapshot.installedModelId != null) ...[
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.gavel_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    title: Text(l10n.accountModelLicensesTitle),
                    subtitle: Text(
                      localModelLicenseLabel(l10n, spec.licenseKind),
                    ),
                    isThreeLine: true,
                  ),
                ],
              ],
            ),
          ),
          if (isExporting) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.accountModelSavingLocally,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: snapshot.progress),
            Builder(
              builder: (context) {
                final stats = localModelDownloadStatsLabel(l10n, snapshot);
                if (stats == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    stats,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
            if (onCancelExport != null) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: onCancelExport,
                child: Text(l10n.accountModelSaveLocallyCancel),
              ),
            ],
          ],
          if (onChange != null) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onChange,
              icon: const Icon(Icons.swap_horiz),
              label: Text(l10n.accountModelChangeButton),
            ),
          ],
          if (onSaveLocally != null) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: onSaveLocally,
              icon: const Icon(Icons.save_alt_outlined),
              label: Text(l10n.accountModelSaveLocallyButton),
            ),
          ],
          if (onDelete != null) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              label: Text(
                l10n.accountModelDeleteButton,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
