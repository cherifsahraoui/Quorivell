import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'chat_conversation_visible_controller.dart';

part 'unread_chat_count_controller.g.dart';

/// Count of Chat replies finished while the transcript was off-screen.
///
/// Session-scoped (not persisted). Generation is one reply at a time, so
/// the badge is almost always `0` or `1`. Opening the live transcript
/// clears the count.
@Riverpod(keepAlive: true)
class UnreadChatCountController extends _$UnreadChatCountController {
  @override
  int build() {
    ref.listen(chatConversationVisibleControllerProvider, (previous, next) {
      if (next) {
        clear();
      }
    });
    return 0;
  }

  void markUnread() {
    if (_isChatConversationVisible()) return;
    state = state + 1;
  }

  void clear() {
    if (state == 0) return;
    state = 0;
  }

  bool _isChatConversationVisible() {
    if (!chatLifecycleIsForeground(WidgetsBinding.instance.lifecycleState)) {
      return false;
    }
    return ref.read(chatConversationVisibleControllerProvider);
  }
}
