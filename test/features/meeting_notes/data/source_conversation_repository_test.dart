import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';
import 'package:quorivell/features/meeting_notes/data/datasources/source_conversation_local_data_source.dart';
import 'package:quorivell/features/meeting_notes/data/repositories/source_conversation_repository_impl.dart';

void main() {
  late AppDatabase database;
  late SourceConversationRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = SourceConversationRepositoryImpl(
      localDataSource: DriftSourceConversationLocalDataSource(database),
      localUserScopeRepository: LocalUserScopeRepositoryImpl(
        DriftLocalUserScopeLocalDataSource(database),
      ),
      now: () => DateTime.utc(2026, 9, 7, 12),
    );
  });

  tearDown(() => database.close());

  test(
    'captures trimmed source text with local scope and revision one',
    () async {
      final captured = await repository.capture('  Synthetic conversation.  ');
      final rows = await database.select(database.sourceConversations).get();

      expect(captured.id, matches(RegExp(r'^[0-9a-f-]{36}$')));
      expect(captured.userId, isNotEmpty);
      expect(captured.content, 'Synthetic conversation.');
      expect(captured.sourceRevision, 1);
      expect(rows, hasLength(1));
      expect(rows.single.id, captured.id);
      expect(rows.single.userId, captured.userId);
      expect(rows.single.content, captured.content);
      expect(rows.single.sourceRevision, 1);
    },
  );

  test('rejects empty source text with a typed failure', () async {
    await expectLater(
      repository.capture('  '),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
    expect(await database.select(database.sourceConversations).get(), isEmpty);
  });

  test('watchAll emits captured conversations newest first', () async {
    var tick = 0;
    final incrementing = SourceConversationRepositoryImpl(
      localDataSource: DriftSourceConversationLocalDataSource(database),
      localUserScopeRepository: LocalUserScopeRepositoryImpl(
        DriftLocalUserScopeLocalDataSource(database),
      ),
      now: () => DateTime.utc(2026, 9, 7, 12, 0, tick++),
    );
    final first = await incrementing.capture('First conversation.');
    final second = await incrementing.capture('Second conversation.');

    final emitted = await incrementing.watchAll().first;

    expect(emitted.map((c) => c.id), [second.id, first.id]);
  });

  test('watchAll is bounded by limit and offset', () async {
    var tick = 0;
    final incrementing = SourceConversationRepositoryImpl(
      localDataSource: DriftSourceConversationLocalDataSource(database),
      localUserScopeRepository: LocalUserScopeRepositoryImpl(
        DriftLocalUserScopeLocalDataSource(database),
      ),
      now: () => DateTime.utc(2026, 9, 7, 12, 0, tick++),
    );
    final first = await incrementing.capture('First conversation.');
    final second = await incrementing.capture('Second conversation.');

    expect((await incrementing.watchAll(limit: 1).first).map((c) => c.id), [
      second.id,
    ]);
    expect(
      (await incrementing.watchAll(limit: 1, offset: 1).first).map((c) => c.id),
      [first.id],
    );
  });

  test('find returns a captured conversation by id', () async {
    final captured = await repository.capture('Synthetic conversation.');

    final found = await repository.find(captured.id);

    expect(found?.id, captured.id);
    expect(found?.content, 'Synthetic conversation.');
  });

  test('find returns null for an unknown id', () async {
    expect(await repository.find('missing-id'), isNull);
  });

  test('delete soft-deletes a conversation so it leaves history', () async {
    final captured = await repository.capture('Synthetic conversation.');

    await repository.delete(captured.id);

    final rows = await database.select(database.sourceConversations).get();
    expect(rows, hasLength(1));
    expect(rows.single.isDeleted, isTrue);
    expect(await repository.find(captured.id), isNull);
    expect(await repository.watchAll().first, isEmpty);
  });

  test('archive hides a conversation from active history and latest', () async {
    final active = await repository.capture('Active conversation.');
    final toArchive = await repository.capture('Used for extraction.');

    await repository.archive(toArchive.id);

    final activeList = await repository.watchAll().first;
    final archivedList = await repository.watchAll(archivedOnly: true).first;
    final latest = await repository.latest();
    final found = await repository.find(toArchive.id);

    expect(activeList.map((c) => c.id), [active.id]);
    expect(archivedList.map((c) => c.id), [toArchive.id]);
    expect(archivedList.single.isArchived, isTrue);
    expect(latest?.id, active.id);
    expect(found?.isArchived, isTrue);
  });

  test('unarchive restores a conversation to active history', () async {
    final captured = await repository.capture('Will archive then restore.');
    await repository.archive(captured.id);
    expect(await repository.latest(), isNull);

    await repository.unarchive(captured.id);

    final active = await repository.watchAll().first;
    expect(active.map((c) => c.id), [captured.id]);
    expect(active.single.isArchived, isFalse);
    expect((await repository.latest())?.id, captured.id);
    expect(await repository.watchAll(archivedOnly: true).first, isEmpty);
  });

  test('latest is null when only archived conversations remain', () async {
    final captured = await repository.capture('Only capture.');
    await repository.archive(captured.id);

    expect(await repository.latest(), isNull);
    expect(await repository.watchAll().first, isEmpty);
    expect(await repository.watchAll(archivedOnly: true).first, hasLength(1));
  });

  test('listActive returns active captures in the requested order', () async {
    var tick = 0;
    final incrementing = SourceConversationRepositoryImpl(
      localDataSource: DriftSourceConversationLocalDataSource(database),
      localUserScopeRepository: LocalUserScopeRepositoryImpl(
        DriftLocalUserScopeLocalDataSource(database),
      ),
      now: () => DateTime.utc(2026, 9, 7, 12, 0, tick++),
    );
    final first = await incrementing.capture('First conversation.');
    final second = await incrementing.capture('Second conversation.');
    await incrementing.archive(first.id);

    final newestFirst = await incrementing.listActive();
    final oldestFirst = await incrementing.listActive(newestFirst: false);

    expect(newestFirst.map((c) => c.id), [second.id]);
    expect(oldestFirst.map((c) => c.id), [second.id]);

    final third = await incrementing.capture('Third conversation.');
    expect((await incrementing.listActive()).map((c) => c.id), [
      third.id,
      second.id,
    ]);
    expect(
      (await incrementing.listActive(newestFirst: false)).map((c) => c.id),
      [second.id, third.id],
    );
  });
}
