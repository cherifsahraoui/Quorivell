// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the welcome + onboarding tour has been shown once.
///
/// Independent of on-device model install: when true and the model is not
/// ready, the router opens the model download gate unless the user already
/// chose **Configure later** (or later deleted a model from Account).
///
/// Kept alive for the process: the router uses one-shot [Ref.read], and
/// auto-dispose would drop the provider while [SharedPreferences] is still
/// loading.

@ProviderFor(OnboardingState)
final onboardingStateProvider = OnboardingStateProvider._();

/// Whether the welcome + onboarding tour has been shown once.
///
/// Independent of on-device model install: when true and the model is not
/// ready, the router opens the model download gate unless the user already
/// chose **Configure later** (or later deleted a model from Account).
///
/// Kept alive for the process: the router uses one-shot [Ref.read], and
/// auto-dispose would drop the provider while [SharedPreferences] is still
/// loading.
final class OnboardingStateProvider
    extends $AsyncNotifierProvider<OnboardingState, bool> {
  /// Whether the welcome + onboarding tour has been shown once.
  ///
  /// Independent of on-device model install: when true and the model is not
  /// ready, the router opens the model download gate unless the user already
  /// chose **Configure later** (or later deleted a model from Account).
  ///
  /// Kept alive for the process: the router uses one-shot [Ref.read], and
  /// auto-dispose would drop the provider while [SharedPreferences] is still
  /// loading.
  OnboardingStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingStateHash();

  @$internal
  @override
  OnboardingState create() => OnboardingState();
}

String _$onboardingStateHash() => r'e3544a2ff593f0283bd7008c7b003ae524d2cb79';

/// Whether the welcome + onboarding tour has been shown once.
///
/// Independent of on-device model install: when true and the model is not
/// ready, the router opens the model download gate unless the user already
/// chose **Configure later** (or later deleted a model from Account).
///
/// Kept alive for the process: the router uses one-shot [Ref.read], and
/// auto-dispose would drop the provider while [SharedPreferences] is still
/// loading.

abstract class _$OnboardingState extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the user may use the app without a verified on-device model.
///
/// Set when they tap **Configure later** on the model gate, or when they
/// delete an installed model from Account (so deletion does not reopen the
/// gate). A ready GGUF also unlocks the app without this flag.

@ProviderFor(ModelSetupState)
final modelSetupStateProvider = ModelSetupStateProvider._();

/// Whether the user may use the app without a verified on-device model.
///
/// Set when they tap **Configure later** on the model gate, or when they
/// delete an installed model from Account (so deletion does not reopen the
/// gate). A ready GGUF also unlocks the app without this flag.
final class ModelSetupStateProvider
    extends $AsyncNotifierProvider<ModelSetupState, bool> {
  /// Whether the user may use the app without a verified on-device model.
  ///
  /// Set when they tap **Configure later** on the model gate, or when they
  /// delete an installed model from Account (so deletion does not reopen the
  /// gate). A ready GGUF also unlocks the app without this flag.
  ModelSetupStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelSetupStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelSetupStateHash();

  @$internal
  @override
  ModelSetupState create() => ModelSetupState();
}

String _$modelSetupStateHash() => r'51f3fffa954eddb2fd8ffa565719682abecdb9a2';

/// Whether the user may use the app without a verified on-device model.
///
/// Set when they tap **Configure later** on the model gate, or when they
/// delete an installed model from Account (so deletion does not reopen the
/// gate). A ready GGUF also unlocks the app without this flag.

abstract class _$ModelSetupState extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
