import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_package_info.dart';

part 'app_update_check.g.dart';

/// Public manifest announcing the latest Quorivell Play version.
///
/// Read from the public [quorivell-website](https://github.com/cherifsahraoui/quorivell-website)
/// raw file (`website/public/app-update.json`) so installs can fetch it without
/// the private app repo and without waiting for GitHub Pages. Bump via
/// `dart run tools/bump_version.dart`. Play In-App Updates SDK is not wired.
const appUpdateManifestUrl =
    'https://raw.githubusercontent.com/cherifsahraoui/quorivell-website/main/public/app-update.json';

const appUpdateDeferredUntilMsKey = 'app_update_deferred_until_ms';
const appUpdateSnoozedVersionKey = 'app_update_snoozed_version';

/// Default snooze after the user taps "Later".
const appUpdateSnoozeDuration = Duration(days: 7);

/// Compares dotted numeric version names (`1.2.3`). Build suffixes are ignored.
int compareVersionNames(String a, String b) {
  List<int> parts(String raw) {
    final core = raw.trim().split('+').first.split('-').first;
    return [
      for (final piece in core.split('.'))
        int.tryParse(piece.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
    ];
  }

  final left = parts(a);
  final right = parts(b);
  final len = left.length > right.length ? left.length : right.length;
  for (var i = 0; i < len; i++) {
    final l = i < left.length ? left[i] : 0;
    final r = i < right.length ? right[i] : 0;
    if (l != r) return l.compareTo(r);
  }
  return 0;
}

class AppUpdateManifest {
  const AppUpdateManifest({
    required this.latestVersion,
    required this.storeUrl,
  });

  final String latestVersion;
  final String storeUrl;

  factory AppUpdateManifest.fromJson(Map<String, dynamic> json) {
    final latest = '${json['latestVersion'] ?? ''}'.trim();
    final storeUrl = '${json['storeUrl'] ?? ''}'.trim();
    if (latest.isEmpty || storeUrl.isEmpty) {
      throw const FormatException('Invalid app update manifest');
    }
    return AppUpdateManifest(latestVersion: latest, storeUrl: storeUrl);
  }
}

class AppUpdateAvailability {
  const AppUpdateAvailability({
    required this.installedVersion,
    required this.latestVersion,
    required this.storeUrl,
  });

  final String installedVersion;
  final String latestVersion;
  final String storeUrl;
}

abstract interface class AppUpdateManifestSource {
  Future<AppUpdateManifest?> load();
}

class HttpAppUpdateManifestSource implements AppUpdateManifestSource {
  HttpAppUpdateManifestSource({http.Client? client, Uri? manifestUri})
    : _client = client ?? http.Client(),
      _manifestUri = manifestUri ?? Uri.parse(appUpdateManifestUrl),
      _ownsClient = client == null;

  final http.Client _client;
  final Uri _manifestUri;
  final bool _ownsClient;

  @override
  Future<AppUpdateManifest?> load() async {
    try {
      final response = await _client
          .get(_manifestUri)
          .timeout(const Duration(seconds: 8));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;
      return AppUpdateManifest.fromJson(decoded);
    } on Object {
      return null;
    } finally {
      if (_ownsClient) {
        _client.close();
      }
    }
  }
}

@Riverpod(keepAlive: true)
AppUpdateManifestSource appUpdateManifestSource(Ref ref) {
  return HttpAppUpdateManifestSource();
}

@Riverpod(keepAlive: true)
class AppUpdatePromptController extends _$AppUpdatePromptController {
  @override
  Future<AppUpdateAvailability?> build() async {
    final installed = await ref.watch(appPackageVersionProvider.future);
    if (!ref.mounted) return null;

    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) return null;

    final deferredUntilMs = prefs.getInt(appUpdateDeferredUntilMsKey);
    if (deferredUntilMs != null) {
      final deferredUntil = DateTime.fromMillisecondsSinceEpoch(
        deferredUntilMs,
        isUtc: true,
      );
      if (DateTime.now().toUtc().isBefore(deferredUntil)) {
        return null;
      }
    }

    final manifest = await ref.watch(appUpdateManifestSourceProvider).load();
    if (!ref.mounted || manifest == null) return null;

    if (compareVersionNames(manifest.latestVersion, installed.versionName) <=
        0) {
      return null;
    }

    return AppUpdateAvailability(
      installedVersion: installed.versionName,
      latestVersion: manifest.latestVersion,
      storeUrl: manifest.storeUrl,
    );
  }

  Future<void> snooze({
    required String version,
    Duration duration = appUpdateSnoozeDuration,
  }) async {
    await future;
    if (!ref.mounted) return;
    final until = DateTime.now().toUtc().add(duration);
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) return;
    await prefs.setInt(
      appUpdateDeferredUntilMsKey,
      until.millisecondsSinceEpoch,
    );
    await prefs.setString(appUpdateSnoozedVersionKey, version);
    state = const AsyncValue.data(null);
  }
}
