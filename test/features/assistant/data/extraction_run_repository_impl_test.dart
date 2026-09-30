import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/features/assistant/data/datasources/extraction_local_data_source.dart';
import 'package:quorivell/features/assistant/data/repositories/extraction_run_repository_impl.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_run.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';

void main() {
  late AppDatabase database;
  late ExtractionRunRepositoryImpl repository;
  late String userId;
  final now = DateTime.utc(2026, 9, 16, 12);

  ExtractionRun run({
    required String id,
    required DateTime completedAt,
    int decisionCount = 0,
  }) {
    return ExtractionRun(
      id: id,
      userId: userId,
      modelId: 'test-model',
      startedAt: completedAt.subtract(const Duration(seconds: 8)),
      completedAt: completedAt,
      status: ExtractionRunStatus.success,
      durationMs: 8000,
      kindCounts: {'decision': decisionCount},
    );
  }

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final userScope = LocalUserScopeRepositoryImpl(
      DriftLocalUserScopeLocalDataSource(database),
    );
    userId = (await userScope.getOrCreate()).id;
    repository = ExtractionRunRepositoryImpl(
      localDataSource: DriftExtractionLocalDataSource(database),
      userScopeRepository: userScope,
      now: () => now,
    );
  });

  tearDown(() => database.close());

  test('watchRuns emits newest completed runs first', () async {
    await repository.createRun(
      run(id: 'older', completedAt: DateTime.utc(2026, 9, 16, 10)),
    );
    await repository.createRun(
      run(
        id: 'newer',
        completedAt: DateTime.utc(2026, 9, 16, 11),
        decisionCount: 2,
      ),
    );

    final rows = await repository.watchRuns().first;
    expect(rows.map((item) => item.id), ['newer', 'older']);
    expect(rows.first.decisionCount, 2);
    expect(rows.first.userId, userId);
  });

  test('deleteRun soft-deletes a history row', () async {
    await repository.createRun(
      run(id: 'keep', completedAt: DateTime.utc(2026, 9, 16, 10)),
    );
    await repository.createRun(
      run(id: 'drop', completedAt: DateTime.utc(2026, 9, 16, 11)),
    );

    await repository.deleteRun('drop');

    final rows = await repository.watchRuns().first;
    expect(rows.map((item) => item.id), ['keep']);
    final stored = await database.select(database.extractionRuns).get();
    expect(stored.where((row) => row.id == 'drop').single.isDeleted, isTrue);
  });
}
