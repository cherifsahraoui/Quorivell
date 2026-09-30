import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/features/onboarding/presentation/widgets/local_model_download_stats.dart';
import 'package:quorivell/l10n/app_localizations.dart';

void main() {
  test('DownloadSpeedTracker computes remaining after observed rate', () async {
    final tracker = DownloadSpeedTracker();
    tracker.observe(0);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final rate = tracker.observe(450000);
    expect(rate, isNotNull);
    expect(rate!, greaterThan(0));

    final remaining = tracker.remainingFor(
      receivedBytes: 450000,
      totalBytes: 900000,
    );
    expect(remaining, isNotNull);
    expect(remaining!.inSeconds, greaterThan(0));

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(tracker.observe(480000), greaterThan(0));
  });

  testWidgets('stats label includes percent, speed, and time left', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final label = localModelDownloadStatsLabel(
      l10n,
      const LocalModelInstallSnapshot(
        isReady: false,
        isDownloading: true,
        progress: 0.42,
        bytesPerSecond: 3.2e6,
        remaining: Duration(minutes: 5),
      ),
    );

    expect(label, '42% · 3.2 MB/s · ~5 min left');
  });

  testWidgets('stats label falls back to percent before speed is known', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final label = localModelDownloadStatsLabel(
      l10n,
      const LocalModelInstallSnapshot(
        isReady: false,
        isDownloading: true,
        progress: 0.08,
      ),
    );

    expect(label, '8%');
  });

  testWidgets(
    'notification stats omit percent-only fallback until speed is known',
    (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        localModelDownloadStatsLabel(
          l10n,
          const LocalModelInstallSnapshot(
            isReady: false,
            isDownloading: true,
            progress: 0.08,
          ),
          percentFallback: false,
        ),
        isNull,
      );
    },
  );

  testWidgets('stats label is hidden while finalizing', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(
      localModelDownloadStatsLabel(
        l10n,
        const LocalModelInstallSnapshot(
          isReady: false,
          isDownloading: true,
          isFinalizing: true,
          progress: 1,
        ),
      ),
      isNull,
    );
  });
}
