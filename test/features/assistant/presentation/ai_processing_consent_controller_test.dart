import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/assistant/data/providers/ai_processing_consent_providers.dart';
import 'package:quorivell/features/assistant/domain/entities/ai_processing_consent.dart';
import 'package:quorivell/features/assistant/domain/repositories/ai_processing_consent_repository.dart';
import 'package:quorivell/features/assistant/presentation/controllers/ai_processing_consent_controller.dart';

class _FakeAiProcessingConsentRepository
    implements AiProcessingConsentRepository {
  _FakeAiProcessingConsentRepository({required this.consent, this.saveError});

  AiProcessingConsent consent;
  final Object? saveError;
  AiProcessingConsentStatus? lastSaved;

  @override
  Future<AiProcessingConsent> load() async => consent;

  @override
  Future<AiProcessingConsent> save(AiProcessingConsentStatus status) async {
    if (saveError != null) throw saveError!;
    lastSaved = status;
    consent = AiProcessingConsent(
      status: status,
      updatedAt: DateTime.utc(2026, 9, 8),
    );
    return consent;
  }
}

ProviderContainer _container(AiProcessingConsentRepository repository) {
  return ProviderContainer.test(
    overrides: [
      aiProcessingConsentRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

void main() {
  final unknown = AiProcessingConsent(
    status: AiProcessingConsentStatus.unknown,
    updatedAt: DateTime.utc(2026, 9, 7),
  );

  test('loads the stored consent state', () async {
    final container = _container(
      _FakeAiProcessingConsentRepository(consent: unknown),
    );
    container.listen(aiProcessingConsentControllerProvider, (_, _) {});

    final loaded = await container.read(
      aiProcessingConsentControllerProvider.future,
    );

    expect(loaded.status, AiProcessingConsentStatus.unknown);
  });

  test('records an affirmative grant', () async {
    final repository = _FakeAiProcessingConsentRepository(consent: unknown);
    final container = _container(repository);

    await container
        .read(aiProcessingConsentControllerProvider.notifier)
        .grant();

    expect(repository.lastSaved, AiProcessingConsentStatus.granted);
    expect(
      container.read(aiProcessingConsentControllerProvider).requireValue.status,
      AiProcessingConsentStatus.granted,
    );
  });

  test('records a decline', () async {
    final repository = _FakeAiProcessingConsentRepository(consent: unknown);
    final container = _container(repository);

    await container
        .read(aiProcessingConsentControllerProvider.notifier)
        .decline();

    expect(repository.lastSaved, AiProcessingConsentStatus.declined);
    expect(
      container.read(aiProcessingConsentControllerProvider).requireValue.status,
      AiProcessingConsentStatus.declined,
    );
  });

  test('surfaces a typed persistence failure', () async {
    final container = _container(
      _FakeAiProcessingConsentRepository(
        consent: unknown,
        saveError: const LocalPersistenceFailure.writeFailed(),
      ),
    );

    await container
        .read(aiProcessingConsentControllerProvider.notifier)
        .grant();

    expect(
      container.read(aiProcessingConsentControllerProvider).error,
      const LocalPersistenceFailure.writeFailed(),
    );
  });
}
