import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

abstract interface class LocalUserScopeLocalDataSource {
  Future<LocalUserScopeRow?> find();
  Future<void> save(LocalUserScopeRow scope);
}

class DriftLocalUserScopeLocalDataSource
    implements LocalUserScopeLocalDataSource {
  DriftLocalUserScopeLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Future<LocalUserScopeRow?> find() async {
    final rows =
        await (_database.select(_database.localUserScopes)
              ..orderBy([(row) => OrderingTerm.asc(row.createdAt)])
              ..limit(1))
            .get();
    if (rows.isEmpty) {
      return null;
    }
    return rows.first;
  }

  @override
  Future<void> save(LocalUserScopeRow scope) =>
      _database.into(_database.localUserScopes).insertOnConflictUpdate(scope);
}
