import 'dart:convert';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../../auth/domain/repositories/local_user_scope_repository.dart';
import '../../domain/entities/extraction_run.dart';
import '../../domain/repositories/extraction_run_repository.dart';
import '../datasources/extraction_local_data_source.dart';

const int extractionRunHistoryPageSize = 50;

class ExtractionRunRepositoryImpl implements ExtractionRunRepository {
  ExtractionRunRepositoryImpl({
    required ExtractionLocalDataSource localDataSource,
    required LocalUserScopeRepository userScopeRepository,
    DateTime Function()? now,
  }) : _localDataSource = localDataSource,
       _userScopeRepository = userScopeRepository,
       _now = now ?? (() => DateTime.now().toUtc());

  final ExtractionLocalDataSource _localDataSource;
  final LocalUserScopeRepository _userScopeRepository;
  final DateTime Function() _now;

  @override
  Stream<List<ExtractionRun>> watchRuns({
    int limit = extractionRunHistoryPageSize,
    int offset = 0,
  }) {
    return guardLocalStream(() async* {
      final user = await _userScopeRepository.getOrCreate();
      yield* _localDataSource
          .watchRuns(userId: user.id, limit: limit, offset: offset)
          .map((rows) => rows.map(_fromRow).toList());
    });
  }

  @override
  Future<void> createRun(ExtractionRun run) {
    return guardLocalWrite(() async {
      final timestamp = _now().millisecondsSinceEpoch;
      final row = ExtractionRunRow(
        id: run.id,
        userId: run.userId,
        sourceConversationId: run.sourceConversationId,
        sourceConversationTitle: run.sourceConversationTitle,
        modelId: run.modelId,
        modelDisplayName: run.modelDisplayName,
        startedAt: run.startedAt.millisecondsSinceEpoch,
        completedAt: run.completedAt.millisecondsSinceEpoch,
        status: run.status.name,
        durationMs: run.durationMs,
        enabledKindSlugsJson: jsonEncode(run.enabledKindSlugs),
        kindCountsJson: jsonEncode(run.kindCounts),
        acceptedCount: run.acceptedCount,
        rejectedCount: run.rejectedCount,
        pendingCount: run.pendingCount,
        createdAt: timestamp,
        updatedAt: timestamp,
        isDeleted: false,
        syncStatus: 0,
      );
      await _localDataSource.insertRun(row);
    });
  }

  @override
  Future<void> deleteRun(String runId) {
    return guardLocalWrite(
      () => _localDataSource.markRunDeleted(
        runId: runId,
        updatedAt: _now().millisecondsSinceEpoch,
      ),
    );
  }

  ExtractionRun _fromRow(ExtractionRunRow row) {
    return ExtractionRun(
      id: row.id,
      userId: row.userId,
      sourceConversationId: row.sourceConversationId,
      sourceConversationTitle: row.sourceConversationTitle,
      modelId: row.modelId,
      modelDisplayName: row.modelDisplayName,
      startedAt: DateTime.fromMillisecondsSinceEpoch(
        row.startedAt,
        isUtc: true,
      ),
      completedAt: DateTime.fromMillisecondsSinceEpoch(
        row.completedAt,
        isUtc: true,
      ),
      status: ExtractionRunStatus.values.byName(row.status),
      durationMs: row.durationMs,
      enabledKindSlugs: _decodeSlugs(row.enabledKindSlugsJson),
      kindCounts: _decodeCounts(row.kindCountsJson),
      acceptedCount: row.acceptedCount,
      rejectedCount: row.rejectedCount,
      pendingCount: row.pendingCount,
    );
  }

  List<String> _decodeSlugs(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const ['decision', 'commitment'];
      return [
        for (final value in decoded)
          if (value is String && value.trim().isNotEmpty) value,
      ];
    } on Object {
      return const ['decision', 'commitment'];
    }
  }

  Map<String, int> _decodeCounts(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const {};
      return {
        for (final entry in decoded.entries)
          if (entry.key is String && entry.value is num)
            entry.key as String: (entry.value as num).toInt(),
      };
    } on Object {
      return const {};
    }
  }
}
