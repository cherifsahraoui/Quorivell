import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/config/app_config.dart';

void main() {
  test('the remote assistant is off by default', () {
    expect(AppConfig.remoteAssistant.enabled, isFalse);
    expect(AppConfig.remoteAssistant.appCheckEnforced, isFalse);
    expect(AppConfig.remoteAssistant.isConfigured, isFalse);
  });

  test('no model id is baked into the build', () {
    expect(AppConfig.remoteAssistant.modelId, isEmpty);
  });

  test('no web App Check site key is baked into the build', () {
    expect(AppConfig.appCheckWebSiteKey, isEmpty);
  });

  test('the privacy policy URL matches the Play listing', () {
    expect(AppConfig.privacyPolicyUrl, 'https://quorivell.com/privacy/');
  });

  test('a configured remote assistant reports itself as configured', () {
    const config = RemoteAssistantConfig(
      enabled: true,
      appCheckEnforced: true,
      modelId: 'test-model',
    );

    expect(config.isConfigured, isTrue);
  });
}
