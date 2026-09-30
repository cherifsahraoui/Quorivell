import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Default page size for ledger inbox queries.
const int ledgerPageSize = 100;

abstract interface class LedgerLocalDataSource {
  Stream<List<LedgerItemRow>> watchItems({
    required String userId,
    String? kind,
    Set<String>? statuses,
    int limit,
    int offset,
  });

  Stream<LedgerItemRow?> watchById({
    required String userId,
    required String id,
  });

  Stream<List<EvidenceRow>> watchEvidence(String ledgerItemId);

  Future<ExtractionCandidateRow?> findCandidate(String candidateId);

  /// Inserts a ledger item without evidence (user-authored records).
  Future<void> insertItem(LedgerItemsCompanion item);

  /// Writes the accepted item, its evidence, and the candidate status in one
  /// transaction so an accepted ledger item can never lose its evidence.
  Future<void> acceptCandidate({
    required LedgerItemsCompanion item,
    required EvidenceCompanion evidence,
    required String candidateId,
    required int acceptedAt,
  });

  /// Returns `false` when no matching non-deleted row exists.
  Future<bool> updateStatus({
    required String id,
    required String userId,
    required String status,
    required int updatedAt,
  });

  /// Soft-deletes the item and its evidence. Returns `false` when missing.
  Future<bool> markDeleted({
    required String id,
    required String userId,
    required int updatedAt,
  });
}

class DriftLedgerLocalDataSource implements LedgerLocalDataSource {
  DriftLedgerLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Stream<List<LedgerItemRow>> watchItems({
    required String userId,
    String? kind,
    Set<String>? statuses,
    int limit = ledgerPageSize,
    int offset = 0,
  }) {
    final query = _database.select(_database.ledgerItems)
      ..where((row) => row.userId.equals(userId))
      ..where((row) => row.isDeleted.equals(false));

    if (kind != null) {
      query.where((row) => row.kind.equals(kind));
    }
    if (statuses != null && statuses.isNotEmpty) {
      query.where((row) => row.status.isIn(statuses));
    }

    query
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
      ..limit(limit, offset: offset);

    return query.watch();
  }

  @override
  Stream<LedgerItemRow?> watchById({
    required String userId,
    required String id,
  }) {
    return (_database.select(_database.ledgerItems)
          ..where((row) => row.id.equals(id))
          ..where((row) => row.userId.equals(userId))
          ..where((row) => row.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  @override
  Stream<List<EvidenceRow>> watchEvidence(String ledgerItemId) {
    return (_database.select(_database.evidence)
          ..where((row) => row.ledgerItemId.equals(ledgerItemId))
          ..where((row) => row.isDeleted.equals(false))
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .watch();
  }

  @override
  Future<ExtractionCandidateRow?> findCandidate(String candidateId) =>
      (_database.select(
        _database.extractionCandidates,
      )..where((row) => row.id.equals(candidateId))).getSingleOrNull();

  @override
  Future<void> insertItem(LedgerItemsCompanion item) {
    return _database.into(_database.ledgerItems).insert(item);
  }

  @override
  Future<void> acceptCandidate({
    required LedgerItemsCompanion item,
    required EvidenceCompanion evidence,
    required String candidateId,
    required int acceptedAt,
  }) {
    return _database.transaction(() async {
      await _database.into(_database.ledgerItems).insert(item);
      await _database.into(_database.evidence).insert(evidence);
      await (_database.update(
        _database.extractionCandidates,
      )..where((row) => row.id.equals(candidateId))).write(
        ExtractionCandidatesCompanion(
          reviewStatus: const Value('accepted'),
          updatedAt: Value(acceptedAt),
        ),
      );
    });
  }

  @override
  Future<bool> updateStatus({
    required String id,
    required String userId,
    required String status,
    required int updatedAt,
  }) async {
    final count =
        await (_database.update(_database.ledgerItems)
              ..where((row) => row.id.equals(id))
              ..where((row) => row.userId.equals(userId))
              ..where((row) => row.isDeleted.equals(false)))
            .write(
              LedgerItemsCompanion(
                status: Value(status),
                updatedAt: Value(updatedAt),
                syncStatus: const Value(0),
              ),
            );
    return count > 0;
  }

  @override
  Future<bool> markDeleted({
    required String id,
    required String userId,
    required int updatedAt,
  }) {
    return _database.transaction(() async {
      final itemCount =
          await (_database.update(_database.ledgerItems)
                ..where((row) => row.id.equals(id))
                ..where((row) => row.userId.equals(userId))
                ..where((row) => row.isDeleted.equals(false)))
              .write(
                LedgerItemsCompanion(
                  isDeleted: const Value(true),
                  updatedAt: Value(updatedAt),
                  syncStatus: const Value(0),
                ),
              );
      if (itemCount == 0) {
        return false;
      }
      await (_database.update(_database.evidence)
            ..where((row) => row.ledgerItemId.equals(id))
            ..where((row) => row.isDeleted.equals(false)))
          .write(
            EvidenceCompanion(
              isDeleted: const Value(true),
              updatedAt: Value(updatedAt),
              syncStatus: const Value(0),
            ),
          );
      return true;
    });
  }
}
