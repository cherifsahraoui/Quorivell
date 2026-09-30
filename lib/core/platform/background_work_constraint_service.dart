import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'background_work_constraint_service.g.dart';

/// Which Account battery card to render. Dialogs remind for every value
/// except [hidden] and [informational].
enum BackgroundWorkAccountCardKind {
  /// Non-Android (Account card shrinks).
  hidden,

  /// Per-app Restricted and not allowlisted.
  restricted,

  /// Xiaomi/HyperOS (or similar) and not on the No restrictions allowlist.
  oemAllowlist,

  /// System-wide Battery Saver.
  batterySaver,

  /// Stock Optimized, or already allowlisted. Account still offers settings.
  informational,
}

class BackgroundWorkConstraints {
  const BackgroundWorkConstraints({
    required this.isBackgroundRestricted,
    required this.isPowerSaveMode,
    this.isIgnoringBatteryOptimizations = true,
    this.isOemAggressiveBattery = false,
    this.isApplicable = true,
  });

  /// Per-app Restricted in system battery settings.
  final bool isBackgroundRestricted;

  /// System-wide Battery Saver.
  final bool isPowerSaveMode;

  /// Whether the app is on the battery-optimization allowlist.
  ///
  /// Xiaomi/HyperOS labels this **No restrictions**. Stock Android labels it
  /// Unrestricted. True when not Android / unsupported API, or when allowlisted.
  final bool isIgnoringBatteryOptimizations;

  /// MIUI/HyperOS family (Xiaomi, Redmi, POCO, …). Their recommended Battery
  /// saver mode is not AOSP Restricted but still interrupts FGS / WorkManager.
  final bool isOemAggressiveBattery;

  /// False on non-Android platforms (Account card should shrink).
  final bool isApplicable;

  /// Per-app restriction after OEM allowlist (Xiaomi No restrictions).
  ///
  /// Some Xiaomi builds still report AOSP Restricted while Battery saver is
  /// No restrictions. The allowlist wins.
  bool get isEffectivelyRestricted =>
      isBackgroundRestricted && !isIgnoringBatteryOptimizations;

  /// OEM default Battery saver / Optimized until the user picks No restrictions.
  bool get needsAllowlistGuidance =>
      isOemAggressiveBattery && !isIgnoringBatteryOptimizations;

  /// Account card kind. Always a card on Android; warnings only when needed.
  BackgroundWorkAccountCardKind get accountCardKind {
    if (!isApplicable) {
      return BackgroundWorkAccountCardKind.hidden;
    }
    if (isEffectivelyRestricted) {
      return BackgroundWorkAccountCardKind.restricted;
    }
    if (needsAllowlistGuidance) {
      return BackgroundWorkAccountCardKind.oemAllowlist;
    }
    if (isPowerSaveMode) {
      return BackgroundWorkAccountCardKind.batterySaver;
    }
    return BackgroundWorkAccountCardKind.informational;
  }

  /// Extract/install dialogs — Restricted, OEM not allowlisted, or Battery Saver.
  ///
  /// Stock Optimized is not a reminder. Allowlisted (No restrictions /
  /// Unrestricted) is not a Restricted or OEM reminder.
  bool get shouldRemind => switch (accountCardKind) {
    BackgroundWorkAccountCardKind.restricted ||
    BackgroundWorkAccountCardKind.oemAllowlist ||
    BackgroundWorkAccountCardKind.batterySaver => true,
    BackgroundWorkAccountCardKind.hidden ||
    BackgroundWorkAccountCardKind.informational => false,
  };
}

abstract interface class BackgroundWorkConstraintService {
  Future<BackgroundWorkConstraints> read();
  Future<void> openSettings();
}

class AndroidBackgroundWorkConstraintService
    implements BackgroundWorkConstraintService {
  AndroidBackgroundWorkConstraintService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.quorivell.app/device');

  final MethodChannel _channel;

  @override
  Future<BackgroundWorkConstraints> read() async {
    try {
      final result = await _channel.invokeMethod<Map>(
        'getBackgroundWorkConstraints',
      );
      if (result == null) {
        return const BackgroundWorkConstraints(
          isBackgroundRestricted: false,
          isPowerSaveMode: false,
          isIgnoringBatteryOptimizations: true,
        );
      }
      return BackgroundWorkConstraints(
        isBackgroundRestricted: result['isBackgroundRestricted'] == true,
        isPowerSaveMode: result['isPowerSaveMode'] == true,
        isIgnoringBatteryOptimizations:
            result['isIgnoringBatteryOptimizations'] != false,
        isOemAggressiveBattery: result['isOemAggressiveBattery'] == true,
      );
    } on PlatformException catch (_) {
      return const BackgroundWorkConstraints(
        isBackgroundRestricted: false,
        isPowerSaveMode: false,
        isIgnoringBatteryOptimizations: true,
      );
    }
  }

  @override
  Future<void> openSettings() async {
    try {
      await _channel.invokeMethod<void>('openBackgroundWorkSettings');
    } on PlatformException catch (_) {
      // Ignore errors opening settings
    }
  }
}

class StubBackgroundWorkConstraintService
    implements BackgroundWorkConstraintService {
  @override
  Future<BackgroundWorkConstraints> read() async {
    return const BackgroundWorkConstraints(
      isBackgroundRestricted: false,
      isPowerSaveMode: false,
      isIgnoringBatteryOptimizations: true,
      isApplicable: false,
    );
  }

  @override
  Future<void> openSettings() async {}
}

BackgroundWorkConstraintService createBackgroundWorkConstraintService() {
  if (Platform.isAndroid) {
    return AndroidBackgroundWorkConstraintService();
  }
  return StubBackgroundWorkConstraintService();
}

@Riverpod(keepAlive: true)
BackgroundWorkConstraintService backgroundWorkConstraintService(Ref ref) {
  return createBackgroundWorkConstraintService();
}

/// Kept alive so Account battery guidance can refresh after returning from
/// system settings without disposing mid-flight.
@Riverpod(keepAlive: true)
class BackgroundWorkConstraintController
    extends _$BackgroundWorkConstraintController {
  @override
  Future<BackgroundWorkConstraints> build() async {
    final service = ref.watch(backgroundWorkConstraintServiceProvider);
    final listener = AppLifecycleListener(onResume: () => unawaited(refresh()));
    ref.onDispose(listener.dispose);
    return service.read();
  }

  Future<void> openSettings() async {
    if (!ref.mounted) return;
    final service = ref.read(backgroundWorkConstraintServiceProvider);
    await service.openSettings();
  }

  Future<void> refresh() async {
    if (!ref.mounted) return;
    final service = ref.read(backgroundWorkConstraintServiceProvider);
    final constraints = await service.read();
    if (!ref.mounted) return;
    state = AsyncData(constraints);
  }

  Future<void> openSettingsAndRefresh() async {
    await openSettings();
    await refresh();
  }

  /// One educational model-install dialog per process (tour → model gate,
  /// then download tap should not repeat it).
  var modelInstallReminderShown = false;

  void markModelInstallReminderShown() {
    modelInstallReminderShown = true;
  }
}
