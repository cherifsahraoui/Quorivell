import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';

part 'database_providers.g.dart';

/// Kept alive for the process: capture uses [Ref.read], and auto-dispose would
/// close the database while a write is still in flight.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase.open();
  ref.onDispose(database.close);
  return database;
}
