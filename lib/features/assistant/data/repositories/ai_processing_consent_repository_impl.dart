import '../../../../core/database/app_database.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../../auth/domain/repositories/local_user_scope_repository.dart';
import '../../domain/entities/ai_processing_consent.dart';
import '../../domain/repositories/ai_processing_consent_repository.dart';
import '../datasources/ai_processing_consent_local_data_source.dart';

class AiProcessingConsentRepositoryImpl
    implements AiProcessingConsentRepository {
  AiProcessingConsentRepositoryImpl({
    required AiProcessingConsentLocalDataSource localDataSource,
    required LocalUserScopeRepository userScopeRepository,
    DateTime Function()? now,
  }) : _localDataSource = localDataSource,
       _userScopeRepository = userScopeRepository,
       _now = now ?? (() => DateTime.now().toUtc());

  final AiProcessingConsentLocalDataSource _localDataSource;
  final LocalUserScopeRepository _userScopeRepository;
  final DateTime Function() _now;

  @override
  Future<AiProcessingConsent> load() => guardLocalRead(() async {
    final row = await _localDataSource.find();
    if (row == null || row.isDeleted) {
      return AiProcessingConsent(
        status: AiProcessingConsentStatus.unknown,
        updatedAt: _now(),
      );
    }
    return _toDomain(row);
  });

  @override
  Future<AiProcessingConsent> save(AiProcessingConsentStatus status) {
    return guardLocalWrite(() async {
      final user = await _userScopeRepository.getOrCreate();
      final timestamp = _now();
      final existing = await _localDataSource.find();
      final createdAt = existing == null || existing.createdAt == 0
          ? timestamp.millisecondsSinceEpoch
          : existing.createdAt;
      await _localDataSource.save(
        AiProcessingConsentRow(
          id: aiProcessingConsentRowId,
          userId: user.id,
          status: status.name,
          createdAt: createdAt,
          updatedAt: timestamp.millisecondsSinceEpoch,
          isDeleted: false,
          syncStatus: 0,
        ),
      );
      return AiProcessingConsent(status: status, updatedAt: timestamp);
    });
  }

  AiProcessingConsent _toDomain(AiProcessingConsentRow row) {
    final status = AiProcessingConsentStatus.values.asNameMap()[row.status];
    return AiProcessingConsent(
      status: status ?? AiProcessingConsentStatus.unknown,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row.updatedAt,
        isUtc: true,
      ),
    );
  }
}
