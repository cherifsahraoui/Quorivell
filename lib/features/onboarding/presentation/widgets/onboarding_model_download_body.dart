import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ai/local_model_spec.dart';
import '../../../../core/ai/local_model_store.dart';
import '../../../../core/platform/background_work_constraint_dialogs.dart';
import '../../../../core/platform/notification_permission_dialogs.dart';
import '../../../../core/platform/open_external_url.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/local_model_install_controller.dart';
import 'confirm_replace_model_dialog.dart';
import 'local_model_download_stats.dart';
import 'recommended_model_catalog.dart';

class OnboardingModelDownloadBody extends ConsumerStatefulWidget {
  const OnboardingModelDownloadBody({
    this.allowReplaceWhenReady = false,
    super.key,
  });

  /// When true, download/import actions stay available after a model is ready
  /// so the user can replace it from Account.
  final bool allowReplaceWhenReady;

  @override
  ConsumerState<OnboardingModelDownloadBody> createState() =>
      _OnboardingModelDownloadBodyState();
}

class _OnboardingModelDownloadBodyState
    extends ConsumerState<OnboardingModelDownloadBody> {
  var _pickInFlight = false;
  OverlayEntry? _barrier;

  void _removeBarrier() {
    final barrier = _barrier;
    _barrier = null;
    barrier?.remove();
  }

  @override
  void dispose() {
    _removeBarrier();
    super.dispose();
  }

  /// Keeps the parent [AppBar] tappable (Account back) while the rest of the
  /// screen, including the shell nav, stays blocked during SAF copy.
  double _appBarOverlayInset() {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold == null || !scaffold.hasAppBar) {
      return 0;
    }
    final toolbarHeight =
        Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight;
    return MediaQuery.paddingOf(context).top + toolbarHeight;
  }

  OverlayEntry _pickingBarrier({required double topInset}) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            Positioned(
              top: topInset,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: colorScheme.scrim.withValues(alpha: 0.45),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ExcludeSemantics(
                              child: CircularProgressIndicator(),
                            ),
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
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startDownload([LocalModelSpec? spec]) async {
    final snapshot = ref.read(localModelInstallControllerProvider).value;
    final replacing =
        snapshot?.isReady == true &&
        (spec == null || spec.modelId != snapshot?.installedModelId);
    if (replacing) {
      final confirmed = await confirmReplaceInstalledModel(context);
      if (!confirmed || !mounted) return;
    }
    final l10n = AppLocalizations.of(context);
    await showBackgroundWorkModelInstallReminder(context: context, ref: ref);
    if (!mounted) return;
    final notifier = ref.read(localModelInstallControllerProvider.notifier);
    notifier.clearError();
    // Start the transfer first. A Flutter permission dialog here remounts
    // this page and the user never leaves the model gate.
    unawaited(requestNotificationPermissionIfNeeded(ref));
    await notifier.download(
      spec: spec,
      progressTitle: l10n.modelInstallDownloadNotificationTitle,
      progressBody: l10n.modelInstallDownloadNotificationBody,
      progressBodyFor: (snapshot) {
        if (snapshot.isFinalizing) {
          return l10n.onboardingModelFinalizingHint;
        }
        return localModelDownloadStatsLabel(
              l10n,
              snapshot,
              percentFallback: false,
            ) ??
            l10n.modelInstallDownloadNotificationBody;
      },
      completionTitle: l10n.modelInstallCompleteNotificationTitle,
      completionBody: l10n.modelInstallDownloadCompleteNotificationBody,
    );
  }

  Future<void> _remindThenImport(Future<void> Function() import) async {
    await showBackgroundWorkModelInstallReminder(context: context, ref: ref);
    if (!mounted) return;
    unawaited(requestNotificationPermissionIfNeeded(ref));
    await import();
  }

  Future<void> _pickLocalModel() async {
    if (_pickInFlight) return;
    _pickInFlight = true;
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(localModelInstallControllerProvider.notifier);
    notifier.clearError();
    // Open the picker first. Asking for notification permission beforehand
    // races the system prompt against SAF / the file dialog, so Allow/Not now
    // appear to do nothing while selection still starts.
    if (Platform.isAndroid) {
      try {
        final picked = await notifier.pickGguf();
        if (!mounted) {
          notifier.cancelPicking();
          return;
        }
        if (picked == null) return;
        await _remindThenImport(
          () => notifier.importPickedGguf(
            picked,
            progressTitle: l10n.modelInstallCopyNotificationTitle,
            progressBody: l10n.modelInstallCopyNotificationBody,
            completionTitle: l10n.modelInstallCompleteNotificationTitle,
            completionBody: l10n.modelInstallCopyCompleteNotificationBody,
          ),
        );
      } finally {
        _removeBarrier();
        _pickInFlight = false;
      }
      return;
    }
    notifier.beginPicking();
    // Paint the blocking loader before the native picker, so it is already
    // on screen while the plugin copies a large GGUF after the dialog closes.
    await Future<void>.delayed(Duration.zero);

    if (!mounted) {
      notifier.cancelPicking();
      _pickInFlight = false;
      return;
    }

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay != null) {
      final entry = _pickingBarrier(topInset: _appBarOverlayInset());
      overlay.insert(entry);
      _barrier = entry;
    }

    try {
      // FileType.custom + ".gguf" often returns null on Android SAF because
      // there is no reliable MIME mapping. Pick any file, then validate.
      final file = await FilePicker.pickFile(type: FileType.any);
      if (!mounted) {
        notifier.cancelPicking();
        return;
      }
      if (file == null) {
        notifier.cancelPicking();
        return;
      }

      final extension = (file.extension ?? '').toLowerCase();
      final name = file.name.toLowerCase();
      if (extension != 'gguf' && !name.endsWith('.gguf')) {
        notifier.failImport(const LocalModelImportException());
        return;
      }

      // Prefer a real filesystem path when available, otherwise stream the
      // SAF/content handle (required for many Android picks).
      final path = file.path;
      if (path != null && path.isNotEmpty) {
        _removeBarrier();
        await _remindThenImport(
          () => notifier.importLocalFile(
            File(path),
            progressTitle: l10n.modelInstallCopyNotificationTitle,
            progressBody: l10n.modelInstallCopyNotificationBody,
            completionTitle: l10n.modelInstallCompleteNotificationTitle,
            completionBody: l10n.modelInstallCopyCompleteNotificationBody,
          ),
        );
        return;
      }

      final knownLength = file.lengthSync();
      final totalBytes = knownLength ?? await file.length();
      _removeBarrier();
      await _remindThenImport(
        () => notifier.importLocalBytes(
          file.readAsByteStream(),
          totalBytes: (totalBytes != null && totalBytes > 0)
              ? totalBytes
              : null,
          progressTitle: l10n.modelInstallCopyNotificationTitle,
          progressBody: l10n.modelInstallCopyNotificationBody,
          completionTitle: l10n.modelInstallCompleteNotificationTitle,
          completionBody: l10n.modelInstallCopyCompleteNotificationBody,
        ),
      );
    } on Object {
      if (!mounted) return;
      notifier.failImport(const LocalModelImportException());
    } finally {
      _removeBarrier();
      _pickInFlight = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final install = ref.watch(localModelInstallControllerProvider);
    final snapshot = install.value;
    final isChecking =
        install.isLoading ||
        snapshot?.isVerifying == true ||
        snapshot?.isPicking == true;
    final isBusy = snapshot?.isBusy == true || snapshot?.isPicking == true;
    final isDownloading = snapshot?.isDownloading == true;
    final isImporting = snapshot?.isImporting == true;
    final isFinalizing = snapshot?.isFinalizing == true;
    final isReady = snapshot?.isReady == true;
    final showReadyCard = isReady && !widget.allowReplaceWhenReady;
    final showInstallActions = !isReady || widget.allowReplaceWhenReady;
    final hasPartial = snapshot?.hasPartialDownload == true;
    final progress = snapshot?.progress;
    final error = snapshot?.error;
    final notifier = ref.read(localModelInstallControllerProvider.notifier);

    final landscape =
        MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height;
    final gap = landscape ? AppSpacing.xs : AppSpacing.sm;
    final sectionGap = landscape ? AppSpacing.sm : AppSpacing.md;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        landscape ? 0 : AppSpacing.lg,
        0,
        landscape ? 0 : AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isChecking)
            Padding(
              padding: EdgeInsets.symmetric(vertical: sectionGap),
              child: const Align(child: LoadingState.inline()),
            )
          else if (showReadyCard)
            InfoCard(
              icon: Icons.check_circle_outline,
              title: l10n.onboardingModelReadyTitle,
              subtitle: l10n.onboardingModelReadySubtitle,
            )
          else if (showInstallActions) ...[
            if (error != null) ...[
              Semantics(
                liveRegion: true,
                child: InfoCard(
                  icon: Icons.error_outline,
                  title: localModelInstallErrorMessage(
                    error,
                    checksum: l10n.onboardingModelChecksumError,
                    download: l10n.onboardingModelDownloadError,
                    import: l10n.onboardingModelImportError,
                    storageFull: l10n.onboardingModelStorageFullError,
                  ),
                  color: colorScheme.error,
                ),
              ),
              if (error is LocalModelStorageFullException && !isBusy) ...[
                SizedBox(height: gap),
                OutlinedButton(
                  onPressed: () async {
                    await notifier.reclaimTemporarySpace();
                  },
                  child: Text(l10n.onboardingModelFreeTempSpace),
                ),
              ],
              SizedBox(height: sectionGap),
            ],
            if (hasPartial && !isBusy) ...[
              FilledButton.icon(
                onPressed: () {
                  _startDownload();
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.onboardingModelResumeDownload),
              ),
              SizedBox(height: gap),
              TextButton(
                onPressed: () async {
                  notifier.clearError();
                  await notifier.clearPartialDownload();
                },
                child: Text(l10n.onboardingModelDiscardPartial),
              ),
              SizedBox(height: sectionGap),
            ],
            if (isDownloading) ...[
              TextButton.icon(
                onPressed: notifier.cancelDownload,
                icon: const Icon(Icons.stop),
                label: Text(l10n.onboardingModelCancelDownload),
              ),
              SizedBox(height: gap),
            ],
            if (isBusy || (hasPartial && progress != null)) ...[
              LinearProgressIndicator(
                value: isFinalizing || progress == null || progress == 0
                    ? null
                    : progress,
              ),
              SizedBox(height: gap),
              if (isDownloading && snapshot != null) ...[
                Text(
                  localModelDownloadStatsLabel(l10n, snapshot) ??
                      l10n.onboardingModelDownloadHint,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: gap),
              ],
              Text(
                isImporting
                    ? l10n.onboardingModelImportHint
                    : isFinalizing
                    ? l10n.onboardingModelFinalizingHint
                    : isDownloading
                    ? l10n.onboardingModelDownloadHint
                    : l10n.onboardingModelDownloadPausedHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sectionGap),
            ],
            if (!isBusy && !hasPartial) ...[
              RecommendedModelCatalog(
                enabled: true,
                downloadingModelId: snapshot?.downloadingModelId,
                currentModelId: isReady ? snapshot?.installedModelId : null,
                onDownload: (model) {
                  _startDownload(model);
                },
                onOpenPage: (uri) {
                  openExternalUrl(uri);
                },
              ),
              SizedBox(height: gap),
              OutlinedButton.icon(
                onPressed: _pickLocalModel,
                icon: const Icon(Icons.folder_open),
                label: Text(l10n.onboardingModelSelectFileButton),
              ),
              SizedBox(height: gap),
              Text(
                l10n.onboardingModelManualResponsibility,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
