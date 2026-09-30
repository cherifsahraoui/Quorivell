import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_processing_consent.freezed.dart';
part 'ai_processing_consent.g.dart';

enum AiProcessingConsentStatus { unknown, granted, declined }

@freezed
abstract class AiProcessingConsent with _$AiProcessingConsent {
  const AiProcessingConsent._();

  const factory AiProcessingConsent({
    required AiProcessingConsentStatus status,
    required DateTime updatedAt,
  }) = _AiProcessingConsent;

  factory AiProcessingConsent.fromJson(Map<String, dynamic> json) =>
      _$AiProcessingConsentFromJson(json);

  /// True only after an explicit grant. Remote AI must not run without this.
  bool get isAffirmative => status == AiProcessingConsentStatus.granted;
}
