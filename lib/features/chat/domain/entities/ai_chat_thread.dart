import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_thread.freezed.dart';
part 'ai_chat_thread.g.dart';

@freezed
abstract class AiChatThread with _$AiChatThread {
  const factory AiChatThread({
    required String id,
    required String userId,
    required String title,
    required String? modelId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AiChatThread;

  factory AiChatThread.fromJson(Map<String, dynamic> json) =>
      _$AiChatThreadFromJson(json);
}
