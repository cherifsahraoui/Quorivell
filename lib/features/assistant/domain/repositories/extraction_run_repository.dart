import '../entities/extraction_run.dart';

abstract interface class ExtractionRunRepository {
  /// Watches extraction run history, newest first.
  ///
  /// [limit] and [offset] keep the history list bounded.
  Stream<List<ExtractionRun>> watchRuns({int limit, int offset});

  /// Records a completed extraction run with privacy-safe aggregates.
  Future<void> createRun(ExtractionRun run);

  /// Soft-deletes a run by id.
  Future<void> deleteRun(String runId);
}
