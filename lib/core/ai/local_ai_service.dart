import 'dart:async';

import 'package:flutter/foundation.dart';

import '../error/diagnostic_sanitizer.dart';
import 'chat_output_guard.dart';
import 'chatml_sanitizer.dart';
import 'evidence_quote_range.dart';
import 'extraction_json_codec.dart';

import 'extraction_kind_slugs.dart';

/// Built-in extraction slugs. [ExtractionCandidate.kind] is a catalog slug.
abstract final class ExtractionCandidateKind {
  static const decision = ExtractionKindSlugs.decision;
  static const commitment = ExtractionKindSlugs.commitment;
}

class ExtractionEvidence {
  const ExtractionEvidence({
    required this.quoteStart,
    required this.quoteEnd,
    required this.quoteSnippet,
  });

  final int quoteStart;
  final int quoteEnd;
  final String quoteSnippet;
}

class ExtractionCandidate {
  const ExtractionCandidate({
    required this.id,
    required this.kind,
    required this.statement,
    required this.owner,
    required this.dueDate,
    required this.evidence,
  });

  final String id;
  final String kind;
  final String statement;
  final String? owner;
  final DateTime? dueDate;
  final ExtractionEvidence evidence;
}

class LocalAIException implements Exception {
  const LocalAIException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'LocalAIException($code)';
}

class LocalAICopy {
  const LocalAICopy({
    required this.emptySummary,
    required this.candidateCommitments,
    required this.reviewEachItem,
    required this.buildPrompt,
    required this.remoteSystemInstruction,
    required this.chatSystemInstruction,
    this.languageCode = 'en',
    this.enabledKindSlugs = const {
      ExtractionKindSlugs.decision,
      ExtractionKindSlugs.commitment,
    },
    this.slugsAllowingDates = const {ExtractionKindSlugs.commitment},
  });

  final String emptySummary;
  final String candidateCommitments;
  final String reviewEachItem;
  final String Function(String conversation) buildPrompt;
  final String remoteSystemInstruction;
  final String chatSystemInstruction;

  /// App UI / prompt locale (`en`, `de`, `ar`) for date parsing heuristics.
  final String languageCode;

  /// Slugs the codec will accept for this run.
  final Set<String> enabledKindSlugs;

  /// Slugs whose `datePolicy` is `optional`.
  final Set<String> slugsAllowingDates;
}

enum LocalChatRole { user, assistant }

class LocalChatTurn {
  const LocalChatTurn({required this.role, required this.content});

  final LocalChatRole role;
  final String content;
}

class LocalChatRequest {
  const LocalChatRequest({required this.turns, required this.copy});

  /// Cap on a single user message before it is rejected.
  static const maxUserMessageCharacters = 2000;

  /// Budget for the assembled ChatML prompt (system + history).
  ///
  /// Kept well under the Android 2048-token context so generation still fits.
  static const maxPromptCharacters = 3000;

  final List<LocalChatTurn> turns;
  final LocalAICopy copy;

  String get normalizedLastUserText {
    if (turns.isEmpty) return '';
    final last = turns.last;
    if (last.role != LocalChatRole.user) return '';
    return last.content.trim();
  }

  bool get isValid {
    final last = normalizedLastUserText;
    return last.isNotEmpty && last.length <= maxUserMessageCharacters;
  }
}

class LocalAIRequest {
  const LocalAIRequest({required this.text, required this.copy});

  /// Soft cap for a single non-chunked extract call.
  static const maxInputCharacters = 8000;

  /// Hard cap for chunked extract (aligned with source conversation storage).
  static const maxChunkedInputCharacters = 20000;

  final String text;
  final LocalAICopy copy;

  String get emptySummary => copy.emptySummary;
  String get candidateCommitments => copy.candidateCommitments;
  String get reviewEachItem => copy.reviewEachItem;
  String get modelPrompt => copy.buildPrompt(normalizedText);

  String get normalizedText => text.trim();

  bool get isValid =>
      normalizedText.isNotEmpty && normalizedText.length <= maxInputCharacters;

  /// Whether [extractChunked] may accept this text (empty or over the hard cap
  /// still fails with a clear invalid-input error).
  bool get isValidForChunked =>
      normalizedText.isNotEmpty &&
      normalizedText.length <= maxChunkedInputCharacters;
}

class LocalAIResponse {
  const LocalAIResponse({
    required this.modelId,
    required this.candidates,
    this.legacyText,
  });

  final String modelId;
  final List<ExtractionCandidate> candidates;
  final String? legacyText;

  String get text =>
      legacyText ??
      candidates.map((candidate) => candidate.statement).join('\n');
}

class ExtractionChunkResult {
  const ExtractionChunkResult({
    required this.chunkIndex,
    required this.totalChunks,
    required this.candidates,
    required this.chunkDurationMs,
  });

  final int chunkIndex;
  final int totalChunks;
  final List<ExtractionCandidate> candidates;
  final int chunkDurationMs;
}

abstract interface class LocalAIService {
  String get modelId;
  int get maxInputCharacters;
  Future<bool> isAvailable();
  Future<LocalAIResponse> extract(LocalAIRequest request);

  /// Chunked extraction that yields results progressively.
  ///
  /// [onChunk] receives extraction results for each chunk as they complete.
  /// Returns the total list of candidates when all chunks finish.
  Future<LocalAIResponse> extractChunked(
    LocalAIRequest request, {
    void Function(ExtractionChunkResult chunk)? onChunk,
    int skipChunks = 0,
  });

  /// Free-form chat against the same on-device runtime used for extraction.
  ///
  /// [onToken] receives decoded fragments as they arrive. The returned string
  /// is the full assistant reply.
  Future<String> chat(
    LocalChatRequest request, {
    void Function(String token)? onToken,
  });

  /// Halts an in-progress [chat] generation. Tokens already received stay.
  Future<void> stopChat();

  /// Clears a prior [cancelExtraction] so the next extract may run.
  ///
  /// Called from [ExtractionRepository.prepareRun] before a fresh job. Do not
  /// reset the cancel flag at the start of [extractChunked] — that wiped an
  /// in-flight cancel and forced users to stop twice.
  void prepareExtraction();

  /// Stops in-flight [extract] / [extractChunked] generation.
  ///
  /// Already-yielded chunks stay. The current generate is aborted so the
  /// chunked loop can exit without hanging.
  Future<void> cancelExtraction();

  Future<void> dispose();
}

abstract interface class LocalTextModelRuntime {
  String get modelId;
  Future<bool> isAvailable();
  Future<String> generate(
    String prompt, {
    void Function(String token)? onToken,
  });
  Future<void> stopGeneration();
  Future<void> dispose();
}

class OnDeviceLocalAIService implements LocalAIService {
  OnDeviceLocalAIService(
    this._runtime, {
    this.codec = const ExtractionJsonCodec(),
  });

  final LocalTextModelRuntime _runtime;
  final ExtractionJsonCodec codec;
  var _extractCancelRequested = false;

  @override
  String get modelId => _runtime.modelId;

  @override
  int get maxInputCharacters => LocalAIRequest.maxInputCharacters;

  @override
  Future<bool> isAvailable() => _runtime.isAvailable();

  @override
  Future<LocalAIResponse> extract(LocalAIRequest request) async {
    if (!request.isValid) {
      throw const LocalAIException(
        'invalid-input',
        'Conversation text is empty or exceeds the local limit.',
      );
    }
    if (!await _runtime.isAvailable()) {
      throw const LocalAIException(
        'unavailable',
        'The on-device model is unavailable on this device.',
      );
    }

    final raw = await _runtime.generate(
      _chatMlPrompt(request.copy.remoteSystemInstruction, request.modelPrompt),
    );

    try {
      final candidates = codec.parse(
        raw,
        request.normalizedText,
        languageCode: request.copy.languageCode,
        enabledKindSlugs: request.copy.enabledKindSlugs,
        slugsAllowingDates: request.copy.slugsAllowingDates,
      );
      _debugLogExtraction(
        outputLength: raw.length,
        candidateCount: candidates.length,
      );
      return LocalAIResponse(modelId: modelId, candidates: candidates);
    } on FormatException catch (error) {
      safeDebugLog('OnDeviceLocalAIService: invalid extraction JSON', {
        'error': error.message,
        'outputLength': raw.length,
      });
      throw const LocalAIException(
        'invalid-output',
        'The on-device model did not return typed extraction JSON.',
      );
    }
  }

  @override
  Future<String> chat(
    LocalChatRequest request, {
    void Function(String token)? onToken,
  }) async {
    if (!request.isValid) {
      throw const LocalAIException(
        'invalid-input',
        'Chat text is empty or exceeds the local limit.',
      );
    }
    if (!await _runtime.isAvailable()) {
      throw const LocalAIException(
        'unavailable',
        'The on-device model is unavailable on this device.',
      );
    }

    final guard = ChatOutputGuard();
    final raw = await _runtime.generate(
      buildLocalChatPrompt(request),
      onToken: (token) {
        if (guard.shouldStop) return;
        final shouldStop = guard.add(token);
        onToken?.call(token);
        if (shouldStop) {
          unawaited(_runtime.stopGeneration());
        }
      },
    );
    final text = (guard.shouldStop ? guard.visibleText : stripChatMLTokens(raw))
        .trim();
    if (text.isEmpty) {
      throw const LocalAIException(
        'invalid-output',
        'The on-device model returned an empty chat reply.',
      );
    }
    return text;
  }

  @override
  Future<LocalAIResponse> extractChunked(
    LocalAIRequest request, {
    void Function(ExtractionChunkResult chunk)? onChunk,
    int skipChunks = 0,
  }) async {
    if (!request.isValidForChunked) {
      throw const LocalAIException(
        'invalid-input',
        'Conversation text is empty or exceeds the chunked extraction limit.',
      );
    }
    if (!await _runtime.isAvailable()) {
      throw const LocalAIException(
        'unavailable',
        'The on-device model is unavailable on this device.',
      );
    }

    if (_extractCancelRequested) {
      throw const LocalAIException('cancelled', 'Extraction was cancelled.');
    }
    final fullText = request.normalizedText;
    final chunks = _chunkText(fullText);
    final allCandidates = <ExtractionCandidate>[];
    final seenCandidateKeys = <String>{};

    for (var i = skipChunks.clamp(0, chunks.length); i < chunks.length; i++) {
      if (_extractCancelRequested) {
        throw const LocalAIException('cancelled', 'Extraction was cancelled.');
      }
      final chunk = chunks[i];
      final chunkStartTime = DateTime.now();
      final chunkRequest = LocalAIRequest(text: chunk.text, copy: request.copy);

      final raw = await _runtime.generate(
        _chatMlPrompt(
          request.copy.remoteSystemInstruction,
          chunkRequest.modelPrompt,
        ),
      );
      if (_extractCancelRequested) {
        throw const LocalAIException('cancelled', 'Extraction was cancelled.');
      }

      final chunkDuration = DateTime.now()
          .difference(chunkStartTime)
          .inMilliseconds;

      try {
        final parsed = codec.parse(
          raw,
          chunk.text,
          languageCode: request.copy.languageCode,
          enabledKindSlugs: request.copy.enabledKindSlugs,
          slugsAllowingDates: request.copy.slugsAllowingDates,
        );
        _debugLogExtraction(
          outputLength: raw.length,
          candidateCount: parsed.length,
          chunkIndex: i,
          totalChunks: chunks.length,
        );
        final candidates = <ExtractionCandidate>[];
        for (final candidate in parsed) {
          final remapped = _remapCandidateToFullText(
            candidate,
            chunkStartOffset: chunk.startOffset,
            fullText: fullText,
          );
          final key =
              '${remapped.kind}:${remapped.statement.trim().toLowerCase()}:'
              '${remapped.evidence.quoteStart}:${remapped.evidence.quoteSnippet}';
          if (seenCandidateKeys.add(key)) {
            candidates.add(remapped);
            allCandidates.add(remapped);
          }
        }

        onChunk?.call(
          ExtractionChunkResult(
            chunkIndex: i + 1,
            totalChunks: chunks.length,
            candidates: candidates,
            chunkDurationMs: chunkDuration,
          ),
        );
      } on FormatException catch (error) {
        safeDebugLog(
          'OnDeviceLocalAIService: invalid extraction JSON for chunk $i',
          {'error': error.message, 'outputLength': raw.length},
        );
        // Continue processing other chunks even if one fails
      }
      // Let Review paint chunk progress before the next llama_decode batch.
      await Future<void>.delayed(Duration.zero);
    }

    return LocalAIResponse(modelId: modelId, candidates: allCandidates);
  }

  @override
  Future<void> stopChat() => _runtime.stopGeneration();

  @override
  void prepareExtraction() {
    _extractCancelRequested = false;
  }

  @override
  Future<void> cancelExtraction() async {
    _extractCancelRequested = true;
    await _runtime.stopGeneration();
  }

  @override
  Future<void> dispose() => _runtime.dispose();

  String _chatMlPrompt(String system, String user) {
    return '<|im_start|>system\n$system<|im_end|>\n'
        '<|im_start|>user\n$user<|im_end|>\n'
        '<|im_start|>assistant\n';
  }

  /// Chunks [text] into manageable pieces for extraction.
  ///
  /// Aims for ~2000 character chunks with sentence-boundary splits and 200
  /// character overlap to preserve context across chunks.
  List<_TextChunkSpan> _chunkText(
    String text, {
    int targetSize = 2000,
    int overlap = 200,
  }) {
    if (text.length <= targetSize) {
      return [_TextChunkSpan(startOffset: 0, text: text)];
    }

    final chunks = <_TextChunkSpan>[];
    var start = 0;

    while (start < text.length) {
      var end = start + targetSize;
      if (end >= text.length) {
        chunks.add(
          _TextChunkSpan(startOffset: start, text: text.substring(start)),
        );
        break;
      }

      // Find sentence boundary within next 200 chars
      var sentenceBoundary = -1;
      for (var i = end; i < text.length && i < end + 200; i++) {
        if (_isSentenceEnd(text, i)) {
          sentenceBoundary = i + 1;
          break;
        }
      }

      // If no boundary found forward, search backward
      if (sentenceBoundary == -1) {
        for (var i = end; i > start + targetSize ~/ 2; i--) {
          if (_isSentenceEnd(text, i)) {
            sentenceBoundary = i + 1;
            break;
          }
        }
      }

      // Fall back to hard split if no sentence boundary
      if (sentenceBoundary == -1) {
        sentenceBoundary = end;
      }

      chunks.add(
        _TextChunkSpan(
          startOffset: start,
          text: text.substring(start, sentenceBoundary),
        ),
      );
      final previousStart = start;
      start = sentenceBoundary - overlap;
      // Overlap must not rewind to the same offset (infinite loop on short
      // tails / missing sentence boundaries).
      if (start <= previousStart) {
        start = sentenceBoundary;
      }
    }

    return chunks;
  }

  ExtractionCandidate _remapCandidateToFullText(
    ExtractionCandidate candidate, {
    required int chunkStartOffset,
    required String fullText,
  }) {
    final snippet = candidate.evidence.quoteSnippet;
    final resolved = resolveEvidenceQuoteRange(
      content: fullText,
      quoteStart: candidate.evidence.quoteStart + chunkStartOffset,
      quoteEnd: candidate.evidence.quoteEnd + chunkStartOffset,
      quoteSnippet: snippet,
    );
    final start = resolved?.start ?? 0;
    final end = resolved?.end ?? 0;

    return ExtractionCandidate(
      id: candidate.id,
      kind: candidate.kind,
      statement: candidate.statement,
      owner: candidate.owner,
      dueDate: candidate.dueDate,
      evidence: ExtractionEvidence(
        quoteStart: start,
        quoteEnd: end,
        quoteSnippet: snippet,
      ),
    );
  }

  bool _isSentenceEnd(String text, int index) {
    if (index >= text.length) return false;
    final char = text[index];
    if (char != '.' && char != '!' && char != '?') return false;
    // Check if followed by space or newline or end
    if (index + 1 >= text.length) return true;
    final next = text[index + 1];
    return next == ' ' || next == '\n' || next == '\r';
  }

  void _debugLogExtraction({
    required int outputLength,
    required int candidateCount,
    int? chunkIndex,
    int? totalChunks,
  }) {
    if (!kDebugMode) return;
    final scope = chunkIndex == null
        ? 'extract'
        : 'extractChunked chunk ${chunkIndex + 1}/$totalChunks';
    safeDebugLog('OnDeviceLocalAIService: $scope completed', {
      'outputLength': outputLength,
      'candidateCount': candidateCount,
    });
  }
}

class _TextChunkSpan {
  const _TextChunkSpan({required this.startOffset, required this.text});

  final int startOffset;
  final String text;
}

/// Assembles a ChatML prompt from [request] turns, dropping the oldest
/// history when the budget would overflow. Always keeps the system turn and
/// the latest user message.
@visibleForTesting
String buildLocalChatPrompt(
  LocalChatRequest request, {
  int budget = LocalChatRequest.maxPromptCharacters,
}) {
  final system = request.copy.chatSystemInstruction.trim();
  final turns = <LocalChatTurn>[
    for (final turn in request.turns)
      LocalChatTurn(role: turn.role, content: turn.content.trim()),
  ].where((turn) => turn.content.isNotEmpty).toList();

  if (turns.isEmpty) {
    return _chatMlBlock('system', system) + _assistantOpen;
  }

  var last = turns.removeLast();
  if (last.role != LocalChatRole.user) {
    turns.add(last);
    last = const LocalChatTurn(role: LocalChatRole.user, content: '');
  }
  if (last.content.length > LocalChatRequest.maxUserMessageCharacters) {
    last = LocalChatTurn(
      role: LocalChatRole.user,
      content: last.content.substring(
        last.content.length - LocalChatRequest.maxUserMessageCharacters,
      ),
    );
  }

  final suffix = _chatMlBlock('user', last.content) + _assistantOpen;
  final systemBlock = _chatMlBlock('system', system);
  var remaining = budget - systemBlock.length - suffix.length;
  if (remaining < 0) {
    remaining = 0;
  }

  final kept = <String>[];
  for (var i = turns.length - 1; i >= 0; i--) {
    final turn = turns[i];
    final role = turn.role == LocalChatRole.user ? 'user' : 'assistant';
    final block = _chatMlBlock(role, turn.content);
    if (block.length > remaining) {
      break;
    }
    kept.add(block);
    remaining -= block.length;
  }

  final history = kept.reversed.join();
  return '$systemBlock$history$suffix';
}

const _assistantOpen = '<|im_start|>assistant\n';

String _chatMlBlock(String role, String content) {
  return '<|im_start|>$role\n$content<|im_end|>\n';
}
