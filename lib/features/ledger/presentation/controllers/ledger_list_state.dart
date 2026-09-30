import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/ledger_item.dart';

part 'ledger_list_state.freezed.dart';

/// Which kinds the ledger inbox should show. [slug] null means all kinds.
class LedgerKindFilter {
  const LedgerKindFilter._(this.slug);

  final String? slug;

  static const all = LedgerKindFilter._(null);

  factory LedgerKindFilter.kind(String slug) => LedgerKindFilter._(slug);

  bool get isAll => slug == null;

  @override
  bool operator ==(Object other) =>
      other is LedgerKindFilter && other.slug == slug;

  @override
  int get hashCode => slug.hashCode;
}

/// Active vs completed items.
enum LedgerStatusFilter { open, completed }

/// What the ledger page renders for a loaded inbox.
///
/// [allItems] and [visibleItems] are kept apart so the page can tell "no items
/// for this filter" from "no search matches" without filtering itself.
@freezed
abstract class LedgerListState with _$LedgerListState {
  const LedgerListState._();

  const factory LedgerListState({
    required String query,
    required LedgerKindFilter kindFilter,
    required LedgerStatusFilter statusFilter,
    required List<LedgerItem> allItems,
    required List<LedgerItem> visibleItems,
  }) = _LedgerListState;

  bool get isEmpty => allItems.isEmpty;
  bool get hasNoMatches => allItems.isNotEmpty && visibleItems.isEmpty;
}
