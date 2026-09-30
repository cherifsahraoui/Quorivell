import 'package:freezed_annotation/freezed_annotation.dart';

part 'extraction_progress.freezed.dart';

@freezed
abstract class ExtractionProgress with _$ExtractionProgress {
  const ExtractionProgress._();

  const factory ExtractionProgress({
    required int currentChunk,
    required int totalChunks,
    required int candidatesFound,
    required List<double> chunkTimings,
    required DateTime startTime,
    DateTime? endTime,

    /// 0-based conversation index within a multi-extract batch.
    @Default(0) int batchIndex,

    /// Conversations in this extract run (1 when extracting a single capture).
    @Default(1) int batchTotal,
  }) = _ExtractionProgress;

  bool get isComplete => currentChunk >= totalChunks;

  double? get totalSeconds {
    final end = endTime;
    if (end == null) return null;
    return end.difference(startTime).inMilliseconds.toDouble() / 1000.0;
  }

  double? get candidatesPerSecond {
    final seconds = totalSeconds;
    if (seconds == null || seconds <= 0 || candidatesFound <= 0) return null;
    return candidatesFound / seconds;
  }
}

@freezed
abstract class ExtractionMetrics with _$ExtractionMetrics {
  const factory ExtractionMetrics({
    required double totalSeconds,
    required double tokensPerSecond,
    required List<double> chunkTimings,
    required int totalCandidates,
  }) = _ExtractionMetrics;
}
