import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/source_conversation_providers.dart';

part 'conversation_actions_controller.g.dart';

@riverpod
class ConversationActionsController extends _$ConversationActionsController {
  @override
  void build() {}

  /// Soft-deletes [id] and refreshes the by-id provider used by the detail page.
  ///
  /// History updates via Drift's [watchAll] stream; do not invalidate that
  /// provider here or the list can rebuild under an in-flight [Dismissible].
  Future<void> delete(String id) async {
    // Auto-dispose would tear this notifier down during [await], then
    // [ref.invalidate] would throw after the row was already soft-deleted.
    final link = ref.keepAlive();
    try {
      await ref.read(sourceConversationRepositoryProvider).delete(id);
      if (!ref.mounted) return;
      ref.invalidate(sourceConversationByIdProvider(id));
    } finally {
      link.close();
    }
  }

  /// Restores an archived conversation to the active list for re-extraction.
  Future<void> unarchive(String id) async {
    final link = ref.keepAlive();
    try {
      await ref.read(sourceConversationRepositoryProvider).unarchive(id);
      if (!ref.mounted) return;
      ref.invalidate(sourceConversationByIdProvider(id));
    } finally {
      link.close();
    }
  }
}
