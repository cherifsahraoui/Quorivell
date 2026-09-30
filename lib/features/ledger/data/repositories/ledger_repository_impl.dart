import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../../auth/domain/repositories/local_user_scope_repository.dart';
import '../../domain/entities/ledger_item.dart';
import '../../domain/repositories/ledger_repository.dart';
import '../datasources/ledger_local_data_source.dart';

class LedgerRepositoryImpl implements LedgerRepository {
  LedgerRepositoryImpl({
    required LedgerLocalDataSource localDataSource,
    required LocalUserScopeRepository userScopeRepository,
    Uuid? uuid,
    DateTime Function()? now,
  }) : _localDataSource = localDataSource,
       _userScopeRepository = userScopeRepository,
       _uuid = uuid ?? const Uuid(),
       _now = now ?? (() => DateTime.now().toUtc());

  final LedgerLocalDataSource _localDataSource;
  final LocalUserScopeRepository _userScopeRepository;
  final Uuid _uuid;
  final DateTime Function() _now;

  @override
  Stream<List<LedgerItem>> watchItems({
    String? kind,
    Set<LedgerItemStatus>? statuses,
    int limit = ledgerPageSize,
    int offset = 0,
  }) {
    return guardLocalStream(() async* {
      final user = await _userScopeRepository.getOrCreate();
      yield* _localDataSource
          .watchItems(
            userId: user.id,
            kind: kind,
            statuses: statuses?.map((status) => status.name).toSet(),
            limit: limit,
            offset: offset,
          )
          .map((rows) => rows.map(_fromRow).toList());
    });
  }

  @override
  Stream<List<LedgerItem>> watchOpenCommitments({
    int limit = ledgerPageSize,
    int offset = 0,
  }) {
    return watchItems(
      kind: LedgerItemKind.commitment,
      statuses: {LedgerItemStatus.open},
      limit: limit,
      offset: offset,
    );
  }

  @override
  Stream<LedgerItem?> watchById(String id) {
    return guardLocalStream(() async* {
      final user = await _userScopeRepository.getOrCreate();
      yield* _localDataSource
          .watchById(userId: user.id, id: id)
          .map((row) => row == null ? null : _fromRow(row));
    });
  }

  @override
  Stream<List<EvidenceReference>> watchEvidence(String ledgerItemId) {
    return guardLocalStream(() async* {
      yield* _localDataSource
          .watchEvidence(ledgerItemId)
          .map((rows) => rows.map(_evidenceFromRow).toList());
    });
  }

  @override
  Future<LedgerItem> acceptCandidate({
    required String candidateId,
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
  }) {
    return guardLocalWrite(() async {
      final normalizedStatement = _normalizeStatement(statement);

      final candidate = await _localDataSource.findCandidate(candidateId);
      if (candidate == null) {
        throw const LocalPersistenceFailure.notFound();
      }

      final timestamp = _now();
      final itemId = _uuid.v4();
      final snapshot = _normalizeSnapshot(kindDisplayNameSnapshot, kind);
      final normalizedNote = _normalizeNote(note);

      await _localDataSource.acceptCandidate(
        candidateId: candidateId,
        acceptedAt: timestamp.millisecondsSinceEpoch,
        item: LedgerItemsCompanion.insert(
          id: itemId,
          userId: candidate.userId,
          kind: kind,
          statement: normalizedStatement,
          status: LedgerItemStatus.open.name,
          owner: Value(owner),
          dueDate: Value(dueDate?.millisecondsSinceEpoch),
          note: Value(normalizedNote),
          kindDisplayNameSnapshot: Value(snapshot),
          createdAt: timestamp.millisecondsSinceEpoch,
          updatedAt: timestamp.millisecondsSinceEpoch,
        ),
        evidence: EvidenceCompanion.insert(
          id: _uuid.v4(),
          ledgerItemId: itemId,
          sourceConversationId: candidate.sourceConversationId,
          sourceRevision: candidate.sourceRevision,
          quoteStart: candidate.quoteStart,
          quoteEnd: candidate.quoteEnd,
          quoteSnippet: candidate.quoteSnippet,
          createdAt: timestamp.millisecondsSinceEpoch,
          updatedAt: timestamp.millisecondsSinceEpoch,
        ),
      );

      return LedgerItem(
        id: itemId,
        userId: candidate.userId,
        kind: kind,
        statement: normalizedStatement,
        status: LedgerItemStatus.open,
        owner: owner,
        dueDate: dueDate,
        note: normalizedNote,
        kindDisplayNameSnapshot: snapshot,
        createdAt: timestamp,
        updatedAt: timestamp,
      );
    });
  }

  @override
  Future<LedgerItem> createManual({
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
    bool allowsDueDate = true,
  }) {
    return guardLocalWrite(() async {
      final normalizedStatement = _normalizeStatement(statement);
      final normalizedOwner = _normalizeOwner(owner);
      final user = await _userScopeRepository.getOrCreate();
      final timestamp = _now();
      final itemId = _uuid.v4();
      final normalizedDueDate = allowsDueDate ? dueDate : null;
      final snapshot = _normalizeSnapshot(kindDisplayNameSnapshot, kind);
      final normalizedNote = _normalizeNote(note);

      await _localDataSource.insertItem(
        LedgerItemsCompanion.insert(
          id: itemId,
          userId: user.id,
          kind: kind,
          statement: normalizedStatement,
          status: LedgerItemStatus.open.name,
          owner: Value(normalizedOwner),
          dueDate: Value(normalizedDueDate?.millisecondsSinceEpoch),
          note: Value(normalizedNote),
          kindDisplayNameSnapshot: Value(snapshot),
          createdAt: timestamp.millisecondsSinceEpoch,
          updatedAt: timestamp.millisecondsSinceEpoch,
        ),
      );

      return LedgerItem(
        id: itemId,
        userId: user.id,
        kind: kind,
        statement: normalizedStatement,
        status: LedgerItemStatus.open,
        owner: normalizedOwner,
        dueDate: normalizedDueDate,
        note: normalizedNote,
        kindDisplayNameSnapshot: snapshot,
        createdAt: timestamp,
        updatedAt: timestamp,
      );
    });
  }

  @override
  Future<void> updateStatus({
    required String id,
    required LedgerItemStatus status,
  }) {
    return guardLocalWrite(() async {
      final normalizedId = id.trim();
      if (normalizedId.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      final user = await _userScopeRepository.getOrCreate();
      final updated = await _localDataSource.updateStatus(
        id: normalizedId,
        userId: user.id,
        status: status.name,
        updatedAt: _now().millisecondsSinceEpoch,
      );
      if (!updated) {
        throw const LocalPersistenceFailure.notFound();
      }
    });
  }

  @override
  Future<void> delete(String id) {
    return guardLocalWrite(() async {
      final normalizedId = id.trim();
      if (normalizedId.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      final user = await _userScopeRepository.getOrCreate();
      final deleted = await _localDataSource.markDeleted(
        id: normalizedId,
        userId: user.id,
        updatedAt: _now().millisecondsSinceEpoch,
      );
      if (!deleted) {
        throw const LocalPersistenceFailure.notFound();
      }
    });
  }

  String _normalizeStatement(String statement) {
    final normalized = statement.trim();
    if (normalized.isEmpty ||
        normalized.length > LedgerItemLimits.statementMaxLength) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    return normalized;
  }

  String? _normalizeOwner(String? owner) {
    final normalized = owner?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    if (normalized.length > LedgerItemLimits.ownerMaxLength) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    return normalized;
  }

  String? _normalizeNote(String? note) {
    final normalized = note?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    if (normalized.length > LedgerItemLimits.noteMaxLength) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    return normalized;
  }

  String _normalizeSnapshot(String snapshot, String kind) {
    final normalized = snapshot.trim();
    if (normalized.isEmpty) {
      return kind;
    }
    if (normalized.length > LedgerItemLimits.displayNameSnapshotMaxLength) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    return normalized;
  }

  LedgerItem _fromRow(LedgerItemRow row) {
    return LedgerItem(
      id: row.id,
      userId: row.userId,
      kind: row.kind,
      statement: row.statement,
      status: LedgerItemStatus.values.byName(row.status),
      owner: row.owner,
      dueDate: row.dueDate != null
          ? DateTime.fromMillisecondsSinceEpoch(row.dueDate!, isUtc: true)
          : null,
      note: row.note,
      kindDisplayNameSnapshot: row.kindDisplayNameSnapshot,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row.createdAt,
        isUtc: true,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row.updatedAt,
        isUtc: true,
      ),
    );
  }

  EvidenceReference _evidenceFromRow(EvidenceRow row) => EvidenceReference(
    id: row.id,
    ledgerItemId: row.ledgerItemId,
    sourceConversationId: row.sourceConversationId,
    sourceRevision: row.sourceRevision,
    quoteStart: row.quoteStart,
    quoteEnd: row.quoteEnd,
    quoteSnippet: row.quoteSnippet,
  );
}
