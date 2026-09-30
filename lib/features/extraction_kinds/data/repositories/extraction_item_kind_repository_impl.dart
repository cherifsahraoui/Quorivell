import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../../core/ai/extraction_kind_slugs.dart';
import '../../../../core/ai/extraction_prompt_sanitizer.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/local_persistence_guard.dart';
import '../../../auth/domain/repositories/local_user_scope_repository.dart';
import '../../domain/entities/extraction_item_kind.dart';
import '../../domain/repositories/extraction_item_kind_repository.dart';
import '../datasources/extraction_item_kind_local_data_source.dart';

class ExtractionItemKindRepositoryImpl implements ExtractionItemKindRepository {
  ExtractionItemKindRepositoryImpl({
    required ExtractionItemKindLocalDataSource localDataSource,
    required LocalUserScopeRepository userScopeRepository,
    required AppDatabase database,
    Uuid? uuid,
    DateTime Function()? now,
  }) : _localDataSource = localDataSource,
       _userScopeRepository = userScopeRepository,
       _database = database,
       _uuid = uuid ?? const Uuid(),
       _now = now ?? (() => DateTime.now().toUtc());

  final ExtractionItemKindLocalDataSource _localDataSource;
  final LocalUserScopeRepository _userScopeRepository;
  final AppDatabase _database;
  final Uuid _uuid;
  final DateTime Function() _now;

  Future<String> _ensureUser() async {
    final user = await _userScopeRepository.getOrCreate();
    await _database.seedBuiltInExtractionKinds(userId: user.id);
    return user.id;
  }

  @override
  Stream<List<ExtractionItemKind>> watchAll({
    int limit = extractionKindPageSize,
    int offset = 0,
  }) {
    return guardLocalStream(() async* {
      final userId = await _ensureUser();
      yield* _localDataSource
          .watchAll(userId: userId, limit: limit, offset: offset)
          .map((rows) => rows.map(_fromRow).toList());
    });
  }

  @override
  Stream<List<ExtractionItemKind>> watchEnabled({
    int limit = extractionKindPageSize,
    int offset = 0,
  }) {
    return guardLocalStream(() async* {
      final userId = await _ensureUser();
      yield* _localDataSource
          .watchAll(
            userId: userId,
            limit: limit,
            offset: offset,
            enabledOnly: true,
          )
          .map((rows) => rows.map(_fromRow).toList());
    });
  }

  @override
  Future<List<ExtractionItemKind>> listAll() {
    return guardLocalRead(() async {
      final userId = await _ensureUser();
      final rows = await _localDataSource.listAll(userId: userId);
      return rows.map(_fromRow).toList();
    });
  }

  @override
  Future<List<ExtractionItemKind>> listEnabled() async {
    final all = await listAll();
    return [
      for (final kind in all)
        if (kind.enabledForExtraction) kind,
    ];
  }

  @override
  Future<ExtractionItemKind> create({
    required String displayName,
    String? extractionHint,
    required ExtractionKindBehavior behavior,
    required ExtractionKindFieldPolicy datePolicy,
    required ExtractionKindFieldPolicy notePolicy,
    required ExtractionKindFieldPolicy ownerPolicy,
    required bool enabledForExtraction,
    List<ExtractionTeachingExample> teachingExamples = const [],
    String? slug,
  }) {
    return guardLocalWrite(() async {
      final userId = await _ensureUser();
      final name = _normalizeDisplayName(displayName);
      final resolvedSlug = _normalizeSlug(
        slug ?? ExtractionKindSlugs.slugFromDisplayName(name),
      );
      if (ExtractionKindSlugs.reserved.contains(resolvedSlug)) {
        throw const LocalPersistenceFailure.alreadyExists();
      }
      final existing = await _localDataSource.findBySlug(
        userId: userId,
        slug: resolvedSlug,
      );
      if (existing != null) {
        throw const LocalPersistenceFailure.alreadyExists();
      }
      final active = await _localDataSource.countActive(userId: userId);
      if (active >= ExtractionKindSlugs.maxCatalogKinds) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      if (enabledForExtraction) {
        final enabled = await _localDataSource.countEnabled(userId: userId);
        if (enabled >= ExtractionKindSlugs.maxEnabledKinds) {
          throw const LocalPersistenceFailure.invalidInput();
        }
      }
      final examples = _normalizeExamples(teachingExamples);
      final timestamp = _now();
      final kind = ExtractionItemKind(
        id: _uuid.v4(),
        userId: userId,
        slug: resolvedSlug,
        displayName: name,
        extractionHint: _normalizeHint(extractionHint),
        behavior: behavior,
        datePolicy: datePolicy,
        notePolicy: notePolicy,
        ownerPolicy: ownerPolicy,
        enabledForExtraction: enabledForExtraction,
        isBuiltIn: false,
        sortOrder: active,
        teachingExamples: examples,
        createdAt: timestamp,
        updatedAt: timestamp,
      );
      await _localDataSource.insert(_toRow(kind));
      return kind;
    });
  }

  @override
  Future<ExtractionItemKind> update(ExtractionItemKind kind) {
    return guardLocalWrite(() async {
      final userId = await _ensureUser();
      final existing = await _localDataSource.findById(
        userId: userId,
        id: kind.id,
      );
      if (existing == null) {
        throw const LocalPersistenceFailure.notFound();
      }
      if (existing.slug != kind.slug || existing.isBuiltIn != kind.isBuiltIn) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      final name = _normalizeDisplayName(kind.displayName);
      final examples = _normalizeExamples(kind.teachingExamples);
      if (kind.enabledForExtraction != existing.enabledForExtraction) {
        await _assertEnableAllowed(
          userId: userId,
          enabling: kind.enabledForExtraction,
        );
      }
      final timestamp = _now();
      final updated = kind.copyWith(
        displayName: name,
        extractionHint: _normalizeHint(kind.extractionHint),
        teachingExamples: examples,
        updatedAt: timestamp,
      );
      await _localDataSource.update(_toRow(updated, existing: existing));
      return updated;
    });
  }

  @override
  Future<void> setEnabled({required String id, required bool enabled}) {
    return guardLocalWrite(() async {
      final userId = await _ensureUser();
      final existing = await _localDataSource.findById(userId: userId, id: id);
      if (existing == null) {
        throw const LocalPersistenceFailure.notFound();
      }
      if (existing.enabledForExtraction == enabled) {
        return;
      }
      await _assertEnableAllowed(userId: userId, enabling: enabled);
      final timestamp = _now();
      await _localDataSource.update(
        existing.copyWith(
          enabledForExtraction: enabled,
          updatedAt: timestamp.millisecondsSinceEpoch,
          syncStatus: 0,
        ),
      );
    });
  }

  @override
  Future<void> archive(String id) {
    return guardLocalWrite(() async {
      final userId = await _ensureUser();
      final existing = await _localDataSource.findById(userId: userId, id: id);
      if (existing == null) {
        throw const LocalPersistenceFailure.notFound();
      }
      if (existing.isBuiltIn) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      final ledgerCount = await _localDataSource.countLedgerBySlug(
        userId: userId,
        slug: existing.slug,
      );
      final pendingCount = await _localDataSource.countPendingCandidatesBySlug(
        userId: userId,
        slug: existing.slug,
      );
      if (ledgerCount > 0 || pendingCount > 0) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      if (existing.enabledForExtraction) {
        await _assertEnableAllowed(userId: userId, enabling: false);
      }
      final timestamp = _now();
      await _localDataSource.update(
        existing.copyWith(
          isDeleted: true,
          enabledForExtraction: false,
          updatedAt: timestamp.millisecondsSinceEpoch,
          syncStatus: 0,
        ),
      );
    });
  }

  @override
  Future<void> resetBuiltIns() {
    return guardLocalWrite(() async {
      final userId = await _ensureUser();
      await _resetBuiltIn(
        userId: userId,
        id: ExtractionKindSlugs.decision,
        displayName: 'Decision',
        hint:
            'Group or product direction is locked. Cues: officially decided, '
            'decision made, moving forward with. Prefer the FINAL locked choice.',
        behavior: ExtractionKindBehavior.record,
        datePolicy: ExtractionKindFieldPolicy.none,
      );
      await _resetBuiltIn(
        userId: userId,
        id: ExtractionKindSlugs.commitment,
        displayName: 'Commitment',
        hint:
            'Named person accepts work. Cues: explicitly committed, will '
            "deliver, I'll have, I will.",
        behavior: ExtractionKindBehavior.completable,
        datePolicy: ExtractionKindFieldPolicy.optional,
      );
    });
  }

  Future<void> _resetBuiltIn({
    required String userId,
    required String id,
    required String displayName,
    required String hint,
    required ExtractionKindBehavior behavior,
    required ExtractionKindFieldPolicy datePolicy,
  }) async {
    final existing = await _localDataSource.findById(userId: userId, id: id);
    if (existing == null) {
      return;
    }
    final timestamp = _now();
    await _localDataSource.update(
      existing.copyWith(
        displayName: displayName,
        extractionHint: Value(hint),
        behavior: behavior.name,
        datePolicy: datePolicy.name,
        notePolicy: ExtractionKindFieldPolicy.optional.name,
        ownerPolicy: ExtractionKindFieldPolicy.optional.name,
        teachingExamplesJson: const Value(null),
        updatedAt: timestamp.millisecondsSinceEpoch,
        syncStatus: 0,
      ),
    );
  }

  Future<void> _assertEnableAllowed({
    required String userId,
    required bool enabling,
  }) async {
    final enabled = await _localDataSource.countEnabled(userId: userId);
    if (enabling) {
      if (enabled >= ExtractionKindSlugs.maxEnabledKinds) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      return;
    }
    if (enabled <= ExtractionKindSlugs.minEnabledKinds) {
      throw const LocalPersistenceFailure.invalidInput();
    }
  }

  String _normalizeDisplayName(String value) {
    final name = ExtractionPromptSanitizer.sanitize(
      value,
      maxLength: ExtractionKindSlugs.maxDisplayNameLength,
    );
    if (name.isEmpty) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    return name;
  }

  String? _normalizeHint(String? value) {
    if (value == null) return null;
    final hint = ExtractionPromptSanitizer.sanitize(
      value,
      maxLength: ExtractionKindSlugs.maxHintLength,
    );
    return hint.isEmpty ? null : hint;
  }

  String _normalizeSlug(String raw) {
    final slug = raw.trim().toLowerCase();
    if (!ExtractionKindSlugs.isValidSlug(slug)) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    return slug;
  }

  List<ExtractionTeachingExample> _normalizeExamples(
    List<ExtractionTeachingExample> examples,
  ) {
    if (examples.length > ExtractionKindSlugs.maxTeachingExamples) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    final normalized = <ExtractionTeachingExample>[];
    for (final example in examples) {
      final source = ExtractionPromptSanitizer.sanitize(
        example.sourceExcerpt,
        maxLength: ExtractionKindSlugs.maxExampleFieldLength,
      );
      final quote = ExtractionPromptSanitizer.sanitize(
        example.quoteSnippet,
        maxLength: ExtractionKindSlugs.maxExampleFieldLength,
      );
      final statement = ExtractionPromptSanitizer.sanitize(
        example.statement,
        maxLength: ExtractionKindSlugs.maxExampleFieldLength,
      );
      if (source.isEmpty || quote.isEmpty || statement.isEmpty) {
        throw const LocalPersistenceFailure.invalidInput();
      }
      normalized.add(
        ExtractionTeachingExample(
          sourceExcerpt: source,
          quoteSnippet: quote,
          statement: statement,
        ),
      );
    }
    return normalized;
  }

  ExtractionItemKind _fromRow(ExtractionItemKindRow row) {
    return ExtractionItemKind(
      id: row.id,
      userId: row.userId,
      slug: row.slug,
      displayName: row.displayName,
      extractionHint: row.extractionHint,
      behavior: ExtractionKindBehavior.values.byName(row.behavior),
      datePolicy: ExtractionKindFieldPolicy.values.byName(row.datePolicy),
      notePolicy: ExtractionKindFieldPolicy.values.byName(row.notePolicy),
      ownerPolicy: ExtractionKindFieldPolicy.values.byName(row.ownerPolicy),
      enabledForExtraction: row.enabledForExtraction,
      isBuiltIn: row.isBuiltIn,
      sortOrder: row.sortOrder,
      teachingExamples: _decodeExamples(row.teachingExamplesJson),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row.createdAt,
        isUtc: true,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row.updatedAt,
        isUtc: true,
      ),
      isDeleted: row.isDeleted,
    );
  }

  ExtractionItemKindRow _toRow(
    ExtractionItemKind kind, {
    ExtractionItemKindRow? existing,
  }) {
    return ExtractionItemKindRow(
      id: kind.id,
      userId: kind.userId,
      slug: kind.slug,
      displayName: kind.displayName,
      extractionHint: kind.extractionHint,
      behavior: kind.behavior.name,
      datePolicy: kind.datePolicy.name,
      notePolicy: kind.notePolicy.name,
      ownerPolicy: kind.ownerPolicy.name,
      enabledForExtraction: kind.enabledForExtraction,
      isBuiltIn: kind.isBuiltIn,
      sortOrder: kind.sortOrder,
      teachingExamplesJson: _encodeExamples(kind.teachingExamples),
      createdAt: kind.createdAt.millisecondsSinceEpoch,
      updatedAt: kind.updatedAt.millisecondsSinceEpoch,
      isDeleted: kind.isDeleted,
      syncStatus: 0,
    );
  }

  List<ExtractionTeachingExample> _decodeExamples(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return const [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return [
        for (final item in decoded)
          if (item is Map)
            ExtractionTeachingExample(
              sourceExcerpt: '${item['sourceExcerpt'] ?? ''}',
              quoteSnippet: '${item['quoteSnippet'] ?? ''}',
              statement: '${item['statement'] ?? ''}',
            ),
      ].where((example) {
        return example.sourceExcerpt.trim().isNotEmpty &&
            example.quoteSnippet.trim().isNotEmpty &&
            example.statement.trim().isNotEmpty;
      }).toList();
    } on Object {
      return const [];
    }
  }

  String? _encodeExamples(List<ExtractionTeachingExample> examples) {
    if (examples.isEmpty) return null;
    final encoded = jsonEncode([
      for (final example in examples)
        {
          'sourceExcerpt': example.sourceExcerpt,
          'quoteSnippet': example.quoteSnippet,
          'statement': example.statement,
        },
    ]);
    if (encoded.length > ExtractionKindSlugs.maxTeachingExamplesJsonLength) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    return encoded;
  }
}
