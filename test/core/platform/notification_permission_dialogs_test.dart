import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/platform/notification_permission_dialogs.dart';
import 'package:quorivell/core/platform/notification_permission_service.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _GatedPermissionService implements NotificationPermissionService {
  NotificationPermissionStatus status = NotificationPermissionStatus.denied;
  final requestGate = Completer<void>();
  var requestCount = 0;

  @override
  Future<NotificationPermissionStatus> checkStatus() async => status;

  @override
  Future<NotificationPermissionStatus> request() async {
    requestCount += 1;
    await requestGate.future;
    status = NotificationPermissionStatus.granted;
    return status;
  }

  @override
  Future<void> openSettings() async {}
}

class _RecordingPermissionService implements NotificationPermissionService {
  NotificationPermissionStatus status = NotificationPermissionStatus.denied;
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpHost(
    WidgetTester tester, {
    required NotificationPermissionService service,
    required Future<void> Function(BuildContext context, WidgetRef ref) show,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationPermissionServiceProvider.overrideWithValue(service),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) {
              return Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () => show(context, ref),
                    child: const Text('open'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'model install reminder requests permission after soft dialog closes',
    (tester) async {
      final service = _RecordingPermissionService();
      await pumpHost(
        tester,
        service: service,
        show: (context, ref) => showNotificationPermissionModelInstallReminder(
          context: context,
          ref: ref,
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(
        find.text(l10n.notificationPermissionModelInstallReminderTitle),
        findsOneWidget,
      );
      expect(service.requestCount, 0);

      await tester.tap(find.text(l10n.accountNotificationPermissionAllow));
      await tester.pump();
      expect(service.requestCount, 0);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(service.requestCount, 1);
      expect(
        find.text(l10n.notificationPermissionModelInstallReminderTitle),
        findsNothing,
      );
    },
  );

  testWidgets('startup dialog defers without requesting permission', (
    tester,
  ) async {
    final service = _RecordingPermissionService();
    await pumpHost(
      tester,
      service: service,
      show: (context, ref) =>
          showNotificationPermissionStartupDialog(context: context, ref: ref),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    await tester.tap(find.text(l10n.accountNotificationPermissionNotNow));
    await tester.pumpAndSettle();

    expect(service.requestCount, 0);
    expect(find.text(l10n.accountNotificationPermissionTitle), findsNothing);
  });

  testWidgets('startup dialog Allow requests permission after dismiss', (
    tester,
  ) async {
    final service = _RecordingPermissionService();
    await pumpHost(
      tester,
      service: service,
      show: (context, ref) =>
          showNotificationPermissionStartupDialog(context: context, ref: ref),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    await tester.tap(find.text(l10n.accountNotificationPermissionAllow));
    await tester.pump();
    expect(service.requestCount, 0);
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(service.requestCount, 1);
    expect(find.text(l10n.accountNotificationPermissionTitle), findsNothing);
  });

  testWidgets(
    'model install Allow returns without waiting for the OS permission request',
    (tester) async {
      final service = _GatedPermissionService();
      var reminderReturned = false;
      await pumpHost(
        tester,
        service: service,
        show: (context, ref) async {
          await showNotificationPermissionModelInstallReminder(
            context: context,
            ref: ref,
          );
          reminderReturned = true;
        },
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final l10n = lookupAppLocalizations(const Locale('en'));
      await tester.tap(find.text(l10n.accountNotificationPermissionAllow));
      await tester.pump();

      expect(reminderReturned, isTrue);
      expect(service.requestCount, 0);

      await tester.pump(const Duration(milliseconds: 350));
      expect(service.requestCount, 1);

      service.requestGate.complete();
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'requestNotificationPermissionIfNeeded asks the OS without a dialog',
    (tester) async {
      final service = _RecordingPermissionService();
      await pumpHost(
        tester,
        service: service,
        show: (context, ref) => requestNotificationPermissionIfNeeded(ref),
      );

      await tester.tap(find.text('open'));
      await tester.pump();
      expect(service.requestCount, 0);
      expect(find.byType(AlertDialog), findsNothing);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(service.requestCount, 1);
    },
  );
}
