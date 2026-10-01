// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The candidates still waiting for a human decision.

@ProviderFor(ReviewQueueController)
final reviewQueueControllerProvider = ReviewQueueControllerProvider._();

/// The candidates still waiting for a human decision.
final class ReviewQueueControllerProvider
    extends
        $StreamNotifierProvider<ReviewQueueController, List<ReviewCandidate>> {
  /// The candidates still waiting for a human decision.
  ReviewQueueControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewQueueControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewQueueControllerHash();

  @$internal
  @override
  ReviewQueueController create() => ReviewQueueController();
}

String _$reviewQueueControllerHash() =>
    r'e11a3654707dcef71aca68eddc8d57eb92d331c0';

/// The candidates still waiting for a human decision.

abstract class _$ReviewQueueController
    extends $StreamNotifier<List<ReviewCandidate>> {
  Stream<List<ReviewCandidate>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ReviewCandidate>>, List<ReviewCandidate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ReviewCandidate>>,
                List<ReviewCandidate>
              >,
              AsyncValue<List<ReviewCandidate>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Rejected candidates still retained on-device (not soft-deleted).

@ProviderFor(RejectedReviewQueueController)
final rejectedReviewQueueControllerProvider =
    RejectedReviewQueueControllerProvider._();

/// Rejected candidates still retained on-device (not soft-deleted).
final class RejectedReviewQueueControllerProvider
    extends
        $StreamNotifierProvider<
          RejectedReviewQueueController,
          List<ReviewCandidate>
        > {
  /// Rejected candidates still retained on-device (not soft-deleted).
  RejectedReviewQueueControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectedReviewQueueControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectedReviewQueueControllerHash();

  @$internal
  @override
  RejectedReviewQueueController create() => RejectedReviewQueueController();
}

String _$rejectedReviewQueueControllerHash() =>
    r'db2637d6de57b76df5081221d85755c31806aeb9';

/// Rejected candidates still retained on-device (not soft-deleted).

abstract class _$RejectedReviewQueueController
    extends $StreamNotifier<List<ReviewCandidate>> {
  Stream<List<ReviewCandidate>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ReviewCandidate>>, List<ReviewCandidate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ReviewCandidate>>,
                List<ReviewCandidate>
              >,
              AsyncValue<List<ReviewCandidate>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Completed extraction runs, newest first (aggregates only).

@ProviderFor(ExtractionHistoryController)
final extractionHistoryControllerProvider =
    ExtractionHistoryControllerProvider._();

/// Completed extraction runs, newest first (aggregates only).
final class ExtractionHistoryControllerProvider
    extends
        $StreamNotifierProvider<
          ExtractionHistoryController,
          List<ExtractionRun>
        > {
  /// Completed extraction runs, newest first (aggregates only).
  ExtractionHistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionHistoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionHistoryControllerHash();

  @$internal
  @override
  ExtractionHistoryController create() => ExtractionHistoryController();
}

String _$extractionHistoryControllerHash() =>
    r'385a2ffa9d3fb45d0336959704506091b5225edf';

/// Completed extraction runs, newest first (aggregates only).

abstract class _$ExtractionHistoryController
    extends $StreamNotifier<List<ExtractionRun>> {
  Stream<List<ExtractionRun>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ExtractionRun>>, List<ExtractionRun>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ExtractionRun>>, List<ExtractionRun>>,
              AsyncValue<List<ExtractionRun>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Pending review count for the Review tab badge and post-setup smart-open.
///
/// `null` while the queue has not emitted yet so the router can wait on boot
/// instead of flashing Ledger then Review.

@ProviderFor(pendingReviewCount)
final pendingReviewCountProvider = PendingReviewCountProvider._();

/// Pending review count for the Review tab badge and post-setup smart-open.
///
/// `null` while the queue has not emitted yet so the router can wait on boot
/// instead of flashing Ledger then Review.

final class PendingReviewCountProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// Pending review count for the Review tab badge and post-setup smart-open.
  ///
  /// `null` while the queue has not emitted yet so the router can wait on boot
  /// instead of flashing Ledger then Review.
  PendingReviewCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingReviewCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingReviewCountHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return pendingReviewCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$pendingReviewCountHash() =>
    r'db2da4002a3e3d4b123b0cbfa4f700d5d31ac954';

/// Tracks extraction progress during chunked extraction.

@ProviderFor(ExtractionProgressController)
final extractionProgressControllerProvider =
    ExtractionProgressControllerProvider._();

/// Tracks extraction progress during chunked extraction.
final class ExtractionProgressControllerProvider
    extends
        $NotifierProvider<ExtractionProgressController, ExtractionProgress?> {
  /// Tracks extraction progress during chunked extraction.
  ExtractionProgressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionProgressControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionProgressControllerHash();

  @$internal
  @override
  ExtractionProgressController create() => ExtractionProgressController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtractionProgress? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtractionProgress?>(value),
    );
  }
}

String _$extractionProgressControllerHash() =>
    r'c10df3cecc254283355be5b738ded3a9e6b8fad6';

/// Tracks extraction progress during chunked extraction.

abstract class _$ExtractionProgressController
    extends $Notifier<ExtractionProgress?> {
  ExtractionProgress? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ExtractionProgress?, ExtractionProgress?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExtractionProgress?, ExtractionProgress?>,
              ExtractionProgress?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// True while chunked extraction is running (independent of accept/reject).

@ProviderFor(ExtractionRunningController)
final extractionRunningControllerProvider =
    ExtractionRunningControllerProvider._();

/// True while chunked extraction is running (independent of accept/reject).
final class ExtractionRunningControllerProvider
    extends $NotifierProvider<ExtractionRunningController, bool> {
  /// True while chunked extraction is running (independent of accept/reject).
  ExtractionRunningControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionRunningControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionRunningControllerHash();

  @$internal
  @override
  ExtractionRunningController create() => ExtractionRunningController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$extractionRunningControllerHash() =>
    r'278c2feeb07f9232333e562f67f73b915d3fe052';

/// True while chunked extraction is running (independent of accept/reject).

abstract class _$ExtractionRunningController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the global extraction progress overlay is minimized to a FAB.

@ProviderFor(ExtractionProgressOverlayMinimizedController)
final extractionProgressOverlayMinimizedControllerProvider =
    ExtractionProgressOverlayMinimizedControllerProvider._();

/// Whether the global extraction progress overlay is minimized to a FAB.
final class ExtractionProgressOverlayMinimizedControllerProvider
    extends
        $NotifierProvider<ExtractionProgressOverlayMinimizedController, bool> {
  /// Whether the global extraction progress overlay is minimized to a FAB.
  ExtractionProgressOverlayMinimizedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionProgressOverlayMinimizedControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$extractionProgressOverlayMinimizedControllerHash();

  @$internal
  @override
  ExtractionProgressOverlayMinimizedController create() =>
      ExtractionProgressOverlayMinimizedController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$extractionProgressOverlayMinimizedControllerHash() =>
    r'0397191e273cc23a29fc55962e774dd892dcf3d2';

/// Whether the global extraction progress overlay is minimized to a FAB.

abstract class _$ExtractionProgressOverlayMinimizedController
    extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
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

@ProviderFor(ExtractionResumeController)
final extractionResumeControllerProvider =
    ExtractionResumeControllerProvider._();

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
final class ExtractionResumeControllerProvider
    extends $NotifierProvider<ExtractionResumeController, void> {
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
  ExtractionResumeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionResumeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionResumeControllerHash();

  @$internal
  @override
  ExtractionResumeController create() => ExtractionResumeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$extractionResumeControllerHash() =>
    r'341cd55ca080467ab23dc2ed224ec816b6a22d8f';

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

abstract class _$ExtractionResumeController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
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

@ProviderFor(ReviewActionsController)
final reviewActionsControllerProvider = ReviewActionsControllerProvider._();

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
final class ReviewActionsControllerProvider
    extends $AsyncNotifierProvider<ReviewActionsController, int?> {
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
  ReviewActionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewActionsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewActionsControllerHash();

  @$internal
  @override
  ReviewActionsController create() => ReviewActionsController();
}

String _$reviewActionsControllerHash() =>
    r'70fae23e340a2c74423a648523ec9a68860fedda';

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

abstract class _$ReviewActionsController extends $AsyncNotifier<int?> {
  FutureOr<int?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int?>, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int?>, int?>,
              AsyncValue<int?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
