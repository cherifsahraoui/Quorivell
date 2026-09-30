import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/ledger_providers.dart';
import '../../domain/entities/ledger_item.dart';

part 'ledger_actions_controller.g.dart';

@riverpod
class LedgerActionsController extends _$LedgerActionsController {
  @override
  void build() {}

  Future<LedgerItem> createManual({
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required String kindDisplayNameSnapshot,
    bool allowsDueDate = true,
  }) async {
    final link = ref.keepAlive();
    try {
      return await ref
          .read(ledgerRepositoryProvider)
          .createManual(
            kind: kind,
            statement: statement,
            owner: owner,
            dueDate: dueDate,
            note: note,
            kindDisplayNameSnapshot: kindDisplayNameSnapshot,
            allowsDueDate: allowsDueDate,
          );
    } finally {
      link.close();
    }
  }

  Future<void> setStatus({
    required String id,
    required LedgerItemStatus status,
  }) async {
    final link = ref.keepAlive();
    try {
      await ref
          .read(ledgerRepositoryProvider)
          .updateStatus(id: id, status: status);
      if (!ref.mounted) return;
      ref.invalidate(ledgerItemByIdProvider(id));
    } finally {
      link.close();
    }
  }

  /// Soft-deletes [id]. List updates via the Drift watch stream; do not
  /// invalidate that provider mid-[Dismissible] or the row can rebuild under it.
  Future<void> delete(String id) async {
    final link = ref.keepAlive();
    try {
      await ref.read(ledgerRepositoryProvider).delete(id);
      if (!ref.mounted) return;
      ref.invalidate(ledgerItemByIdProvider(id));
      ref.invalidate(ledgerEvidenceProvider(id));
    } finally {
      link.close();
    }
  }
}
