import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/app_database.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/auth/data/datasources/local_user_scope_local_data_source.dart';
import 'package:quorivell/features/auth/data/repositories/local_user_scope_repository_impl.dart';
import 'package:quorivell/features/extraction_kinds/data/datasources/extraction_item_kind_local_data_source.dart';
import 'package:quorivell/features/extraction_kinds/data/repositories/extraction_item_kind_repository_impl.dart';
import 'package:quorivell/features/extraction_kinds/domain/entities/extraction_item_kind.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';

void main() {
  late AppDatabase database;
  late ExtractionItemKindRepositoryImpl repository;
  late String userId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final userScope = LocalUserScopeRepositoryImpl(
      DriftLocalUserScopeLocalDataSource(database),
    );
    userId = (await userScope.getOrCreate()).id;
    repository = ExtractionItemKindRepositoryImpl(
      localDataSource: DriftExtractionItemKindLocalDataSource(database),
      userScopeRepository: userScope,
      database: database,
      now: () => DateTime.utc(2026, 9, 21),
    );
  });

  tearDown(() => database.close());

  test(
    'seeds built-in kinds and round-trips a custom groceries kind',
    () async {
      final seeded = await repository.listAll();
      expect(seeded.map((kind) => kind.slug), ['decision', 'commitment']);

      final groceries = await repository.create(
        displayName: 'Groceries',
        extractionHint: 'Things we need to buy.',
        behavior: ExtractionKindBehavior.completable,
        datePolicy: ExtractionKindFieldPolicy.optional,
        notePolicy: ExtractionKindFieldPolicy.optional,
        ownerPolicy: ExtractionKindFieldPolicy.none,
        enabledForExtraction: true,
      );

      expect(groceries.slug, 'groceries');
      expect(groceries.userId, userId);
      expect(groceries.isBuiltIn, isFalse);
      expect(
        (await repository.listAll()).map((kind) => kind.slug),
        containsAll(['decision', 'commitment', 'groceries']),
      );
    },
  );

  test('refuses a second groceries kind with the same slug', () async {
    await repository.create(
      displayName: 'Groceries',
      behavior: ExtractionKindBehavior.completable,
      datePolicy: ExtractionKindFieldPolicy.optional,
      notePolicy: ExtractionKindFieldPolicy.optional,
      ownerPolicy: ExtractionKindFieldPolicy.none,
      enabledForExtraction: true,
    );

    await expectLater(
      repository.create(
        displayName: 'Groceries',
        behavior: ExtractionKindBehavior.completable,
        datePolicy: ExtractionKindFieldPolicy.optional,
        notePolicy: ExtractionKindFieldPolicy.optional,
        ownerPolicy: ExtractionKindFieldPolicy.none,
        enabledForExtraction: false,
      ),
      throwsA(const LocalPersistenceFailure.alreadyExists()),
    );
  });

  test('refuses creating a reserved built-in slug', () async {
    await expectLater(
      repository.create(
        displayName: 'Decision',
        behavior: ExtractionKindBehavior.record,
        datePolicy: ExtractionKindFieldPolicy.none,
        notePolicy: ExtractionKindFieldPolicy.optional,
        ownerPolicy: ExtractionKindFieldPolicy.optional,
        enabledForExtraction: false,
      ),
      throwsA(const LocalPersistenceFailure.alreadyExists()),
    );
  });

  test('refuses disabling the last enabled kind', () async {
    final seeded = await repository.listAll();
    await repository.setEnabled(id: seeded.first.id, enabled: false);
    await expectLater(
      repository.setEnabled(id: seeded.last.id, enabled: false),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
  });

  test('refuses deleting a built-in kind', () async {
    await expectLater(
      repository.archive('decision'),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
  });

  test('refuses archiving a slug that still has a ledger row', () async {
    final groceries = await repository.create(
      displayName: 'Gro maries',
      behavior: ExtractionKindBehavior.completable,
      datePolicy: ExtractionKindFieldPolicy.optional,
      notePolicy: ExtractionKindFieldPolicy.optional,
      ownerPolicy: ExtractionKindFieldPolicy.none,
      enabledForExtraction: false,
      slug: 'groceries',
    );
    await database
        .into(database.ledgerItems)
        .insert(
          LedgerItemsCompanion.insert(
            id: 'ledger-g',
            userId: userId,
            kind: 'groceries',
            statement: 'Buy milk.',
            status: LedgerItemStatus.open.name,
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    await expectLater(
      repository.archive(groceries.id),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
  });

  test('rejects a fourth teaching example', () async {
    final examples = [
      for (var i = 0; i < 4; i++)
        ExtractionTeachingExample(
          sourceExcerpt: 'Please pick up milk $i.',
          quoteSnippet: 'Please pick up milk $i.',
          statement: 'Buy milk $i.',
        ),
    ];

    await expectLater(
      repository.create(
        displayName: 'Follow up',
        behavior: ExtractionKindBehavior.completable,
        datePolicy: ExtractionKindFieldPolicy.optional,
        notePolicy: ExtractionKindFieldPolicy.optional,
        ownerPolicy: ExtractionKindFieldPolicy.optional,
        enabledForExtraction: true,
        teachingExamples: examples,
      ),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
  });

  test('round-trips teaching examples on create and update', () async {
    final created = await repository.create(
      displayName: 'Names',
      extractionHint: 'Extract person names like Alice or Thomas.',
      behavior: ExtractionKindBehavior.record,
      datePolicy: ExtractionKindFieldPolicy.none,
      notePolicy: ExtractionKindFieldPolicy.optional,
      ownerPolicy: ExtractionKindFieldPolicy.optional,
      enabledForExtraction: true,
      teachingExamples: const [
        ExtractionTeachingExample(
          sourceExcerpt: 'Emila did pick up her child Manolis from school.',
          quoteSnippet: 'Emila did pick up her child Manolis',
          statement: 'Emila and Manolis are named.',
        ),
      ],
    );

    expect(created.teachingExamples, hasLength(1));
    expect(
      created.teachingExamples.single.statement,
      'Emila and Manolis are named.',
    );

    final listed = await repository.listAll();
    final reloaded = listed.firstWhere((kind) => kind.id == created.id);
    expect(reloaded.teachingExamples, hasLength(1));
    expect(
      reloaded.teachingExamples.single.sourceExcerpt,
      'Emila did pick up her child Manolis from school.',
    );

    final updated = await repository.update(
      reloaded.copyWith(
        teachingExamples: const [
          ExtractionTeachingExample(
            sourceExcerpt: 'Alice met Thomas at the park.',
            quoteSnippet: 'Alice met Thomas',
            statement: 'Alice and Thomas are named.',
          ),
        ],
      ),
    );
    expect(
      updated.teachingExamples.single.statement,
      'Alice and Thomas are named.',
    );
    final again = (await repository.listAll()).firstWhere(
      (kind) => kind.id == created.id,
    );
    expect(again.teachingExamples.single.quoteSnippet, 'Alice met Thomas');
  });

  test('template slug groceries survives localized display names', () async {
    final german = await repository.create(
      displayName: 'Einkauf',
      extractionHint: 'Things we need to buy',
      behavior: ExtractionKindBehavior.completable,
      datePolicy: ExtractionKindFieldPolicy.optional,
      notePolicy: ExtractionKindFieldPolicy.optional,
      ownerPolicy: ExtractionKindFieldPolicy.none,
      enabledForExtraction: true,
      slug: 'groceries',
    );
    expect(german.slug, 'groceries');
    expect(german.displayName, 'Einkauf');
  });

  test('template slug fails create when Arabic name has no slug', () async {
    await expectLater(
      repository.create(
        displayName: 'مشتريات',
        behavior: ExtractionKindBehavior.completable,
        datePolicy: ExtractionKindFieldPolicy.optional,
        notePolicy: ExtractionKindFieldPolicy.optional,
        ownerPolicy: ExtractionKindFieldPolicy.none,
        enabledForExtraction: true,
      ),
      throwsA(const LocalPersistenceFailure.invalidInput()),
    );
    final fixed = await repository.create(
      displayName: 'مشتريات',
      behavior: ExtractionKindBehavior.completable,
      datePolicy: ExtractionKindFieldPolicy.optional,
      notePolicy: ExtractionKindFieldPolicy.optional,
      ownerPolicy: ExtractionKindFieldPolicy.none,
      enabledForExtraction: true,
      slug: 'groceries',
    );
    expect(fixed.slug, 'groceries');
  });

  test('reset built-ins leaves a user groceries kind in place', () async {
    await repository.create(
      displayName: 'Groceries',
      behavior: ExtractionKindBehavior.completable,
      datePolicy: ExtractionKindFieldPolicy.optional,
      notePolicy: ExtractionKindFieldPolicy.optional,
      ownerPolicy: ExtractionKindFieldPolicy.none,
      enabledForExtraction: true,
    );
    await repository.update(
      (await repository.listAll())
          .firstWhere((kind) => kind.slug == 'decision')
          .copyWith(
            displayName: 'Renamed decision',
            extractionHint: 'custom hint',
          ),
    );

    await repository.resetBuiltIns();
    final kinds = await repository.listAll();
    expect(kinds.map((kind) => kind.slug), contains('groceries'));
    final decision = kinds.firstWhere((kind) => kind.slug == 'decision');
    expect(decision.displayName, 'Decision');
    expect(decision.extractionHint, contains('officially decided'));
  });
}
