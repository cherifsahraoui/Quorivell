// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_processing_consent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiProcessingConsent _$AiProcessingConsentFromJson(Map<String, dynamic> json) =>
    _AiProcessingConsent(
      status: $enumDecode(_$AiProcessingConsentStatusEnumMap, json['status']),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AiProcessingConsentToJson(
  _AiProcessingConsent instance,
) => <String, dynamic>{
  'status': _$AiProcessingConsentStatusEnumMap[instance.status]!,
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$AiProcessingConsentStatusEnumMap = {
  AiProcessingConsentStatus.unknown: 'unknown',
  AiProcessingConsentStatus.granted: 'granted',
  AiProcessingConsentStatus.declined: 'declined',
};
