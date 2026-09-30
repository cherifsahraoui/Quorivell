import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/routing/post_setup_home.dart';
import 'package:quorivell/features/chat/presentation/controllers/chat_conversation_visible_controller.dart';

void main() {
  test('chat conversation is visible when resumed or inactive on /chat', () {
    expect(
      chatConversationIsVisible(
        lifecycle: AppLifecycleState.resumed,
        locationPath: PostSetupHome.chat,
      ),
      isTrue,
    );
    expect(
      chatConversationIsVisible(
        lifecycle: AppLifecycleState.inactive,
        locationPath: PostSetupHome.chat,
      ),
      isTrue,
    );
    expect(chatLifecycleIsForeground(null), isTrue);
  });

  test('chat conversation is hidden on another tab', () {
    expect(
      chatConversationIsVisible(
        lifecycle: AppLifecycleState.resumed,
        locationPath: PostSetupHome.ledger,
      ),
      isFalse,
    );
  });

  test('chat conversation is hidden on chat history', () {
    expect(
      chatConversationIsVisible(
        lifecycle: AppLifecycleState.resumed,
        locationPath: '${PostSetupHome.chat}/threads',
      ),
      isFalse,
    );
  });

  test('chat conversation is hidden when minimized or the screen is off', () {
    expect(
      chatConversationIsVisible(
        lifecycle: AppLifecycleState.paused,
        locationPath: PostSetupHome.chat,
      ),
      isFalse,
    );
    expect(
      chatConversationIsVisible(
        lifecycle: AppLifecycleState.hidden,
        locationPath: PostSetupHome.chat,
      ),
      isFalse,
    );
    expect(
      chatConversationIsVisible(
        lifecycle: AppLifecycleState.detached,
        locationPath: PostSetupHome.chat,
      ),
      isFalse,
    );
  });
}
