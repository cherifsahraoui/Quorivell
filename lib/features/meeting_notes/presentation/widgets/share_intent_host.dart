import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/platform/share_intent.dart';
import '../../../../core/platform/share_intent_service.dart';
import '../controllers/incoming_share_controller.dart';

/// Applies Android share and PROCESS_TEXT payloads once [AppShell] is on screen.
///
/// Share (`ACTION_SEND`) opens Capture. Text selection (`PROCESS_TEXT`) opens
/// Chat. Cold start waits until onboarding is done (this host is not mounted
/// on boot / welcome / model-setup). Does not extract or sync.
class ShareIntentHost extends ConsumerStatefulWidget {
  const ShareIntentHost({super.key});

  @override
  ConsumerState<ShareIntentHost> createState() => _ShareIntentHostState();
}

class _ShareIntentHostState extends ConsumerState<ShareIntentHost> {
  StreamSubscription<IncomingSharePayload>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bind();
    });
  }

  Future<void> _bind() async {
    if (!mounted) return;
    final service = ref.read(shareIntentServiceProvider);
    _subscription = service.incomingShares.listen(_offerAndOpen);
    final initial = await service.consumeInitialShare();
    if (initial != null) {
      _offerAndOpen(initial);
      return;
    }
    final pending = ref.read(incomingShareControllerProvider);
    if (pending != null && mounted) {
      context.go(_routeFor(pending));
    }
  }

  void _offerAndOpen(IncomingSharePayload payload) {
    final accepted = ref
        .read(incomingShareControllerProvider.notifier)
        .offer(payload);
    if (!accepted || !mounted) return;
    context.go(_routeFor(payload));
  }

  String _routeFor(IncomingSharePayload payload) {
    return payload.isProcessText ? '/chat' : '/capture';
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
