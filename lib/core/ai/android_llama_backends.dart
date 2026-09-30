import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

import 'llama_cpp_local_text_model_runtime.dart';

/// Shared libraries that must be mapped before registering the CPU backend.
const androidGgmlPreloadLibraries = <String>[
  'libc++_shared.so',
  'libggml-base.so',
  'libggml.so',
  'libggml-cpu.so',
];

/// Directory that contains the app's jniLibs on Android (`…/lib/<abi>`).
String androidNativeLibraryDirectory() {
  return File(Platform.resolvedExecutable).parent.path;
}

/// Ensures ggml has at least one device (CPU) before `llama_load_model_*`.
///
/// `llama_cpp_dart` skips [ggml_backend_load_all] on Android (SELinux). Our
/// jniLibs ship `libggml-cpu.so` with `ggml_backend_cpu_reg`, but that entry
/// is never registered unless we do it here — without a backend,
/// `llama_load_model_from_file` returns null and surfaces as
/// "Could not load model".
void ensureAndroidLlamaCpuBackendRegistered() {
  if (!Platform.isAndroid) return;

  for (final name in androidGgmlPreloadLibraries) {
    try {
      DynamicLibrary.open(name);
    } on Object catch (error) {
      debugPrint('Quorivell llama: preload $name failed: $error');
    }
  }

  try {
    DynamicLibrary.open(androidLlamaLibraryName);
  } on Object catch (error) {
    debugPrint(
      'Quorivell llama: preload $androidLlamaLibraryName failed: $error',
    );
  }

  Llama.libraryPath ??= androidLlamaLibraryName;
  final lib = Llama.lib;

  final before = lib.ggml_backend_dev_count();
  debugPrint('Quorivell llama: ggml_backend_dev_count before=$before');
  if (before > 0) return;

  final nativeDir = androidNativeLibraryDirectory();
  final dirPtr = nativeDir.toNativeUtf8();
  try {
    // Safe alternative to ggml_backend_load_all(): only scans the app lib dir.
    lib.ggml_backend_load_all_from_path(dirPtr.cast());
  } on Object catch (error) {
    debugPrint(
      'Quorivell llama: ggml_backend_load_all_from_path($nativeDir) '
      'failed: $error',
    );
  } finally {
    malloc.free(dirPtr);
  }

  var afterPath = lib.ggml_backend_dev_count();
  debugPrint(
    'Quorivell llama: ggml_backend_dev_count after path load=$afterPath',
  );
  if (afterPath > 0) return;

  // jniLibs CPU backend exports ggml_backend_cpu_reg (static API), not the
  // dynamic-plugin ggml_backend_init entry point.
  try {
    final cpuLib = DynamicLibrary.open('libggml-cpu.so');
    final ggmlLib = DynamicLibrary.open('libggml.so');
    final cpuReg = cpuLib
        .lookupFunction<Pointer Function(), Pointer Function()>(
          'ggml_backend_cpu_reg',
        )
        .call();
    if (cpuReg == nullptr) {
      debugPrint('Quorivell llama: ggml_backend_cpu_reg returned null');
      return;
    }
    ggmlLib
        .lookupFunction<Void Function(Pointer), void Function(Pointer)>(
          'ggml_backend_register',
        )
        .call(cpuReg);
  } on Object catch (error) {
    debugPrint('Quorivell llama: manual CPU backend register failed: $error');
    return;
  }

  afterPath = lib.ggml_backend_dev_count();
  debugPrint(
    'Quorivell llama: ggml_backend_dev_count after cpu_reg=$afterPath',
  );
}

Pointer<NativeFunction<LlamaLogCallback>>? _llamaFlutterLogCallback;

/// ggml log levels: DEBUG=1, INFO=2, WARN=3, ERROR=4, CONT=5.
///
/// Forwarding DEBUG/INFO through Dart `print` during decode floods the UI
/// isolate. Keep warn/error (and continuations of those lines).
@visibleForTesting
bool shouldForwardLlamaLog(int level) => level >= 3;

void _llamaLogCallbackFiltered(
  int level,
  Pointer<Char> text,
  Pointer<Void> userData,
) {
  if (!shouldForwardLlamaLog(level)) return;
  Llama.llamaLogCallbackPrint(level, text, userData);
}

/// Routes llama.cpp warn/error logs to Flutter logcat.
///
/// Stock `verbose: false` installs a null sink. Re-apply this after
/// [LlamaLoad] so load failures still show without per-token INFO spam.
void installLlamaFlutterLogs() {
  _llamaFlutterLogCallback ??= Pointer.fromFunction<LlamaLogCallback>(
    _llamaLogCallbackFiltered,
  );
  Llama.lib.llama_log_set(_llamaFlutterLogCallback!, nullptr);
}
