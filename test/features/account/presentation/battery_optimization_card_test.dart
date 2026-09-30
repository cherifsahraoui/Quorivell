import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/platform/background_work_constraint_service.dart';
import 'package:quorivell/features/account/presentation/widgets/battery_optimization_card.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _FakeBackgroundWorkConstraintService
    implements BackgroundWorkConstraintService {
  _FakeBackgroundWorkConstraintService({
    this.isApplicable = true,
    this.isBackgroundRestricted = false,
    this.isPowerSaveMode = false,
    this.isOemAggressiveBattery = false,
    bool? isIgnoringBatteryOptimizations,
  }) : isIgnoringBatteryOptimizations =
           isIgnoringBatteryOptimizations ?? !isBackgroundRestricted;

  bool isApplicable;
  bool isBackgroundRestricted;
  bool isPowerSaveMode;
  bool isOemAggressiveBattery;
  bool isIgnoringBatteryOptimizations;
  var openSettingsCount = 0;

  @override
  Future<BackgroundWorkConstraints> read() async {
    return BackgroundWorkConstraints(
      isBackgroundRestricted: isBackgroundRestricted,
      isPowerSaveMode: isPowerSaveMode,
      isIgnoringBatteryOptimizations: isIgnoringBatteryOptimizations,
      isOemAggressiveBattery: isOemAggressiveBattery,
      isApplicable: isApplicable,
    );
  }

  @override
  Future<void> openSettings() async {
    openSettingsCount += 1;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final l10n = lookupAppLocalizations(const Locale('en'));

  Future<void> pumpCard(
    WidgetTester tester, {
    required BackgroundWorkConstraintService service,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          backgroundWorkConstraintServiceProvider.overrideWithValue(service),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: BatteryOptimizationCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('hides the card when background constraints do not apply', (
    tester,
  ) async {
    await pumpCard(
      tester,
      service: _FakeBackgroundWorkConstraintService(isApplicable: false),
    );

    expect(find.text(l10n.accountBatteryGuidanceTitle), findsNothing);
    expect(find.text(l10n.accountBatteryGuidanceOpenSettings), findsNothing);
  });

  testWidgets('shows a calm card for stock Optimized', (tester) async {
    final service = _FakeBackgroundWorkConstraintService();
    await pumpCard(tester, service: service);

    expect(find.text(l10n.accountBatteryGuidanceTitle), findsOneWidget);
    expect(find.text(l10n.accountBatteryGuidanceBody), findsOneWidget);
    expect(find.text(l10n.accountBatteryGuidanceRestrictedTitle), findsNothing);
    expect(find.text(l10n.accountBatteryGuidanceOemTitle), findsNothing);
    expect(find.byType(OutlinedButton), findsOneWidget);

    await tester.tap(find.text(l10n.accountBatteryGuidanceOpenSettings));
    await tester.pumpAndSettle();

    expect(service.openSettingsCount, 1);
  });

  testWidgets('shows a Restricted warning and opens settings', (tester) async {
    final service = _FakeBackgroundWorkConstraintService(
      isBackgroundRestricted: true,
    );
    await pumpCard(tester, service: service);

    expect(
      find.text(l10n.accountBatteryGuidanceRestrictedTitle),
      findsOneWidget,
    );
    expect(find.byType(FilledButton), findsOneWidget);

    await tester.tap(find.text(l10n.accountBatteryGuidanceOpenSettings));
    await tester.pumpAndSettle();

    expect(service.openSettingsCount, 1);
  });

  testWidgets('shows Battery Saver guidance', (tester) async {
    await pumpCard(
      tester,
      service: _FakeBackgroundWorkConstraintService(isPowerSaveMode: true),
    );

    expect(
      find.text(l10n.accountBatteryGuidanceBatterySaverTitle),
      findsOneWidget,
    );
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('shows OEM guidance for Xiaomi recommended Battery saver', (
    tester,
  ) async {
    final service = _FakeBackgroundWorkConstraintService(
      isOemAggressiveBattery: true,
      isIgnoringBatteryOptimizations: false,
    );
    await pumpCard(tester, service: service);

    expect(find.text(l10n.accountBatteryGuidanceOemTitle), findsOneWidget);
    expect(find.text(l10n.accountBatteryGuidanceOemBody), findsOneWidget);
    expect(find.text(l10n.accountBatteryGuidanceRestrictedTitle), findsNothing);
    expect(find.byType(FilledButton), findsOneWidget);

    await tester.tap(find.text(l10n.accountBatteryGuidanceOpenSettings));
    await tester.pumpAndSettle();

    expect(service.openSettingsCount, 1);
  });

  testWidgets('returns to the calm card after Restricted is cleared', (
    tester,
  ) async {
    final service = _FakeBackgroundWorkConstraintService(
      isBackgroundRestricted: true,
    );
    await pumpCard(tester, service: service);

    expect(
      find.text(l10n.accountBatteryGuidanceRestrictedTitle),
      findsOneWidget,
    );

    service.isBackgroundRestricted = false;
    service.isIgnoringBatteryOptimizations = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(find.text(l10n.accountBatteryGuidanceRestrictedTitle), findsNothing);
    expect(find.text(l10n.accountBatteryGuidanceTitle), findsOneWidget);
    expect(find.text(l10n.accountBatteryGuidanceOpenSettings), findsOneWidget);
  });

  testWidgets('shows a calm card when Xiaomi No restrictions allowlists', (
    tester,
  ) async {
    await pumpCard(
      tester,
      service: _FakeBackgroundWorkConstraintService(
        isBackgroundRestricted: true,
        isIgnoringBatteryOptimizations: true,
        isOemAggressiveBattery: true,
      ),
    );

    expect(find.text(l10n.accountBatteryGuidanceRestrictedTitle), findsNothing);
    expect(find.text(l10n.accountBatteryGuidanceOemTitle), findsNothing);
    expect(find.text(l10n.accountBatteryGuidanceTitle), findsOneWidget);
    expect(find.text(l10n.accountBatteryGuidanceOpenSettings), findsOneWidget);
  });
}
