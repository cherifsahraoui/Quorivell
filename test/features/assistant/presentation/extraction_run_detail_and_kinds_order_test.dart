import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_run.dart';
import 'package:quorivell/features/assistant/presentation/pages/extraction_run_detail_page.dart';
import 'package:quorivell/features/extraction_kinds/presentation/pages/extraction_kinds_page.dart';

import '../../../helpers/extraction_kind_catalog.dart';

void main() {
  group('orderedExtractionKinds', () {
    test('puts enabled kinds before disabled, then sortOrder', () {
      final disabledEarly = testExtractionKind(
        id: 'd1',
        slug: 'names',
        displayName: 'Names',
        enabledForExtraction: false,
        sortOrder: 0,
      );
      final enabledLate = testExtractionKind(
        id: 'e1',
        slug: 'groceries',
        displayName: 'Groceries',
        enabledForExtraction: true,
        sortOrder: 5,
      );
      final enabledEarly = testExtractionKind(
        id: 'e0',
        slug: 'decision',
        displayName: 'Decision',
        isBuiltIn: true,
        enabledForExtraction: true,
        sortOrder: 1,
      );

      final ordered = orderedExtractionKinds([
        disabledEarly,
        enabledLate,
        enabledEarly,
      ]);

      expect(ordered.map((kind) => kind.id), ['e0', 'e1', 'd1']);
    });
  });

  group('recountExtractionRunResults', () {
    final started = DateTime.utc(2026, 9, 28, 10);
    final completed = DateTime.utc(2026, 9, 28, 10, 5);
    final run = ExtractionRun(
      id: 'run-1',
      userId: 'user-1',
      sourceConversationId: 'source-1',
      modelId: 'model',
      startedAt: started,
      completedAt: completed,
      status: ExtractionRunStatus.success,
      durationMs: 300000,
      enabledKindSlugs: const ['decision', 'commitment'],
      kindCounts: const {'decision': 2, 'commitment': 1},
      acceptedCount: 0,
      rejectedCount: 0,
      pendingCount: 3,
    );

    ExtractionCandidateRow row({
      required String id,
      required String status,
      required String kind,
      required DateTime createdAt,
    }) {
      final ms = createdAt.millisecondsSinceEpoch;
      return ExtractionCandidateRow(
        id: id,
        userId: 'user-1',
        sourceConversationId: 'source-1',
        sourceRevision: 1,
        kind: kind,
        statement: 'Statement $id',
        quoteStart: 0,
        quoteEnd: 1,
        quoteSnippet: 'q',
        reviewStatus: status,
        createdAt: ms,
        updatedAt: ms,
        isDeleted: false,
        syncStatus: 0,
      );
    }

    test('falls back to snapshot while rows are loading', () {
      final counts = recountExtractionRunResults(run: run, rows: null);
      expect(counts.pending, 3);
      expect(counts.accepted, 0);
    });

    test('recounts live statuses inside the run window', () {
      final counts = recountExtractionRunResults(
        run: run,
        rows: [
          row(
            id: 'a',
            status: 'accepted',
            kind: 'decision',
            createdAt: started.add(const Duration(minutes: 1)),
          ),
          row(
            id: 'b',
            status: 'rejected',
            kind: 'decision',
            createdAt: started.add(const Duration(minutes: 2)),
          ),
          row(
            id: 'c',
            status: 'pending',
            kind: 'commitment',
            createdAt: started.add(const Duration(minutes: 3)),
          ),
          // Outside window — ignored.
          row(
            id: 'old',
            status: 'pending',
            kind: 'decision',
            createdAt: started.subtract(const Duration(hours: 1)),
          ),
        ],
      );

      expect(counts.accepted, 1);
      expect(counts.rejected, 1);
      expect(counts.pending, 1);
      expect(counts.kindCounts, {'decision': 2, 'commitment': 1});
    });
  });
}
