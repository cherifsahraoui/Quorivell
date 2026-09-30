import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/ai/local_model_downloader.dart';
import '../../../../core/ai/local_model_providers.dart';
import '../../../../core/ai/local_model_spec.dart';
import '../../../../core/ai/local_model_store.dart';
import '../../../../core/platform/extraction_platform_service.dart';
import '../../../../core/platform/model_transfer_platform_service.dart';
import '../../../assistant/data/providers/extraction_providers.dart';
import '../../data/providers/onboarding_providers.dart';

part 'local_model_install_controller.g.dart';

class LocalModelInstallSnapshot {
  const LocalModelInstallSnapshot({
    required this.isReady,
    this.isVerifying = false,
    this.isPicking = false,
    this.isDownloading = false,
    this.isImporting = false,
    this.isFinalizing = false,
    this.isExporting = false,
    this.hasPartialDownload = false,
    this.progress,
    this.receivedBytes,
    this.totalBytes,
    this.bytesPerSecond,
    this.remaining,
    this.origin,
    this.installedBytes,
    this.installedModelId,
    this.installedFileName,
    this.downloadingModelId,
    this.error,
  });

  final bool isReady;

  /// A GGUF is on disk and SHA-256 is running (or the first store lookup
  /// has not finished). Download/import actions must stay hidden.
  final bool isVerifying;

  /// The system file picker is open or still handing back the selected GGUF
  /// (Android SAF copy, length lookup). Show a blocking loader until import
  /// progress starts.
  final bool isPicking;
  final bool isDownloading;
  final bool isImporting;

  /// Download reached 100% and is unpacking/verifying before ready.
  final bool isFinalizing;

  /// Copying the installed GGUF to a user-chosen save location.
  final bool isExporting;

  final bool hasPartialDownload;
  final double? progress;
  final int? receivedBytes;
  final int? totalBytes;

  /// Smoothed download throughput in bytes/second while [isDownloading].
  final double? bytesPerSecond;

  /// Estimated time left while [isDownloading] and throughput is known.
  final Duration? remaining;

  /// How the current GGUF was installed, when known.
  final LocalModelOrigin? origin;
  final int? installedBytes;
  final String? installedModelId;
  final String? installedFileName;
  final String? downloadingModelId;
  final Object? error;

  bool get isBusy => isDownloading || isImporting || isFinalizing;
}

/// Tracks smoothed download throughput from successive byte samples.
class DownloadSpeedTracker {
  DateTime? _sampleAt;
  int? _sampleBytes;
  double? bytesPerSecond;

  void reset() {
    _sampleAt = null;
    _sampleBytes = null;
    bytesPerSecond = null;
  }

  /// Updates the EMA when at least [minSample] has elapsed since the last
  /// sample. Returns the current smoothed bytes/second (may be null).
  double? observe(
    int receivedBytes, {
    Duration minSample = const Duration(milliseconds: 400),
  }) {
    final now = DateTime.now();
    final previousAt = _sampleAt;
    final previousBytes = _sampleBytes;
    if (previousAt == null || previousBytes == null) {
      _sampleAt = now;
      _sampleBytes = receivedBytes;
      return bytesPerSecond;
    }

    final elapsed = now.difference(previousAt);
    if (elapsed < minSample) {
      return bytesPerSecond;
    }

    final deltaBytes = receivedBytes - previousBytes;
    final seconds = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    if (deltaBytes >= 0 && seconds > 0) {
      final instant = deltaBytes / seconds;
      bytesPerSecond = bytesPerSecond == null
          ? instant
          : (bytesPerSecond! * 0.7) + (instant * 0.3);
    }
    _sampleAt = now;
    _sampleBytes = receivedBytes;
    return bytesPerSecond;
  }

  Duration? remainingFor({
    required int receivedBytes,
    required int? totalBytes,
  }) {
    final rate = bytesPerSecond;
    if (rate == null || rate <= 0 || totalBytes == null || totalBytes <= 0) {
      return null;
    }
    final left = totalBytes - receivedBytes;
    if (left <= 0) {
      return Duration.zero;
    }
    return Duration(seconds: (left / rate).ceil());
  }
}

@Riverpod(keepAlive: true)
class LocalModelInstallController extends _$LocalModelInstallController {
  final _downloadSpeed = DownloadSpeedTracker();
  var _autoResumeScheduled = false;
  DateTime? _lastNotificationAt;
  int? _lastNotificationPercent;

  @override
  Future<LocalModelInstallSnapshot> build() async {
    final store = ref.watch(localModelStoreProvider);
    await store.cleanupStaleTemps();
    if (await store.isReady(hashIfNeeded: false)) {
      return _readySnapshot(store);
    }
    if (await store.hasModelFile()) {
      unawaited(_verifyExisting(store));
      return const LocalModelInstallSnapshot(isReady: false, isVerifying: true);
    }
    final partial = await store.partialProgress();
    final importPartial = await store.importPartialProgress();
    final downloadComplete = partial?.isComplete == true;
    _scheduleAutoResume(
      hasDownloadPart: partial != null,
      importUri: importPartial?.sourceUri,
    );
    return LocalModelInstallSnapshot(
      isReady: false,
      isFinalizing: downloadComplete,
      hasPartialDownload: partial != null && !downloadComplete,
      progress: importPartial?.progress ?? partial?.progress,
      receivedBytes: importPartial?.bytesReceived ?? partial?.bytesReceived,
      totalBytes: importPartial?.totalBytes ?? partial?.totalBytes,
      downloadingModelId: partial?.modelId,
    );
  }

  void _scheduleAutoResume({
    required bool hasDownloadPart,
    required String? importUri,
  }) {
    if (_autoResumeScheduled) return;
    _autoResumeScheduled = true;
    final transfer = ref.read(modelTransferPlatformServiceProvider);
    if (importUri != null &&
        importUri.isNotEmpty &&
        transfer.canRunNativeTransfers) {
      unawaited(Future<void>(() => resumeInterruptedImport()));
      return;
    }
    if (hasDownloadPart) {
      unawaited(
        Future<void>(() async {
          if (!ref.mounted) return;
          await download();
        }),
      );
    }
  }

  Future<void> _verifyExisting(LocalModelStore store) async {
    // Let [build] publish the verifying snapshot before this writes ready.
    await Future<void>.delayed(Duration.zero);
    if (!ref.mounted) return;
    try {
      final ready = await store.isReady();
      if (!ref.mounted) return;
      if (ready) {
        state = AsyncData(await _readySnapshot(store));
        return;
      }
      final partial = await store.partialProgress();
      if (!ref.mounted) return;
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: false,
          hasPartialDownload: partial != null,
          progress: partial?.progress,
          receivedBytes: partial?.bytesReceived,
          totalBytes: partial?.totalBytes,
        ),
      );
    } on Object catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        LocalModelInstallSnapshot(isReady: false, error: error),
      );
    }
  }

  Future<void> download({
    LocalModelSpec? spec,
    String progressTitle = '',
    String progressBody = '',
    String Function(LocalModelInstallSnapshot snapshot)? progressBodyFor,
    String completionTitle = '',
    String completionBody = '',
  }) async {
    final store = ref.read(localModelStoreProvider);
    final previous = state.asData?.value;
    final partial = await store.partialProgress();
    if (!ref.mounted) return;
    final LocalModelSpec requested =
        spec ??
        LocalModelSpec.byId(partial?.modelId) ??
        ref.read(localModelSpecProvider);
    // Changing model must not re-download the GGUF already installed.
    if (previous?.isReady == true &&
        previous?.installedModelId != null &&
        previous!.installedModelId == requested.modelId) {
      return;
    }
    await _prepareStoreForDownload(store, requested);
    if (!ref.mounted) return;
    final activePartial = await store.partialProgress();
    if (!ref.mounted) return;
    final alreadyComplete = activePartial?.isComplete == true;
    _downloadSpeed.reset();
    _resetNotificationThrottle();
    state = AsyncData(
      LocalModelInstallSnapshot(
        isReady: false,
        isDownloading: !alreadyComplete,
        isFinalizing: alreadyComplete,
        hasPartialDownload: activePartial != null && !alreadyComplete,
        progress: activePartial?.progress ?? (alreadyComplete ? 1 : 0),
        receivedBytes: activePartial?.bytesReceived,
        totalBytes: activePartial?.totalBytes,
        downloadingModelId: requested.modelId,
      ),
    );
    final platformService = ref.read(extractionPlatformServiceProvider);
    await platformService.startForegroundService(progressTitle, progressBody);
    try {
      await for (final tick
          in ref.read(localModelDownloaderProvider).download(spec: requested)) {
        final finalizing = tick.isComplete;
        final previous = state.asData?.value;
        final totalBytes = tick.totalBytes ?? previous?.totalBytes;
        final rate = finalizing
            ? null
            : _downloadSpeed.observe(tick.receivedBytes) ??
                  previous?.bytesPerSecond;
        final remaining = finalizing
            ? null
            : _downloadSpeed.remainingFor(
                    receivedBytes: tick.receivedBytes,
                    totalBytes: totalBytes,
                  ) ??
                  previous?.remaining;
        final snapshot = LocalModelInstallSnapshot(
          isReady: false,
          isDownloading: !finalizing,
          isFinalizing: finalizing,
          hasPartialDownload: !finalizing,
          progress: tick.progress,
          receivedBytes: tick.receivedBytes,
          totalBytes: totalBytes,
          bytesPerSecond: rate,
          remaining: remaining,
          downloadingModelId: requested.modelId,
        );
        state = AsyncData(snapshot);
        await _publishInstallNotification(
          platformService,
          progressTitle: progressTitle,
          progressBody: progressBody,
          progressBodyFor: progressBodyFor,
          snapshot: snapshot,
        );
      }
      _downloadSpeed.reset();
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: false,
          isFinalizing: true,
          progress: 1.0,
          downloadingModelId: requested.modelId,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      if (!ref.mounted) return;
      await store.isReady();
      if (!ref.mounted) return;
      state = AsyncData(
        await _readySnapshot(store, fallbackOrigin: LocalModelOrigin.download),
      );
      if (completionTitle.isNotEmpty && completionBody.isNotEmpty) {
        await platformService.showCompletionNotification(
          completionTitle,
          completionBody,
        );
      }
    } on LocalModelDownloadCancelledException {
      _downloadSpeed.reset();
      final paused = await store.partialProgress();
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: false,
          hasPartialDownload: paused != null,
          progress: paused?.progress,
          receivedBytes: paused?.bytesReceived,
          totalBytes: paused?.totalBytes,
          downloadingModelId: paused?.modelId ?? requested.modelId,
        ),
      );
    } on Object catch (error) {
      _downloadSpeed.reset();
      await store.clearImportPartial();
      final paused = await store.partialProgress();
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: false,
          hasPartialDownload: paused != null,
          progress: paused?.progress,
          receivedBytes: paused?.bytesReceived,
          totalBytes: paused?.totalBytes,
          downloadingModelId: paused?.modelId,
          error: error,
        ),
      );
    } finally {
      _resetNotificationThrottle();
      await platformService.stopForegroundService();
    }
  }

  void cancelDownload() {
    ref.read(localModelDownloaderProvider).cancel();
  }

  Future<void> clearPartialDownload() async {
    final store = ref.read(localModelStoreProvider);
    final part = await store.partialFile();
    ref.read(localModelDownloaderProvider).cancel();
    ref.read(modelTransferPlatformServiceProvider).cancelDownload(part);
    await store.clearPartialDownload();
    await store.clearImportPartial();
    state = const AsyncData(LocalModelInstallSnapshot(isReady: false));
  }

  /// Frees import leftovers and, when [includeResumePart] is true, the paused
  /// download too — use after a disk-full error.
  Future<void> reclaimTemporarySpace({bool includeResumePart = true}) async {
    final store = ref.read(localModelStoreProvider);
    await store.cleanupStaleTemps(
      keepResumePart: !includeResumePart,
      keepImportPart: false,
    );
    final partial = await store.partialProgress();
    state = AsyncData(
      LocalModelInstallSnapshot(
        isReady: false,
        hasPartialDownload: partial != null,
        progress: partial?.progress,
        receivedBytes: partial?.bytesReceived,
        totalBytes: partial?.totalBytes,
      ),
    );
  }

  /// Shows a blocking loader before the selected local GGUF is available.
  void beginPicking() {
    final current = state.asData?.value;
    if (current?.isBusy == true || current?.isPicking == true) return;
    state = AsyncData(
      LocalModelInstallSnapshot(
        isReady: current?.isReady ?? false,
        isPicking: true,
        hasPartialDownload: current?.hasPartialDownload ?? false,
        progress: current?.progress,
        receivedBytes: current?.receivedBytes,
        totalBytes: current?.totalBytes,
        origin: current?.origin,
        installedBytes: current?.installedBytes,
      ),
    );
  }

  /// Restores the snapshot from before [beginPicking] when the picker cancels.
  void cancelPicking() {
    final current = state.asData?.value;
    if (current == null || !current.isPicking) return;
    state = AsyncData(
      LocalModelInstallSnapshot(
        isReady: current.isReady,
        hasPartialDownload: current.hasPartialDownload,
        progress: current.progress,
        receivedBytes: current.receivedBytes,
        totalBytes: current.totalBytes,
        origin: current.origin,
        installedBytes: current.installedBytes,
      ),
    );
  }

  /// Imports a GGUF already on this device (e.g. Downloads).
  Future<void> importLocalBytes(
    Stream<List<int>> bytes, {
    int? totalBytes,
    String progressTitle = '',
    String progressBody = '',
    String completionTitle = '',
    String completionBody = '',
  }) async {
    state = const AsyncData(
      LocalModelInstallSnapshot(isReady: false, isImporting: true, progress: 0),
    );
    await Future<void>.delayed(Duration.zero);
    final platformService = ref.read(extractionPlatformServiceProvider);
    _resetNotificationThrottle();
    await platformService.startForegroundService(progressTitle, progressBody);
    try {
      await for (final progress
          in ref
              .read(localModelStoreProvider)
              .installFromBytes(bytes, totalBytes: totalBytes)) {
        final snapshot = LocalModelInstallSnapshot(
          isReady: false,
          isImporting: true,
          progress: progress,
          totalBytes: totalBytes,
        );
        state = AsyncData(snapshot);
        await _publishInstallNotification(
          platformService,
          progressTitle: progressTitle,
          progressBody: progressBody,
          snapshot: snapshot,
        );
      }
      state = AsyncData(
        await _readySnapshot(
          ref.read(localModelStoreProvider),
          fallbackOrigin: LocalModelOrigin.import,
        ),
      );
      if (completionTitle.isNotEmpty && completionBody.isNotEmpty) {
        await platformService.showCompletionNotification(
          completionTitle,
          completionBody,
        );
      }
    } on Object catch (error) {
      state = AsyncData(
        LocalModelInstallSnapshot(isReady: false, error: error),
      );
    } finally {
      _resetNotificationThrottle();
      await platformService.stopForegroundService();
    }
  }

  Future<void> importLocalFile(
    File source, {
    String progressTitle = '',
    String progressBody = '',
    String completionTitle = '',
    String completionBody = '',
  }) async {
    state = const AsyncData(
      LocalModelInstallSnapshot(isReady: false, isImporting: true, progress: 0),
    );
    await Future<void>.delayed(Duration.zero);
    final platformService = ref.read(extractionPlatformServiceProvider);
    _resetNotificationThrottle();
    await platformService.startForegroundService(progressTitle, progressBody);
    try {
      await for (final progress
          in ref.read(localModelStoreProvider).installFromFile(source)) {
        final snapshot = LocalModelInstallSnapshot(
          isReady: false,
          isImporting: true,
          progress: progress,
        );
        state = AsyncData(snapshot);
        await _publishInstallNotification(
          platformService,
          progressTitle: progressTitle,
          progressBody: progressBody,
          snapshot: snapshot,
        );
      }
      state = AsyncData(
        await _readySnapshot(
          ref.read(localModelStoreProvider),
          fallbackOrigin: LocalModelOrigin.import,
        ),
      );
      if (completionTitle.isNotEmpty && completionBody.isNotEmpty) {
        await platformService.showCompletionNotification(
          completionTitle,
          completionBody,
        );
      }
    } on Object catch (error) {
      state = AsyncData(
        LocalModelInstallSnapshot(isReady: false, error: error),
      );
    } finally {
      _resetNotificationThrottle();
      await platformService.stopForegroundService();
    }
  }

  /// Android SAF pick. Returns a valid GGUF, or null if cancelled / invalid.
  ///
  /// Leaves [LocalModelInstallSnapshot.isPicking] true until
  /// [importPickedGguf] or [cancelPicking].
  Future<PickedGguf?> pickGguf() async {
    beginPicking();
    final transfer = ref.read(modelTransferPlatformServiceProvider);
    try {
      final picked = await transfer.pickGguf();
      if (picked == null) {
        cancelPicking();
        return null;
      }
      if (!picked.isGguf) {
        failImport(const LocalModelImportException());
        return null;
      }
      return picked;
    } on Object catch (error) {
      failImport(error);
      return null;
    }
  }

  /// Imports a GGUF previously returned by [pickGguf].
  Future<void> importPickedGguf(
    PickedGguf picked, {
    String progressTitle = '',
    String progressBody = '',
    String completionTitle = '',
    String completionBody = '',
  }) {
    return _importPickedGguf(
      picked,
      progressTitle: progressTitle,
      progressBody: progressBody,
      completionTitle: completionTitle,
      completionBody: completionBody,
    );
  }

  /// Android SAF pick + native single-stream copy under the dataSync FGS.
  Future<void> pickAndImport({
    String progressTitle = '',
    String progressBody = '',
    String completionTitle = '',
    String completionBody = '',
  }) async {
    final picked = await pickGguf();
    if (picked == null) return;
    await importPickedGguf(
      picked,
      progressTitle: progressTitle,
      progressBody: progressBody,
      completionTitle: completionTitle,
      completionBody: completionBody,
    );
  }

  Future<void> resumeInterruptedImport({
    String progressTitle = '',
    String progressBody = '',
    String completionTitle = '',
    String completionBody = '',
  }) async {
    final store = ref.read(localModelStoreProvider);
    final partial = await store.importPartialProgress();
    final uri = partial?.sourceUri;
    if (uri == null || uri.isEmpty) return;
    await _importFromContentUri(
      uri: uri,
      displayName: partial?.displayName,
      existingBytes: partial?.bytesReceived ?? 0,
      totalBytes: partial?.totalBytes,
      progressTitle: progressTitle,
      progressBody: progressBody,
      completionTitle: completionTitle,
      completionBody: completionBody,
    );
  }

  Future<void> _importPickedGguf(
    PickedGguf picked, {
    required String progressTitle,
    required String progressBody,
    required String completionTitle,
    required String completionBody,
  }) async {
    final store = ref.read(localModelStoreProvider);
    await store.writeImportPartialMeta(
      totalBytes: picked.size,
      sourceUri: picked.uri,
      displayName: picked.displayName,
    );
    await _importFromContentUri(
      uri: picked.uri,
      displayName: picked.displayName,
      existingBytes: 0,
      totalBytes: picked.size,
      progressTitle: progressTitle,
      progressBody: progressBody,
      completionTitle: completionTitle,
      completionBody: completionBody,
    );
  }

  Future<void> _importFromContentUri({
    required String uri,
    required String? displayName,
    required int existingBytes,
    int? totalBytes,
    required String progressTitle,
    required String progressBody,
    required String completionTitle,
    required String completionBody,
  }) async {
    final store = ref.read(localModelStoreProvider);
    final dest = await store.importPartialFile();
    await dest.parent.create(recursive: true);
    state = AsyncData(
      LocalModelInstallSnapshot(
        isReady: false,
        isImporting: true,
        progress: totalBytes != null && totalBytes > 0
            ? (existingBytes / totalBytes).clamp(0, 1)
            : 0,
        receivedBytes: existingBytes,
        totalBytes: totalBytes,
      ),
    );
    final platformService = ref.read(extractionPlatformServiceProvider);
    final transfer = ref.read(modelTransferPlatformServiceProvider);
    _resetNotificationThrottle();
    await platformService.startForegroundService(progressTitle, progressBody);
    try {
      await for (final tick in transfer.copyFromUri(
        uri: uri,
        destFile: dest,
        existingBytes: existingBytes,
        totalBytes: totalBytes,
        title: progressTitle,
        body: progressBody,
      )) {
        final snapshot = LocalModelInstallSnapshot(
          isReady: false,
          isImporting: !tick.isComplete,
          isFinalizing: tick.isComplete,
          progress: tick.progress,
          receivedBytes: tick.receivedBytes,
          totalBytes: tick.totalBytes,
        );
        state = AsyncData(snapshot);
        await _publishInstallNotification(
          platformService,
          progressTitle: progressTitle,
          progressBody: progressBody,
          snapshot: snapshot,
        );
      }
      final finalizing = LocalModelInstallSnapshot(
        isReady: false,
        isFinalizing: true,
        progress: 1,
        receivedBytes: totalBytes,
        totalBytes: totalBytes,
      );
      state = AsyncData(finalizing);
      await _publishInstallNotification(
        platformService,
        progressTitle: progressTitle,
        progressBody: progressBody,
        snapshot: finalizing,
      );
      await _installCompletedImportPart(displayName: displayName);
      if (!ref.mounted) return;
      state = AsyncData(
        await _readySnapshot(store, fallbackOrigin: LocalModelOrigin.import),
      );
      if (completionTitle.isNotEmpty && completionBody.isNotEmpty) {
        await platformService.showCompletionNotification(
          completionTitle,
          completionBody,
        );
      }
    } on LocalModelDownloadCancelledException {
      final paused = await store.importPartialProgress();
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: false,
          progress: paused?.progress,
          receivedBytes: paused?.bytesReceived,
          totalBytes: paused?.totalBytes,
        ),
      );
    } on Object catch (error) {
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: false,
          error: error is LocalModelImportException
              ? error
              : const LocalModelImportException(),
        ),
      );
    } finally {
      _resetNotificationThrottle();
      await platformService.stopForegroundService();
    }
  }

  Future<void> _installCompletedImportPart({String? displayName}) async {
    final store = ref.read(localModelStoreProvider);
    final temp = await store.importPartialFile();
    if (!temp.existsSync() || temp.lengthSync() <= 0) {
      throw const LocalModelImportException();
    }
    final digest = await sha256.bind(temp.openRead()).first;
    final name = (displayName == null || displayName.trim().isEmpty)
        ? store.spec.fileName
        : displayName.trim();
    await store.installVerified(
      temp,
      digest.toString(),
      origin: LocalModelOrigin.import,
      requireChecksum: false,
      identity: LocalModelSpec(
        modelId: name,
        fileName: name,
        downloadUri: store.spec.downloadUri,
      ),
    );
    await store.clearImportPartial();
  }

  Future<void> deleteInstalled() async {
    await _unloadLocalRuntime();
    final store = ref.read(localModelStoreProvider);
    await store.deleteInstalled();
    await ref.read(modelSetupStateProvider.notifier).markCompleted();
    final partial = await store.partialProgress();
    state = AsyncData(
      LocalModelInstallSnapshot(
        isReady: false,
        hasPartialDownload: partial != null,
        progress: partial?.progress,
        receivedBytes: partial?.bytesReceived,
        totalBytes: partial?.totalBytes,
      ),
    );
  }

  /// Saves a copy of the installed GGUF to a user-chosen location (Downloads
  /// / Files via SAF on Android) so it can be re-selected later.
  ///
  /// Returns `true` when the copy finished, `false` when the user cancelled
  /// the save dialog, and throws [LocalModelExportException] on failure.
  Future<bool> exportInstalled({
    String progressTitle = '',
    String progressBody = '',
    String completionTitle = '',
    String completionBody = '',
  }) async {
    final current = state.asData?.value;
    if (current == null ||
        !current.isReady ||
        current.isBusy ||
        current.isExporting ||
        current.isPicking) {
      return false;
    }

    final store = ref.read(localModelStoreProvider);
    final source = await store.modelFile();
    if (!source.existsSync() || source.lengthSync() <= 0) {
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: true,
          origin: current.origin,
          installedBytes: current.installedBytes,
          installedModelId: current.installedModelId,
          installedFileName: current.installedFileName,
          error: const LocalModelExportException(),
        ),
      );
      return false;
    }

    final suggestedName =
        current.installedFileName ??
        (await store.readInstalledIdentity())?.fileName ??
        store.spec.fileName;
    final transfer = ref.read(modelTransferPlatformServiceProvider);
    final uri = await transfer.createGgufDocument(suggestedName: suggestedName);
    if (uri == null || uri.isEmpty) {
      return false;
    }

    final statusFile = await store.exportStatusFile();
    final totalBytes = source.lengthSync();
    _downloadSpeed.reset();
    state = AsyncData(
      LocalModelInstallSnapshot(
        isReady: true,
        isExporting: true,
        progress: 0,
        receivedBytes: 0,
        totalBytes: totalBytes,
        origin: current.origin,
        installedBytes: current.installedBytes,
        installedModelId: current.installedModelId,
        installedFileName: current.installedFileName,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final platformService = ref.read(extractionPlatformServiceProvider);
    _resetNotificationThrottle();
    await platformService.startForegroundService(progressTitle, progressBody);
    try {
      if (!transfer.canRunNativeTransfers) {
        throw const LocalModelExportException();
      }
      await for (final tick in transfer.copyToUri(
        sourceFile: source,
        uri: uri,
        statusFile: statusFile,
        title: progressTitle,
        body: progressBody,
      )) {
        if (!ref.mounted) return false;
        final speed = _downloadSpeed.observe(tick.receivedBytes);
        final snapshot = LocalModelInstallSnapshot(
          isReady: true,
          isExporting: true,
          progress: tick.progress,
          receivedBytes: tick.receivedBytes,
          totalBytes: tick.totalBytes ?? totalBytes,
          bytesPerSecond: speed,
          remaining: _downloadSpeed.remainingFor(
            receivedBytes: tick.receivedBytes,
            totalBytes: tick.totalBytes ?? totalBytes,
          ),
          origin: current.origin,
          installedBytes: current.installedBytes,
          installedModelId: current.installedModelId,
          installedFileName: current.installedFileName,
        );
        state = AsyncData(snapshot);
        await _publishInstallNotification(
          platformService,
          progressTitle: progressTitle,
          progressBody: progressBody,
          snapshot: snapshot,
        );
      }
      if (!ref.mounted) return false;
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: true,
          origin: current.origin,
          installedBytes: current.installedBytes,
          installedModelId: current.installedModelId,
          installedFileName: current.installedFileName,
        ),
      );
      if (completionTitle.isNotEmpty && completionBody.isNotEmpty) {
        await platformService.showCompletionNotification(
          completionTitle,
          completionBody,
        );
      }
      return true;
    } on LocalModelDownloadCancelledException {
      if (!ref.mounted) return false;
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: true,
          origin: current.origin,
          installedBytes: current.installedBytes,
          installedModelId: current.installedModelId,
          installedFileName: current.installedFileName,
        ),
      );
      return false;
    } on Object {
      if (!ref.mounted) return false;
      state = AsyncData(
        LocalModelInstallSnapshot(
          isReady: true,
          origin: current.origin,
          installedBytes: current.installedBytes,
          installedModelId: current.installedModelId,
          installedFileName: current.installedFileName,
          error: const LocalModelExportException(),
        ),
      );
      return false;
    } finally {
      _downloadSpeed.reset();
      _resetNotificationThrottle();
      await platformService.stopForegroundService();
      try {
        await store.cleanupStaleTemps();
        final export = await store.exportStatusFile();
        await _deleteQuietly(File('${export.path}.status'));
        await _deleteQuietly(File('${export.path}.cancel'));
        await _deleteQuietly(export);
      } on Object {
        // Best-effort cleanup of export sidecars.
      }
    }
  }

  void cancelExport() {
    final current = state.asData?.value;
    if (current == null || !current.isExporting) return;
    unawaited(() async {
      final status = await ref.read(localModelStoreProvider).exportStatusFile();
      ref.read(modelTransferPlatformServiceProvider).cancelExport(status);
    }());
  }

  Future<void> _deleteQuietly(File file) async {
    if (!file.existsSync()) return;
    try {
      await file.delete();
    } on Object {
      // Ignore.
    }
  }

  /// Stops llama.cpp so the GGUF is not mmap-locked while it is replaced.
  Future<void> _unloadLocalRuntime() async {
    try {
      await ref.read(localAIServiceProvider).dispose();
    } on Object {
      // Still replace the on-disk GGUF if the runtime cannot stop cleanly.
    }
    ref.invalidate(localAIServiceProvider);
  }

  /// Unloads the current model, frees its GGUF, and drops a `.part` that
  /// belongs to a different catalog entry before a new download starts.
  Future<void> _prepareStoreForDownload(
    LocalModelStore store,
    LocalModelSpec requested,
  ) async {
    await store.clearImportPartial();
    if (await store.hasModelFile()) {
      await _unloadLocalRuntime();
      cancelDownload();
      ref
          .read(modelTransferPlatformServiceProvider)
          .cancelDownload(await store.partialFile());
      await store.removeInstalledWeights();
    }
    await store.clearPartialUnlessFor(requested.modelId);
  }

  void failImport([Object error = const LocalModelImportException()]) {
    state = AsyncData(LocalModelInstallSnapshot(isReady: false, error: error));
  }

  void clearError() {
    final current = state.asData?.value;
    if (current == null ||
        current.error == null ||
        current.isBusy ||
        current.isExporting ||
        current.isPicking) {
      return;
    }
    state = AsyncData(
      LocalModelInstallSnapshot(
        isReady: current.isReady,
        hasPartialDownload: current.hasPartialDownload,
        progress: current.progress,
        receivedBytes: current.receivedBytes,
        totalBytes: current.totalBytes,
        origin: current.origin,
        installedBytes: current.installedBytes,
        installedModelId: current.installedModelId,
        installedFileName: current.installedFileName,
      ),
    );
  }

  Future<LocalModelInstallSnapshot> _readySnapshot(
    LocalModelStore store, {
    LocalModelOrigin? fallbackOrigin,
  }) async {
    final identity = await store.readInstalledIdentity();
    return LocalModelInstallSnapshot(
      isReady: true,
      origin: await store.readOrigin() ?? fallbackOrigin,
      installedBytes: await store.installedByteLength(),
      installedModelId: identity?.modelId,
      installedFileName: identity?.fileName,
    );
  }

  void _resetNotificationThrottle() {
    _lastNotificationAt = null;
    _lastNotificationPercent = null;
  }

  bool _snapshotHasLiveStats(LocalModelInstallSnapshot snapshot) {
    final speed = snapshot.bytesPerSecond;
    return !snapshot.isFinalizing &&
        speed != null &&
        speed > 0 &&
        snapshot.remaining != null;
  }

  /// Pushes determinate progress (and optional stats body) to the FGS notice.
  Future<void> _publishInstallNotification(
    ExtractionPlatformService platformService, {
    required String progressTitle,
    required String progressBody,
    String Function(LocalModelInstallSnapshot snapshot)? progressBodyFor,
    required LocalModelInstallSnapshot snapshot,
  }) async {
    final progress = snapshot.progress;
    final totalKnown =
        (snapshot.totalBytes != null && snapshot.totalBytes! > 0) ||
        (progress != null && progress > 0);
    final percent = progress == null
        ? 0
        : (progress * 100).floor().clamp(0, 100);
    final proposed = progressBodyFor?.call(snapshot) ?? progressBody;
    final hasLiveStats = _snapshotHasLiveStats(snapshot);
    // After the first post, only replace the text when stats (or finalizing)
    // are available. Percent-only / generic bodies race the native worker and
    // make speed/ETA vanish on each +1%.
    final String? body;
    if (snapshot.isFinalizing || hasLiveStats || _lastNotificationAt == null) {
      body = proposed;
    } else {
      body = null;
    }

    final now = DateTime.now();
    final lastAt = _lastNotificationAt;
    final elapsed = lastAt == null
        ? const Duration(days: 1)
        : now.difference(lastAt);
    final percentChanged = _lastNotificationPercent != percent;
    if (elapsed < const Duration(milliseconds: 400) &&
        !percentChanged &&
        !snapshot.isFinalizing) {
      return;
    }

    final indeterminate = snapshot.isFinalizing || !totalKnown || percent <= 0;
    await platformService.updateForegroundServiceProgress(
      current: indeterminate ? 0 : percent,
      total: indeterminate ? 0 : 100,
      title: progressTitle.isEmpty ? null : progressTitle,
      body: (body == null || body.isEmpty) ? null : body,
    );
    _lastNotificationAt = now;
    _lastNotificationPercent = percent;
  }
}

String localModelInstallErrorMessage(
  Object? error, {
  required String checksum,
  required String download,
  required String import,
  required String storageFull,
}) {
  if (error is LocalModelChecksumException) return checksum;
  if (error is LocalModelStorageFullException) return storageFull;
  if (error is LocalModelImportException) return import;
  return download;
}
