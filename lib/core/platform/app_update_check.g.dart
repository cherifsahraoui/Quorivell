// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_check.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appUpdateManifestSource)
final appUpdateManifestSourceProvider = AppUpdateManifestSourceProvider._();

final class AppUpdateManifestSourceProvider
    extends
        $FunctionalProvider<
          AppUpdateManifestSource,
          AppUpdateManifestSource,
          AppUpdateManifestSource
        >
    with $Provider<AppUpdateManifestSource> {
  AppUpdateManifestSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdateManifestSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdateManifestSourceHash();

  @$internal
  @override
  $ProviderElement<AppUpdateManifestSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppUpdateManifestSource create(Ref ref) {
    return appUpdateManifestSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUpdateManifestSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUpdateManifestSource>(value),
    );
  }
}

String _$appUpdateManifestSourceHash() =>
    r'22686f8c798eff7be127ae22fc42610767906105';

@ProviderFor(AppUpdatePromptController)
final appUpdatePromptControllerProvider = AppUpdatePromptControllerProvider._();

final class AppUpdatePromptControllerProvider
    extends
        $AsyncNotifierProvider<
          AppUpdatePromptController,
          AppUpdateAvailability?
        > {
  AppUpdatePromptControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdatePromptControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdatePromptControllerHash();

  @$internal
  @override
  AppUpdatePromptController create() => AppUpdatePromptController();
}

String _$appUpdatePromptControllerHash() =>
    r'657de3e4317b6c052631ab33fbcd8c5bb4d4c0b2';

abstract class _$AppUpdatePromptController
    extends $AsyncNotifier<AppUpdateAvailability?> {
  FutureOr<AppUpdateAvailability?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<AppUpdateAvailability?>, AppUpdateAvailability?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AppUpdateAvailability?>,
                AppUpdateAvailability?
              >,
              AsyncValue<AppUpdateAvailability?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
