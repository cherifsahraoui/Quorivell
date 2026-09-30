// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extraction_run.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExtractionRun _$ExtractionRunFromJson(Map<String, dynamic> json) =>
    _ExtractionRun(
      id: json['id'] as String,
      userId: json['userId'] as String,
      sourceConversationId: json['sourceConversationId'] as String?,
      sourceConversationTitle: json['sourceConversationTitle'] as String?,
      modelId: json['modelId'] as String,
      modelDisplayName: json['modelDisplayName'] as String?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      status: $enumDecode(_$ExtractionRunStatusEnumMap, json['status']),
      durationMs: (json['durationMs'] as num).toInt(),
      enabledKindSlugs:
          (json['enabledKindSlugs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['decision', 'commitment'],
      kindCounts:
          (json['kindCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      acceptedCount: (json['acceptedCount'] as num?)?.toInt() ?? 0,
      rejectedCount: (json['rejectedCount'] as num?)?.toInt() ?? 0,
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ExtractionRunToJson(_ExtractionRun instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'sourceConversationId': instance.sourceConversationId,
      'sourceConversationTitle': instance.sourceConversationTitle,
      'modelId': instance.modelId,
      'modelDisplayName': instance.modelDisplayName,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt.toIso8601String(),
      'status': _$ExtractionRunStatusEnumMap[instance.status]!,
      'durationMs': instance.durationMs,
      'enabledKindSlugs': instance.enabledKindSlugs,
      'kindCounts': instance.kindCounts,
      'acceptedCount': instance.acceptedCount,
      'rejectedCount': instance.rejectedCount,
      'pendingCount': instance.pendingCount,
    };

const _$ExtractionRunStatusEnumMap = {
  ExtractionRunStatus.success: 'success',
  ExtractionRunStatus.failure: 'failure',
};
