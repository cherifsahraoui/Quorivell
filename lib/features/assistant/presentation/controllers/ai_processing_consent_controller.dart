import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/ai_processing_consent_providers.dart';
import '../../domain/entities/ai_processing_consent.dart';

part 'ai_processing_consent_controller.g.dart';

@riverpod
class AiProcessingConsentController extends _$AiProcessingConsentController {
  @override
  Future<AiProcessingConsent> build() {
    return ref.watch(aiProcessingConsentRepositoryProvider).load();
  }

  Future<void> grant() => _persist(AiProcessingConsentStatus.granted);

  Future<void> decline() => _persist(AiProcessingConsentStatus.declined);

  Future<void> _persist(AiProcessingConsentStatus status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(aiProcessingConsentRepositoryProvider).save(status),
    );
  }
}
