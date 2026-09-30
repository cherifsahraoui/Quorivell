import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quorivell/features/onboarding/data/providers/onboarding_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('keeps onboarding state after a one-shot read', () {
    expect(onboardingStateProvider.isAutoDispose, isFalse);
  });

  test('loads unseen welcome as false and can mark it seen', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(await container.read(onboardingStateProvider.future), isFalse);

    await container.read(onboardingStateProvider.notifier).markWelcomeSeen();

    expect(container.read(onboardingStateProvider).value, isTrue);
  });

  test('clears shared preferences and marks welcome unseen', () async {
    SharedPreferences.setMockInitialValues({'has_seen_welcome': true});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(await container.read(onboardingStateProvider.future), isTrue);

    await container
        .read(onboardingStateProvider.notifier)
        .clearLocalPreferences();

    expect(container.read(onboardingStateProvider).value, isFalse);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('has_seen_welcome'), isNull);
  });

  test('marks model setup completed independently of welcome', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(await container.read(modelSetupStateProvider.future), isFalse);

    await container.read(modelSetupStateProvider.notifier).markCompleted();

    expect(container.read(modelSetupStateProvider).value, isTrue);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('has_completed_model_setup'), isTrue);
  });
}
