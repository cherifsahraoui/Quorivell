import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('LocalUserScopeRow')
class LocalUserScopes extends Table {
  TextColumn get id => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SourceConversationRow')
class SourceConversations extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get content => text()();

  /// Original http(s) page when Capture fetched webpage text; null for paste.
  TextColumn get sourceUrl => text().nullable()();
  IntColumn get sourceRevision => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LedgerItemRow')
class LedgerItems extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get kind => text()();
  TextColumn get statement => text()();
  TextColumn get status => text()();
  TextColumn get owner => text().nullable()();
  IntColumn get dueDate => integer().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get kindDisplayNameSnapshot =>
      text().withDefault(const Constant(''))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EvidenceRow')
class Evidence extends Table {
  TextColumn get id => text()();
  TextColumn get ledgerItemId => text()();
  TextColumn get sourceConversationId => text()();
  IntColumn get sourceRevision => integer()();
  IntColumn get quoteStart => integer()();
  IntColumn get quoteEnd => integer()();
  TextColumn get quoteSnippet => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AiProcessingConsentRow')
class AiProcessingConsents extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().withDefault(const Constant(''))();
  TextColumn get status => text()();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('UserPreferenceRow')
class UserPreferences extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get themeMode => text()();
  TextColumn get localePreference =>
      text().withDefault(const Constant('system'))();
  BoolColumn get debugModeEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get chatSystemPromptOverride => text().nullable()();
  TextColumn get extractionPromptOverride => text().nullable()();
  TextColumn get extractionSystemPromptOverride => text().nullable()();
  BoolColumn get extractionKindsIntroDismissed =>
      boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ExtractionCandidateRow')
class ExtractionCandidates extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sourceConversationId => text()();
  IntColumn get sourceRevision => integer()();
  TextColumn get kind => text()();
  TextColumn get statement => text()();
  TextColumn get owner => text().nullable()();
  IntColumn get dueDate => integer().nullable()();
  IntColumn get quoteStart => integer()();
  IntColumn get quoteEnd => integer()();
  TextColumn get quoteSnippet => text()();
  TextColumn get note => text().nullable()();
  TextColumn get reviewStatus =>
      text().withDefault(const Constant('pending'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ChatThreadRow')
class ChatThreads extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get modelId => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ChatMessageRow')
class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get threadId => text()();
  TextColumn get role => text()();
  TextColumn get content => text()();
  TextColumn get status => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Device-local in-flight extraction checkpoint. Not a Firestore mirror.
@DataClassName('ExtractionJobRow')
class ExtractionJobs extends Table {
  TextColumn get id => text()();
  TextColumn get sourceConversationId => text()();
  IntColumn get sourceRevision => integer().withDefault(const Constant(1))();
  IntColumn get completedChunkCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalChunks => integer().withDefault(const Constant(0))();
  IntColumn get candidatesFound => integer().withDefault(const Constant(0))();
  IntColumn get startTimeMs => integer()();
  TextColumn get chunkTimingsJson => text().withDefault(const Constant('[]'))();
  TextColumn get progressTitle => text().withDefault(const Constant(''))();
  TextColumn get progressBody => text().withDefault(const Constant(''))();
  TextColumn get completionTitle => text().withDefault(const Constant(''))();
  TextColumn get queuedSourceConversationIdsJson =>
      text().withDefault(const Constant('[]'))();
  IntColumn get batchIndex => integer().withDefault(const Constant(0))();
  IntColumn get batchTotal => integer().withDefault(const Constant(1))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Extraction run history (mirrorable, Firestore contract).
@DataClassName('ExtractionRunRow')
class ExtractionRuns extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sourceConversationId => text().nullable()();
  TextColumn get sourceConversationTitle => text().nullable()();
  TextColumn get modelId => text()();
  TextColumn get modelDisplayName => text().nullable()();
  IntColumn get startedAt => integer()();
  IntColumn get completedAt => integer()();
  TextColumn get status => text()();
  IntColumn get durationMs => integer()();
  TextColumn get enabledKindSlugsJson =>
      text().withDefault(const Constant('["decision","commitment"]'))();
  TextColumn get kindCountsJson => text().withDefault(const Constant('{}'))();
  IntColumn get acceptedCount => integer().withDefault(const Constant(0))();
  IntColumn get rejectedCount => integer().withDefault(const Constant(0))();
  IntColumn get pendingCount => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// User-configured extraction kind catalog (mirrorable).
@DataClassName('ExtractionItemKindRow')
class ExtractionItemKinds extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get slug => text()();
  TextColumn get displayName => text()();
  TextColumn get extractionHint => text().nullable()();
  TextColumn get behavior => text()();
  TextColumn get datePolicy => text()();
  TextColumn get notePolicy => text()();
  TextColumn get ownerPolicy => text()();
  BoolColumn get enabledForExtraction =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get teachingExamplesJson => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    LocalUserScopes,
    SourceConversations,
    LedgerItems,
    Evidence,
    ExtractionCandidates,
    AiProcessingConsents,
    UserPreferences,
    ChatThreads,
    ChatMessages,
    ExtractionJobs,
    ExtractionRuns,
    ExtractionItemKinds,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Canonical local SQLite file in application documents.
  ///
  /// Runs SQLite on the UI isolate. A Drift background worker is paused by
  /// the debugger when llama.cpp spawns its isolate after save, then the
  /// process dies under native load.
  factory AppDatabase.open() =>
      AppDatabase(LazyDatabase(_openOnCurrentIsolate));

  static Future<QueryExecutor> _openOnCurrentIsolate() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}quorivell_local.sqlite',
    );
    return NativeDatabase(file);
  }

  @override
  int get schemaVersion => 12;

  /// Permanently removes user content while keeping device-local identity,
  /// preferences, AI-processing consent, and the extraction kind catalog.
  ///
  /// Intended for the debug Account "Clear app data" control. Does not touch
  /// SharedPreferences, onboarding flags, or on-device GGUF files. Kinds stay
  /// so clearing content does not destroy the daily catalog.
  Future<void> clearUserContent() {
    return transaction(() async {
      await delete(chatMessages).go();
      await delete(chatThreads).go();
      await delete(evidence).go();
      await delete(extractionCandidates).go();
      await delete(extractionJobs).go();
      await delete(extractionRuns).go();
      await delete(ledgerItems).go();
      await delete(sourceConversations).go();
    });
  }

  /// Seeds Decision and Commitment when missing. Safe to call on every open.
  Future<void> seedBuiltInExtractionKinds({String userId = ''}) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    var resolvedUserId = userId;
    if (resolvedUserId.isEmpty) {
      final scoped = await customSelect(
        'SELECT id FROM local_user_scopes LIMIT 1',
      ).getSingleOrNull();
      resolvedUserId = scoped?.data['id'] as String? ?? '';
    }

    await into(extractionItemKinds).insert(
      ExtractionItemKindsCompanion.insert(
        id: 'decision',
        userId: resolvedUserId,
        slug: 'decision',
        displayName: 'Decision',
        behavior: 'record',
        datePolicy: 'none',
        notePolicy: 'optional',
        ownerPolicy: 'optional',
        enabledForExtraction: const Value(true),
        isBuiltIn: const Value(true),
        sortOrder: const Value(0),
        createdAt: now,
        updatedAt: now,
      ),
      mode: InsertMode.insertOrIgnore,
    );
    await into(extractionItemKinds).insert(
      ExtractionItemKindsCompanion.insert(
        id: 'commitment',
        userId: resolvedUserId,
        slug: 'commitment',
        displayName: 'Commitment',
        behavior: 'completable',
        datePolicy: 'optional',
        notePolicy: 'optional',
        ownerPolicy: 'optional',
        enabledForExtraction: const Value(true),
        isBuiltIn: const Value(true),
        sortOrder: const Value(1),
        createdAt: now,
        updatedAt: now,
      ),
      mode: InsertMode.insertOrIgnore,
    );

    if (resolvedUserId.isNotEmpty) {
      await (update(extractionItemKinds)
            ..where((row) => row.userId.equals(''))
            ..where((row) => row.isBuiltIn.equals(true)))
          .write(ExtractionItemKindsCompanion(userId: Value(resolvedUserId)));
    }
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await seedBuiltInExtractionKinds();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(aiProcessingConsents);
      }
      if (from < 3) {
        await m.addColumn(sourceConversations, sourceConversations.isArchived);
      }
      if (from < 4) {
        await m.createTable(chatThreads);
        await m.createTable(chatMessages);
      }
      if (from < 5) {
        await m.addColumn(aiProcessingConsents, aiProcessingConsents.userId);
        await m.addColumn(aiProcessingConsents, aiProcessingConsents.createdAt);
        await m.addColumn(aiProcessingConsents, aiProcessingConsents.isDeleted);
        await m.addColumn(
          aiProcessingConsents,
          aiProcessingConsents.syncStatus,
        );
        await customStatement('''
UPDATE ai_processing_consents
SET created_at = updated_at
WHERE created_at = 0
''');
        await customStatement('''
UPDATE ai_processing_consents
SET user_id = (SELECT id FROM local_user_scopes LIMIT 1)
WHERE user_id = '' AND EXISTS (SELECT 1 FROM local_user_scopes)
''');
        await m.createTable(userPreferences);
      }
      if (from < 6) {
        await m.addColumn(userPreferences, userPreferences.localePreference);
      }
      if (from < 7) {
        await m.createTable(extractionJobs);
      }
      if (from < 8) {
        await m.addColumn(
          extractionJobs,
          extractionJobs.queuedSourceConversationIdsJson,
        );
        await m.addColumn(extractionJobs, extractionJobs.batchIndex);
        await m.addColumn(extractionJobs, extractionJobs.batchTotal);
      }
      if (from < 9) {
        await m.createTable(extractionRuns);
      }
      if (from < 10) {
        await m.addColumn(userPreferences, userPreferences.debugModeEnabled);
        await m.addColumn(
          userPreferences,
          userPreferences.chatSystemPromptOverride,
        );
        await m.addColumn(
          userPreferences,
          userPreferences.extractionPromptOverride,
        );
        await m.addColumn(
          userPreferences,
          userPreferences.extractionSystemPromptOverride,
        );
      }
      if (from < 11) {
        await m.createTable(extractionItemKinds);
        await m.addColumn(ledgerItems, ledgerItems.note);
        await m.addColumn(ledgerItems, ledgerItems.kindDisplayNameSnapshot);
        await m.addColumn(extractionCandidates, extractionCandidates.note);
        await m.addColumn(
          userPreferences,
          userPreferences.extractionKindsIntroDismissed,
        );
        if (from >= 9) {
          await m.addColumn(
            extractionRuns,
            extractionRuns.enabledKindSlugsJson,
          );
          await m.addColumn(extractionRuns, extractionRuns.kindCountsJson);
          await customStatement('''
UPDATE extraction_runs
SET enabled_kind_slugs_json = '["decision","commitment"]',
    kind_counts_json = '{"decision":' || decision_count || ',"commitment":' || commitment_count || '}'
''');
          await customStatement(
            'ALTER TABLE extraction_runs DROP COLUMN decision_count',
          );
          await customStatement(
            'ALTER TABLE extraction_runs DROP COLUMN commitment_count',
          );
        }
        await customStatement('''
UPDATE ledger_items
SET kind_display_name_snapshot = CASE kind
  WHEN 'decision' THEN 'Decision'
  WHEN 'commitment' THEN 'Commitment'
  ELSE kind
END
WHERE kind_display_name_snapshot IS NULL OR kind_display_name_snapshot = ''
''');
        await seedBuiltInExtractionKinds();
      }
      if (from < 12) {
        await m.addColumn(sourceConversations, sourceConversations.sourceUrl);
      }
    },
  );
}
