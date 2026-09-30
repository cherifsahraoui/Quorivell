// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiChatMessage _$AiChatMessageFromJson(Map<String, dynamic> json) =>
    _AiChatMessage(
      id: json['id'] as String,
      userId: json['userId'] as String,
      threadId: json['threadId'] as String,
      role: $enumDecode(_$AiChatRoleEnumMap, json['role']),
      content: json['content'] as String,
      status: $enumDecode(_$AiChatMessageStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AiChatMessageToJson(_AiChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'threadId': instance.threadId,
      'role': _$AiChatRoleEnumMap[instance.role]!,
      'content': instance.content,
      'status': _$AiChatMessageStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AiChatRoleEnumMap = {
  AiChatRole.user: 'user',
  AiChatRole.assistant: 'assistant',
};

const _$AiChatMessageStatusEnumMap = {
  AiChatMessageStatus.complete: 'complete',
  AiChatMessageStatus.error: 'error',
};
