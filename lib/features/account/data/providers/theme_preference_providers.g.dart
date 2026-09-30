// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_preference_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted appearance preference. Defaults to [ThemeMode.system].

@ProviderFor(ThemeModePreference)
final themeModePreferenceProvider = ThemeModePreferenceProvider._();

/// Persisted appearance preference. Defaults to [ThemeMode.system].
final class ThemeModePreferenceProvider
    extends $AsyncNotifierProvider<ThemeModePreference, ThemeMode> {
  /// Persisted appearance preference. Defaults to [ThemeMode.system].
  ThemeModePreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModePreferenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModePreferenceHash();

  @$internal
  @override
  ThemeModePreference create() => ThemeModePreference();
}

String _$themeModePreferenceHash() =>
    r'37948220339ca8e72ac4855ee47c12f77bbfc82c';

/// Persisted appearance preference. Defaults to [ThemeMode.system].

abstract class _$ThemeModePreference extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
