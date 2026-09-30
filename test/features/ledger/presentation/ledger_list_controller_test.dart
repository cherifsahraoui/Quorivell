import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/features/ledger/data/providers/ledger_providers.dart';
import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';
import 'package:quorivell/features/ledger/domain/repositories/ledger_repository.dart';
import 'package:quorivell/features/ledger/presentation/controllers/ledger_list_controller.dart';
import 'package:quorivell/features/ledger/presentation/controllers/ledger_list_state.dart';

LedgerItem _item(
  String id,
  String statement, {
  String kind = LedgerItemKind.commitment,
  LedgerItemStatus status = LedgerItemStatus.open,
}) => LedgerItem(
  id: id,
  userId: 'user-1',
  kind: kind,
  statement: statement,
  status: status,
  owner: null,
  dueDate: null,
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

class _FakeLedgerRepository implements LedgerRepository {
  _FakeLedgerRepository(this.items);

  final List<LedgerItem> items;
  int subscriptions = 0;

  @override
  Stream<List<LedgerItem>> watchItems({
    String? kind,
    Set<LedgerItemStatus>? statuses,
    int limit = 100,
    int offset = 0,
  }) {
    subscriptions++;
    return Stream.value(items);
  }

  @override
  Stream<List<LedgerItem>> watchOpenCommitments({
    int limit = 100,
    int offset = 0,
  }) {
    subscriptions++;
    return Stream.value(
      items
          .where(
            (item) =>
                item.kind == LedgerItemKind.commitment &&
                item.status == LedgerItemStatus.open,
          )
          .toList(),
    );
  }

  @override
  Stream<LedgerItem?> watchById(String id) => Stream.value(null);

  @override
  Stream<List<EvidenceReference>> watchEvidence(String ledgerItemId) =>
      const Stream.empty();

  @override
  Future<LedgerItem> acceptCandidate({
    required String candidateId,
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
  }) async => throw UnimplementedError();

  @override
  Future<LedgerItem> createManual({
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
    bool allowsDueDate = true,
  }) async => throw UnimplementedError();

  @override
  Future<void> updateStatus({
    required String id,
    required LedgerItemStatus status,
  }) async {}

  @override
  Future<void> delete(String id) async {}
}

void main() {
  late _FakeLedgerRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _FakeLedgerRepository([
      _item('a', 'Send the checklist.'),
      _item('b', 'Book the venue.'),
      _item('d1', 'We chose option B.', kind: LedgerItemKind.decision),
      _item('done', 'Already handled.', status: LedgerItemStatus.completed),
    ]);
    container = ProviderContainer.test(
      overrides: [ledgerRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(ledgerListControllerProvider, (_, _) {});
  });

  test('exposes active decisions and open commitments by default', () async {
    await container.read(ledgerItemsProvider.future);

    final state = container.read(ledgerListControllerProvider).requireValue;
    expect(state.visibleItems.map((item) => item.id), ['a', 'b', 'd1']);
    expect(state.isEmpty, isFalse);
    expect(state.hasNoMatches, isFalse);
  });

  test(
    'filters case-insensitively without resubscribing to the stream',
    () async {
      await container.read(ledgerItemsProvider.future);
      final subscriptionsBeforeSearch = repository.subscriptions;

      container.read(ledgerListControllerProvider.notifier).search('VENUE');

      final state = container.read(ledgerListControllerProvider).requireValue;
      expect(state.visibleItems.map((item) => item.id), ['b']);
      expect(repository.subscriptions, subscriptionsBeforeSearch);
    },
  );

  test('kind filter isolates decisions', () async {
    await container.read(ledgerItemsProvider.future);

    container
        .read(ledgerListControllerProvider.notifier)
        .setKindFilter(LedgerKindFilter.kind(LedgerItemKind.decision));

    final state = container.read(ledgerListControllerProvider).requireValue;
    expect(state.visibleItems.map((item) => item.id), ['d1']);
  });

  test('status filter shows completed commitments', () async {
    await container.read(ledgerItemsProvider.future);

    container
        .read(ledgerListControllerProvider.notifier)
        .setStatusFilter(LedgerStatusFilter.completed);

    final state = container.read(ledgerListControllerProvider).requireValue;
    expect(state.visibleItems.map((item) => item.id), ['done']);
  });

  test('reports no matches separately from an empty ledger', () async {
    await container.read(ledgerItemsProvider.future);

    container.read(ledgerListControllerProvider.notifier).search('nothing');

    final state = container.read(ledgerListControllerProvider).requireValue;
    expect(state.hasNoMatches, isTrue);
    expect(state.isEmpty, isFalse);
  });

  test('reports an empty ledger when there is nothing to show', () async {
    final empty = ProviderContainer.test(
      overrides: [
        ledgerRepositoryProvider.overrideWithValue(_FakeLedgerRepository([])),
      ],
    );
    empty.listen(ledgerListControllerProvider, (_, _) {});
    await empty.read(ledgerItemsProvider.future);

    expect(
      empty.read(ledgerListControllerProvider).requireValue.isEmpty,
      isTrue,
    );
  });
}
