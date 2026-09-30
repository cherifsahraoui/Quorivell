import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preference.freezed.dart';
part 'user_preference.g.dart';

enum AppearanceThemeMode { system, light, dark }

/// Persisted UI locale preference. [system] follows the device locale.
enum AppLocalePreference { system, en, de, ar }

@freezed
abstract class UserPreference with _$UserPreference {
  const factory UserPreference({
    required String id,
    required String userId,
    required AppearanceThemeMode themeMode,
    required AppLocalePreference localePreference,
    @Default(false) bool debugModeEnabled,
    String? chatSystemPromptOverride,
    String? extractionPromptOverride,
    String? extractionSystemPromptOverride,
    @Default(false) bool extractionKindsIntroDismissed,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserPreference;

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceFromJson(json);
}
