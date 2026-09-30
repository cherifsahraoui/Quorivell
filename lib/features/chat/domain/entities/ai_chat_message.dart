import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_message.freezed.dart';
part 'ai_chat_message.g.dart';

enum AiChatRole { user, assistant }

enum AiChatMessageStatus { complete, error }

@freezed
abstract class AiChatMessage with _$AiChatMessage {
  const factory AiChatMessage({
    required String id,
    required String userId,
    required String threadId,
    required AiChatRole role,
    required String content,
    required AiChatMessageStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AiChatMessage;

  factory AiChatMessage.fromJson(Map<String, dynamic> json) =>
      _$AiChatMessageFromJson(json);
}
