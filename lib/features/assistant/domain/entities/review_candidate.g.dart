// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewCandidate _$ReviewCandidateFromJson(Map<String, dynamic> json) =>
    _ReviewCandidate(
      id: json['id'] as String,
      userId: json['userId'] as String,
      sourceConversationId: json['sourceConversationId'] as String,
      sourceRevision: (json['sourceRevision'] as num).toInt(),
      kind: json['kind'] as String,
      statement: json['statement'] as String,
      owner: json['owner'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      note: json['note'] as String?,
      quoteStart: (json['quoteStart'] as num).toInt(),
      quoteEnd: (json['quoteEnd'] as num).toInt(),
      quoteSnippet: json['quoteSnippet'] as String,
      reviewStatus: $enumDecode(_$ReviewStatusEnumMap, json['reviewStatus']),
    );

Map<String, dynamic> _$ReviewCandidateToJson(_ReviewCandidate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'sourceConversationId': instance.sourceConversationId,
      'sourceRevision': instance.sourceRevision,
      'kind': instance.kind,
      'statement': instance.statement,
      'owner': instance.owner,
      'dueDate': instance.dueDate?.toIso8601String(),
      'note': instance.note,
      'quoteStart': instance.quoteStart,
      'quoteEnd': instance.quoteEnd,
      'quoteSnippet': instance.quoteSnippet,
      'reviewStatus': _$ReviewStatusEnumMap[instance.reviewStatus]!,
    };

const _$ReviewStatusEnumMap = {
  ReviewStatus.pending: 'pending',
  ReviewStatus.accepted: 'accepted',
  ReviewStatus.rejected: 'rejected',
  ReviewStatus.deferred: 'deferred',
};
