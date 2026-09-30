// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_ai_settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted debug-mode flag and on-device prompt overrides.

@ProviderFor(DebugAiSettingsController)
final debugAiSettingsControllerProvider = DebugAiSettingsControllerProvider._();

/// Persisted debug-mode flag and on-device prompt overrides.
final class DebugAiSettingsControllerProvider
    extends $AsyncNotifierProvider<DebugAiSettingsController, UserPreference?> {
  /// Persisted debug-mode flag and on-device prompt overrides.
  DebugAiSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugAiSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugAiSettingsControllerHash();

  @$internal
  @override
  DebugAiSettingsController create() => DebugAiSettingsController();
}

String _$debugAiSettingsControllerHash() =>
    r'61ec90a05fd0db973933523401173d523d035a0b';

/// Persisted debug-mode flag and on-device prompt overrides.

abstract class _$DebugAiSettingsController
    extends $AsyncNotifier<UserPreference?> {
  FutureOr<UserPreference?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserPreference?>, UserPreference?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserPreference?>, UserPreference?>,
              AsyncValue<UserPreference?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
