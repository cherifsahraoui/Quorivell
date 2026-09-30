import '../../../../l10n/app_localizations.dart';
import '../controllers/local_model_install_controller.dart';

/// Builds the live download stats line (percent · speed · time left).
///
/// When [percentFallback] is false (system notification), returns null until
/// throughput is known so the body never flashes percent-only then stats.
String? localModelDownloadStatsLabel(
  AppLocalizations l10n,
  LocalModelInstallSnapshot snapshot, {
  bool percentFallback = true,
}) {
  if ((!snapshot.isDownloading && !snapshot.isExporting) ||
      snapshot.isFinalizing) {
    return null;
  }
  final progress = snapshot.progress;
  if (progress == null) {
    return null;
  }

  final percent = (progress * 100).floor().clamp(0, 100);
  final speed = snapshot.bytesPerSecond;
  final remaining = snapshot.remaining;

  if (speed == null || speed <= 0 || remaining == null) {
    return percentFallback
        ? l10n.onboardingModelDownloadPercent(percent)
        : null;
  }

  return l10n.onboardingModelDownloadStats(
    percent,
    _speedLabel(l10n, speed),
    _remainingLabel(l10n, remaining),
  );
}

String _speedLabel(AppLocalizations l10n, double bytesPerSecond) {
  final abs = bytesPerSecond.abs();
  if (abs >= 1000 * 1000) {
    return l10n.onboardingModelDownloadSpeedMBps(_rateValue(abs / 1e6));
  }
  if (abs >= 1000) {
    return l10n.onboardingModelDownloadSpeedKBps(_rateValue(abs / 1e3));
  }
  return l10n.onboardingModelDownloadSpeedBps(abs.round());
}

String _rateValue(double value) {
  final decimals = value >= 10 ? 0 : 1;
  return value.toStringAsFixed(decimals);
}

String _remainingLabel(AppLocalizations l10n, Duration remaining) {
  final totalSeconds = remaining.inSeconds;
  if (totalSeconds >= 3600) {
    return l10n.onboardingModelDownloadTimeLeftHours(
      (totalSeconds / 3600).ceil(),
    );
  }
  if (totalSeconds >= 60) {
    return l10n.onboardingModelDownloadTimeLeftMinutes(
      (totalSeconds / 60).ceil(),
    );
  }
  return l10n.onboardingModelDownloadTimeLeftSeconds(
    totalSeconds < 1 ? 1 : totalSeconds,
  );
}
