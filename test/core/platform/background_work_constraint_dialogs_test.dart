import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/platform/background_work_constraint_dialogs.dart';
import 'package:quorivell/core/platform/background_work_constraint_service.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _FakeBackgroundWorkConstraintService
    implements BackgroundWorkConstraintService {
  _FakeBackgroundWorkConstraintService({
    this.isBackgroundRestricted = false,
    this.isPowerSaveMode = false,
    this.isOemAggressiveBattery = false,
    bool? isIgnoringBatteryOptimizations,
  }) : isIgnoringBatteryOptimizations =
           isIgnoringBatteryOptimizations ?? !isBackgroundRestricted;

  bool isBackgroundRestricted;
  bool isPowerSaveMode;
  bool isOemAggressiveBattery;
  bool isIgnoringBatteryOptimizations;
  var openSettingsCount = 0;
  Completer<void>? openSettingsGate;

  @override
  Future<BackgroundWorkConstraints> read() async {
    return BackgroundWorkConstraints(
      isBackgroundRestricted: isBackgroundRestricted,
      isPowerSaveMode: isPowerSaveMode,
      isIgnoringBatteryOptimizations: isIgnoringBatteryOptimizations,
      isOemAggressiveBattery: isOemAggressiveBattery,
    );
  }

  @override
  Future<void> openSettings() async {
    openSettingsCount += 1;
    final gate = openSettingsGate;
    if (gate != null) {
      await gate.future;
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpHost(
    WidgetTester tester, {
    required BackgroundWorkConstraintService service,
    required Future<void> Function(BuildContext context, WidgetRef ref) show,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          backgroundWorkConstraintServiceProvider.overrideWithValue(service),
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

  testWidgets('skips the reminder when neither restriction applies', (
    tester,
  ) async {
    final service = _FakeBackgroundWorkConstraintService();
    var reminderReturned = false;
    await pumpHost(
      tester,
      service: service,
      show: (context, ref) async {
        await showBackgroundWorkExtractionReminder(context: context, ref: ref);
        reminderReturned = true;
      },
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
    expect(find.text(l10n.backgroundBatterySaverReminderTitle), findsNothing);
    expect(reminderReturned, isTrue);
    expect(service.openSettingsCount, 0);
  });

  testWidgets('skips Restricted copy when the Xiaomi allowlist is on', (
    tester,
  ) async {
    final service = _FakeBackgroundWorkConstraintService(
      isBackgroundRestricted: true,
      isIgnoringBatteryOptimizations: true,
      isOemAggressiveBattery: true,
    );
    var reminderReturned = false;
    await pumpHost(
      tester,
      service: service,
      show: (context, ref) async {
        await showBackgroundWorkExtractionReminder(context: context, ref: ref);
        reminderReturned = true;
      },
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
    expect(reminderReturned, isTrue);
  });

  testWidgets(
    'shows OEM extraction copy for Xiaomi recommended Battery saver',
    (tester) async {
      final service = _FakeBackgroundWorkConstraintService(
        isOemAggressiveBattery: true,
        isIgnoringBatteryOptimizations: false,
      );
      await pumpHost(
        tester,
        service: service,
        show: (context, ref) =>
            showBackgroundWorkExtractionReminder(context: context, ref: ref),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(find.text(l10n.backgroundOemBatteryReminderTitle), findsOneWidget);
      expect(
        find.text(l10n.backgroundOemBatteryReminderExtractionBody),
        findsOneWidget,
      );
      expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
      expect(find.text(l10n.backgroundBatterySaverReminderTitle), findsNothing);
    },
  );

  testWidgets('shows Restricted extraction copy and continues on dismiss', (
    tester,
  ) async {
    final service = _FakeBackgroundWorkConstraintService(
      isBackgroundRestricted: true,
      isPowerSaveMode: true,
    );
    var reminderReturned = false;
    await pumpHost(
      tester,
      service: service,
      show: (context, ref) async {
        await showBackgroundWorkExtractionReminder(context: context, ref: ref);
        reminderReturned = true;
      },
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsOneWidget);
    expect(
      find.text(l10n.backgroundRestrictionReminderExtractionBody),
      findsOneWidget,
    );
    expect(find.text(l10n.backgroundBatterySaverReminderTitle), findsNothing);
    expect(reminderReturned, isFalse);

    await tester.tap(find.text(l10n.backgroundWorkReminderContinue));
    await tester.pumpAndSettle();

    expect(reminderReturned, isTrue);
    expect(service.openSettingsCount, 0);
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
  });

  testWidgets('shows Battery Saver copy when the app is not Restricted', (
    tester,
  ) async {
    final service = _FakeBackgroundWorkConstraintService(isPowerSaveMode: true);
    await pumpHost(
      tester,
      service: service,
      show: (context, ref) =>
          showBackgroundWorkModelInstallReminder(context: context, ref: ref),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.backgroundBatterySaverReminderTitle), findsOneWidget);
    expect(
      find.text(l10n.backgroundBatterySaverReminderModelInstallBody),
      findsOneWidget,
    );
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
  });

  testWidgets('model-install reminder is shown only once per session', (
    tester,
  ) async {
    final service = _FakeBackgroundWorkConstraintService(
      isBackgroundRestricted: true,
    );
    var firstReturned = false;
    var secondReturned = false;
    await pumpHost(
      tester,
      service: service,
      show: (context, ref) async {
        await showBackgroundWorkModelInstallReminder(
          context: context,
          ref: ref,
        );
        firstReturned = true;
        await showBackgroundWorkModelInstallReminder(
          context: context,
          ref: ref,
        );
        secondReturned = true;
      },
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsOneWidget);
    expect(secondReturned, isFalse);

    await tester.tap(find.text(l10n.backgroundWorkReminderContinue));
    await tester.pumpAndSettle();

    expect(firstReturned, isTrue);
    expect(secondReturned, isTrue);
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
  });

  testWidgets('Open settings returns without waiting so work can continue', (
    tester,
  ) async {
    final service = _FakeBackgroundWorkConstraintService(
      isBackgroundRestricted: true,
    );
    service.openSettingsGate = Completer<void>();
    var reminderReturned = false;
    await pumpHost(
      tester,
      service: service,
      show: (context, ref) async {
        await showBackgroundWorkExtractionReminder(context: context, ref: ref);
        reminderReturned = true;
      },
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    await tester.tap(find.text(l10n.accountNotificationPermissionOpenSettings));
    await tester.pump();

    expect(reminderReturned, isTrue);
    expect(service.openSettingsCount, 1);
    expect(service.openSettingsGate!.isCompleted, isFalse);

    service.openSettingsGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text(l10n.backgroundRestrictionReminderTitle), findsNothing);
  });
}
