import '../../../../core/database/app_database.dart';
import '../../domain/entities/extraction_run.dart';

/// Pure recount used by history tiles and the run detail screen.
///
/// Recomputes from current candidate rows in the run's time window so accepted /
/// rejected / pending stay correct after review, and ignores prior extracts on
/// the same source (unarchive / re-extract).
({int accepted, int rejected, int pending, Map<String, int> kindCounts})
recountExtractionRunResults({
  required ExtractionRun run,
  required List<ExtractionCandidateRow>? rows,
}) {
  if (rows == null) {
    return (
      accepted: run.acceptedCount,
      rejected: run.rejectedCount,
      pending: run.pendingCount,
      kindCounts: Map<String, int>.from(run.kindCounts),
    );
  }

  final startedMs = run.startedAt.millisecondsSinceEpoch;
  // Small grace so candidates written in the same tick as completedAt still
  // count when clocks / awaits order poorly across isolates.
  final endMs = run.completedAt.millisecondsSinceEpoch + 2000;
  var accepted = 0;
  var rejected = 0;
  var pending = 0;
  final kindCounts = <String, int>{};

  for (final row in rows) {
    if (row.createdAt < startedMs || row.createdAt > endMs) continue;
    kindCounts[row.kind] = (kindCounts[row.kind] ?? 0) + 1;
    switch (row.reviewStatus) {
      case 'accepted':
        accepted++;
      case 'rejected':
        rejected++;
      default:
        // pending, deferred, or any unknown open status
        pending++;
    }
  }

  return (
    accepted: accepted,
    rejected: rejected,
    pending: pending,
    kindCounts: kindCounts,
  );
}
