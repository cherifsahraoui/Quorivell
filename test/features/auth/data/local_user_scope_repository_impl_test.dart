import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';
import 'package:quorivell/features/auth/domain/entities/local_user_scope.dart';

class _FakeLocalUserScopeLocalDataSource
    implements LocalUserScopeLocalDataSource {
  _FakeLocalUserScopeLocalDataSource({this.existing, this.error});

  LocalUserScopeRow? existing;
  final Object? error;
  LocalUserScopeRow? saved;

  @override
  Future<LocalUserScopeRow?> find() async {
    if (error != null) throw error!;
    return existing;
  }

  @override
  Future<void> save(LocalUserScopeRow scope) async {
    if (error != null) throw error!;
    saved = scope;
    existing = scope;
  }
}

void main() {
  final createdAt = DateTime.utc(2026, 9, 7).millisecondsSinceEpoch;

  test('returns the existing local user scope without writing', () async {
    final dataSource = _FakeLocalUserScopeLocalDataSource(
      existing: LocalUserScopeRow(
        id: 'scope-1',
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );
    final repository = LocalUserScopeRepositoryImpl(dataSource);

    final scope = await repository.getOrCreate();

    expect(
      scope,
      LocalUserScope(
        id: 'scope-1',
        createdAt: DateTime.utc(2026, 9, 7),
        updatedAt: DateTime.utc(2026, 9, 7),
      ),
    );
    expect(dataSource.saved, isNull);
  });

  test('creates and persists a scope when none exists', () async {
    final dataSource = _FakeLocalUserScopeLocalDataSource();
    final repository = LocalUserScopeRepositoryImpl(dataSource);

    final scope = await repository.getOrCreate();

    expect(scope.id, matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(dataSource.saved?.id, scope.id);
    expect(dataSource.saved?.createdAt, scope.createdAt.millisecondsSinceEpoch);
  });

  test('maps data-source errors to a typed write failure', () async {
    final repository = LocalUserScopeRepositoryImpl(
      _FakeLocalUserScopeLocalDataSource(error: StateError('disk full')),
    );

    await expectLater(
      repository.getOrCreate(),
      throwsA(const LocalPersistenceFailure.writeFailed()),
    );
  });

  test('serializes concurrent getOrCreate calls to one scope row', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalUserScopeRepositoryImpl(
      DriftLocalUserScopeLocalDataSource(database),
    );

    final results = await Future.wait([
      repository.getOrCreate(),
      repository.getOrCreate(),
      repository.getOrCreate(),
    ]);

    expect(results.map((scope) => scope.id).toSet(), hasLength(1));
    expect(await database.select(database.localUserScopes).get(), hasLength(1));
  });
}
