import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_history_filter_controller.g.dart';

/// Which slice of past conversations the history page shows.
enum ConversationHistoryFilter { active, archived }

@riverpod
class ConversationHistoryFilterController
    extends _$ConversationHistoryFilterController {
  @override
  ConversationHistoryFilter build() => ConversationHistoryFilter.active;

  void select(ConversationHistoryFilter value) => state = value;
}
