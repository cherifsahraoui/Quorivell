import 'package:flutter/foundation.dart';

/// Whether this build can receive Android share / PROCESS_TEXT from other apps.
bool showsAndroidIncomingActions({
  bool isWeb = kIsWeb,
  TargetPlatform? platform,
}) {
  return !isWeb &&
      (platform ?? defaultTargetPlatform) == TargetPlatform.android;
}
