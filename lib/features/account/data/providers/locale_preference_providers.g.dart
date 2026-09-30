// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_preference_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted UI locale preference. Defaults to [AppLocalePreference.system].

@ProviderFor(LocalePreferenceController)
final localePreferenceControllerProvider =
    LocalePreferenceControllerProvider._();

/// Persisted UI locale preference. Defaults to [AppLocalePreference.system].
final class LocalePreferenceControllerProvider
    extends
        $AsyncNotifierProvider<
          LocalePreferenceController,
          AppLocalePreference
        > {
  /// Persisted UI locale preference. Defaults to [AppLocalePreference.system].
  LocalePreferenceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localePreferenceControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localePreferenceControllerHash();

  @$internal
  @override
  LocalePreferenceController create() => LocalePreferenceController();
}

String _$localePreferenceControllerHash() =>
    r'43b48add0e1621277b241605805deaa8f47e0d22';

/// Persisted UI locale preference. Defaults to [AppLocalePreference.system].

abstract class _$LocalePreferenceController
    extends $AsyncNotifier<AppLocalePreference> {
  FutureOr<AppLocalePreference> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AppLocalePreference>, AppLocalePreference>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppLocalePreference>, AppLocalePreference>,
              AsyncValue<AppLocalePreference>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
