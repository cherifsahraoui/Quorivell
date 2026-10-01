// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SourceConversation _$SourceConversationFromJson(Map<String, dynamic> json) =>
    _SourceConversation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      sourceUrl: json['sourceUrl'] as String?,
      sourceRevision: (json['sourceRevision'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isArchived: json['isArchived'] as bool? ?? false,
    );

Map<String, dynamic> _$SourceConversationToJson(_SourceConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'content': instance.content,
      'sourceUrl': instance.sourceUrl,
      'sourceRevision': instance.sourceRevision,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isArchived': instance.isArchived,
    };
