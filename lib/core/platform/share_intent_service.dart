import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'share_intent.dart';

part 'share_intent_service.g.dart';

abstract interface class ShareIntentService {
  /// Cold-start share extras from the intent that launched the app.
  Future<IncomingSharePayload?> consumeInitialShare();

  /// Warm-start shares while the activity is already running.
  Stream<IncomingSharePayload> get incomingShares;
}

class AndroidShareIntentService implements ShareIntentService {
  AndroidShareIntentService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.quorivell.app/share') {
    _channel.setMethodCallHandler(_onNativeCall);
  }

  final MethodChannel _channel;
  final StreamController<IncomingSharePayload> _incoming =
      StreamController<IncomingSharePayload>.broadcast();

  Future<void> _onNativeCall(MethodCall call) async {
    if (call.method != 'onSharedText') return;
    final payload = parseIncomingSharePayload(call.arguments);
    if (payload != null) {
      _incoming.add(payload);
    }
  }

  @override
  Stream<IncomingSharePayload> get incomingShares => _incoming.stream;

  @override
  Future<IncomingSharePayload?> consumeInitialShare() async {
    try {
      final raw = await _channel.invokeMethod<Object?>('consumePendingShare');
      return parseIncomingSharePayload(raw);
    } on PlatformException catch (_) {
      return null;
    }
  }
}

class StubShareIntentService implements ShareIntentService {
  const StubShareIntentService();

  @override
  Future<IncomingSharePayload?> consumeInitialShare() async => null;

  @override
  Stream<IncomingSharePayload> get incomingShares => const Stream.empty();
}

ShareIntentService createShareIntentService() {
  if (Platform.isAndroid) {
    return AndroidShareIntentService();
  }
  return StubShareIntentService();
}

@Riverpod(keepAlive: true)
ShareIntentService shareIntentService(Ref ref) {
  return createShareIntentService();
}
