import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/core/platform/app_package_info.dart';

void main() {
  test('hides the build number from the display label', () {
    const version = AppPackageVersion(versionName: '0.1.0', buildNumber: '12');

    expect(version.displayLabel, '0.1.0');
  });

  test('display label is the version name when build number is empty', () {
    const version = AppPackageVersion(versionName: '0.1.0', buildNumber: '');

    expect(version.displayLabel, '0.1.0');
  });

  test('reads version name and build number from package metadata', () async {
    final source = PackageInfoAppPackageInfoSource(
      loadPackageInfo: () async => PackageInfo(
        appName: 'Quorivell',
        packageName: 'com.quorivell.app',
        version: '0.1.0',
        buildNumber: '16',
      ),
    );

    expect(
      await source.load(),
      const AppPackageVersion(versionName: '0.1.0', buildNumber: '16'),
    );
  });

  test('maps missing version metadata to a typed read failure', () async {
    final source = PackageInfoAppPackageInfoSource(
      loadPackageInfo: () async => PackageInfo(
        appName: 'Quorivell',
        packageName: 'com.quorivell.app',
        version: '  ',
        buildNumber: '1',
      ),
    );

    await expectLater(
      source.load(),
      throwsA(isA<LocalPersistenceReadFailedFailure>()),
    );
  });

  test('maps package-info plugin errors to a typed read failure', () async {
    final source = PackageInfoAppPackageInfoSource(
      loadPackageInfo: () async => throw Exception('plugin unavailable'),
    );

    await expectLater(
      source.load(),
      throwsA(isA<LocalPersistenceReadFailedFailure>()),
    );
  });
}
