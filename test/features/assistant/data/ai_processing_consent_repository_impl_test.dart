import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/assistant/data/datasources/ai_processing_consent_local_data_source.dart';
import 'package:quorivell/features/assistant/data/repositories/ai_processing_consent_repository_impl.dart';
import 'package:quorivell/features/assistant/domain/entities/ai_processing_consent.dart';
import 'package:quorivell/features/auth/domain/entities/local_user_scope.dart';
import 'package:quorivell/features/auth/domain/repositories/local_user_scope_repository.dart';

class _FakeLocalUserScopeRepository implements LocalUserScopeRepository {
  @override
  Future<LocalUserScope> getOrCreate() async => LocalUserScope(
    id: 'user-1',
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

class _FakeAiProcessingConsentLocalDataSource
    implements AiProcessingConsentLocalDataSource {
  _FakeAiProcessingConsentLocalDataSource({this.existing, this.error});

  AiProcessingConsentRow? existing;
  final Object? error;
  AiProcessingConsentRow? saved;

  @override
  Future<AiProcessingConsentRow?> find() async {
    if (error != null) throw error!;
    return existing;
  }

  @override
  Future<void> save(AiProcessingConsentRow row) async {
    if (error != null) throw error!;
    saved = row;
    existing = row;
  }
}

AiProcessingConsentRow _row({
  required DateTime now,
  String status = 'granted',
  bool isDeleted = false,
}) => AiProcessingConsentRow(
  id: aiProcessingConsentRowId,
  userId: 'user-1',
  status: status,
  createdAt: now.millisecondsSinceEpoch,
  updatedAt: now.millisecondsSinceEpoch,
  isDeleted: isDeleted,
  syncStatus: 0,
);

void main() {
  final now = DateTime.utc(2026, 9, 8, 12);
  final userScope = _FakeLocalUserScopeRepository();

  test('loads unknown consent when nothing is stored', () async {
    final repository = AiProcessingConsentRepositoryImpl(
      localDataSource: _FakeAiProcessingConsentLocalDataSource(),
      userScopeRepository: userScope,
      now: () => now,
    );

    final consent = await repository.load();

    expect(consent.status, AiProcessingConsentStatus.unknown);
    expect(consent.isAffirmative, isFalse);
    expect(consent.updatedAt, now);
  });

  test('persists an affirmative grant for the local user', () async {
    final dataSource = _FakeAiProcessingConsentLocalDataSource();
    final repository = AiProcessingConsentRepositoryImpl(
      localDataSource: dataSource,
      userScopeRepository: userScope,
      now: () => now,
    );

    final consent = await repository.save(AiProcessingConsentStatus.granted);

    expect(consent.status, AiProcessingConsentStatus.granted);
    expect(consent.isAffirmative, isTrue);
    expect(dataSource.saved?.id, aiProcessingConsentRowId);
    expect(dataSource.saved?.userId, 'user-1');
    expect(dataSource.saved?.status, 'granted');
    expect(dataSource.saved?.syncStatus, 0);
    expect(await repository.load(), consent);
  });

  test(
    'persists a decline and treats unknown stored values as unknown',
    () async {
      final dataSource = _FakeAiProcessingConsentLocalDataSource(
        existing: _row(now: now, status: 'not-a-status'),
      );
      final repository = AiProcessingConsentRepositoryImpl(
        localDataSource: dataSource,
        userScopeRepository: userScope,
        now: () => now,
      );

      expect(
        (await repository.load()).status,
        AiProcessingConsentStatus.unknown,
      );

      final declined = await repository.save(
        AiProcessingConsentStatus.declined,
      );
      expect(declined.status, AiProcessingConsentStatus.declined);
      expect(declined.isAffirmative, isFalse);
    },
  );

  test('treats a tombstoned consent row as unknown', () async {
    final repository = AiProcessingConsentRepositoryImpl(
      localDataSource: _FakeAiProcessingConsentLocalDataSource(
        existing: _row(now: now, isDeleted: true),
      ),
      userScopeRepository: userScope,
      now: () => now,
    );

    expect((await repository.load()).status, AiProcessingConsentStatus.unknown);
  });

  test('maps data-source errors to typed persistence failures', () async {
    final repository = AiProcessingConsentRepositoryImpl(
      localDataSource: _FakeAiProcessingConsentLocalDataSource(
        error: StateError('locked'),
      ),
      userScopeRepository: userScope,
      now: () => now,
    );

    await expectLater(
      repository.load(),
      throwsA(const LocalPersistenceFailure.readFailed()),
    );
    await expectLater(
      repository.save(AiProcessingConsentStatus.granted),
      throwsA(const LocalPersistenceFailure.writeFailed()),
    );
  });
}
