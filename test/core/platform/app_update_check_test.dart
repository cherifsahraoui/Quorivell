import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/platform/app_update_check.dart';

void main() {
  test('compareVersionNames orders dotted numeric versions', () {
    expect(compareVersionNames('0.2.0', '0.1.9'), greaterThan(0));
    expect(compareVersionNames('0.2.0', '0.2.0'), 0);
    expect(compareVersionNames('0.2.0', '0.2.1'), lessThan(0));
    expect(compareVersionNames('1.0.0+12', '1.0.0+99'), 0);
  });

  test('AppUpdateManifest parses store metadata', () {
    final manifest = AppUpdateManifest.fromJson({
      'latestVersion': '0.3.0',
      'storeUrl':
          'https://play.google.com/store/apps/details?id=com.quorivell.app',
    });
    expect(manifest.latestVersion, '0.3.0');
    expect(manifest.storeUrl, contains('com.quorivell.app'));
  });

  test('manifest URL is the public website repo raw file', () {
    expect(
      appUpdateManifestUrl,
      'https://raw.githubusercontent.com/cherifsahraoui/quorivell-website/main/public/app-update.json',
    );
    expect(appUpdateManifestUrl, isNot(contains('quorivell.com')));
  });
}
