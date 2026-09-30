import 'package:freezed_annotation/freezed_annotation.dart';

import 'extraction_progress.dart';

part 'extraction_job.freezed.dart';
part 'extraction_job.g.dart';

/// Stable Drift row id for the at-most-one in-flight extraction job.
const String kActiveExtractionJobId = 'active';

/// Device-local checkpoint so Dart can resume remaining chunks after process
/// death. Not mirrored to Firestore.
@freezed
abstract class ExtractionJob with _$ExtractionJob {
  const ExtractionJob._();

  const factory ExtractionJob({
    @Default(kActiveExtractionJobId) String id,
    required String sourceConversationId,
    @Default(1) int sourceRevision,
    @Default(0) int completedChunkCount,
    @Default(0) int totalChunks,
    @Default(0) int candidatesFound,
    required DateTime startTime,
    @Default([]) List<double> chunkTimings,
    @Default('') String progressTitle,
    @Default('') String progressBody,
    @Default('') String completionTitle,

    /// Remaining active source ids after [sourceConversationId], oldest→newest
    /// for extract-all. Empty for a single-conversation run.
    @Default([]) List<String> queuedSourceConversationIds,

    /// 0-based index of the conversation currently being extracted in a batch.
    @Default(0) int batchIndex,

    /// Total conversations in this extract run (1 for a single pick).
    @Default(1) int batchTotal,
  }) = _ExtractionJob;

  factory ExtractionJob.fromJson(Map<String, dynamic> json) =>
      _$ExtractionJobFromJson(json);

  ExtractionProgress get progress => ExtractionProgress(
    currentChunk: completedChunkCount,
    totalChunks: totalChunks <= 0 ? 1 : totalChunks,
    candidatesFound: candidatesFound,
    chunkTimings: chunkTimings,
    startTime: startTime,
    batchIndex: batchIndex,
    batchTotal: batchTotal <= 0 ? 1 : batchTotal,
  );
}
