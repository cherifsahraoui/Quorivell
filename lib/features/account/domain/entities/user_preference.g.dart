// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreference _$UserPreferenceFromJson(Map<String, dynamic> json) =>
    _UserPreference(
      id: json['id'] as String,
      userId: json['userId'] as String,
      themeMode: $enumDecode(_$AppearanceThemeModeEnumMap, json['themeMode']),
      localePreference: $enumDecode(
        _$AppLocalePreferenceEnumMap,
        json['localePreference'],
      ),
      debugModeEnabled: json['debugModeEnabled'] as bool? ?? false,
      chatSystemPromptOverride: json['chatSystemPromptOverride'] as String?,
      extractionPromptOverride: json['extractionPromptOverride'] as String?,
      extractionSystemPromptOverride:
          json['extractionSystemPromptOverride'] as String?,
      extractionKindsIntroDismissed:
          json['extractionKindsIntroDismissed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserPreferenceToJson(
  _UserPreference instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'themeMode': _$AppearanceThemeModeEnumMap[instance.themeMode]!,
  'localePreference': _$AppLocalePreferenceEnumMap[instance.localePreference]!,
  'debugModeEnabled': instance.debugModeEnabled,
  'chatSystemPromptOverride': instance.chatSystemPromptOverride,
  'extractionPromptOverride': instance.extractionPromptOverride,
  'extractionSystemPromptOverride': instance.extractionSystemPromptOverride,
  'extractionKindsIntroDismissed': instance.extractionKindsIntroDismissed,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$AppearanceThemeModeEnumMap = {
  AppearanceThemeMode.system: 'system',
  AppearanceThemeMode.light: 'light',
  AppearanceThemeMode.dark: 'dark',
};

const _$AppLocalePreferenceEnumMap = {
  AppLocalePreference.system: 'system',
  AppLocalePreference.en: 'en',
  AppLocalePreference.de: 'de',
  AppLocalePreference.ar: 'ar',
};
