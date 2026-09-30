// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiChatThread _$AiChatThreadFromJson(Map<String, dynamic> json) =>
    _AiChatThread(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      modelId: json['modelId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AiChatThreadToJson(_AiChatThread instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'modelId': instance.modelId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
