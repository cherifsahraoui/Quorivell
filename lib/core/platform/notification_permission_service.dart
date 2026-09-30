import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'notification_permission_prompt.dart';

part 'notification_permission_service.g.dart';

abstract interface class NotificationPermissionService {
  Future<NotificationPermissionStatus> checkStatus();
  Future<NotificationPermissionStatus> request();
  Future<void> openSettings();
}

enum NotificationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  notApplicable,
}

class AndroidNotificationPermissionService
    implements NotificationPermissionService {
  AndroidNotificationPermissionService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.quorivell.app/permission');

  final MethodChannel _channel;

  @override
  Future<NotificationPermissionStatus> checkStatus() async {
    if (!Platform.isAndroid) {
      return NotificationPermissionStatus.notApplicable;
    }

    try {
      final result = await _channel.invokeMethod<String>(
        'checkNotificationPermission',
      );
      return _parseStatus(result);
    } on PlatformException catch (_) {
      return NotificationPermissionStatus.notApplicable;
    }
  }

  @override
  Future<NotificationPermissionStatus> request() async {
    if (!Platform.isAndroid) {
      return NotificationPermissionStatus.notApplicable;
    }

    try {
      final result = await _channel.invokeMethod<String>(
        'requestNotificationPermission',
      );
      return _parseStatus(result);
    } on PlatformException catch (_) {
      return NotificationPermissionStatus.denied;
    }
  }

  @override
  Future<void> openSettings() async {
    try {
      await _channel.invokeMethod('openAppSettings');
    } on PlatformException catch (_) {
      // Ignore errors opening settings
    }
  }

  NotificationPermissionStatus _parseStatus(String? status) {
    switch (status) {
      case 'granted':
        return NotificationPermissionStatus.granted;
      case 'permanentlyDenied':
        return NotificationPermissionStatus.permanentlyDenied;
      case 'denied':
      default:
        return NotificationPermissionStatus.denied;
    }
  }
}

class StubNotificationPermissionService
    implements NotificationPermissionService {
  @override
  Future<NotificationPermissionStatus> checkStatus() async {
    return NotificationPermissionStatus.notApplicable;
  }

  @override
  Future<NotificationPermissionStatus> request() async {
    return NotificationPermissionStatus.notApplicable;
  }

  @override
  Future<void> openSettings() async {}
}

NotificationPermissionService createNotificationPermissionService() {
  if (Platform.isAndroid) {
    return AndroidNotificationPermissionService();
  }
  return StubNotificationPermissionService();
}

@Riverpod(keepAlive: true)
NotificationPermissionService notificationPermissionService(Ref ref) {
  return createNotificationPermissionService();
}

/// Kept alive so Allow after a dialog does not drop the notifier (autoDispose
/// would make [enableFromUi] return without requesting the OS permission).
/// Refreshes on resume so Account can hide the notice while granted and show
/// it again if the user later turns notifications off in system settings.
@Riverpod(keepAlive: true)
class NotificationPermissionController
    extends _$NotificationPermissionController {
  @override
  Future<NotificationPermissionStatus> build() async {
    final service = ref.watch(notificationPermissionServiceProvider);
    final listener = AppLifecycleListener(onResume: () => unawaited(refresh()));
    ref.onDispose(listener.dispose);
    return service.checkStatus();
  }

  /// Whether the cold-start rationale should appear once.
  ///
  /// Skips when the user already chose Allow/Not now, when the OS already
  /// granted or permanently denied, or when notifications are not applicable.
  ///
  /// Does not await [future] after an async gap — that throws if this
  /// autoDispose provider was rebuilt/disposed while pending.
  Future<bool> shouldShowStartupPrompt() async {
    if (!ref.mounted) return false;

    final decisionFuture = ref.read(
      notificationPermissionPromptDecisionControllerProvider.future,
    );
    final service = ref.read(notificationPermissionServiceProvider);
    final existing = state;

    final decision = await decisionFuture;
    if (!ref.mounted) return false;
    if (decision != NotificationPermissionPromptDecision.neverAsked) {
      return false;
    }

    final NotificationPermissionStatus status;
    if (existing case AsyncData(:final value)) {
      status = value;
    } else {
      status = await service.checkStatus();
      if (!ref.mounted) return false;
    }

    switch (status) {
      case NotificationPermissionStatus.denied:
        return true;
      case NotificationPermissionStatus.granted:
      case NotificationPermissionStatus.permanentlyDenied:
      case NotificationPermissionStatus.notApplicable:
        return false;
    }
  }

  Future<void> request() async {
    final service = ref.read(notificationPermissionServiceProvider);
    final promptNotifier = ref.read(
      notificationPermissionPromptDecisionControllerProvider.notifier,
    );
    if (ref.mounted) {
      state = const AsyncLoading();
    }
    final status = await service.request();
    await promptNotifier.markRequested();
    if (!ref.mounted) return;
    state = AsyncData(status);
  }

  /// Persists **Not now** so startup stops nagging; Account + extract reminders remain.
  Future<void> defer() async {
    if (!ref.mounted) return;
    final promptNotifier = ref.read(
      notificationPermissionPromptDecisionControllerProvider.notifier,
    );
    await promptNotifier.markDeferred();
  }

  /// Allow CTA that requests when possible, otherwise opens system settings.
  Future<void> enableFromUi() async {
    final service = ref.read(notificationPermissionServiceProvider);
    final existing = state;

    final NotificationPermissionStatus status;
    if (existing case AsyncData(:final value)) {
      status = value;
    } else {
      status = await service.checkStatus();
    }

    if (status == NotificationPermissionStatus.permanentlyDenied) {
      await service.openSettings();
      return;
    }
    await request();
  }

  Future<void> openSettings() async {
    if (!ref.mounted) return;
    final service = ref.read(notificationPermissionServiceProvider);
    await service.openSettings();
  }

  Future<void> refresh() async {
    if (!ref.mounted) return;
    final service = ref.read(notificationPermissionServiceProvider);
    final status = await service.checkStatus();
    if (!ref.mounted) return;
    state = AsyncData(status);
  }
}
