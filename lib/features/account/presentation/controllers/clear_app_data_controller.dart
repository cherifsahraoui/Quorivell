import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/error/local_persistence_guard.dart';

part 'clear_app_data_controller.g.dart';

/// Debug-only wipe of Drift user content (ledger, conversations, review,
/// chat). Keeps local user scope, preferences, and AI consent.
@riverpod
class ClearAppDataController extends _$ClearAppDataController {
  @override
  FutureOr<void> build() {}

  Future<void> clearUserContent() {
    return guardLocalWrite(
      () => ref.read(appDatabaseProvider).clearUserContent(),
    );
  }
}
