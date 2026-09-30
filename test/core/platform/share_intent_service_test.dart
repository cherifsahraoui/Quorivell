import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/platform/share_intent.dart';
import 'package:quorivell/core/platform/share_intent_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.quorivell.app/share');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('consumes the cold-start share map from native', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'consumePendingShare');
          return {'id': 7, 'text': '  Shared synthetic note.  '};
        });

    final service = AndroidShareIntentService(channel: channel);
    final payload = await service.consumeInitialShare();

    expect(
      payload,
      const IncomingSharePayload(id: 7, text: 'Shared synthetic note.'),
    );
  });

  test('returns null when native has no pending share', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => null);

    final service = AndroidShareIntentService(channel: channel);

    expect(await service.consumeInitialShare(), isNull);
  });

  test('forwards warm-start shares from native', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => null);

    final service = AndroidShareIntentService(channel: channel);
    final received = <IncomingSharePayload>[];
    final sub = service.incomingShares.listen(received.add);
    addTearDown(sub.cancel);

    const codec = StandardMethodCodec();
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          channel.name,
          codec.encodeMethodCall(
            const MethodCall('onSharedText', {
              'id': 2,
              'text': 'Second synthetic share.',
            }),
          ),
          (_) {},
        );
    await Future<void>.delayed(Duration.zero);

    expect(received, const [
      IncomingSharePayload(id: 2, text: 'Second synthetic share.'),
    ]);
  });

  test('stub service never yields a share', () async {
    const service = StubShareIntentService();
    expect(await service.consumeInitialShare(), isNull);
    expect(service.incomingShares, emitsDone);
  });
}
