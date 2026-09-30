import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/ai/local_ai_service.dart';
import 'package:quorivell/core/ai/local_model_downloader.dart';
import 'package:quorivell/core/ai/local_model_providers.dart';
import 'package:quorivell/core/ai/local_model_spec.dart';
import 'package:quorivell/core/ai/local_model_store.dart';
import 'package:quorivell/core/platform/extraction_platform_service.dart';
import 'package:quorivell/core/platform/model_transfer_platform_service.dart';
import 'package:quorivell/features/assistant/data/providers/extraction_providers.dart';
import 'package:quorivell/features/onboarding/data/providers/onboarding_providers.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAiService implements LocalAIService {
  var disposed = false;

  @override
  String get modelId => 'test-model';

  @override
  int get maxInputCharacters => LocalAIRequest.maxInputCharacters;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<LocalAIResponse> extract(LocalAIRequest request) async {
    return const LocalAIResponse(modelId: 'test-model', candidates: []);
  }

  @override
  Future<LocalAIResponse> extractChunked(
    LocalAIRequest request, {
    void Function(ExtractionChunkResult chunk)? onChunk,
    int skipChunks = 0,
  }) async {
    return const LocalAIResponse(modelId: 'test-model', candidates: []);
  }

  @override
  Future<String> chat(
    LocalChatRequest request, {
    void Function(String token)? onToken,
  }) async => '';

  @override
  Future<void> stopChat() async {}

  @override
  void prepareExtraction() {}

  @override
  Future<void> cancelExtraction() async {}

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}

class _RecordingKeepAlive implements ExtractionPlatformService {
  var starts = 0;
  var stops = 0;
  var completions = 0;
  final progressUpdates = <({int current, int total, String? body})>[];

  @override
  Future<void> startForegroundService(
    String title,
    String body, {
    String destination = '',
  }) async {
    starts += 1;
  }

  @override
  Future<void> updateForegroundServiceProgress({
    required int current,
    required int total,
    String? title,
    String? body,
  }) async {
    progressUpdates.add((current: current, total: total, body: body));
  }

  @override
  Future<void> stopForegroundService() async {
    stops += 1;
  }

  @override
  Future<void> showCompletionNotification(
    String title,
    String body, {
    String destination = '',
  }) async {
    completions += 1;
  }

  @override
  Future<String?> consumeLaunchDestination() async => null;

  @override
  Stream<String> get launchDestinations => const Stream.empty();

  @override
  Future<bool> isForegroundServiceRunning() async => false;
}

class _FakeDownloader extends LocalModelDownloader {
  _FakeDownloader(this._progress) : super(store: _unusedStore);

  static final _unusedStore = LocalModelStore(
    resolveDocumentsDirectory: () async => Directory.systemTemp,
  );

  final List<double> _progress;

  @override
  Stream<LocalModelDownloadTick> download({LocalModelSpec? spec}) async* {
    for (final value in _progress) {
      final total = 100;
      final received = (value * total).round();
      yield LocalModelDownloadTick(
        progress: value,
        receivedBytes: received,
        totalBytes: total,
      );
    }
  }
}

class _HoldingDownloader extends LocalModelDownloader {
  _HoldingDownloader(this._gate) : super(store: _FakeDownloader._unusedStore);

  final Completer<void> _gate;

  @override
  Stream<LocalModelDownloadTick> download({LocalModelSpec? spec}) async* {
    yield const LocalModelDownloadTick(
      progress: 1,
      receivedBytes: 100,
      totalBytes: 100,
      isFinalizing: true,
    );
    await _gate.future;
  }
}

class _PacedDownloader extends LocalModelDownloader {
  _PacedDownloader(this._steps) : super(store: _FakeDownloader._unusedStore);

  final List<(int received, int total, Duration delayBefore)> _steps;

  @override
  Stream<LocalModelDownloadTick> download({LocalModelSpec? spec}) async* {
    for (final (received, total, delayBefore) in _steps) {
      if (delayBefore > Duration.zero) {
        await Future<void>.delayed(delayBefore);
      }
      yield LocalModelDownloadTick(
        progress: received / total,
        receivedBytes: received,
        totalBytes: total,
      );
    }
  }
}

class _ScriptedPickTransfer extends StubModelTransferPlatformService {
  _ScriptedPickTransfer(this._picked);

  final PickedGguf? _picked;
  var pickCalls = 0;

  @override
  Future<PickedGguf?> pickGguf() async {
    pickCalls += 1;
    return _picked;
  }
}

class _ScriptedExportTransfer extends StubModelTransferPlatformService {
  _ScriptedExportTransfer({this.documentUri = 'content://exports/model.gguf'})
    : ticks = const [(50, 100), (100, 100)];

  final String? documentUri;
  final List<(int, int)> ticks;
  var createCalls = 0;
  var exportCalls = 0;
  var cancelCalls = 0;

  @override
  bool get canRunNativeTransfers => true;

  @override
  Future<String?> createGgufDocument({required String suggestedName}) async {
    createCalls += 1;
    return documentUri;
  }

  @override
  Stream<LocalModelDownloadTick> copyToUri({
    required File sourceFile,
    required String uri,
    required File statusFile,
    String? title,
    String? body,
  }) async* {
    exportCalls += 1;
    for (final (received, total) in ticks) {
      yield LocalModelDownloadTick(
        progress: received / total,
        receivedBytes: received,
        totalBytes: total,
      );
    }
  }

  @override
  void cancelExport(File statusFile) {
    cancelCalls += 1;
  }
}

void main() {
  late Directory tempDir;
  const payload = [3, 1, 4];
  final spec = LocalModelSpec(
    modelId: 'test-model',
    fileName: 'test.gguf',
    downloadUri: 'http://127.0.0.1/test.gguf',
    sha256: sha256.convert(payload).toString(),
  );

  Future<ProviderContainer> containerFor({
    required bool ready,
    LocalModelDownloader? downloader,
    ExtractionPlatformService? keepAlive,
    ModelTransferPlatformService? transfer,
    _FakeAiService? ai,
  }) async {
    tempDir = await Directory.systemTemp.createTemp('quorivell-install-');
    addTearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    if (ready) {
      final temp = File('${tempDir.path}${Platform.pathSeparator}part');
      await temp.writeAsBytes(payload);
      await store.installVerified(temp, sha256.convert(payload).toString());
    }
    final container = ProviderContainer(
      overrides: [
        localModelStoreProvider.overrideWithValue(store),
        localModelSpecProvider.overrideWithValue(spec),
        localAIServiceProvider.overrideWithValue(ai ?? _FakeAiService()),
        if (downloader != null)
          localModelDownloaderProvider.overrideWithValue(downloader),
        if (keepAlive != null)
          extractionPlatformServiceProvider.overrideWithValue(keepAlive),
        if (transfer != null)
          modelTransferPlatformServiceProvider.overrideWithValue(transfer),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('reports a missing model as not ready', () async {
    final container = await containerFor(ready: false);
    container.listen(localModelInstallControllerProvider, (_, _) {});

    final snapshot = await container.read(
      localModelInstallControllerProvider.future,
    );

    expect(snapshot.isReady, isFalse);
    expect(snapshot.isVerifying, isFalse);
  });

  test(
    'verifies an on-disk model without blocking the first snapshot',
    () async {
      tempDir = await Directory.systemTemp.createTemp('quorivell-install-');
      addTearDown(() async {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });
      final store = LocalModelStore(
        resolveDocumentsDirectory: () async => tempDir,
        spec: spec,
      );
      final dest = await store.modelFile();
      await dest.parent.create(recursive: true);
      await dest.writeAsBytes(payload);

      final container = ProviderContainer(
        overrides: [
          localModelStoreProvider.overrideWithValue(store),
          localModelSpecProvider.overrideWithValue(spec),
        ],
      );
      addTearDown(container.dispose);

      container.listen(localModelInstallControllerProvider, (_, _) {});

      final first = await container.read(
        localModelInstallControllerProvider.future,
      );
      expect(first.isVerifying, isTrue);
      expect(first.isReady, isFalse);

      LocalModelInstallSnapshot? ready;
      for (var i = 0; i < 50; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final value = container.read(localModelInstallControllerProvider).value;
        if (value?.isReady == true) {
          ready = value;
          break;
        }
      }
      expect(ready?.isReady, isTrue);
      expect(ready?.isVerifying, isFalse);
    },
  );

  test('records download progress then ready', () async {
    final keepAlive = _RecordingKeepAlive();
    final container = await containerFor(
      ready: false,
      downloader: _FakeDownloader(const [0.25, 1]),
      keepAlive: keepAlive,
    );
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    await container
        .read(localModelInstallControllerProvider.notifier)
        .download(
          progressTitle: 'Downloading model',
          progressBody: 'Starting',
          progressBodyFor: (snapshot) {
            final percent = ((snapshot.progress ?? 0) * 100).floor();
            final speed = snapshot.bytesPerSecond;
            if (speed == null) return '$percent%';
            return '$percent% · fast';
          },
        );

    final snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.isReady, isTrue);
    expect(snapshot?.isDownloading, isFalse);
    expect(snapshot?.origin, LocalModelOrigin.download);
    expect(keepAlive.starts, 1);
    expect(keepAlive.stops, 1);
    expect(keepAlive.progressUpdates, isNotEmpty);
    expect(
      keepAlive.progressUpdates.any((u) => u.current == 25 && u.total == 100),
      isTrue,
    );
    expect(
      keepAlive.progressUpdates.any(
        (u) => u.body != null && u.body!.contains('%'),
      ),
      isTrue,
    );
  });

  test('does not drop notification stats after speed is known', () async {
    final keepAlive = _RecordingKeepAlive();
    final container = await containerFor(
      ready: false,
      downloader: _PacedDownloader(const [
        (100000, 1000000, Duration.zero),
        (200000, 1000000, Duration(milliseconds: 450)),
        (210000, 1000000, Duration(milliseconds: 50)),
        (1000000, 1000000, Duration(milliseconds: 50)),
      ]),
      keepAlive: keepAlive,
    );
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    await container
        .read(localModelInstallControllerProvider.notifier)
        .download(
          progressTitle: 'Downloading model',
          progressBody: 'Starting',
          progressBodyFor: (snapshot) {
            if (snapshot.isFinalizing) return 'Finalizing';
            final percent = ((snapshot.progress ?? 0) * 100).floor();
            final speed = snapshot.bytesPerSecond;
            if (speed == null) return '$percent%';
            return '$percent% · fast';
          },
        );

    final bodies = keepAlive.progressUpdates
        .map((u) => u.body)
        .whereType<String>()
        .toList();
    final firstStats = bodies.indexWhere((body) => body.contains('fast'));
    expect(firstStats, greaterThanOrEqualTo(0));
    expect(
      bodies.skip(firstStats).where((body) => RegExp(r'^\d+%$').hasMatch(body)),
      isEmpty,
    );
  });

  test('skips re-download when the same model is already ready', () async {
    final downloader = _FakeDownloader(const [1]);
    final container = await containerFor(ready: true, downloader: downloader);
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    await container
        .read(localModelInstallControllerProvider.notifier)
        .download(spec: spec);

    final snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.isReady, isTrue);
    expect(snapshot?.isDownloading, isFalse);
    expect(snapshot?.installedModelId, spec.modelId);
  });

  test(
    'replacing an installed model unloads the runtime and removes the GGUF',
    () async {
      final ai = _FakeAiService();
      final other = LocalModelSpec(
        modelId: 'other-model',
        fileName: 'other.gguf',
        downloadUri: 'http://127.0.0.1/other.gguf',
      );
      final container = await containerFor(
        ready: true,
        downloader: _FakeDownloader(const [1]),
        ai: ai,
      );
      container.listen(localModelInstallControllerProvider, (_, _) {});
      await container.read(localModelInstallControllerProvider.future);

      await container
          .read(localModelInstallControllerProvider.notifier)
          .download(spec: other);

      expect(ai.disposed, isTrue);
      expect(
        await container.read(localModelStoreProvider).hasModelFile(),
        isFalse,
      );
    },
  );

  test('imports a local file then ready', () async {
    final container = await containerFor(ready: false);
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    final source = File('${tempDir.path}${Platform.pathSeparator}source.gguf');
    await source.writeAsBytes(payload);

    await container
        .read(localModelInstallControllerProvider.notifier)
        .importLocalFile(source);

    final snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.isReady, isTrue);
    expect(snapshot?.isImporting, isFalse);
    expect(snapshot?.origin, LocalModelOrigin.import);
  });

  test('auto-resumes a partial download without a Resume tap', () async {
    final container = await containerFor(
      ready: false,
      downloader: _FakeDownloader(const [1]),
    );
    final store = container.read(localModelStoreProvider);
    final part = await store.partialFile();
    await part.parent.create(recursive: true);
    await part.writeAsBytes(payload.sublist(0, 2));
    await store.writePartialMeta(
      totalBytes: payload.length,
      modelId: spec.modelId,
    );

    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    LocalModelInstallSnapshot? ready;
    for (var i = 0; i < 50; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      final value = container.read(localModelInstallControllerProvider).value;
      if (value?.isReady == true) {
        ready = value;
        break;
      }
    }
    expect(ready?.isReady, isTrue);
    expect(ready?.isDownloading, isFalse);
  });

  test(
    '100% download tick is shown as finalizing, not stuck downloading',
    () async {
      final gate = Completer<void>();
      addTearDown(() {
        if (!gate.isCompleted) gate.complete();
      });
      final container = await containerFor(
        ready: false,
        downloader: _HoldingDownloader(gate),
      );
      container.listen(localModelInstallControllerProvider, (_, _) {});
      await container.read(localModelInstallControllerProvider.future);

      final inFlight = container
          .read(localModelInstallControllerProvider.notifier)
          .download();

      LocalModelInstallSnapshot? finalizing;
      for (var i = 0; i < 50; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final value = container.read(localModelInstallControllerProvider).value;
        if (value?.isFinalizing == true) {
          finalizing = value;
          break;
        }
      }
      expect(finalizing?.isFinalizing, isTrue);
      expect(finalizing?.isDownloading, isFalse);
      expect(finalizing?.progress, 1);
      expect(finalizing?.isBusy, isTrue);

      gate.complete();
      await inFlight;
    },
  );

  test(
    'complete partial shows finalizing on launch without a Resume tap',
    () async {
      final gate = Completer<void>();
      addTearDown(() {
        if (!gate.isCompleted) gate.complete();
      });
      final container = await containerFor(
        ready: false,
        downloader: _HoldingDownloader(gate),
      );
      final store = container.read(localModelStoreProvider);
      final part = await store.partialFile();
      await part.parent.create(recursive: true);
      await part.writeAsBytes(payload);
      await store.writePartialMeta(
        totalBytes: payload.length,
        modelId: spec.modelId,
      );

      container.listen(localModelInstallControllerProvider, (_, _) {});
      final first = await container.read(
        localModelInstallControllerProvider.future,
      );
      expect(first.isFinalizing, isTrue);
      expect(first.isDownloading, isFalse);
      expect(first.hasPartialDownload, isFalse);
      expect(first.progress, 1);

      await Future<void>.delayed(Duration.zero);
      final resumed = container.read(localModelInstallControllerProvider).value;
      expect(resumed?.isFinalizing, isTrue);
      expect(resumed?.isDownloading, isFalse);

      gate.complete();
      LocalModelInstallSnapshot? settled;
      for (var i = 0; i < 50; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final value = container.read(localModelInstallControllerProvider).value;
        if (value?.isReady == true) {
          settled = value;
          break;
        }
      }
      expect(settled?.isReady, isTrue);
    },
  );

  test('beginPicking blocks then cancel restores ready', () async {
    final container = await containerFor(ready: true);
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    final notifier = container.read(
      localModelInstallControllerProvider.notifier,
    );
    notifier.beginPicking();

    var snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.isPicking, isTrue);
    expect(snapshot?.isReady, isTrue);
    expect(snapshot?.isImporting, isFalse);
    expect(snapshot?.isBusy, isFalse);

    notifier.cancelPicking();
    snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.isPicking, isFalse);
    expect(snapshot?.isReady, isTrue);
  });

  test('import after picking clears the picking loader', () async {
    final container = await containerFor(ready: false);
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    final notifier = container.read(
      localModelInstallControllerProvider.notifier,
    );
    notifier.beginPicking();
    expect(
      container.read(localModelInstallControllerProvider).value?.isPicking,
      isTrue,
    );

    final source = File('${tempDir.path}${Platform.pathSeparator}source.gguf');
    await source.writeAsBytes(payload);
    await notifier.importLocalFile(source);

    final snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.isReady, isTrue);
    expect(snapshot?.isPicking, isFalse);
    expect(snapshot?.isImporting, isFalse);
  });

  test('pickGguf cancel clears picking without importing', () async {
    final transfer = _ScriptedPickTransfer(null);
    final container = await containerFor(ready: false, transfer: transfer);
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    final picked = await container
        .read(localModelInstallControllerProvider.notifier)
        .pickGguf();

    expect(picked, isNull);
    expect(transfer.pickCalls, 1);
    final snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.isPicking, isFalse);
    expect(snapshot?.isImporting, isFalse);
    expect(snapshot?.isReady, isFalse);
  });

  test('pickGguf keeps picking true until import starts', () async {
    final transfer = _ScriptedPickTransfer(
      const PickedGguf(
        uri: 'content://test/model.gguf',
        displayName: 'model.gguf',
        size: 12,
      ),
    );
    final container = await containerFor(ready: false, transfer: transfer);
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    final picked = await container
        .read(localModelInstallControllerProvider.notifier)
        .pickGguf();

    expect(picked?.displayName, 'model.gguf');
    expect(transfer.pickCalls, 1);
    final snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.isPicking, isTrue);
    expect(snapshot?.isImporting, isFalse);
    expect(snapshot?.isReady, isFalse);
  });

  test('build keeps import.part leftovers for resume', () async {
    final container = await containerFor(ready: false);
    final store = container.read(localModelStoreProvider);
    final importPart = await store.importPartialFile();
    await importPart.parent.create(recursive: true);
    await importPart.writeAsBytes(payload);

    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    expect(importPart.existsSync(), isTrue);
  });

  test('reclaimTemporarySpace clears resume and import temps', () async {
    final container = await containerFor(ready: false);
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    final store = container.read(localModelStoreProvider);
    final part = await store.partialFile();
    final importPart = await store.importPartialFile();
    await part.parent.create(recursive: true);
    await part.writeAsBytes(payload.sublist(0, 2));
    await importPart.writeAsBytes(payload);

    await container
        .read(localModelInstallControllerProvider.notifier)
        .reclaimTemporarySpace();

    expect(part.existsSync(), isFalse);
    expect(importPart.existsSync(), isFalse);
    final snapshot = container.read(localModelInstallControllerProvider).value;
    expect(snapshot?.hasPartialDownload, isFalse);
    expect(snapshot?.error, isNull);
  });

  test('deleteInstalled unloads the runtime and removes the GGUF', () async {
    SharedPreferences.setMockInitialValues({});
    final container = await containerFor(ready: true);
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    await container
        .read(localModelInstallControllerProvider.notifier)
        .deleteInstalled();

    expect(
      container.read(localModelInstallControllerProvider).value?.isReady,
      isFalse,
    );
    expect(
      await container.read(localModelStoreProvider).hasModelFile(),
      isFalse,
    );
    expect(await container.read(modelSetupStateProvider.future), isTrue);
  });

  test('exports the installed GGUF to a user-chosen location', () async {
    final keepAlive = _RecordingKeepAlive();
    final transfer = _ScriptedExportTransfer();
    final container = await containerFor(
      ready: true,
      keepAlive: keepAlive,
      transfer: transfer,
    );
    container.listen(localModelInstallControllerProvider, (_, _) {});
    await container.read(localModelInstallControllerProvider.future);

    final saved = await container
        .read(localModelInstallControllerProvider.notifier)
        .exportInstalled(
          progressTitle: 'Saving',
          progressBody: 'Copying',
          completionTitle: 'Saving',
          completionBody: 'Done',
        );

    expect(saved, isTrue);
    expect(transfer.createCalls, 1);
    expect(transfer.exportCalls, 1);
    expect(keepAlive.starts, greaterThan(0));
    expect(keepAlive.stops, greaterThan(0));
    expect(keepAlive.completions, 1);
    expect(
      container.read(localModelInstallControllerProvider).value?.isReady,
      isTrue,
    );
    expect(
      container.read(localModelInstallControllerProvider).value?.isExporting,
      isFalse,
    );
    expect(
      container.read(localModelInstallControllerProvider).value?.error,
      isNull,
    );
  });

  test(
    'export cancel at the save dialog returns false without error',
    () async {
      final transfer = _ScriptedExportTransfer(documentUri: null);
      final container = await containerFor(ready: true, transfer: transfer);
      container.listen(localModelInstallControllerProvider, (_, _) {});
      await container.read(localModelInstallControllerProvider.future);

      final saved = await container
          .read(localModelInstallControllerProvider.notifier)
          .exportInstalled();

      expect(saved, isFalse);
      expect(transfer.exportCalls, 0);
      expect(
        container.read(localModelInstallControllerProvider).value?.error,
        isNull,
      );
    },
  );
}
