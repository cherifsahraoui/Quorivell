import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';

void main() {
  late AppDatabase database;
  late LocalUserScopeRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = LocalUserScopeRepositoryImpl(
      DriftLocalUserScopeLocalDataSource(database),
    );
  });

  tearDown(() => database.close());

  test('creates one stable local user scope and reuses it', () async {
    final first = await repository.getOrCreate();
    final second = await repository.getOrCreate();

    expect(first.id, matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(second.id, first.id);
    expect(second.createdAt, first.createdAt);
  });

  test('uses schema version 12 for extraction kinds', () {
    expect(database.schemaVersion, 12);
  });

  test('seeds built-in decision and commitment kinds', () async {
    final rows = await database.select(database.extractionItemKinds).get();
    expect(rows.map((row) => row.slug), ['decision', 'commitment']);
    expect(rows.every((row) => row.isBuiltIn), isTrue);
  });

  test('keeps canonical tables available in the local database', () async {
    await database
        .into(database.sourceConversations)
        .insert(
          SourceConversationsCompanion.insert(
            id: 'source-1',
            userId: 'local-user',
            content: 'Synthetic conversation fixture.',
            sourceRevision: 1,
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    await database
        .into(database.ledgerItems)
        .insert(
          LedgerItemsCompanion.insert(
            id: 'ledger-1',
            userId: 'local-user',
            kind: 'commitment',
            statement: 'Synthetic commitment fixture.',
            status: 'open',
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    await database
        .into(database.evidence)
        .insert(
          EvidenceCompanion.insert(
            id: 'evidence-1',
            ledgerItemId: 'ledger-1',
            sourceConversationId: 'source-1',
            sourceRevision: 1,
            quoteStart: 0,
            quoteEnd: 10,
            quoteSnippet: 'Synthetic.',
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    expect(
      await database.select(database.sourceConversations).get(),
      hasLength(1),
    );
    expect(await database.select(database.ledgerItems).get(), hasLength(1));
    expect(await database.select(database.evidence).get(), hasLength(1));

    await database
        .into(database.chatThreads)
        .insert(
          ChatThreadsCompanion.insert(
            id: 'thread-1',
            userId: 'local-user',
            title: 'Synthetic chat fixture.',
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    await database
        .into(database.chatMessages)
        .insert(
          ChatMessagesCompanion.insert(
            id: 'message-1',
            userId: 'local-user',
            threadId: 'thread-1',
            role: 'user',
            content: 'Synthetic chat turn.',
            status: 'complete',
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    expect(await database.select(database.chatThreads).get(), hasLength(1));
    expect(await database.select(database.chatMessages).get(), hasLength(1));

    await database
        .into(database.aiProcessingConsents)
        .insert(
          AiProcessingConsentsCompanion.insert(
            id: 'ai_processing_consent',
            status: 'granted',
            updatedAt: 1,
            userId: const Value('local-user'),
            createdAt: const Value(1),
          ),
        );
    await database
        .into(database.userPreferences)
        .insert(
          UserPreferencesCompanion.insert(
            id: 'app',
            userId: 'local-user',
            themeMode: 'dark',
            localePreference: const Value('ar'),
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    expect(
      await database.select(database.aiProcessingConsents).get(),
      hasLength(1),
    );
    final preferences = await database.select(database.userPreferences).get();
    expect(preferences, hasLength(1));
    expect(preferences.single.debugModeEnabled, isFalse);
    expect(preferences.single.chatSystemPromptOverride, equals(null));
    expect(preferences.single.extractionPromptOverride, equals(null));
    expect(preferences.single.extractionSystemPromptOverride, equals(null));
  });

  test(
    'clearUserContent removes content tables and keeps identity prefs',
    () async {
      await database
          .into(database.localUserScopes)
          .insert(
            LocalUserScopesCompanion.insert(
              id: 'local-user',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await database
          .into(database.sourceConversations)
          .insert(
            SourceConversationsCompanion.insert(
              id: 'source-1',
              userId: 'local-user',
              content: 'Synthetic conversation fixture.',
              sourceRevision: 1,
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await database
          .into(database.ledgerItems)
          .insert(
            LedgerItemsCompanion.insert(
              id: 'ledger-1',
              userId: 'local-user',
              kind: 'commitment',
              statement: 'Synthetic commitment fixture.',
              status: 'open',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await database
          .into(database.evidence)
          .insert(
            EvidenceCompanion.insert(
              id: 'evidence-1',
              ledgerItemId: 'ledger-1',
              sourceConversationId: 'source-1',
              sourceRevision: 1,
              quoteStart: 0,
              quoteEnd: 10,
              quoteSnippet: 'Synthetic.',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await database
          .into(database.extractionCandidates)
          .insert(
            ExtractionCandidatesCompanion.insert(
              id: 'candidate-1',
              userId: 'local-user',
              sourceConversationId: 'source-1',
              sourceRevision: 1,
              kind: 'decision',
              statement: 'Synthetic candidate.',
              quoteStart: 0,
              quoteEnd: 10,
              quoteSnippet: 'Synthetic.',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await database
          .into(database.chatThreads)
          .insert(
            ChatThreadsCompanion.insert(
              id: 'thread-1',
              userId: 'local-user',
              title: 'Synthetic chat fixture.',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await database
          .into(database.chatMessages)
          .insert(
            ChatMessagesCompanion.insert(
              id: 'message-1',
              userId: 'local-user',
              threadId: 'thread-1',
              role: 'user',
              content: 'Synthetic chat turn.',
              status: 'complete',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await database
          .into(database.aiProcessingConsents)
          .insert(
            AiProcessingConsentsCompanion.insert(
              id: 'ai_processing_consent',
              status: 'granted',
              updatedAt: 1,
              userId: const Value('local-user'),
              createdAt: const Value(1),
            ),
          );
      await database
          .into(database.userPreferences)
          .insert(
            UserPreferencesCompanion.insert(
              id: 'app',
              userId: 'local-user',
              themeMode: 'dark',
              createdAt: 1,
              updatedAt: 1,
            ),
          );

      await database.clearUserContent();

      expect(
        await database.select(database.sourceConversations).get(),
        isEmpty,
      );
      expect(await database.select(database.ledgerItems).get(), isEmpty);
      expect(await database.select(database.evidence).get(), isEmpty);
      expect(
        await database.select(database.extractionCandidates).get(),
        isEmpty,
      );
      expect(await database.select(database.chatThreads).get(), isEmpty);
      expect(await database.select(database.chatMessages).get(), isEmpty);
      expect(
        await database.select(database.localUserScopes).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.aiProcessingConsents).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.userPreferences).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.extractionItemKinds).get(),
        hasLength(2),
      );
    },
  );
}
