// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extraction_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExtractionJob _$ExtractionJobFromJson(Map<String, dynamic> json) =>
    _ExtractionJob(
      id: json['id'] as String? ?? kActiveExtractionJobId,
      sourceConversationId: json['sourceConversationId'] as String,
      sourceRevision: (json['sourceRevision'] as num?)?.toInt() ?? 1,
      completedChunkCount: (json['completedChunkCount'] as num?)?.toInt() ?? 0,
      totalChunks: (json['totalChunks'] as num?)?.toInt() ?? 0,
      candidatesFound: (json['candidatesFound'] as num?)?.toInt() ?? 0,
      startTime: DateTime.parse(json['startTime'] as String),
      chunkTimings:
          (json['chunkTimings'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      progressTitle: json['progressTitle'] as String? ?? '',
      progressBody: json['progressBody'] as String? ?? '',
      completionTitle: json['completionTitle'] as String? ?? '',
      queuedSourceConversationIds:
          (json['queuedSourceConversationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      batchIndex: (json['batchIndex'] as num?)?.toInt() ?? 0,
      batchTotal: (json['batchTotal'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$ExtractionJobToJson(_ExtractionJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceConversationId': instance.sourceConversationId,
      'sourceRevision': instance.sourceRevision,
      'completedChunkCount': instance.completedChunkCount,
      'totalChunks': instance.totalChunks,
      'candidatesFound': instance.candidatesFound,
      'startTime': instance.startTime.toIso8601String(),
      'chunkTimings': instance.chunkTimings,
      'progressTitle': instance.progressTitle,
      'progressBody': instance.progressBody,
      'completionTitle': instance.completionTitle,
      'queuedSourceConversationIds': instance.queuedSourceConversationIds,
      'batchIndex': instance.batchIndex,
      'batchTotal': instance.batchTotal,
    };
