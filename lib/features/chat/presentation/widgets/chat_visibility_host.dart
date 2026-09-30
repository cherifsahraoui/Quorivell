import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/chat_conversation_visible_controller.dart';

/// Publishes whether the Chat transcript is in the foreground.
///
/// Lives on [AppShell] so IndexedStack offstage Chat still reports hidden
/// when another tab is selected, Chat history is open, the app is
/// minimized, or the screen is off. A focus-only inactive window still
/// counts as visible so a reply finishing on Chat does not alert.
class ChatVisibilityHost extends ConsumerStatefulWidget {
  const ChatVisibilityHost({super.key});

  @override
  ConsumerState<ChatVisibilityHost> createState() => _ChatVisibilityHostState();
}

class _ChatVisibilityHostState extends ConsumerState<ChatVisibilityHost> {
  AppLifecycleListener? _listener;
  GoRouterDelegate? _delegate;
  var _publishScheduled = false;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onStateChange: (_) => _schedulePublish());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.maybeOf(context);
    if (router == null) return;
    final delegate = router.routerDelegate;
    if (!identical(_delegate, delegate)) {
      _delegate?.removeListener(_schedulePublish);
      _delegate = delegate;
      _delegate!.addListener(_schedulePublish);
    }
    _schedulePublish();
  }

  @override
  void dispose() {
    _delegate?.removeListener(_schedulePublish);
    _listener?.dispose();
    super.dispose();
  }

  void _schedulePublish() {
    if (_publishScheduled) return;
    _publishScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _publishScheduled = false;
      _publish();
    });
  }

  void _publish() {
    if (!mounted) return;
    final router = GoRouter.maybeOf(context);
    if (router == null) return;
    final visible = chatConversationIsVisible(
      lifecycle: WidgetsBinding.instance.lifecycleState,
      locationPath: router.routerDelegate.currentConfiguration.uri.path,
    );
    ref
        .read(chatConversationVisibleControllerProvider.notifier)
        .setVisible(visible);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
