import '../entities/ai_processing_consent.dart';

abstract interface class AiProcessingConsentRepository {
  Future<AiProcessingConsent> load();
  Future<AiProcessingConsent> save(AiProcessingConsentStatus status);
}
