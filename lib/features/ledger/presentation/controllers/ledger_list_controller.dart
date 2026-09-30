import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/ledger_providers.dart';
import '../../domain/entities/ledger_item.dart';
import 'ledger_list_state.dart';

part 'ledger_list_controller.g.dart';

@riverpod
class LedgerSearchQuery extends _$LedgerSearchQuery {
  @override
  String build() => '';

  void update(String value) => state = value;
}

@riverpod
class LedgerKindFilterController extends _$LedgerKindFilterController {
  @override
  LedgerKindFilter build() => LedgerKindFilter.all;

  void select(LedgerKindFilter value) => state = value;
}

@riverpod
class LedgerStatusFilterController extends _$LedgerStatusFilterController {
  @override
  LedgerStatusFilter build() => LedgerStatusFilter.open;

  void select(LedgerStatusFilter value) => state = value;
}

/// Owns ledger search and filters so the page only renders what it is given.
///
/// Filter and search live in their own providers, so changing them re-runs the
/// in-memory filter without resubscribing to the underlying database stream.
@riverpod
class LedgerListController extends _$LedgerListController {
  @override
  AsyncValue<LedgerListState> build() {
    final query = ref.watch(ledgerSearchQueryProvider);
    final kindFilter = ref.watch(ledgerKindFilterControllerProvider);
    final statusFilter = ref.watch(ledgerStatusFilterControllerProvider);
    return ref.watch(ledgerItemsProvider).whenData((items) {
      final scoped = _scoped(items, kindFilter, statusFilter);
      return LedgerListState(
        query: query,
        kindFilter: kindFilter,
        statusFilter: statusFilter,
        allItems: scoped,
        visibleItems: _matching(scoped, query),
      );
    });
  }

  void search(String query) =>
      ref.read(ledgerSearchQueryProvider.notifier).update(query);

  void setKindFilter(LedgerKindFilter value) =>
      ref.read(ledgerKindFilterControllerProvider.notifier).select(value);

  void setStatusFilter(LedgerStatusFilter value) =>
      ref.read(ledgerStatusFilterControllerProvider.notifier).select(value);

  static List<LedgerItem> _scoped(
    List<LedgerItem> items,
    LedgerKindFilter kindFilter,
    LedgerStatusFilter statusFilter,
  ) {
    return items.where((item) {
      if (kindFilter.slug != null && item.kind != kindFilter.slug) {
        return false;
      }
      return _statusMatches(item, statusFilter);
    }).toList();
  }

  static bool _statusMatches(LedgerItem item, LedgerStatusFilter filter) {
    return switch (filter) {
      LedgerStatusFilter.open => item.status == LedgerItemStatus.open,
      LedgerStatusFilter.completed =>
        item.status == LedgerItemStatus.completed ||
            item.status == LedgerItemStatus.cancelled,
    };
  }

  static List<LedgerItem> _matching(List<LedgerItem> items, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return items;
    return items
        .where(
          (item) =>
              item.statement.toLowerCase().contains(normalized) ||
              (item.owner?.toLowerCase().contains(normalized) ?? false),
        )
        .toList();
  }
}
