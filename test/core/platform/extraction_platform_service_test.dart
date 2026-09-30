import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/platform/extraction_platform_service.dart';
import 'package:quorivell/core/platform/notification_permission_service.dart';

class _GrantedNotificationPermissionService
    implements NotificationPermissionService {
  @override
  Future<NotificationPermissionStatus> checkStatus() async =>
      NotificationPermissionStatus.granted;

  @override
  Future<NotificationPermissionStatus> request() async =>
      NotificationPermissionStatus.granted;

  @override
  Future<void> openSettings() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.quorivell.app/extraction');
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

  test('forwards progress updates to the extraction method channel', () async {
    final service = AndroidExtractionPlatformService(
      channel: channel,
      permissionService: _GrantedNotificationPermissionService(),
    );

    await service.updateForegroundServiceProgress(
      current: 1,
      total: 3,
      title: 'Downloading model',
      body: '42% · 3.2 MB/s',
    );

    expect(log.single.method, 'updateForegroundServiceProgress');
    expect(log.single.arguments, {
      'current': 1,
      'total': 3,
      'title': 'Downloading model',
      'body': '42% · 3.2 MB/s',
    });
  });

  test('forwards start and completion destinations to native', () async {
    final service = AndroidExtractionPlatformService(
      channel: channel,
      permissionService: _GrantedNotificationPermissionService(),
    );

    await service.startForegroundService(
      'Extraction in progress',
      'Processing',
      destination: '/review',
    );
    await service.showCompletionNotification(
      'Extraction complete',
      '2 found',
      destination: '/ledger',
    );

    expect(log[0].method, 'startForegroundService');
    expect(log[0].arguments, {
      'title': 'Extraction in progress',
      'body': 'Processing',
      'destination': '/review',
    });
    expect(log[1].method, 'showCompletionNotification');
    expect(log[1].arguments, {
      'title': 'Extraction complete',
      'body': '2 found',
      'destination': '/ledger',
    });
  });

  test('queries whether the native foreground service is running', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          log.add(call);
          if (call.method == 'isForegroundServiceRunning') {
            return true;
          }
          return null;
        });

    final service = AndroidExtractionPlatformService(
      channel: channel,
      permissionService: _GrantedNotificationPermissionService(),
    );

    expect(await service.isForegroundServiceRunning(), isTrue);
    expect(log.single.method, 'isForegroundServiceRunning');
  });

  test('stopForegroundService always invokes native stop', () async {
    final service = AndroidExtractionPlatformService(
      channel: channel,
      permissionService: _GrantedNotificationPermissionService(),
    );

    await service.stopForegroundService();

    expect(log.single.method, 'stopForegroundService');
  });
}
