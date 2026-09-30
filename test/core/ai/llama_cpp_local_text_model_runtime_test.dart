import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/android_llama_backends.dart';
import 'package:quorivell/core/ai/llama_cpp_local_text_model_runtime.dart';
import 'package:quorivell/core/ai/local_model_spec.dart';
import 'package:quorivell/core/ai/local_model_store.dart';

void main() {
  test('cpu-only params disable GPU offload', () {
    final params = cpuOnlyLlamaModelParams(useMemoryMap: true);
    expect(params.nGpuLayers, 0);
    expect(params.mainGpu, -1);
    expect(params.useMemorymap, isTrue);
    expect(params.useMemoryLock, isFalse);
  });

  test('cpu-only params default mmap follows the host platform', () {
    final params = cpuOnlyLlamaModelParams();
    expect(params.useMemorymap, isNot(Platform.isAndroid));
  });

  test('cpu-only params can disable mmap when requested', () {
    final params = cpuOnlyLlamaModelParams(useMemoryMap: false);
    expect(params.useMemorymap, isFalse);
  });

  test('Android mmap load attempts try no-mmap then mmap', () {
    expect(llamaMmapLoadAttempts(isAndroid: true), [false, true]);
    expect(llamaMmapLoadAttempts(isAndroid: false), [true]);
  });

  test('Android ggml preload list includes the CPU backend', () {
    expect(androidGgmlPreloadLibraries, contains('libggml-cpu.so'));
    expect(androidGgmlPreloadLibraries, contains('libggml.so'));
  });

  test('llama log callback drops debug and info', () {
    expect(shouldForwardLlamaLog(1), isFalse);
    expect(shouldForwardLlamaLog(2), isFalse);
    expect(shouldForwardLlamaLog(3), isTrue);
    expect(shouldForwardLlamaLog(4), isTrue);
    expect(shouldForwardLlamaLog(5), isTrue);
  });

  test('Android library basename is libllama rather than libmtmd', () {
    expect(androidLlamaLibraryName, 'libllama.so');
  });

  test('Android caps context below the desktop production default', () {
    expect(androidMaxContextTokens, lessThan(LocalModelSpec.production.nCtx));
    expect(androidMaxContextTokens, greaterThan(0));
  });

  test('inference threads leave cores for the UI', () {
    expect(
      llamaInferenceThreadCount(processorCount: 4, requested: 4),
      llamaUiReservedThreadCount,
    );
    expect(llamaInferenceThreadCount(processorCount: 8, requested: 4), 4);
    expect(llamaInferenceThreadCount(processorCount: 1, requested: 4), 1);
    expect(llamaInferenceThreadCount(processorCount: 2, requested: 4), 1);
  });

  test('default sampler penalizes repeating tokens', () {
    final params = llamaDefaultSamplerParams();
    expect(params.penaltyRepeat, greaterThan(1.0));
    expect(params.dryMultiplier, greaterThan(0.0));
    expect(params.temp, 0.1);
  });

  test('prompt overflows map to invalid-input rather than unavailable', () {
    expect(
      LlamaCppLocalTextModelRuntime.mapLlamaExceptionCode(
        'LlamaException: Prompt tokens (900) > batch capacity (512)',
      ),
      'invalid-input',
    );
    expect(
      LlamaCppLocalTextModelRuntime.mapLlamaExceptionCode('Prompt too large'),
      'invalid-input',
    );
    expect(
      LlamaCppLocalTextModelRuntime.mapLlamaExceptionCode(
        'Could not load model',
      ),
      'unavailable',
    );
  });

  test('isAvailable does not hash a stored GGUF', () async {
    final tempDir = await Directory.systemTemp.createTemp('quorivell-llama-');
    addTearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });
    const payload = [7, 1, 8];
    final spec = LocalModelSpec(
      modelId: 'test-model',
      fileName: 'test.gguf',
      downloadUri: 'http://127.0.0.1/test.gguf',
      sha256: sha256.convert(payload).toString(),
    );
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    final dest = await store.modelFile();
    await dest.parent.create(recursive: true);
    await dest.writeAsBytes(payload);

    final runtime = LlamaCppLocalTextModelRuntime(store: store, spec: spec);

    expect(await runtime.isAvailable(), isTrue);
    expect(await store.isReady(hashIfNeeded: false), isFalse);
  });
}
