import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../auth/data/providers/local_user_scope_providers.dart';
import '../../domain/entities/ledger_item.dart';
import '../../domain/repositories/ledger_repository.dart';
import '../datasources/ledger_local_data_source.dart';
import '../repositories/ledger_repository_impl.dart';

part 'ledger_providers.g.dart';

@riverpod
LedgerLocalDataSource ledgerLocalDataSource(Ref ref) {
  return DriftLedgerLocalDataSource(ref.watch(appDatabaseProvider));
}

@riverpod
LedgerRepository ledgerRepository(Ref ref) {
  return LedgerRepositoryImpl(
    localDataSource: ref.watch(ledgerLocalDataSourceProvider),
    userScopeRepository: ref.watch(localUserScopeRepositoryProvider),
  );
}

/// All non-deleted ledger items for the local user (decisions + commitments).
@riverpod
Stream<List<LedgerItem>> ledgerItems(Ref ref) {
  return ref.watch(ledgerRepositoryProvider).watchItems();
}

@riverpod
Stream<List<LedgerItem>> openCommitments(Ref ref) {
  return ref.watch(ledgerRepositoryProvider).watchOpenCommitments();
}

@riverpod
Stream<LedgerItem?> ledgerItemById(Ref ref, String id) {
  return ref.watch(ledgerRepositoryProvider).watchById(id);
}

@riverpod
Stream<List<EvidenceReference>> ledgerEvidence(Ref ref, String ledgerItemId) {
  return ref.watch(ledgerRepositoryProvider).watchEvidence(ledgerItemId);
}
