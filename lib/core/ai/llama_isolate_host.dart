import 'dart:async';

import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:typed_isolate/typed_isolate.dart';

import '../error/diagnostic_sanitizer.dart';
import 'android_llama_backends.dart';
import 'chat_output_guard.dart';

/// First GGUF load on device can exceed the stock `LlamaParent` 60s timeout.
const llamaModelLoadTimeout = Duration(minutes: 10);

const _defaultCommandTimeout = Duration(seconds: 30);

/// Delay before flushing coalesced tokens to the UI isolate.
const llamaTokenFlushInterval = Duration(milliseconds: 80);

/// Flush immediately once this many characters are buffered.
const llamaTokenFlushMaxChars = 48;

/// Batches per-token isolate messages so the UI isolate can paint frames.
///
/// Stock `LlamaChild` sends every generated token to the parent. On a fast
/// decode that floods the Flutter event loop and freezes the extract spinner.
class LlamaTokenCoalescer {
  LlamaTokenCoalescer({
    required this.onFlush,
    this.interval = llamaTokenFlushInterval,
    this.maxChars = llamaTokenFlushMaxChars,
  });

  final void Function(String text) onFlush;
  final Duration interval;
  final int maxChars;

  final StringBuffer _buffer = StringBuffer();
  Timer? _timer;

  void add(String token) {
    if (token.isEmpty) return;
    _buffer.write(token);
    if (_buffer.length >= maxChars) {
      flush();
      return;
    }
    _timer ??= Timer(interval, flush);
  }

  void flush() {
    _timer?.cancel();
    _timer = null;
    if (_buffer.isEmpty) return;
    final text = _buffer.toString();
    _buffer.clear();
    onFlush(text);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _buffer.clear();
  }
}

class _QueuedPrompt {
  _QueuedPrompt(this.prompt);

  final String prompt;
  final Completer<String> idCompleter = Completer<String>();
}

/// Isolate host for text generation with a long model-load timeout.
///
/// Stock `LlamaParent` aborts load at 60s and then `dispose()` completes
/// orphaned completers with `"Disposed"`, which surfaces as an unhandled
/// exception and a false "model unavailable" error.
class LlamaIsolateHost {
  LlamaIsolateHost(this.loadCommand);

  final LlamaLoad loadCommand;

  final _controller = StreamController<String>.broadcast();
  final _parent = IsolateParent<LlamaCommand, LlamaResponse>();

  StreamSubscription<LlamaResponse>? _subscription;
  Completer<void>? _readyCompleter;
  Completer<void>? _operationCompleter;
  final Map<String, Completer<void>> _promptCompleters = {};
  final List<_QueuedPrompt> _promptQueue = [];

  bool _isProcessingQueue = false;
  String _currentPromptId = '';

  Stream<String> get stream => _controller.stream;

  Future<void> init() async {
    _readyCompleter = Completer<void>();

    _parent.init();
    await _subscription?.cancel();
    _subscription = _parent.stream.listen(_onData);

    await _parent.spawn(QuorivellLlamaChild());
    try {
      await _sendCommand(
        LlamaInit(Llama.libraryPath),
        timeout: _defaultCommandTimeout,
      );
      await _sendCommand(loadCommand, timeout: llamaModelLoadTimeout);
      await _readyCompleter!.future;
    } on Object {
      // Load failures complete the in-flight command. Ignore the unused ready
      // future so a second completeError does not become an unhandled crash.
      _readyCompleter?.future.ignore();
      rethrow;
    }
  }

  Future<String> sendPrompt(String prompt) async {
    final queued = _QueuedPrompt(prompt);
    _promptQueue.add(queued);
    if (!_isProcessingQueue) {
      unawaited(_processNextPrompt());
    }
    return queued.idCompleter.future;
  }

  Future<void> waitForCompletion(String promptId) async {
    final completer = _promptCompleters[promptId];
    if (completer == null) return;
    await completer.future;
  }

  /// Stops the in-flight prompt so [waitForCompletion] can return.
  Future<void> stop() async {
    try {
      await _sendCommand(LlamaStop(), timeout: const Duration(seconds: 5));
    } on Object {
      // Generation may already have finished, or the child ignored stop.
    }
    final completer = _promptCompleters.remove(_currentPromptId);
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  Future<void> dispose() async {
    _failOrphan(_readyCompleter);
    _readyCompleter = null;
    _failOrphan(_operationCompleter);
    _operationCompleter = null;

    for (final queued in _promptQueue) {
      _failOrphan(queued.idCompleter);
    }
    _promptQueue.clear();

    for (final completer in _promptCompleters.values) {
      _failOrphan(completer);
    }
    _promptCompleters.clear();

    if (!_controller.isClosed) {
      await _controller.close();
    }

    try {
      _parent.sendToChild(id: 1, data: LlamaDispose());
    } on Object {
      // Child may already be gone.
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await _subscription?.cancel();
    _subscription = null;
    _parent.dispose();
  }

  void _onData(LlamaResponse data) {
    if (data.status == LlamaStatus.error && data.errorDetails != null) {
      final error = LlamaException(data.errorDetails!);
      final op = _operationCompleter;
      if (op != null && !op.isCompleted) {
        op.completeError(error);
        _operationCompleter = null;
        // The command future is what init awaits. Do not also completeError
        // [_readyCompleter] — that second future is often unawaited and
        // becomes an unhandled [LlamaException] after restart.
      } else {
        final ready = _readyCompleter;
        if (ready != null && !ready.isCompleted) {
          ready.future.ignore();
          ready.completeError(error);
        }
      }
    }

    if (data.status == LlamaStatus.ready &&
        _readyCompleter != null &&
        !_readyCompleter!.isCompleted) {
      _readyCompleter!.complete();
    }

    if (data.isConfirmation) {
      final op = _operationCompleter;
      if (op != null && !op.isCompleted) {
        op.complete();
        _operationCompleter = null;
      }
    }

    if (data.text.isNotEmpty) {
      final promptId = data.promptId;
      if (promptId == null || promptId == _currentPromptId) {
        _controller.add(data.text);
      }
    }

    if (data.isDone &&
        data.stateData == null &&
        data.embeddings == null &&
        !data.isConfirmation) {
      final promptId = data.promptId ?? _currentPromptId;
      final completer = _promptCompleters.remove(promptId);
      if (completer != null && !completer.isCompleted) {
        if (data.status == LlamaStatus.error) {
          completer.completeError(
            LlamaException(data.errorDetails ?? 'Generation failed'),
          );
        } else {
          completer.complete();
        }
      }
    }
  }

  Future<void> _sendCommand(
    LlamaCommand command, {
    required Duration timeout,
  }) async {
    final completer = Completer<void>();
    _operationCompleter = completer;
    _parent.sendToChild(data: command, id: 1);
    try {
      await completer.future.timeout(timeout);
    } on TimeoutException {
      // Stock LlamaParent leaves this completer pending; a later dispose then
      // emits an unhandled "Disposed". Ignore late completions instead.
      completer.future.ignore();
      if (identical(_operationCompleter, completer)) {
        _operationCompleter = null;
      }
      rethrow;
    }
  }

  Future<void> _processNextPrompt() async {
    if (_promptQueue.isEmpty) {
      _isProcessingQueue = false;
      return;
    }

    _isProcessingQueue = true;
    final next = _promptQueue.removeAt(0);
    _currentPromptId = DateTime.now().millisecondsSinceEpoch.toString();
    _promptCompleters[_currentPromptId] = Completer<void>();
    next.idCompleter.complete(_currentPromptId);

    try {
      // llama_cpp_dart appends prompts when n_pos > 0. Clear KV between
      // extracts so a second Review tap does not hit "Context limit".
      await _sendCommand(LlamaClear(), timeout: _defaultCommandTimeout);
      _parent.sendToChild(
        id: 1,
        data: LlamaPrompt(next.prompt, _currentPromptId),
      );
    } on Object catch (error, stack) {
      final completer = _promptCompleters.remove(_currentPromptId);
      if (completer != null && !completer.isCompleted) {
        completer.completeError(error, stack);
      }
      unawaited(_processNextPrompt());
      return;
    }

    unawaited(
      _promptCompleters[_currentPromptId]!.future.whenComplete(() {
        unawaited(_processNextPrompt());
      }),
    );
  }

  void _failOrphan(Completer<dynamic>? completer) {
    if (completer == null || completer.isCompleted) return;
    completer.future.ignore();
    completer.completeError(
      const LocalAIHostDisposedException(),
      StackTrace.current,
    );
  }
}

/// Internal signal that the llama isolate host was torn down.
class LocalAIHostDisposedException implements Exception {
  const LocalAIHostDisposedException();

  @override
  String toString() => 'LocalAIHostDisposedException';
}

/// [LlamaChild] that registers the Android CPU backend after library init.
///
/// Stock `llama_cpp_dart` skips `ggml_backend_load_all` on Android, which leaves
/// zero ggml devices and makes every GGUF load return null.
class QuorivellLlamaChild extends LlamaChild {
  @override
  void onData(LlamaCommand data) {
    switch (data) {
      case LlamaInit():
        super.onData(data);
        try {
          ensureAndroidLlamaCpuBackendRegistered();
          installLlamaFlutterLogs();
        } on Object catch (error) {
          safeDebugLog('Quorivell llama backend setup failed', {
            'error': DiagnosticSanitizer.sanitizeException(error),
          });
        }
      case LlamaLoad():
        super.onData(data);
        try {
          // Llama() with verbose=false installs a null log sink. Restore
          // warn/error forwarding after load.
          installLlamaFlutterLogs();
        } on Object catch (error) {
          safeDebugLog('Quorivell llama log callback failed', {
            'error': DiagnosticSanitizer.sanitizeException(error),
          });
        }
      case LlamaPrompt(
        :final prompt,
        :final promptId,
        :final images,
        :final slotId,
      ):
        shouldStop = false;
        unawaited(_sendPromptBatched(prompt, promptId, images, slotId));
      default:
        super.onData(data);
    }
  }

  Future<void> _sendPromptBatched(
    String prompt,
    String promptId,
    List<LlamaImage>? images,
    String? slotId,
  ) async {
    if (llama == null) {
      sendToParent(LlamaResponse.error('Model not initialized', promptId));
      return;
    }

    final coalescer = LlamaTokenCoalescer(
      onFlush: (text) {
        sendToParent(
          LlamaResponse(
            text: text,
            isDone: false,
            status: LlamaStatus.generating,
            promptId: promptId,
          ),
        );
      },
    );

    try {
      if (slotId != null) {
        try {
          llama!.createSlot(slotId);
          llama!.setSlot(slotId);
        } catch (e) {
          sendToParent(
            LlamaResponse.error('Slot allocation failed: $e', promptId),
          );
          return;
        }
      } else {
        llama!.setSlot('default');
      }

      sendToParent(
        LlamaResponse(
          text: '',
          isDone: false,
          status: LlamaStatus.generating,
          promptId: promptId,
        ),
      );

      final Stream<String> tokenStream;
      if (images != null && images.isNotEmpty) {
        tokenStream = llama!.generateWithMedia(prompt, inputs: images);
      } else {
        llama!.setPrompt(prompt);
        tokenStream = llama!.generateText();
      }

      final generated = StringBuffer();
      await for (final token in tokenStream) {
        if (shouldStop) break;
        generated.write(token);
        coalescer.add(token);
        if (chatGenerationShouldHalt(generated.toString())) {
          shouldStop = true;
          break;
        }
      }

      coalescer.flush();
      sendToParent(
        LlamaResponse(
          text: '',
          isDone: true,
          status: LlamaStatus.ready,
          promptId: promptId,
        ),
      );
    } catch (e) {
      coalescer.flush();
      sendToParent(
        LlamaResponse.error('Generation error: ${e.toString()}', promptId),
      );
    } finally {
      coalescer.dispose();
    }
  }
}
