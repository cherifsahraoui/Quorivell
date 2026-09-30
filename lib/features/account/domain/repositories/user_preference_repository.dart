import '../entities/user_preference.dart';

abstract interface class UserPreferenceRepository {
  Future<UserPreference?> load();
  Future<UserPreference> saveThemeMode(AppearanceThemeMode themeMode);
  Future<UserPreference> saveLocalePreference(
    AppLocalePreference localePreference,
  );
  Future<UserPreference> saveDebugModeEnabled(bool enabled);
  Future<UserPreference> savePromptOverrides({
    String? chatSystemPromptOverride,
    String? extractionPromptOverride,
    String? extractionSystemPromptOverride,
  });
  Future<UserPreference> saveExtractionKindsIntroDismissed(bool dismissed);
  Future<void> clear();
}
