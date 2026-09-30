import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/features/chat/presentation/controllers/chat_conversation_visible_controller.dart';
import 'package:quorivell/features/chat/presentation/controllers/unread_chat_count_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('markUnread is a no-op when the transcript is visible', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(unreadChatCountControllerProvider);
    container.read(unreadChatCountControllerProvider.notifier).markUnread();

    expect(container.read(unreadChatCountControllerProvider), 0);
  });

  test('markUnread increments when the transcript is hidden', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(unreadChatCountControllerProvider);
    container
        .read(chatConversationVisibleControllerProvider.notifier)
        .setVisible(false);
    container.read(unreadChatCountControllerProvider.notifier).markUnread();
    container.read(unreadChatCountControllerProvider.notifier).markUnread();

    expect(container.read(unreadChatCountControllerProvider), 2);
  });

  test('opening the transcript clears unread', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(unreadChatCountControllerProvider);
    container
        .read(chatConversationVisibleControllerProvider.notifier)
        .setVisible(false);
    container.read(unreadChatCountControllerProvider.notifier).markUnread();
    expect(container.read(unreadChatCountControllerProvider), 1);

    container
        .read(chatConversationVisibleControllerProvider.notifier)
        .setVisible(true);
    expect(container.read(unreadChatCountControllerProvider), 0);
  });

  test('markUnread increments when the app is paused on Chat', () async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    addTearDown(
      () => binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed),
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(unreadChatCountControllerProvider);
    container.read(unreadChatCountControllerProvider.notifier).markUnread();

    expect(container.read(unreadChatCountControllerProvider), 1);
  });
}
