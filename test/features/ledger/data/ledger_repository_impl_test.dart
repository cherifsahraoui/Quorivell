import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';
import 'package:quorivell/features/ledger/data/datasources/ledger_local_data_source.dart';
import 'package:quorivell/features/ledger/data/repositories/ledger_repository_impl.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';

void main() {
  late AppDatabase database;
  late LedgerRepositoryImpl repository;
  late String localUserId;

  Future<void> insertItem({
    required String id,
    required String statement,
    String status = 'open',
    String kind = 'commitment',
    int updatedAt = 1,
  }) {
    return database
        .into(database.ledgerItems)
        .insert(
          LedgerItemsCompanion.insert(
            id: id,
            userId: localUserId,
            kind: kind,
            statement: statement,
            status: status,
            owner: const Value('Alex'),
            createdAt: 1,
            updatedAt: updatedAt,
          ),
        );
  }

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final userScope = LocalUserScopeRepositoryImpl(
      DriftLocalUserScopeLocalDataSource(database),
    );
    localUserId = (await userScope.getOrCreate()).id;
    repository = LedgerRepositoryImpl(
      localDataSource: DriftLedgerLocalDataSource(database),
      userScopeRepository: userScope,
      now: () => DateTime.utc(2026, 9, 7),
    );
  });

  tearDown(() => database.close());

  test('watches only open commitments for the local user scope', () async {
    await insertItem(id: 'open-1', statement: 'Send the checklist.');
    await insertItem(
      id: 'done-1',
      statement: 'Already handled.',
      status: 'completed',
    );
    await insertItem(
      id: 'decision-1',
      statement: 'We chose option B.',
      kind: 'decision',
    );

    final items = await repository.watchOpenCommitments().first;

    expect(items.map((item) => item.id), ['open-1']);
    expect(items.single.status, LedgerItemStatus.open);
    expect(items.single.kind, LedgerItemKind.commitment);
  });

  test('watches decisions and commitments together', () async {
    await insertItem(id: 'open-1', statement: 'Send the checklist.');
    await insertItem(
      id: 'decision-1',
      statement: 'We chose option B.',
      kind: 'decision',
      updatedAt: 2,
    );

    final items = await repository.watchItems().first;

    expect(items.map((item) => item.id), ['decision-1', 'open-1']);
  });

  test('bounds the inbox query with limit and offset', () async {
    await insertItem(id: 'a', statement: 'Older.', updatedAt: 1);
    await insertItem(id: 'b', statement: 'Newer.', updatedAt: 2);

    final firstPage = await repository.watchOpenCommitments(limit: 1).first;
    final secondPage = await repository
        .watchOpenCommitments(limit: 1, offset: 1)
        .first;

    expect(firstPage.map((item) => item.id), ['b']);
    expect(secondPage.map((item) => item.id), ['a']);
  });

  test('marks a commitment completed and soft-deletes with evidence', () async {
    await insertItem(id: 'open-1', statement: 'Send the checklist.');
    await database
        .into(database.evidence)
        .insert(
          EvidenceCompanion.insert(
            id: 'ev-1',
            ledgerItemId: 'open-1',
            sourceConversationId: 'src-1',
            sourceRevision: 1,
            quoteStart: 0,
            quoteEnd: 4,
            quoteSnippet: 'Send',
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    await repository.updateStatus(
      id: 'open-1',
      status: LedgerItemStatus.completed,
    );
    final completed = await repository.watchById('open-1').first;
    expect(completed?.status, LedgerItemStatus.completed);

    await repository.delete('open-1');
    final deleted = await repository.watchById('open-1').first;
    expect(deleted, isNull);

    final evidence = await repository.watchEvidence('open-1').first;
    expect(evidence, isEmpty);

    final evidenceRow = await (database.select(
      database.evidence,
    )..where((row) => row.id.equals('ev-1'))).getSingle();
    expect(evidenceRow.isDeleted, isTrue);
  });

  test('rejects an empty accepted statement', () async {
    await expectLater(
      repository.acceptCandidate(
        candidateId: 'any',
        kind: LedgerItemKind.commitment,
        statement: '   ',
        owner: null,
        dueDate: null,
        kindDisplayNameSnapshot: 'Commitment',
      ),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
  });

  test('reports an unknown candidate as a typed failure', () async {
    await expectLater(
      repository.acceptCandidate(
        candidateId: 'missing',
        kind: LedgerItemKind.commitment,
        statement: 'Send the checklist.',
        owner: null,
        dueDate: null,
        kindDisplayNameSnapshot: 'Commitment',
      ),
      throwsA(const LocalPersistenceFailure.notFound()),
    );
  });

  test('persists dueDate when accepting a decision if provided', () async {
    await database
        .into(database.extractionCandidates)
        .insert(
          ExtractionCandidatesCompanion.insert(
            id: 'cand-decision',
            userId: localUserId,
            sourceConversationId: 'src-1',
            sourceRevision: 1,
            kind: 'commitment',
            statement: 'We chose option B.',
            quoteStart: 0,
            quoteEnd: 18,
            quoteSnippet: 'We chose option B.',
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    final item = await repository.acceptCandidate(
      candidateId: 'cand-decision',
      kind: LedgerItemKind.decision,
      statement: 'We chose option B.',
      owner: null,
      dueDate: DateTime.utc(2026, 9, 10, 15, 30),
      kindDisplayNameSnapshot: 'Decision',
    );

    expect(item.kind, LedgerItemKind.decision);
    expect(item.dueDate, DateTime.utc(2026, 9, 10, 15, 30));
  });

  test('keeps dueDate when accepting a commitment', () async {
    final dueDate = DateTime.utc(2026, 9, 10, 15, 30);
    await database
        .into(database.extractionCandidates)
        .insert(
          ExtractionCandidatesCompanion.insert(
            id: 'cand-commitment',
            userId: localUserId,
            sourceConversationId: 'src-1',
            sourceRevision: 1,
            kind: 'decision',
            statement: 'Alex will send the checklist.',
            quoteStart: 0,
            quoteEnd: 29,
            quoteSnippet: 'Alex will send the checklist.',
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    final item = await repository.acceptCandidate(
      candidateId: 'cand-commitment',
      kind: LedgerItemKind.commitment,
      statement: 'Alex will send the checklist.',
      owner: 'Alex',
      dueDate: dueDate,
      kindDisplayNameSnapshot: 'Commitment',
    );

    expect(item.kind, LedgerItemKind.commitment);
    expect(item.dueDate, dueDate);
  });

  test('creates a user-authored commitment without evidence', () async {
    final dueDate = DateTime.utc(2026, 9, 10, 15, 30);

    final item = await repository.createManual(
      kind: LedgerItemKind.commitment,
      statement: '  Send the checklist.  ',
      owner: '  Alex  ',
      dueDate: dueDate,
      kindDisplayNameSnapshot: 'Commitment',
    );

    expect(item.statement, 'Send the checklist.');
    expect(item.owner, 'Alex');
    expect(item.kind, LedgerItemKind.commitment);
    expect(item.status, LedgerItemStatus.open);
    expect(item.dueDate, dueDate);
    expect(item.userId, localUserId);

    final evidence = await repository.watchEvidence(item.id).first;
    expect(evidence, isEmpty);

    final listed = await repository.watchOpenCommitments().first;
    expect(listed.map((row) => row.id), [item.id]);
  });

  test('strips dueDate and blank owner on a user-authored decision', () async {
    final item = await repository.createManual(
      kind: LedgerItemKind.decision,
      statement: 'We chose option B.',
      owner: '   ',
      dueDate: DateTime.utc(2026, 9, 10, 15, 30),
      kindDisplayNameSnapshot: 'Decision',
      allowsDueDate: false,
    );

    expect(item.kind, LedgerItemKind.decision);
    expect(item.owner, isNull);
    expect(item.dueDate, isNull);

    final row = await (database.select(
      database.ledgerItems,
    )..where((table) => table.id.equals(item.id))).getSingle();
    expect(row.dueDate, isNull);
    expect(row.owner, isNull);
  });

  test('rejects an empty or oversized manual statement', () async {
    await expectLater(
      repository.createManual(
        kind: LedgerItemKind.commitment,
        statement: '   ',
        owner: null,
        dueDate: null,
        kindDisplayNameSnapshot: 'Commitment',
      ),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );

    await expectLater(
      repository.createManual(
        kind: LedgerItemKind.commitment,
        statement: 'x' * (LedgerItemLimits.statementMaxLength + 1),
        owner: null,
        dueDate: null,
        kindDisplayNameSnapshot: 'Commitment',
      ),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
  });
}
