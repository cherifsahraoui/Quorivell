import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/core/platform/notification_permission_service.dart';
import 'package:quorivell/features/account/presentation/widgets/notification_permission_card.dart';
import 'package:quorivell/l10n/app_localizations.dart';

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final l10n = lookupAppLocalizations(const Locale('en'));

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpCard(
    WidgetTester tester, {
    required NotificationPermissionService service,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationPermissionServiceProvider.overrideWithValue(service),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: NotificationPermissionCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('hides the notice when notifications are enabled', (
    tester,
  ) async {
    await pumpCard(
      tester,
      service: _FakeNotificationPermissionService(
        status: NotificationPermissionStatus.granted,
      ),
    );

    expect(
      find.text(l10n.accountNotificationPermissionGrantedTitle),
      findsNothing,
    );
    expect(find.text(l10n.accountNotificationPermissionTitle), findsNothing);
    expect(
      find.text(l10n.accountNotificationPermissionDeniedTitle),
      findsNothing,
    );
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('hides the notice when notifications are not applicable', (
    tester,
  ) async {
    await pumpCard(
      tester,
      service: _FakeNotificationPermissionService(
        status: NotificationPermissionStatus.notApplicable,
      ),
    );

    expect(find.text(l10n.accountNotificationPermissionTitle), findsNothing);
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('shows an allow notice when notifications are off', (
    tester,
  ) async {
    await pumpCard(tester, service: _FakeNotificationPermissionService());

    expect(find.text(l10n.accountNotificationPermissionTitle), findsOneWidget);
    expect(find.text(l10n.accountNotificationPermissionAllow), findsOneWidget);
    expect(find.text(l10n.accountNotificationPermissionNotNow), findsOneWidget);
  });

  testWidgets('hides the notice after the user allows notifications', (
    tester,
  ) async {
    await pumpCard(tester, service: _FakeNotificationPermissionService());

    await tester.tap(find.text(l10n.accountNotificationPermissionAllow));
    await tester.pumpAndSettle();

    expect(find.text(l10n.accountNotificationPermissionTitle), findsNothing);
    expect(
      find.text(l10n.accountNotificationPermissionGrantedTitle),
      findsNothing,
    );
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('shows a blocked notice when permission is permanently denied', (
    tester,
  ) async {
    final service = _FakeNotificationPermissionService(
      status: NotificationPermissionStatus.permanentlyDenied,
    );
    await pumpCard(tester, service: service);

    expect(
      find.text(l10n.accountNotificationPermissionDeniedTitle),
      findsOneWidget,
    );
    expect(find.byType(FilledButton), findsOneWidget);

    await tester.tap(find.text(l10n.accountNotificationPermissionOpenSettings));
    await tester.pumpAndSettle();

    expect(service.openSettingsCount, 1);
  });

  testWidgets('shows the notice again after the user turns notifications off', (
    tester,
  ) async {
    final service = _FakeNotificationPermissionService(
      status: NotificationPermissionStatus.granted,
    );
    await pumpCard(tester, service: service);

    expect(
      find.text(l10n.accountNotificationPermissionDeniedTitle),
      findsNothing,
    );

    service.status = NotificationPermissionStatus.permanentlyDenied;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(
      find.text(l10n.accountNotificationPermissionDeniedTitle),
      findsOneWidget,
    );
  });
}
