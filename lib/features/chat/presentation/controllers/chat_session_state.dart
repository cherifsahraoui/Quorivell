import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/app_failure.dart';

part 'chat_session_state.freezed.dart';

@freezed
abstract class ChatSessionState with _$ChatSessionState {
  const factory ChatSessionState({
    String? threadId,
    @Default(true) bool draftNew,
    @Default(false) bool isGenerating,
    @Default('') String streamingText,
    @Default(true) bool autoScrollEnabled,
    AppFailure? sendFailure,
  }) = _ChatSessionState;
}
