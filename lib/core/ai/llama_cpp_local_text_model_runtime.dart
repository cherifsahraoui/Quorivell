import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

import '../error/diagnostic_sanitizer.dart';
import 'llama_isolate_host.dart';
import 'local_ai_service.dart';
import 'local_model_spec.dart';
import 'local_model_store.dart';

/// Android text inference loads this basename from `jniLibs`.
///
/// `llama_cpp_dart` defaults [Llama.libraryPath] to `libmtmd.so` (vision).
const androidLlamaLibraryName = 'libllama.so';

/// Caps context on Android to keep first load/KV memory within phone RAM.
const androidMaxContextTokens = 2048;

/// Cores kept free for Flutter UI, raster, and the OS during llama.cpp work.
const llamaUiReservedThreadCount = 2;

/// llama.cpp thread count that leaves CPU for Flutter frames.
///
/// Using every core for `n_threads` / `n_threads_batch` starves the UI and
/// raster threads, so the extract spinner looks frozen even though inference
/// runs on a background isolate.
int llamaInferenceThreadCount({
  int? processorCount,
  int requested = 4,
  int reservedForUi = llamaUiReservedThreadCount,
}) {
  final processors = processorCount ?? Platform.numberOfProcessors;
  final usable = processors - reservedForUi;
  if (usable < 1 || requested < 1) return 1;
  return math.min(requested, usable);
}

/// Sampling used for on-device chat and extraction.
///
/// Low temperature keeps extraction JSON stable. Repeat and DRY penalties
/// stop small GGUFs from echoing the same paragraph when ChatML EOS is missed.
SamplerParams llamaDefaultSamplerParams() {
  return SamplerParams()
    ..temp = 0.1
    ..topP = 0.9
    ..topK = 20
    ..penaltyRepeat = 1.15
    ..penaltyLastTokens = 256
    ..dryMultiplier = 0.8
    ..dryBase = 1.75
    ..dryAllowedLen = 2;
}

/// CPU-only model params. llama.cpp defaults [ModelParams.nGpuLayers] to 99,
/// which tries a GPU backend and aborts on typical Android devices.
///
/// jniLibs must be built from llama.cpp commit `4ffc47cb` (the
/// `llama_cpp_dart` 0.2.2 pin). A newer `libllama.so` changes
/// `llama_model_params` layout and SIGSEGVs during model load.
///
/// With split mode `none`, llama.cpp treats [ModelParams.mainGpu] as an index
/// into **GPU** devices only (CPU backends are skipped). On a CPU-only phone
/// that list is empty, so `main_gpu: 0` fails with
/// `invalid value for main_gpu: 0 (available devices: 0)`. `-1` clears the
/// GPU list and loads weights on CPU.
///
/// Android mmap of a ~1.1 GB GGUF often returns a null model (`Could not
/// load model at …`). Prefer copying weights into RAM there, then fall back
/// to mmap if the no-mmap load fails (typical when free RAM is tight).
ModelParams cpuOnlyLlamaModelParams({bool? useMemoryMap}) {
  return ModelParams()
    ..nGpuLayers = 0
    ..mainGpu = -1
    ..useMemorymap = useMemoryMap ?? !Platform.isAndroid
    ..useMemoryLock = false;
}

/// Ordered `use_mmap` attempts for [platform].
///
/// Android: no-mmap first (documented default), then mmap. Elsewhere: mmap.
List<bool> llamaMmapLoadAttempts({bool? isAndroid}) {
  final android = isAndroid ?? Platform.isAndroid;
  return android ? const [false, true] : const [true];
}

/// llama.cpp runtime that keeps the GGUF loaded on a managed isolate.
class LlamaCppLocalTextModelRuntime implements LocalTextModelRuntime {
  LlamaCppLocalTextModelRuntime({
    required LocalModelStore store,
    this.spec = LocalModelSpec.production,
    this.libraryPath,
  }) : _store = store;

  final LocalModelStore _store;
  final LocalModelSpec spec;
  final String? libraryPath;

  LlamaIsolateHost? _host;
  Future<LlamaIsolateHost>? _starting;

  @override
  String get modelId => spec.modelId;

  @override
  Future<bool> isAvailable() async {
    if (await _store.isReady(hashIfNeeded: false)) return true;
    return _store.hasModelFile();
  }

  @override
  Future<String> generate(
    String prompt, {
    void Function(String token)? onToken,
  }) async {
    final host = await _ensureHost();
    // Model load can take seconds. Yield so the extract/chat spinner can paint
    // before the first prompt-eval batch pegs the remaining CPU cores.
    await Future<void>.delayed(Duration.zero);
    final buffer = StringBuffer();
    final subscription = host.stream.listen((token) {
      buffer.write(token);
      onToken?.call(token);
    });
    try {
      final promptId = await host.sendPrompt(prompt);
      await host.waitForCompletion(promptId);
      return buffer.toString();
    } on LlamaException catch (error) {
      throw LocalAIException(
        mapLlamaExceptionCode(error.message),
        error.message,
      );
    } on TimeoutException {
      throw const LocalAIException(
        'unavailable',
        'The on-device model timed out while loading or generating.',
      );
    } on LocalAIHostDisposedException {
      throw const LocalAIException(
        'unavailable',
        'The on-device llama.cpp runtime was interrupted.',
      );
    } finally {
      await subscription.cancel();
    }
  }

  Future<LlamaIsolateHost> _ensureHost() {
    final existing = _host;
    if (existing != null) return Future.value(existing);
    return _starting ??= _start();
  }

  Future<LlamaIsolateHost> _start() async {
    if (!await isAvailable()) {
      _starting = null;
      throw const LocalAIException(
        'unavailable',
        'The on-device model is not installed.',
      );
    }

    // Soft `isAvailable` only checks for a non-empty file. Official downloads
    // still verify SHA-256. User-imported GGUF files skip that digest.
    if (!await _store.isReady(hashIfNeeded: true)) {
      _starting = null;
      throw const LocalAIException(
        'unavailable',
        'The on-device model file is missing or failed checksum verification.',
      );
    }

    final resolvedLibrary = libraryPath ?? _resolveLibraryPath();
    if (resolvedLibrary != null) {
      Llama.libraryPath = resolvedLibrary;
    }

    final nCtx = Platform.isAndroid
        ? math.min(spec.nCtx, androidMaxContextTokens)
        : spec.nCtx;
    final nThreads = llamaInferenceThreadCount(requested: spec.nThreads);
    // llama_cpp_dart puts the entire prompt in one llama_batch. n_batch must
    // be >= prompt tokens or setPrompt throws "Prompt tokens > batch capacity"
    // and extraction surfaces a generic failure after a long load. Keep
    // n_ubatch modest so the CPU compute graph stays near the 512-token size.
    final contextParams = ContextParams()
      ..nCtx = nCtx
      ..nBatch = nCtx
      ..nUbatch = math.min(512, nCtx)
      ..nPredict = spec.nPredict
      ..nThreads = nThreads
      ..nThreadsBatch = nThreads
      // Defaults offload KQV/ops toward GPU backends. Keep extraction on CPU.
      ..offloadKqv = false
      ..opOffload = false;
    final samplingParams = llamaDefaultSamplerParams();

    final modelPath = (await _store.modelFile()).path;
    Object? lastError;

    for (final useMmap in llamaMmapLoadAttempts()) {
      final host = LlamaIsolateHost(
        LlamaLoad(
          path: modelPath,
          modelParams: cpuOnlyLlamaModelParams(useMemoryMap: useMmap),
          contextParams: contextParams,
          samplingParams: samplingParams,
          // verbose=true installs a Dart print sink for every llama.cpp INFO
          // line and freezes the UI during decode. Warn/error still go through
          // [installLlamaFlutterLogs] after load.
          verbose: false,
        ),
      );

      try {
        await host.init();
        _host = host;
        return host;
      } on Object catch (error) {
        lastError = error;
        safeDebugLog('LlamaCppLocalTextModelRuntime: load failed', {
          'useMmap': useMmap,
          'error': DiagnosticSanitizer.sanitizeException(error),
        });
        await _disposeHostQuietly(host);
      }
    }

    _starting = null;
    final detail = lastError == null ? '' : ' ($lastError)';
    throw LocalAIException(
      'unavailable',
      'The on-device llama.cpp runtime could not start.$detail',
    );
  }

  @override
  Future<void> stopGeneration() async {
    final host = _host;
    if (host == null) return;
    await host.stop();
  }

  @override
  Future<void> dispose() async {
    final host = _host;
    _host = null;
    _starting = null;
    if (host != null) {
      await _disposeHostQuietly(host);
    }
  }

  Future<void> _disposeHostQuietly(LlamaIsolateHost host) async {
    await runZonedGuarded(() async {
      await host.dispose();
    }, (_, _) {});
  }

  /// Prompt/context overflows are input limits, not a missing model.
  @visibleForTesting
  static String mapLlamaExceptionCode(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('prompt too large') ||
        lower.contains('batch capacity') ||
        lower.contains('context limit') ||
        lower.contains('context full') ||
        lower.contains('n_ctx overflow')) {
      return 'invalid-input';
    }
    return 'unavailable';
  }

  String? _resolveLibraryPath() {
    if (Platform.isAndroid) return androidLlamaLibraryName;

    final names = Platform.isWindows
        ? const ['llama.dll', 'libllama.dll']
        : Platform.isLinux
        ? const ['libllama.so']
        : Platform.isMacOS
        ? const ['libllama.dylib']
        : const <String>[];
    if (names.isEmpty) return Llama.libraryPath;

    final searchDirs = <String>[
      Directory.current.path,
      File(Platform.resolvedExecutable).parent.path,
    ];
    for (final dir in searchDirs) {
      for (final name in names) {
        final file = File('$dir${Platform.pathSeparator}$name');
        if (file.existsSync()) return file.path;
      }
    }
    return Llama.libraryPath;
  }
}
