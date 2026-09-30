import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_providers.g.dart';

const _hasSeenWelcomeKey = 'has_seen_welcome';

/// Whether the welcome + onboarding tour has been shown once.
///
/// Independent of on-device model install: when true and the model is not
/// ready, the router opens the model download gate unless the user already
/// chose **Configure later** (or later deleted a model from Account).
///
/// Kept alive for the process: the router uses one-shot [Ref.read], and
/// auto-dispose would drop the provider while [SharedPreferences] is still
/// loading.
@Riverpod(keepAlive: true)
class OnboardingState extends _$OnboardingState {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) {
      return false;
    }
    return prefs.getBool(_hasSeenWelcomeKey) ?? false;
  }

  Future<void> markWelcomeSeen() async {
    state = const AsyncValue.data(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenWelcomeKey, true);
  }

  Future<void> clearLocalPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!ref.mounted) {
      return;
    }
    state = const AsyncValue.data(false);
  }
}

const _hasCompletedModelSetupKey = 'has_completed_model_setup';

/// Whether the user may use the app without a verified on-device model.
///
/// Set when they tap **Configure later** on the model gate, or when they
/// delete an installed model from Account (so deletion does not reopen the
/// gate). A ready GGUF also unlocks the app without this flag.
@Riverpod(keepAlive: true)
class ModelSetupState extends _$ModelSetupState {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) {
      return false;
    }
    return prefs.getBool(_hasCompletedModelSetupKey) ?? false;
  }

  Future<void> markCompleted() async {
    state = const AsyncValue.data(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedModelSetupKey, true);
  }
}
