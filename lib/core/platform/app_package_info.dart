import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../error/local_persistence_failure.dart';
import '../error/local_persistence_guard.dart';

part 'app_package_info.g.dart';

/// Version stamped into this binary (`versionName` and `versionCode`).
///
/// Play CI may pass `--build-number` higher than `pubspec.yaml`, so Account
/// must read package metadata instead of a localized constant. The UI shows
/// [versionName] only; [buildNumber] stays on the model for equality and
/// diagnostics. Marketing / Play versionName has no `+build` suffix.
class AppPackageVersion {
  const AppPackageVersion({
    required this.versionName,
    required this.buildNumber,
  });

  final String versionName;
  final String buildNumber;

  /// Marketing version shown in Account, e.g. `0.2.0`, never `name+build`.
  String get displayLabel => versionName;

  @override
  bool operator ==(Object other) =>
      other is AppPackageVersion &&
      other.versionName == versionName &&
      other.buildNumber == buildNumber;

  @override
  int get hashCode => Object.hash(versionName, buildNumber);
}

abstract interface class AppPackageInfoSource {
  Future<AppPackageVersion> load();
}

class PackageInfoAppPackageInfoSource implements AppPackageInfoSource {
  PackageInfoAppPackageInfoSource({
    Future<PackageInfo> Function()? loadPackageInfo,
  }) : _loadPackageInfo = loadPackageInfo ?? PackageInfo.fromPlatform;

  final Future<PackageInfo> Function() _loadPackageInfo;

  @override
  Future<AppPackageVersion> load() {
    return guardLocalRead(() async {
      final info = await _loadPackageInfo();
      final versionName = info.version.trim();
      final buildNumber = info.buildNumber.trim();
      if (versionName.isEmpty) {
        throw const LocalPersistenceFailure.readFailed();
      }
      return AppPackageVersion(
        versionName: versionName,
        buildNumber: buildNumber,
      );
    });
  }
}

@Riverpod(keepAlive: true)
AppPackageInfoSource appPackageInfoSource(Ref ref) {
  return PackageInfoAppPackageInfoSource();
}

@Riverpod(keepAlive: true)
Future<AppPackageVersion> appPackageVersion(Ref ref) {
  return ref.watch(appPackageInfoSourceProvider).load();
}
