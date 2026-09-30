import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/features/chat/presentation/controllers/chat_conversation_visible_controller.dart';
import 'package:quorivell/features/chat/presentation/widgets/chat_visibility_host.dart';

void main() {
  testWidgets('marks chat hidden on another route', (tester) async {
    final router = GoRouter(
      initialLocation: '/chat',
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              Stack(children: [child, const ChatVisibilityHost()]),
          routes: [
            GoRoute(path: '/chat', builder: (_, _) => const SizedBox()),
            GoRoute(path: '/ledger', builder: (_, _) => const SizedBox()),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    expect(container.read(chatConversationVisibleControllerProvider), isTrue);

    router.go('/ledger');
    await tester.pump();
    expect(container.read(chatConversationVisibleControllerProvider), isFalse);

    router.go('/chat');
    await tester.pump();
    expect(container.read(chatConversationVisibleControllerProvider), isTrue);
  });

  testWidgets('keeps chat visible when the window is inactive', (tester) async {
    addTearDown(() {
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    });

    final router = GoRouter(
      initialLocation: '/chat',
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              Stack(children: [child, const ChatVisibilityHost()]),
          routes: [GoRoute(path: '/chat', builder: (_, _) => const SizedBox())],
        ),
      ],
    );
    addTearDown(router.dispose);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    expect(container.read(chatConversationVisibleControllerProvider), isTrue);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(container.read(chatConversationVisibleControllerProvider), isTrue);
  });
}
