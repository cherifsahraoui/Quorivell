import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/platform/background_work_constraint_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.quorivell.app/device');
  final log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          log.add(call);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('maps Restricted when the app is not on the allowlist', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          log.add(call);
          return {
            'isBackgroundRestricted': true,
            'isPowerSaveMode': false,
            'isIgnoringBatteryOptimizations': false,
          };
        });

    final service = AndroidBackgroundWorkConstraintService(channel: channel);
    final constraints = await service.read();

    expect(log.single.method, 'getBackgroundWorkConstraints');
    expect(constraints.isBackgroundRestricted, isTrue);
    expect(constraints.isPowerSaveMode, isFalse);
    expect(constraints.isIgnoringBatteryOptimizations, isFalse);
    expect(constraints.isEffectivelyRestricted, isTrue);
    expect(
      constraints.accountCardKind,
      BackgroundWorkAccountCardKind.restricted,
    );
    expect(constraints.shouldRemind, isTrue);
  });

  test('treats Xiaomi No restrictions allowlist as not Restricted', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          log.add(call);
          return {
            'isBackgroundRestricted': true,
            'isPowerSaveMode': false,
            'isIgnoringBatteryOptimizations': true,
            'isOemAggressiveBattery': true,
          };
        });

    final service = AndroidBackgroundWorkConstraintService(channel: channel);
    final constraints = await service.read();

    expect(constraints.isBackgroundRestricted, isTrue);
    expect(constraints.isIgnoringBatteryOptimizations, isTrue);
    expect(constraints.isOemAggressiveBattery, isTrue);
    expect(constraints.isEffectivelyRestricted, isFalse);
    expect(constraints.needsAllowlistGuidance, isFalse);
    expect(
      constraints.accountCardKind,
      BackgroundWorkAccountCardKind.informational,
    );
    expect(constraints.shouldRemind, isFalse);
  });

  test(
    'does not remind for stock Optimized without Restricted or Battery Saver',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            log.add(call);
            return {
              'isBackgroundRestricted': false,
              'isPowerSaveMode': false,
              'isIgnoringBatteryOptimizations': false,
              'isOemAggressiveBattery': false,
            };
          });

      final service = AndroidBackgroundWorkConstraintService(channel: channel);
      final constraints = await service.read();

      expect(constraints.isIgnoringBatteryOptimizations, isFalse);
      expect(constraints.isOemAggressiveBattery, isFalse);
      expect(
        constraints.accountCardKind,
        BackgroundWorkAccountCardKind.informational,
      );
      expect(constraints.shouldRemind, isFalse);
    },
  );

  test(
    'reminds for Xiaomi recommended Battery saver until allowlisted',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            log.add(call);
            return {
              'isBackgroundRestricted': false,
              'isPowerSaveMode': false,
              'isIgnoringBatteryOptimizations': false,
              'isOemAggressiveBattery': true,
            };
          });

      final service = AndroidBackgroundWorkConstraintService(channel: channel);
      final constraints = await service.read();

      expect(constraints.needsAllowlistGuidance, isTrue);
      expect(
        constraints.accountCardKind,
        BackgroundWorkAccountCardKind.oemAllowlist,
      );
      expect(constraints.shouldRemind, isTrue);
    },
  );

  test('treats a missing channel result as no reminder', () async {
    final service = AndroidBackgroundWorkConstraintService(channel: channel);
    final constraints = await service.read();

    expect(constraints.isBackgroundRestricted, isFalse);
    expect(constraints.isPowerSaveMode, isFalse);
    expect(constraints.shouldRemind, isFalse);
  });

  test('treats a platform error as no reminder', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          throw PlatformException(code: 'unavailable');
        });

    final service = AndroidBackgroundWorkConstraintService(channel: channel);
    final constraints = await service.read();

    expect(constraints.shouldRemind, isFalse);
  });

  test('opens background work settings on the device channel', () async {
    final service = AndroidBackgroundWorkConstraintService(channel: channel);
    await service.openSettings();

    expect(log.single.method, 'openBackgroundWorkSettings');
  });

  test('stub never reminds and does not open settings', () async {
    final stub = StubBackgroundWorkConstraintService();
    final constraints = await stub.read();

    expect(constraints.shouldRemind, isFalse);
    expect(constraints.accountCardKind, BackgroundWorkAccountCardKind.hidden);
    await stub.openSettings();
  });
}
