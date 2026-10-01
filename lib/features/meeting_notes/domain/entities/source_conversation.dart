import 'package:freezed_annotation/freezed_annotation.dart';

part 'source_conversation.freezed.dart';
part 'source_conversation.g.dart';

@freezed
abstract class SourceConversation with _$SourceConversation {
  const factory SourceConversation({
    required String id,
    required String userId,
    required String content,

    /// Original http(s) page when Capture fetched webpage text; null for paste.
    String? sourceUrl,
    required int sourceRevision,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isArchived,
  }) = _SourceConversation;

  factory SourceConversation.fromJson(Map<String, dynamic> json) =>
      _$SourceConversationFromJson(json);
}
