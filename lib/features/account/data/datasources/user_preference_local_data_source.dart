import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Singleton primary key for the on-device appearance preference row.
const String userPreferenceRowId = 'app';

abstract interface class UserPreferenceLocalDataSource {
  Future<UserPreferenceRow?> find({required String userId});
  Future<void> save(UserPreferenceRow row);
  Future<void> markDeleted({required String userId, required int updatedAt});
}

class DriftUserPreferenceLocalDataSource
    implements UserPreferenceLocalDataSource {
  DriftUserPreferenceLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Future<UserPreferenceRow?> find({required String userId}) =>
      (_database.select(_database.userPreferences)
            ..where((row) => row.id.equals(userPreferenceRowId))
            ..where((row) => row.userId.equals(userId))
            ..where((row) => row.isDeleted.equals(false)))
          .getSingleOrNull();

  @override
  Future<void> save(UserPreferenceRow row) =>
      _database.into(_database.userPreferences).insertOnConflictUpdate(row);

  @override
  Future<void> markDeleted({
    required String userId,
    required int updatedAt,
  }) async {
    await (_database.update(_database.userPreferences)
          ..where((row) => row.id.equals(userPreferenceRowId))
          ..where((row) => row.userId.equals(userId)))
        .write(
          UserPreferencesCompanion(
            isDeleted: const Value(true),
            updatedAt: Value(updatedAt),
            syncStatus: const Value(0),
          ),
        );
  }
}
