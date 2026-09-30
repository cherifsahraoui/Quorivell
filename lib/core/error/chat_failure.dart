import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_failure.dart';

part 'chat_failure.freezed.dart';

/// Failures raised while chatting with the on-device model.
///
/// `LocalAIException` and Drift errors are mapped to these values at the
/// repository / controller boundary so UI never sees SDK text.
@freezed
sealed class ChatFailure with _$ChatFailure implements AppFailure {
  const factory ChatFailure.invalidInput() = ChatInvalidInputFailure;
  const factory ChatFailure.modelUnavailable() = ChatModelUnavailableFailure;
  const factory ChatFailure.unknown() = ChatUnknownFailure;
}
