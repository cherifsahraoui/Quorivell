import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_failure.dart';

part 'extraction_failure.freezed.dart';

/// Failures raised while turning a captured conversation into review
/// candidates. `LocalAIException` is mapped to these values at the repository
/// boundary.
@freezed
sealed class ExtractionFailure with _$ExtractionFailure implements AppFailure {
  const factory ExtractionFailure.noSourceConversation() =
      ExtractionNoSourceConversationFailure;
  const factory ExtractionFailure.sourceArchived() =
      ExtractionSourceArchivedFailure;
  const factory ExtractionFailure.invalidInput() =
      ExtractionInvalidInputFailure;
  const factory ExtractionFailure.modelUnavailable() =
      ExtractionModelUnavailableFailure;
  const factory ExtractionFailure.modelUnsupported() =
      ExtractionModelUnsupportedFailure;
  const factory ExtractionFailure.invalidOutput() =
      ExtractionInvalidOutputFailure;
  const factory ExtractionFailure.unknown() = ExtractionUnknownFailure;
  const factory ExtractionFailure.cancelled() = ExtractionCancelledFailure;
}
