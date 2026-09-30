import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/meeting_notes/data/providers/source_conversation_providers.dart';
import 'package:quorivell/features/meeting_notes/domain/entities/source_conversation.dart';
import 'package:quorivell/features/meeting_notes/domain/repositories/source_conversation_repository.dart';
import 'package:quorivell/features/meeting_notes/presentation/controllers/capture_controller.dart';

class _FakeSourceConversationRepository
    implements SourceConversationRepository {
  _FakeSourceConversationRepository({this.failure});

  final Object? failure;

  @override
  Future<SourceConversation> capture(String content) async {
    if (failure != null) throw failure!;
    return SourceConversation(
      id: 'source-id',
      userId: 'user-id',
      content: content.trim(),
      sourceRevision: 1,
      createdAt: DateTime.utc(2026, 9, 7),
      updatedAt: DateTime.utc(2026, 9, 7),
    );
  }

  @override
  Future<SourceConversation?> latest() async => null;

  @override
  Future<List<SourceConversation>> listActive({
    int? limit,
    bool newestFirst = true,
  }) async => const [];

  @override
  Stream<List<SourceConversation>> watchAll({
    int limit = 50,
    int offset = 0,
    bool archivedOnly = false,
  }) => const Stream.empty();

  @override
  Future<SourceConversation?> find(String id) async => null;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> archive(String id) async {}

  @override
  Future<void> unarchive(String id) async {}
}

ProviderContainer _container({
  required SourceConversationRepository conversations,
}) {
  return ProviderContainer.test(
    overrides: [
      sourceConversationRepositoryProvider.overrideWithValue(conversations),
    ],
  );
}

void main() {
  test('captures the conversation without extracting', () async {
    final container = _container(
      conversations: _FakeSourceConversationRepository(),
    );
    addTearDown(container.dispose);
    final subscription = container.listen(captureControllerProvider, (_, _) {});
    addTearDown(subscription.close);

    await container
        .read(captureControllerProvider.notifier)
        .capture('Alex will send the checklist.');

    expect(container.read(captureControllerProvider).hasValue, isTrue);
    expect(
      container.read(captureControllerProvider).requireValue?.id,
      'source-id',
    );
  });

  test('reports a typed persistence failure', () async {
    final container = _container(
      conversations: _FakeSourceConversationRepository(
        failure: const LocalPersistenceFailure.invalidInput(),
      ),
    );
    addTearDown(container.dispose);
    final subscription = container.listen(captureControllerProvider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(captureControllerProvider.notifier).capture('  ');

    expect(
      container.read(captureControllerProvider).error,
      const LocalPersistenceFailure.invalidInput(),
    );
  });
}
