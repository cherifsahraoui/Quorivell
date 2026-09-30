import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

const int extractionKindPageSize = 100;

abstract interface class ExtractionItemKindLocalDataSource {
  Stream<List<ExtractionItemKindRow>> watchAll({
    required String userId,
    int limit,
    int offset,
    bool enabledOnly,
  });

  Future<List<ExtractionItemKindRow>> listAll({required String userId});

  Future<ExtractionItemKindRow?> findById({
    required String userId,
    required String id,
  });

  Future<ExtractionItemKindRow?> findBySlug({
    required String userId,
    required String slug,
  });

  Future<int> countActive({required String userId});

  Future<int> countEnabled({required String userId});

  Future<int> countLedgerBySlug({required String userId, required String slug});

  Future<int> countPendingCandidatesBySlug({
    required String userId,
    required String slug,
  });

  Future<void> insert(ExtractionItemKindRow row);

  Future<void> update(ExtractionItemKindRow row);

  Future<void> upsert(ExtractionItemKindRow row);
}

class DriftExtractionItemKindLocalDataSource
    implements ExtractionItemKindLocalDataSource {
  DriftExtractionItemKindLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Stream<List<ExtractionItemKindRow>> watchAll({
    required String userId,
    int limit = extractionKindPageSize,
    int offset = 0,
    bool enabledOnly = false,
  }) {
    final query = _database.select(_database.extractionItemKinds)
      ..where((row) => row.userId.equals(userId) | row.userId.equals(''))
      ..where((row) => row.isDeleted.equals(false));
    if (enabledOnly) {
      query.where((row) => row.enabledForExtraction.equals(true));
    }
    query
      ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)])
      ..limit(limit, offset: offset);
    return query.watch();
  }

  @override
  Future<List<ExtractionItemKindRow>> listAll({required String userId}) {
    return (_database.select(_database.extractionItemKinds)
          ..where((row) => row.userId.equals(userId) | row.userId.equals(''))
          ..where((row) => row.isDeleted.equals(false))
          ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
        .get();
  }

  @override
  Future<ExtractionItemKindRow?> findById({
    required String userId,
    required String id,
  }) {
    return (_database.select(_database.extractionItemKinds)
          ..where((row) => row.id.equals(id))
          ..where((row) => row.userId.equals(userId) | row.userId.equals(''))
          ..where((row) => row.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  @override
  Future<ExtractionItemKindRow?> findBySlug({
    required String userId,
    required String slug,
  }) {
    return (_database.select(_database.extractionItemKinds)
          ..where((row) => row.slug.equals(slug))
          ..where((row) => row.userId.equals(userId) | row.userId.equals(''))
          ..where((row) => row.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  @override
  Future<int> countActive({required String userId}) async {
    final count = countAll();
    final query = _database.selectOnly(_database.extractionItemKinds)
      ..addColumns([count])
      ..where(
        _database.extractionItemKinds.userId.equals(userId) |
            _database.extractionItemKinds.userId.equals(''),
      )
      ..where(_database.extractionItemKinds.isDeleted.equals(false));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<int> countEnabled({required String userId}) async {
    final count = countAll();
    final query = _database.selectOnly(_database.extractionItemKinds)
      ..addColumns([count])
      ..where(
        _database.extractionItemKinds.userId.equals(userId) |
            _database.extractionItemKinds.userId.equals(''),
      )
      ..where(_database.extractionItemKinds.isDeleted.equals(false))
      ..where(_database.extractionItemKinds.enabledForExtraction.equals(true));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<int> countLedgerBySlug({
    required String userId,
    required String slug,
  }) async {
    final count = countAll();
    final query = _database.selectOnly(_database.ledgerItems)
      ..addColumns([count])
      ..where(_database.ledgerItems.userId.equals(userId))
      ..where(_database.ledgerItems.kind.equals(slug))
      ..where(_database.ledgerItems.isDeleted.equals(false));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<int> countPendingCandidatesBySlug({
    required String userId,
    required String slug,
  }) async {
    final count = countAll();
    final query = _database.selectOnly(_database.extractionCandidates)
      ..addColumns([count])
      ..where(_database.extractionCandidates.userId.equals(userId))
      ..where(_database.extractionCandidates.kind.equals(slug))
      ..where(_database.extractionCandidates.isDeleted.equals(false))
      ..where(_database.extractionCandidates.reviewStatus.equals('pending'));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<void> insert(ExtractionItemKindRow row) {
    return _database.into(_database.extractionItemKinds).insert(row);
  }

  @override
  Future<void> update(ExtractionItemKindRow row) {
    return _database.update(_database.extractionItemKinds).replace(row);
  }

  @override
  Future<void> upsert(ExtractionItemKindRow row) {
    return _database
        .into(_database.extractionItemKinds)
        .insertOnConflictUpdate(row);
  }
}

String encodeTeachingExamples(List<Map<String, String>> examples) {
  if (examples.isEmpty) return '';
  return jsonEncode(examples);
}
