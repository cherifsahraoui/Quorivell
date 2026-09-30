import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';
import 'package:quorivell/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:quorivell/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:quorivell/features/chat/domain/entities/ai_chat_message.dart';

void main() {
  late AppDatabase database;
  late ChatRepositoryImpl repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final userScope = LocalUserScopeRepositoryImpl(
      DriftLocalUserScopeLocalDataSource(database),
    );
    repository = ChatRepositoryImpl(
      localDataSource: DriftChatLocalDataSource(database),
      userScopeRepository: userScope,
      now: () => DateTime.utc(2026, 9, 11),
    );
  });

  tearDown(() => database.close());

  test('creates a thread, appends turns, and watches them', () async {
    final thread = await repository.createThread(
      title: '  synthetic fixture chat  ',
      modelId: 'test-model',
    );

    expect(thread.title, 'synthetic fixture chat');
    expect(thread.modelId, 'test-model');

    await repository.appendMessage(
      threadId: thread.id,
      role: AiChatRole.user,
      content: '  Hello model.  ',
      status: AiChatMessageStatus.complete,
    );
    await repository.appendMessage(
      threadId: thread.id,
      role: AiChatRole.assistant,
      content: 'Hello from the model.',
      status: AiChatMessageStatus.complete,
    );

    final threads = await repository.watchThreads().first;
    final messages = await repository.listMessages(thread.id);

    expect(threads.map((item) => item.id), [thread.id]);
    expect(messages.map((item) => item.role), [
      AiChatRole.user,
      AiChatRole.assistant,
    ]);
    expect(messages.first.content, 'Hello model.');
  });

  test(
    'updates the thread model when a new user message records one',
    () async {
      final thread = await repository.createThread(
        title: 'synthetic fixture chat',
        modelId: 'old-model',
      );

      await repository.appendMessage(
        threadId: thread.id,
        role: AiChatRole.user,
        content: 'Hello with a new model.',
        status: AiChatMessageStatus.complete,
        modelId: 'new-model',
      );

      final updated = await repository.watchThread(thread.id).first;
      expect(updated?.modelId, 'new-model');
    },
  );

  test('updateThreadModelId rewrites the recorded model', () async {
    final thread = await repository.createThread(
      title: 'synthetic fixture chat',
      modelId: 'old-model',
    );

    await repository.updateThreadModelId(
      threadId: thread.id,
      modelId: 'retry-model',
    );

    final updated = await repository.watchThread(thread.id).first;
    expect(updated?.modelId, 'retry-model');
  });

  test('soft-deletes a thread and hides its messages', () async {
    final thread = await repository.createThread(title: 'synthetic fixture');
    await repository.appendMessage(
      threadId: thread.id,
      role: AiChatRole.user,
      content: 'Hello model.',
      status: AiChatMessageStatus.complete,
    );

    await repository.deleteThread(thread.id);

    expect(await repository.watchThreads().first, isEmpty);
    expect(await repository.listMessages(thread.id), isEmpty);
  });

  test('rejects an empty title', () async {
    await expectLater(
      repository.createThread(title: '   '),
      throwsA(isA<LocalPersistenceInvalidInputFailure>()),
    );
  });
}
