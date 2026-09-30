import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/platform/extraction_platform_service.dart';
import '../../../../core/platform/model_transfer_platform_service.dart';
import '../../../../core/routing/post_setup_home.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/data/providers/locale_preference_providers.dart';
import '../../../account/domain/entities/user_preference.dart';
import '../../../chat/presentation/controllers/chat_generation_hold_controller.dart';
import '../../../extraction_kinds/data/providers/extraction_item_kind_providers.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';
import '../../../ledger/data/providers/ledger_providers.dart';
import '../../../meeting_notes/data/providers/source_conversation_providers.dart';
import '../../data/providers/extraction_providers.dart';
import '../../domain/entities/extraction_job.dart';
import '../../domain/entities/extraction_progress.dart';
import '../../domain/entities/extraction_run.dart';
import '../../domain/entities/review_candidate.dart';

part 'review_controller.g.dart';

/// The candidates still waiting for a human decision.
@riverpod
class ReviewQueueController extends _$ReviewQueueController {
  @override
  Stream<List<ReviewCandidate>> build() {
    return ref.watch(extractionRepositoryProvider).watchPending();
  }
}

/// Rejected candidates still retained on-device (not soft-deleted).
@riverpod
class RejectedReviewQueueController extends _$RejectedReviewQueueController {
  @override
  Stream<List<ReviewCandidate>> build() {
    return ref.watch(extractionRepositoryProvider).watchRejected();
  }
}

/// Completed extraction runs, newest first (aggregates only).
@riverpod
class ExtractionHistoryController extends _$ExtractionHistoryController {
  @override
  Stream<List<ExtractionRun>> build() {
    return ref.watch(extractionRunRepositoryProvider).watchRuns();
  }
}

/// Pending review count for the Review tab badge and post-setup smart-open.
///
/// `null` while the queue has not emitted yet so the router can wait on boot
/// instead of flashing Ledger then Review.
@riverpod
int? pendingReviewCount(Ref ref) {
  final queue = ref.watch(reviewQueueControllerProvider);
  if (!queue.hasValue && queue.isLoading) {
    return null;
  }
  return queue.value?.length ?? 0;
}

/// Tracks extraction progress during chunked extraction.
@Riverpod(keepAlive: true)
class ExtractionProgressController extends _$ExtractionProgressController {
  @override
  ExtractionProgress? build() => null;

  void updateProgress(ExtractionProgress progress) {
    state = progress;
  }

  void reset() {
    state = null;
  }
}

/// True while chunked extraction is running (independent of accept/reject).
@Riverpod(keepAlive: true)
class ExtractionRunningController extends _$ExtractionRunningController {
  @override
  bool build() => false;

  void start() => state = true;

  void stop() => state = false;
}

/// Whether the global extraction progress overlay is minimized to a FAB.
@Riverpod(keepAlive: true)
class ExtractionProgressOverlayMinimizedController
    extends _$ExtractionProgressOverlayMinimizedController {
  @override
  bool build() => false;

  void minimize() => state = true;

  void expand() => state = false;

  void reset() => state = false;
}

/// Restores overlay + remaining chunks after process death, and stops a
/// leftover native FGS when Dart has nothing to resume.
///
/// Recents swipe / process kill still stops llama.cpp; the native extraction
/// service clears the progress shade on task-removed when no model transfer
/// is running. This runs again on every Dart isolate and on
/// [AppLifecycleState.resumed] so a cached engine that lost inference still
/// restores the card or clears a ghost shade. Tapping the completion
/// notification also refreshes Review/Ledger streams that could not mark
/// widgets dirty while the FlutterView was detached. A live Chat generation
/// holds the same shade; do not cancel it here.
@Riverpod(keepAlive: true)
class ExtractionResumeController extends _$ExtractionResumeController {
  Future<void>? _inFlight;

  @override
  void build() {
    final listener = AppLifecycleListener(onResume: _schedule);
    ref.onDispose(listener.dispose);
    _schedule();
  }

  void _schedule() {
    _inFlight ??= Future<void>(_reconcile).whenComplete(() {
      _inFlight = null;
    });
  }

  Future<void> _reconcile() async {
    if (!ref.mounted) return;
    // Elements deactivated while the FlutterView was detached ignore
    // markNeedsBuild. Re-subscribe Drift lists and schedule a frame so a
    // completion-notification tap does not show a frozen overlay/queue.
    _refreshForegroundUi();
    try {
      final l10n = _appL10n();
      await ref
          .read(reviewActionsControllerProvider.notifier)
          .resumeInterruptedExtraction(
            completionBody: l10n.extractionCompleteNotificationBody,
          );
    } on Object {
      if (!ref.mounted) return;
      final stillWorking =
          ref.read(extractionRunningControllerProvider) &&
          await ref.read(extractionRepositoryProvider).loadActiveJob() != null;
      if (stillWorking) {
        return;
      }
      try {
        final transferring = await ref
            .read(modelTransferPlatformServiceProvider)
            .isTransferRunning();
        if (!ref.mounted || transferring) return;
        await ref
            .read(extractionPlatformServiceProvider)
            .stopForegroundService();
      } on Object {
        // Shade dismiss is best-effort; boot must still succeed.
      }
    }
  }

  void _refreshForegroundUi() {
    ref.invalidate(reviewQueueControllerProvider);
    ref.invalidate(rejectedReviewQueueControllerProvider);
    ref.invalidate(ledgerItemsProvider);
    ref.invalidate(openCommitmentsProvider);
    ref.invalidate(sourceConversationsProvider(false));
    ref.invalidate(sourceConversationsProvider(true));
    final progress = ref.read(extractionProgressControllerProvider);
    if (progress != null) {
      ref
          .read(extractionProgressControllerProvider.notifier)
          .updateProgress(progress);
    }
    WidgetsBinding.instance.scheduleFrame();
  }

  AppLocalizations _appL10n() {
    // Do not mount locale prefs here: resume can run in tests (and on the
    // first router listen) before Account language is loaded. Reading the
    // provider would open Drift via path_provider after those tests complete.
    final localePreference = ref.exists(localePreferenceControllerProvider)
        ? (ref.read(localePreferenceControllerProvider).asData?.value ??
              AppLocalePreference.system)
        : AppLocalePreference.system;
    return lookupAppLocalizations(
      LocalePreferenceController.effectiveLocale(localePreference),
    );
  }
}

/// Review workflow: extract from active captures (one id or a batch), accept a
/// candidate into the ledger, and record corrections or a changed review
/// status.
///
/// Extract never targets archived conversations. With no active capture,
/// extract fails as [ExtractionFailure.noSourceConversation].
///
/// Extract-all runs **oldest → newest**, one conversation per
/// [ExtractionRepository.extractChunked] call (never concatenated). Remaining
/// ids stay on the device-local `extraction_jobs` row so process-death resume
/// continues the batch after the current conversation.
///
/// The queue itself keeps streaming while an action is in flight. Extract
/// stores the candidate count (including zero); other actions store `null`.
@Riverpod(keepAlive: true)
class ReviewActionsController extends _$ReviewActionsController {
  /// `null` after a non-extract action. After extract, the number of
  /// candidates persisted from the run (including zero).
  @override
  FutureOr<int?> build() => null;

  /// Extracts from [SourceConversationRepository.latest] (active only).
  Future<void> extractLatest() async {
    state = const AsyncLoading();
    final link = ref.keepAlive();
    try {
      // Paint the loading CTA before Isolate.spawn. Under a debugger, spawning
      // llama.cpp pauses every isolate, including the UI.
      await Future<void>.delayed(Duration.zero);
      if (!ref.mounted) return;
      state = await AsyncValue.guard(() async {
        final source = await ref
            .read(sourceConversationRepositoryProvider)
            .latest();
        if (source == null) {
          throw const ExtractionFailure.noSourceConversation();
        }
        final candidates = await ref
            .read(extractionRepositoryProvider)
            .extract(source.id);
        return candidates.length;
      });
    } finally {
      link.close();
    }
  }

  /// Chunked extraction for one or more active source ids.
  ///
  /// [sourceConversationIds] must already be active (non-deleted,
  /// non-archived). Order is caller-defined; extract-all should pass
  /// oldest → newest. Shows a LOW-importance ongoing notification while
  /// extraction runs, then a DEFAULT completion alert with findings count.
  ///
  /// When an in-flight job already exists, resumes that job (and any queued
  /// remainder) instead of starting [sourceConversationIds].
  Future<void> extractSourcesChunked({
    required List<String> sourceConversationIds,
    required String progressTitle,
    required String progressBody,
    required String Function(int) completionBody,
    required String completionTitle,
  }) async {
    if (ref.read(extractionRunningControllerProvider)) {
      return;
    }

    state = const AsyncLoading();
    final existing = await ref
        .read(extractionRepositoryProvider)
        .loadActiveJob();
    if (!ref.mounted) return;
    if (ref.read(extractionRunningControllerProvider)) {
      return;
    }

    if (existing != null) {
      await _runChunkedExtraction(
        job: existing.copyWith(
          progressTitle: progressTitle,
          progressBody: progressBody,
          completionTitle: completionTitle,
        ),
        completionBody: completionBody,
      );
      return;
    }

    final ids = [
      for (final id in sourceConversationIds)
        if (id.trim().isNotEmpty) id.trim(),
    ];
    if (ids.isEmpty) {
      state = AsyncError(
        const ExtractionFailure.noSourceConversation(),
        StackTrace.empty,
      );
      return;
    }

    final sourceRepository = ref.read(sourceConversationRepositoryProvider);
    final first = await sourceRepository.find(ids.first);
    if (!ref.mounted) return;
    if (ref.read(extractionRunningControllerProvider)) {
      return;
    }
    if (first == null || first.isArchived) {
      state = AsyncError(
        const ExtractionFailure.noSourceConversation(),
        StackTrace.empty,
      );
      return;
    }

    await _runChunkedExtraction(
      job: ExtractionJob(
        sourceConversationId: first.id,
        sourceRevision: first.sourceRevision,
        startTime: DateTime.now().toUtc(),
        progressTitle: progressTitle,
        progressBody: progressBody,
        completionTitle: completionTitle,
        queuedSourceConversationIds: ids.skip(1).toList(),
        batchIndex: 0,
        batchTotal: ids.length,
      ),
      completionBody: completionBody,
    );
  }

  /// Restores remaining chunks after process death, or stops a zombie FGS.
  ///
  /// No-ops when this isolate is already extracting so a cached Flutter
  /// engine does not double-start or reset progress. Does not show the
  /// extract chooser — resumes the persisted job / queue directly.
  Future<void> resumeInterruptedExtraction({
    required String Function(int) completionBody,
  }) async {
    final link = ref.keepAlive();
    try {
      final repository = ref.read(extractionRepositoryProvider);
      final platformService = ref.read(extractionPlatformServiceProvider);
      final job = await repository.loadActiveJob();
      if (!ref.mounted) return;

      if (job == null) {
        _hideOverlay();
        final transferRunning = await ref
            .read(modelTransferPlatformServiceProvider)
            .isTransferRunning();
        if (!ref.mounted || transferRunning) return;
        if (ref.read(chatGenerationHoldControllerProvider)) return;
        // Cancel even when [isForegroundServiceRunning] is false — after
        // process death the native `running` flag is null but shade 1001
        // can remain.
        await platformService.stopForegroundService();
        return;
      }

      if (ref.read(extractionRunningControllerProvider)) {
        return;
      }

      _showOverlay(job.progress);
      state = const AsyncLoading();
      await _runChunkedExtraction(job: job, completionBody: completionBody);
    } finally {
      link.close();
    }
  }

  void _showOverlay(ExtractionProgress progress) {
    ref.read(extractionRunningControllerProvider.notifier).start();
    ref
        .read(extractionProgressOverlayMinimizedControllerProvider.notifier)
        .reset();
    ref
        .read(extractionProgressControllerProvider.notifier)
        .updateProgress(progress);
  }

  void _hideOverlay() {
    ref.read(extractionRunningControllerProvider.notifier).stop();
    ref.read(extractionProgressControllerProvider.notifier).reset();
    ref
        .read(extractionProgressOverlayMinimizedControllerProvider.notifier)
        .reset();
  }

  Future<void> _runChunkedExtraction({
    required ExtractionJob job,
    required String Function(int) completionBody,
  }) async {
    state = const AsyncLoading();
    final link = ref.keepAlive();
    final platformService = ref.read(extractionPlatformServiceProvider);
    final repository = ref.read(extractionRepositoryProvider);
    await repository.prepareRun();
    _showOverlay(job.progress);

    try {
      await repository.upsertJob(job);

      await platformService.startForegroundService(
        job.progressTitle,
        job.progressBody,
        destination: PostSetupHome.review,
      );

      await Future<void>.delayed(Duration.zero);
      if (!ref.mounted) return;

      state = await AsyncValue.guard(() async {
        var totalCandidates = job.candidatesFound;
        var currentJob = job;

        try {
          while (true) {
            await platformService.updateForegroundServiceProgress(
              current: currentJob.progress.currentChunk,
              total: currentJob.progress.totalChunks,
            );

            await for (final update in repository.extractChunked(
              currentJob.sourceConversationId,
            )) {
              if (!ref.read(extractionRunningControllerProvider)) {
                break;
              }
              totalCandidates = update.progress.candidatesFound;
              ref
                  .read(extractionProgressControllerProvider.notifier)
                  .updateProgress(update.progress);
              await platformService.updateForegroundServiceProgress(
                current: update.progress.currentChunk,
                total: update.progress.totalChunks,
              );
            }

            if (!ref.read(extractionRunningControllerProvider)) {
              Error.throwWithStackTrace(
                const ExtractionFailure.cancelled(),
                StackTrace.current,
              );
            }

            if (!ref.mounted) return totalCandidates;

            // Cancel clears the job; do not start the next queued source.
            final next = await repository.loadActiveJob();
            if (next == null) {
              break;
            }
            currentJob = next;
            ref
                .read(extractionProgressControllerProvider.notifier)
                .updateProgress(next.progress);
          }
        } on ExtractionCancelledFailure {
          // Surface as error so Review skips the empty-result teach dialog and
          // shows the stopped snackbar instead of treating cancel as "0 found".
          Error.throwWithStackTrace(
            const ExtractionFailure.cancelled(),
            StackTrace.current,
          );
        }

        // Cancel hides the overlay (running=false) and clears the job so the
        // while-loop breaks without throwing — treat that as cancel, not success.
        if (!ref.read(extractionRunningControllerProvider)) {
          Error.throwWithStackTrace(
            const ExtractionFailure.cancelled(),
            StackTrace.current,
          );
        }

        await platformService.showCompletionNotification(
          job.completionTitle,
          completionBody(totalCandidates),
          destination: PostSetupHome.locationForPendingCount(totalCandidates),
        );

        return totalCandidates;
      });
    } finally {
      if (ref.mounted) {
        _hideOverlay();
      }
      await platformService.stopForegroundService();
      link.close();
    }
  }

  Future<void> accept(ReviewCandidate candidate) async {
    final catalog =
        ref.read(extractionItemKindsProvider).asData?.value ?? const [];
    final match = kindBySlug(catalog, candidate.kind);
    final snapshot = (match?.displayName.trim().isNotEmpty ?? false)
        ? match!.displayName
        : candidate.kind;
    final allowDue = kindAllowsDueDate(
      match,
      existingDueDate: candidate.dueDate,
      slug: candidate.kind,
    );
    final allowNote = kindAllowsNote(
      match,
      existingNote: candidate.note,
      slug: candidate.kind,
    );
    Future<void> persist() => ref
        .read(ledgerRepositoryProvider)
        .acceptCandidate(
          candidateId: candidate.id,
          kind: candidate.kind,
          statement: candidate.statement,
          owner: candidate.owner,
          dueDate: allowDue ? candidate.dueDate : null,
          note: allowNote ? candidate.note : null,
          kindDisplayNameSnapshot: snapshot,
        );

    if (ref.read(extractionRunningControllerProvider)) {
      await persist();
      return;
    }

    final link = ref.keepAlive();
    try {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        await persist();
        return null;
      });
    } finally {
      link.close();
    }
  }

  Future<void> saveCorrection(ReviewCandidate candidate) =>
      _write(candidate.copyWith(reviewStatus: ReviewStatus.pending));

  Future<void> changeStatus(ReviewCandidate candidate, ReviewStatus status) {
    final updated = candidate.copyWith(reviewStatus: status);
    if (ref.read(extractionRunningControllerProvider)) {
      return ref.read(extractionRepositoryProvider).updateReview(updated);
    }
    return _write(updated);
  }

  /// Soft-deletes a rejected (or pending) candidate from local history.
  Future<void> deleteCandidate(String candidateId) async {
    final link = ref.keepAlive();
    try {
      await ref.read(extractionRepositoryProvider).deletePending(candidateId);
    } finally {
      link.close();
    }
  }

  /// Soft-deletes an extraction run from local history.
  Future<void> deleteRun(String runId) async {
    final link = ref.keepAlive();
    try {
      await ref.read(extractionRunRepositoryProvider).deleteRun(runId);
    } finally {
      link.close();
    }
  }

  Future<void> _write(ReviewCandidate candidate) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(extractionRepositoryProvider).updateReview(candidate);
      return null;
    });
  }

  /// Stops the in-flight extraction after the user confirmed.
  ///
  /// Hides the progress overlay and drops the Android progress shade
  /// immediately. [cancelActive] still awaits llama stop, so the FGS cannot
  /// wait for [_runChunkedExtraction]'s finally or the shade lags the card.
  /// Persisted candidates stay. The device-local job is cleared so resume does
  /// not restart remaining chunks; [ExtractionRepository.upsertJob] refuses to
  /// revive a cancelled job.
  Future<void> cancelExtraction() async {
    _hideOverlay();
    if (ref.mounted) {
      state = const AsyncError(ExtractionFailure.cancelled(), StackTrace.empty);
    }
    // Same shade as model transfer / chat hold — only tear it down when those
    // are idle (mirrors [resumeInterruptedExtraction]).
    try {
      final transferring = await ref
          .read(modelTransferPlatformServiceProvider)
          .isTransferRunning();
      if (!transferring && !ref.read(chatGenerationHoldControllerProvider)) {
        await ref
            .read(extractionPlatformServiceProvider)
            .stopForegroundService();
      }
    } on Object {
      // Shade dismiss is best-effort; cancelActive still proceeds.
    }
    try {
      await ref.read(extractionRepositoryProvider).cancelActive();
    } on Object {
      // UI already cleared; native stop is best-effort.
    }
  }
}
