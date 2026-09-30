import '../../../../core/database/app_database.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../../auth/domain/repositories/local_user_scope_repository.dart';
import '../../domain/entities/user_preference.dart';
import '../../domain/repositories/user_preference_repository.dart';
import '../datasources/user_preference_local_data_source.dart';

const _unset = Object();

class UserPreferenceRepositoryImpl implements UserPreferenceRepository {
  UserPreferenceRepositoryImpl(
    this._localDataSource,
    this._userScopeRepository, {
    DateTime Function()? now,
  }) : _now = now ?? (() => DateTime.now().toUtc());

  final UserPreferenceLocalDataSource _localDataSource;
  final LocalUserScopeRepository _userScopeRepository;
  final DateTime Function() _now;

  @override
  Future<UserPreference?> load() => guardLocalRead(() async {
    final user = await _userScopeRepository.getOrCreate();
    final row = await _localDataSource.find(userId: user.id);
    if (row == null) {
      return null;
    }
    return _toDomain(row);
  });

  @override
  Future<UserPreference> saveThemeMode(AppearanceThemeMode themeMode) {
    return _upsert(themeMode: themeMode);
  }

  @override
  Future<UserPreference> saveLocalePreference(
    AppLocalePreference localePreference,
  ) {
    return _upsert(localePreference: localePreference);
  }

  @override
  Future<UserPreference> saveDebugModeEnabled(bool enabled) {
    return _upsert(debugModeEnabled: enabled);
  }

  @override
  Future<UserPreference> savePromptOverrides({
    String? chatSystemPromptOverride,
    String? extractionPromptOverride,
    String? extractionSystemPromptOverride,
  }) {
    return _upsert(
      chatSystemPromptOverride: chatSystemPromptOverride,
      extractionPromptOverride: extractionPromptOverride,
      extractionSystemPromptOverride: extractionSystemPromptOverride,
    );
  }

  @override
  Future<UserPreference> saveExtractionKindsIntroDismissed(bool dismissed) {
    return _upsert(extractionKindsIntroDismissed: dismissed);
  }

  Future<UserPreference> _upsert({
    AppearanceThemeMode? themeMode,
    AppLocalePreference? localePreference,
    bool? debugModeEnabled,
    Object? chatSystemPromptOverride = _unset,
    Object? extractionPromptOverride = _unset,
    Object? extractionSystemPromptOverride = _unset,
    bool? extractionKindsIntroDismissed,
  }) {
    return guardLocalWrite(() async {
      final user = await _userScopeRepository.getOrCreate();
      final timestamp = _now();
      final existing = await _localDataSource.find(userId: user.id);
      final createdAt = existing == null
          ? timestamp
          : DateTime.fromMillisecondsSinceEpoch(
              existing.createdAt,
              isUtc: true,
            );
      final existingDomain = existing == null ? null : _toDomain(existing);
      final preference = UserPreference(
        id: userPreferenceRowId,
        userId: user.id,
        themeMode:
            themeMode ??
            existingDomain?.themeMode ??
            AppearanceThemeMode.system,
        localePreference:
            localePreference ??
            existingDomain?.localePreference ??
            AppLocalePreference.system,
        debugModeEnabled:
            debugModeEnabled ?? existingDomain?.debugModeEnabled ?? false,
        chatSystemPromptOverride: _pickOverride(
          chatSystemPromptOverride,
          existingDomain?.chatSystemPromptOverride,
        ),
        extractionPromptOverride: _pickOverride(
          extractionPromptOverride,
          existingDomain?.extractionPromptOverride,
        ),
        extractionSystemPromptOverride: _pickOverride(
          extractionSystemPromptOverride,
          existingDomain?.extractionSystemPromptOverride,
        ),
        extractionKindsIntroDismissed:
            extractionKindsIntroDismissed ??
            existingDomain?.extractionKindsIntroDismissed ??
            false,
        createdAt: createdAt,
        updatedAt: timestamp,
      );
      await _localDataSource.save(
        UserPreferenceRow(
          id: preference.id,
          userId: preference.userId,
          themeMode: preference.themeMode.name,
          localePreference: preference.localePreference.name,
          debugModeEnabled: preference.debugModeEnabled,
          chatSystemPromptOverride: preference.chatSystemPromptOverride,
          extractionPromptOverride: preference.extractionPromptOverride,
          extractionSystemPromptOverride:
              preference.extractionSystemPromptOverride,
          extractionKindsIntroDismissed:
              preference.extractionKindsIntroDismissed,
          createdAt: preference.createdAt.millisecondsSinceEpoch,
          updatedAt: preference.updatedAt.millisecondsSinceEpoch,
          isDeleted: false,
          syncStatus: 0,
        ),
      );
      return preference;
    });
  }

  @override
  Future<void> clear() => guardLocalWrite(() async {
    final user = await _userScopeRepository.getOrCreate();
    await _localDataSource.markDeleted(
      userId: user.id,
      updatedAt: _now().millisecondsSinceEpoch,
    );
  });

  UserPreference _toDomain(UserPreferenceRow row) {
    final themeMode = AppearanceThemeMode.values.asNameMap()[row.themeMode];
    final localePreference = AppLocalePreference.values
        .asNameMap()[row.localePreference];
    return UserPreference(
      id: row.id,
      userId: row.userId,
      themeMode: themeMode ?? AppearanceThemeMode.system,
      localePreference: localePreference ?? AppLocalePreference.system,
      debugModeEnabled: row.debugModeEnabled,
      chatSystemPromptOverride: row.chatSystemPromptOverride,
      extractionPromptOverride: row.extractionPromptOverride,
      extractionSystemPromptOverride: row.extractionSystemPromptOverride,
      extractionKindsIntroDismissed: row.extractionKindsIntroDismissed,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row.createdAt,
        isUtc: true,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row.updatedAt,
        isUtc: true,
      ),
    );
  }
}

String? _pickOverride(Object? value, String? existing) {
  if (identical(value, _unset)) return existing;
  final text = value as String?;
  final trimmed = text?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
