import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/platform/notification_permission_prompt.dart';
import 'package:quorivell/core/platform/notification_permission_service.dart';

class _FakeNotificationPermissionService
    implements NotificationPermissionService {
  _FakeNotificationPermissionService({
    this.status = NotificationPermissionStatus.denied,
  });

  NotificationPermissionStatus status;
  var requestCount = 0;
  var openSettingsCount = 0;

  @override
  Future<NotificationPermissionStatus> checkStatus() async => status;

  @override
  Future<NotificationPermissionStatus> request() async {
    requestCount += 1;
    status = NotificationPermissionStatus.granted;
    return status;
  }

  @override
  Future<void> openSettings() async {
    openSettingsCount += 1;
  }
}

/// Delays [checkStatus] until [release] completes so tests can dispose mid-flight.
class _GatedNotificationPermissionService
    implements NotificationPermissionService {
  _GatedNotificationPermissionService({required this.release});

  final Completer<void> release;
  final status = NotificationPermissionStatus.denied;

  @override
  Future<NotificationPermissionStatus> checkStatus() async {
    await release.future;
    return status;
  }

  @override
  Future<NotificationPermissionStatus> request() async => status;

  @override
  Future<void> openSettings() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationPermissionPromptDecision', () {
    test('defaults to neverAsked and persists deferred', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        await container.read(
          notificationPermissionPromptDecisionControllerProvider.future,
        ),
        NotificationPermissionPromptDecision.neverAsked,
      );

      await container
          .read(notificationPermissionPromptDecisionControllerProvider.notifier)
          .markDeferred();

      expect(
        container
            .read(notificationPermissionPromptDecisionControllerProvider)
            .value,
        NotificationPermissionPromptDecision.deferred,
      );
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(notificationPermissionPromptDecisionKey),
        'deferred',
      );
    });

    test('loads requested from storage', () async {
      SharedPreferences.setMockInitialValues({
        notificationPermissionPromptDecisionKey: 'requested',
      });
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        await container.read(
          notificationPermissionPromptDecisionControllerProvider.future,
        ),
        NotificationPermissionPromptDecision.requested,
      );
    });
  });

  group('NotificationPermissionController', () {
    test('shouldShowStartupPrompt only when neverAsked and denied', () async {
      SharedPreferences.setMockInitialValues({});
      final fake = _FakeNotificationPermissionService();
      final container = ProviderContainer(
        overrides: [
          notificationPermissionServiceProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      expect(
        await container
            .read(notificationPermissionControllerProvider.notifier)
            .shouldShowStartupPrompt(),
        isTrue,
      );

      await container
          .read(notificationPermissionControllerProvider.notifier)
          .defer();

      expect(
        await container
            .read(notificationPermissionControllerProvider.notifier)
            .shouldShowStartupPrompt(),
        isFalse,
      );
    });

    test('request marks decision requested and updates status', () async {
      SharedPreferences.setMockInitialValues({});
      final fake = _FakeNotificationPermissionService();
      final container = ProviderContainer(
        overrides: [
          notificationPermissionServiceProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(notificationPermissionControllerProvider.notifier)
          .request();

      expect(fake.requestCount, 1);
      expect(
        container.read(notificationPermissionControllerProvider).value,
        NotificationPermissionStatus.granted,
      );
      expect(
        container
            .read(notificationPermissionPromptDecisionControllerProvider)
            .value,
        NotificationPermissionPromptDecision.requested,
      );
      expect(
        await container
            .read(notificationPermissionControllerProvider.notifier)
            .shouldShowStartupPrompt(),
        isFalse,
      );
    });

    test('enableFromUi requests after an async gap with no listener', () async {
      SharedPreferences.setMockInitialValues({});
      final fake = _FakeNotificationPermissionService();
      final container = ProviderContainer(
        overrides: [
          notificationPermissionServiceProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      await container.read(notificationPermissionControllerProvider.future);
      final notifier = container.read(
        notificationPermissionControllerProvider.notifier,
      );
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await notifier.enableFromUi();

      expect(fake.requestCount, 1);
    });

    test('enableFromUi opens settings when permanently denied', () async {
      SharedPreferences.setMockInitialValues({});
      final fake = _FakeNotificationPermissionService(
        status: NotificationPermissionStatus.permanentlyDenied,
      );
      final container = ProviderContainer(
        overrides: [
          notificationPermissionServiceProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      await container.read(notificationPermissionControllerProvider.future);
      await container
          .read(notificationPermissionControllerProvider.notifier)
          .enableFromUi();

      expect(fake.openSettingsCount, 1);
      expect(fake.requestCount, 0);
    });

    test('refresh picks up permission revoked in system settings', () async {
      SharedPreferences.setMockInitialValues({});
      final fake = _FakeNotificationPermissionService(
        status: NotificationPermissionStatus.granted,
      );
      final container = ProviderContainer(
        overrides: [
          notificationPermissionServiceProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      expect(
        await container.read(notificationPermissionControllerProvider.future),
        NotificationPermissionStatus.granted,
      );

      fake.status = NotificationPermissionStatus.permanentlyDenied;
      await container
          .read(notificationPermissionControllerProvider.notifier)
          .refresh();

      expect(
        container.read(notificationPermissionControllerProvider).value,
        NotificationPermissionStatus.permanentlyDenied,
      );
    });

    test('shouldShowStartupPrompt is false when already granted', () async {
      SharedPreferences.setMockInitialValues({});
      final fake = _FakeNotificationPermissionService(
        status: NotificationPermissionStatus.granted,
      );
      final container = ProviderContainer(
        overrides: [
          notificationPermissionServiceProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      expect(
        await container
            .read(notificationPermissionControllerProvider.notifier)
            .shouldShowStartupPrompt(),
        isFalse,
      );
    });

    test(
      'shouldShowStartupPrompt returns false if disposed mid-flight',
      () async {
        SharedPreferences.setMockInitialValues({});
        final release = Completer<void>();
        final fake = _GatedNotificationPermissionService(release: release);
        final container = ProviderContainer(
          overrides: [
            notificationPermissionServiceProvider.overrideWithValue(fake),
          ],
        );
        var disposed = false;
        addTearDown(() {
          if (!release.isCompleted) {
            release.complete();
          }
          if (!disposed) {
            container.dispose();
          }
        });

        final pending = container
            .read(notificationPermissionControllerProvider.notifier)
            .shouldShowStartupPrompt();

        // Let the prompt-decision await finish before disposing.
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        container.dispose();
        disposed = true;
        release.complete();

        expect(await pending, isFalse);
      },
    );
  });
}
