import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/platform/android_incoming_actions.dart';

void main() {
  test('shows Android incoming-action help only on Android', () {
    expect(
      showsAndroidIncomingActions(
        isWeb: false,
        platform: TargetPlatform.android,
      ),
      isTrue,
    );
    expect(
      showsAndroidIncomingActions(isWeb: false, platform: TargetPlatform.iOS),
      isFalse,
    );
    expect(
      showsAndroidIncomingActions(
        isWeb: false,
        platform: TargetPlatform.windows,
      ),
      isFalse,
    );
    expect(
      showsAndroidIncomingActions(
        isWeb: true,
        platform: TargetPlatform.android,
      ),
      isFalse,
    );
  });
}
