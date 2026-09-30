import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'notification_permission_dialogs.dart';
import 'notification_permission_service.dart';

/// One-shot host that shows the startup notification rationale after AppShell
/// is visible (post onboarding / model setup).
class NotificationPermissionStartupHost extends ConsumerStatefulWidget {
  const NotificationPermissionStartupHost({super.key});

  @override
  ConsumerState<NotificationPermissionStartupHost> createState() =>
      _NotificationPermissionStartupHostState();
}

class _NotificationPermissionStartupHostState
    extends ConsumerState<NotificationPermissionStartupHost> {
  var _attempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShow();
    });
  }

  Future<void> _maybeShow() async {
    if (_attempted || !mounted) return;
    _attempted = true;

    final shouldShow = await ref
        .read(notificationPermissionControllerProvider.notifier)
        .shouldShowStartupPrompt();
    if (!mounted || !shouldShow) return;

    await showNotificationPermissionStartupDialog(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    // Keep the autoDispose controller alive for the one-shot startup check.
    ref.watch(notificationPermissionControllerProvider);
    return const SizedBox.shrink();
  }
}
