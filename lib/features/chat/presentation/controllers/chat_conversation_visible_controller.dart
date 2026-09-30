import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/routing/post_setup_home.dart';

part 'chat_conversation_visible_controller.g.dart';

/// Whether the app is in the foreground for Chat completion alerts.
///
/// `null` (tests / first frame), [AppLifecycleState.resumed], and
/// [AppLifecycleState.inactive] count as on screen. Inactive is a focus loss
/// (IME, notification shade, split-screen) — the transcript can still be
/// visible. Hidden, paused, and detached mean Chat is not on screen
/// (minimized, screen off, or the activity is gone).
bool chatLifecycleIsForeground(AppLifecycleState? lifecycle) {
  return switch (lifecycle) {
    null || AppLifecycleState.resumed || AppLifecycleState.inactive => true,
    AppLifecycleState.hidden ||
    AppLifecycleState.paused ||
    AppLifecycleState.detached => false,
  };
}

/// Whether the live Chat transcript is on screen in the foreground.
///
/// True only when the app is in the foreground and the route is exactly
/// [PostSetupHome.chat] (not Chat history or another tab).
bool chatConversationIsVisible({
  required AppLifecycleState? lifecycle,
  required String locationPath,
}) {
  return chatLifecycleIsForeground(lifecycle) &&
      locationPath == PostSetupHome.chat;
}

@Riverpod(keepAlive: true)
class ChatConversationVisibleController
    extends _$ChatConversationVisibleController {
  @override
  bool build() => true;

  void setVisible(bool visible) {
    if (state == visible) return;
    state = visible;
  }
}
