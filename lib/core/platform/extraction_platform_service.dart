import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'notification_permission_service.dart';

part 'extraction_platform_service.g.dart';

abstract interface class ExtractionPlatformService {
  Future<void> startForegroundService(
    String title,
    String body, {
    String destination = '',
  });
  Future<void> updateForegroundServiceProgress({
    required int current,
    required int total,
    String? title,
    String? body,
  });
  Future<void> stopForegroundService();
  Future<void> showCompletionNotification(
    String title,
    String body, {
    String destination = '',
  });

  /// Cold-start destination extra from the notification that launched the app.
  Future<String?> consumeLaunchDestination();

  /// Warm-start destinations when the user taps a notification while resumed.
  Stream<String> get launchDestinations;

  /// Whether the native dataSync [ExtractionService] is currently running.
  Future<bool> isForegroundServiceRunning();
}

class AndroidExtractionPlatformService implements ExtractionPlatformService {
  AndroidExtractionPlatformService({
    MethodChannel? channel,
    required this.permissionService,
  }) : _channel =
           channel ?? const MethodChannel('com.quorivell.app/extraction') {
    _channel.setMethodCallHandler(_onNativeCall);
  }

  final MethodChannel _channel;
  final NotificationPermissionService permissionService;
  final StreamController<String> _launchDestinations =
      StreamController<String>.broadcast();

  Future<void> _onNativeCall(MethodCall call) async {
    if (call.method == 'onLaunchDestination') {
      final dest = call.arguments as String?;
      if (dest != null && dest.isNotEmpty) {
        _launchDestinations.add(dest);
      }
    }
  }

  @override
  Stream<String> get launchDestinations => _launchDestinations.stream;

  @override
  Future<bool> isForegroundServiceRunning() async {
    try {
      final running = await _channel.invokeMethod<bool>(
        'isForegroundServiceRunning',
      );
      return running ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  Future<String?> consumeLaunchDestination() async {
    try {
      final dest = await _channel.invokeMethod<String>(
        'consumeLaunchDestination',
      );
      if (dest == null || dest.isEmpty) return null;
      return dest;
    } on PlatformException catch (_) {
      return null;
    }
  }

  @override
  Future<void> startForegroundService(
    String title,
    String body, {
    String destination = '',
  }) async {
    try {
      await _channel.invokeMethod('startForegroundService', {
        'title': title,
        'body': body,
        'destination': destination,
      });
    } on PlatformException catch (_) {
      // Foreground service not available, continue without it
    }
  }

  @override
  Future<void> updateForegroundServiceProgress({
    required int current,
    required int total,
    String? title,
    String? body,
  }) async {
    try {
      await _channel.invokeMethod('updateForegroundServiceProgress', {
        'current': current,
        'total': total,
        'title': ?title,
        'body': ?body,
      });
    } on PlatformException catch (_) {
      // Foreground service not available, continue without it
    }
  }

  @override
  Future<void> stopForegroundService() async {
    try {
      await _channel.invokeMethod('stopForegroundService');
    } on PlatformException catch (_) {
      // Ignore errors on stop
    }
  }

  @override
  Future<void> showCompletionNotification(
    String title,
    String body, {
    String destination = '',
  }) async {
    final status = await permissionService.checkStatus();
    if (status != NotificationPermissionStatus.granted) {
      return;
    }

    try {
      await _channel.invokeMethod('showCompletionNotification', {
        'title': title,
        'body': body,
        'destination': destination,
      });
    } on PlatformException catch (_) {
      // Notification not available, continue without it
    }
  }
}

class StubExtractionPlatformService implements ExtractionPlatformService {
  @override
  Future<void> startForegroundService(
    String title,
    String body, {
    String destination = '',
  }) async {
    // No-op on non-Android platforms
  }

  @override
  Future<void> updateForegroundServiceProgress({
    required int current,
    required int total,
    String? title,
    String? body,
  }) async {
    // No-op on non-Android platforms
  }

  @override
  Future<void> stopForegroundService() async {
    // No-op on non-Android platforms
  }

  @override
  Future<void> showCompletionNotification(
    String title,
    String body, {
    String destination = '',
  }) async {
    // No-op on non-Android platforms
  }

  @override
  Future<String?> consumeLaunchDestination() async => null;

  @override
  Stream<String> get launchDestinations => const Stream.empty();

  @override
  Future<bool> isForegroundServiceRunning() async => false;
}

ExtractionPlatformService createExtractionPlatformService(
  NotificationPermissionService permissionService,
) {
  if (Platform.isAndroid) {
    return AndroidExtractionPlatformService(
      permissionService: permissionService,
    );
  }
  return StubExtractionPlatformService();
}

@Riverpod(keepAlive: true)
ExtractionPlatformService extractionPlatformService(Ref ref) {
  return createExtractionPlatformService(
    ref.watch(notificationPermissionServiceProvider),
  );
}
