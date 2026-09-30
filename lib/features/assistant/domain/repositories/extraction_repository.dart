import '../entities/extraction_job.dart';
import '../entities/extraction_progress.dart';
import '../entities/review_candidate.dart';

class ExtractionProgressUpdate {
  const ExtractionProgressUpdate({
    required this.progress,
    required this.newCandidates,
  });

  final ExtractionProgress progress;
  final List<ReviewCandidate> newCandidates;
}

abstract interface class ExtractionRepository {
  /// Watches candidates still awaiting review, oldest first.
  ///
  /// [limit] and [offset] keep the review queue bounded.
  Stream<List<ReviewCandidate>> watchPending({int limit, int offset});

  /// Watches rejected candidates that have not been soft-deleted, newest first.
  Stream<List<ReviewCandidate>> watchRejected({int limit, int offset});

  Future<List<ReviewCandidate>> extract(String sourceConversationId);

  /// Chunked extraction that yields progress updates and candidates
  /// as they are extracted from each chunk.
  ///
  /// Reads [loadActiveJob] to skip already finished chunks after a process
  /// death. Persists the checkpoint after each chunk. Archives the source
  /// only when every chunk completes.
  Stream<ExtractionProgressUpdate> extractChunked(String sourceConversationId);

  Future<ExtractionJob?> loadActiveJob();

  Future<void> upsertJob(ExtractionJob job);

  Future<void> clearJob();

  /// Clears a previous cancel so a new extract can start.
  Future<void> prepareRun();

  /// Stops in-flight llama generation and clears the device-local job.
  ///
  /// Candidates already persisted stay. The current source is not archived.
  Future<void> cancelActive();

  Future<void> updateReview(ReviewCandidate candidate);

  /// Soft-deletes a candidate (pending or rejected) by id.
  Future<void> deletePending(String candidateId);
}
