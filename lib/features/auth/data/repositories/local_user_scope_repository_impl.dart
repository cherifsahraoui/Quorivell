import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../domain/entities/local_user_scope.dart';
import '../../domain/repositories/local_user_scope_repository.dart';
import '../datasources/local_user_scope_local_data_source.dart';

class LocalUserScopeRepositoryImpl implements LocalUserScopeRepository {
  LocalUserScopeRepositoryImpl(this._localDataSource, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final LocalUserScopeLocalDataSource _localDataSource;
  final Uuid _uuid;

  /// Serializes concurrent [getOrCreate] calls on this instance so parallel
  /// preference loaders cannot insert duplicate scope rows.
  Future<LocalUserScope>? _inFlight;

  @override
  Future<LocalUserScope> getOrCreate() {
    final pending = _inFlight;
    if (pending != null) {
      return pending;
    }
    final created = guardLocalWrite(() async {
      final existing = await _localDataSource.find();
      if (existing != null) {
        return _toDomain(existing);
      }

      final currentTime = DateTime.now().toUtc();
      final now = DateTime.fromMillisecondsSinceEpoch(
        currentTime.millisecondsSinceEpoch,
        isUtc: true,
      );
      final scope = LocalUserScope(
        id: _uuid.v4(),
        createdAt: now,
        updatedAt: now,
      );
      await _localDataSource.save(
        LocalUserScopeRow(
          id: scope.id,
          createdAt: scope.createdAt.millisecondsSinceEpoch,
          updatedAt: scope.updatedAt.millisecondsSinceEpoch,
        ),
      );
      return scope;
    });
    _inFlight = created;
    return created.whenComplete(() {
      if (identical(_inFlight, created)) {
        _inFlight = null;
      }
    });
  }

  LocalUserScope _toDomain(LocalUserScopeRow row) => LocalUserScope(
    id: row.id,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt, isUtc: true),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt, isUtc: true),
  );
}
