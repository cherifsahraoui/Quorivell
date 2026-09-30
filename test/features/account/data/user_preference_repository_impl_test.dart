import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/account/data/datasources/user_preference_local_data_source.dart';
import 'package:quorivell/features/account/data/repositories/user_preference_repository_impl.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';
import 'package:quorivell/features/auth/domain/entities/local_user_scope.dart';
import 'package:quorivell/features/auth/domain/repositories/local_user_scope_repository.dart';

class _ThrowingUserPreferenceLocalDataSource
    implements UserPreferenceLocalDataSource {
  @override
  Future<UserPreferenceRow?> find({required String userId}) {
    throw StateError('locked');
  }

  @override
  Future<void> save(UserPreferenceRow row) {
    throw StateError('locked');
  }

  @override
  Future<void> markDeleted({required String userId, required int updatedAt}) {
    throw StateError('locked');
  }
}

class _FixedUserScopeRepository implements LocalUserScopeRepository {
  @override
  Future<LocalUserScope> getOrCreate() async => LocalUserScope(
    id: 'user-1',
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

void main() {
  late AppDatabase database;
  late UserPreferenceRepositoryImpl repository;
  final now = DateTime.utc(2026, 9, 12, 12);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = UserPreferenceRepositoryImpl(
      DriftUserPreferenceLocalDataSource(database),
      LocalUserScopeRepositoryImpl(
        DriftLocalUserScopeLocalDataSource(database),
      ),
      now: () => now,
    );
  });

  tearDown(() => database.close());

  test('loads nothing until a preference is saved', () async {
    expect(await repository.load(), isNull);
  });

  test('persists and reloads an appearance preference', () async {
    final saved = await repository.saveThemeMode(AppearanceThemeMode.dark);

    expect(saved.themeMode, AppearanceThemeMode.dark);
    expect(saved.localePreference, AppLocalePreference.system);
    expect(saved.id, userPreferenceRowId);
    expect((await repository.load())?.themeMode, AppearanceThemeMode.dark);
  });

  test('persists locale preference without clearing theme', () async {
    await repository.saveThemeMode(AppearanceThemeMode.light);
    final saved = await repository.saveLocalePreference(AppLocalePreference.ar);

    expect(saved.themeMode, AppearanceThemeMode.light);
    expect(saved.localePreference, AppLocalePreference.ar);
    expect((await repository.load())?.localePreference, AppLocalePreference.ar);
  });

  test('persists debug mode and prompt overrides', () async {
    await repository.saveThemeMode(AppearanceThemeMode.dark);
    final enabled = await repository.saveDebugModeEnabled(true);
    expect(enabled.debugModeEnabled, isTrue);
    expect(enabled.themeMode, AppearanceThemeMode.dark);

    final saved = await repository.savePromptOverrides(
      chatSystemPromptOverride: 'Stay on this device.',
      extractionPromptOverride: 'Extract only.\n\n{conversation}',
      extractionSystemPromptOverride: 'Return JSON only.',
    );
    expect(saved.debugModeEnabled, isTrue);
    expect(saved.chatSystemPromptOverride, 'Stay on this device.');
    expect(saved.extractionPromptOverride, 'Extract only.\n\n{conversation}');
    expect(saved.extractionSystemPromptOverride, 'Return JSON only.');

    final reloaded = await repository.load();
    expect(reloaded?.debugModeEnabled, isTrue);
    expect(reloaded?.chatSystemPromptOverride, 'Stay on this device.');
    expect(
      reloaded?.extractionPromptOverride,
      'Extract only.\n\n{conversation}',
    );
    expect(reloaded?.extractionSystemPromptOverride, 'Return JSON only.');

    final cleared = await repository.savePromptOverrides(
      chatSystemPromptOverride: null,
      extractionPromptOverride: null,
      extractionSystemPromptOverride: null,
    );
    expect(cleared.debugModeEnabled, isTrue);
    expect(cleared.chatSystemPromptOverride, isNull);
    expect(cleared.extractionPromptOverride, isNull);
    expect(cleared.extractionSystemPromptOverride, isNull);
  });

  test('clearing hides the stored preference', () async {
    await repository.saveThemeMode(AppearanceThemeMode.light);
    await repository.clear();

    expect(await repository.load(), isNull);
  });

  test('maps data-source errors to typed persistence failures', () async {
    final failing = UserPreferenceRepositoryImpl(
      _ThrowingUserPreferenceLocalDataSource(),
      _FixedUserScopeRepository(),
      now: () => now,
    );

    await expectLater(
      failing.load(),
      throwsA(const LocalPersistenceFailure.readFailed()),
    );
    await expectLater(
      failing.saveThemeMode(AppearanceThemeMode.system),
      throwsA(const LocalPersistenceFailure.writeFailed()),
    );
    await expectLater(
      failing.saveLocalePreference(AppLocalePreference.en),
      throwsA(const LocalPersistenceFailure.writeFailed()),
    );
    await expectLater(
      failing.saveDebugModeEnabled(true),
      throwsA(const LocalPersistenceFailure.writeFailed()),
    );
    await expectLater(
      failing.savePromptOverrides(chatSystemPromptOverride: 'Stay on device.'),
      throwsA(const LocalPersistenceFailure.writeFailed()),
    );
    await expectLater(
      failing.clear(),
      throwsA(const LocalPersistenceFailure.writeFailed()),
    );
  });
}
