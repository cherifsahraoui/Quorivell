import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../platform/extraction_platform_service.dart';
import 'post_setup_home.dart';

/// Allowed in-app paths a notification tap may open.
const _allowedNotificationPaths = {
  PostSetupHome.review,
  PostSetupHome.ledger,
  PostSetupHome.chat,
  '/account/model',
  '/model-setup',
};

/// Parses a notification extra into a safe GoRouter location, or `null`.
Uri? sanitizeNotificationDestination(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final uri = Uri.parse(raw);
  if (uri.hasScheme || uri.host.isNotEmpty) return null;
  if (!_allowedNotificationPaths.contains(uri.path)) return null;
  if (uri.path == PostSetupHome.review &&
      uri.queryParameters[PostSetupHome.teachQuery] ==
          PostSetupHome.teachValue) {
    return Uri(
      path: PostSetupHome.review,
      queryParameters: {PostSetupHome.teachQuery: PostSetupHome.teachValue},
    );
  }
  return Uri(path: uri.path);
}

/// Applies notification-tap destinations once [AppShell] is on screen.
class NotificationLaunchHost extends ConsumerStatefulWidget {
  const NotificationLaunchHost({super.key});

  @override
  ConsumerState<NotificationLaunchHost> createState() =>
      _NotificationLaunchHostState();
}

class _NotificationLaunchHostState
    extends ConsumerState<NotificationLaunchHost> {
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bind();
    });
  }

  Future<void> _bind() async {
    if (!mounted) return;
    final service = ref.read(extractionPlatformServiceProvider);
    _subscription = service.launchDestinations.listen(_open);
    final initial = await service.consumeLaunchDestination();
    if (initial != null) {
      _open(initial);
    }
  }

  void _open(String raw) {
    final dest = sanitizeNotificationDestination(raw);
    if (dest == null || !mounted) return;
    context.go(dest.toString());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
