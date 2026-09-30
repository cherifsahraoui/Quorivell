import '../entities/ledger_item.dart';

abstract interface class LedgerRepository {
  /// Watches ledger items for the local user scope, newest first.
  ///
  /// When [kind] is null, both decisions and commitments are included.
  /// When [statuses] is null or empty, every non-deleted status is included.
  /// [limit] and [offset] keep the query bounded.
  Stream<List<LedgerItem>> watchItems({
    String? kind,
    Set<LedgerItemStatus>? statuses,
    int limit,
    int offset,
  });

  /// Convenience watch for the open-commitments inbox.
  Stream<List<LedgerItem>> watchOpenCommitments({int limit, int offset});

  Stream<LedgerItem?> watchById(String id);

  Stream<List<EvidenceReference>> watchEvidence(String ledgerItemId);

  Future<LedgerItem> acceptCandidate({
    required String candidateId,
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
  });

  /// Creates a user-authored ledger item with no evidence.
  ///
  /// Does not invent a source conversation or quote span. [dueDate] is stored
  /// only when the kind's date policy allows it.
  Future<LedgerItem> createManual({
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
    bool allowsDueDate = true,
  });

  /// Updates status (for example open → completed) and refreshes [updatedAt].
  Future<void> updateStatus({
    required String id,
    required LedgerItemStatus status,
  });

  /// Soft-deletes a ledger item and its evidence.
  Future<void> delete(String id);
}
