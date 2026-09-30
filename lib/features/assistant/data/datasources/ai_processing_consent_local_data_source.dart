import '../../../../core/database/app_database.dart';

/// Singleton primary key for the on-device AI-processing consent row.
const String aiProcessingConsentRowId = 'ai_processing_consent';

abstract interface class AiProcessingConsentLocalDataSource {
  Future<AiProcessingConsentRow?> find();
  Future<void> save(AiProcessingConsentRow row);
}

class DriftAiProcessingConsentLocalDataSource
    implements AiProcessingConsentLocalDataSource {
  DriftAiProcessingConsentLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Future<AiProcessingConsentRow?> find() => (_database.select(
    _database.aiProcessingConsents,
  )..where((row) => row.id.equals(aiProcessingConsentRowId))).getSingleOrNull();

  @override
  Future<void> save(AiProcessingConsentRow row) => _database
      .into(_database.aiProcessingConsents)
      .insertOnConflictUpdate(row);
}
