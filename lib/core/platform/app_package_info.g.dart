// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_package_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appPackageInfoSource)
final appPackageInfoSourceProvider = AppPackageInfoSourceProvider._();

final class AppPackageInfoSourceProvider
    extends
        $FunctionalProvider<
          AppPackageInfoSource,
          AppPackageInfoSource,
          AppPackageInfoSource
        >
    with $Provider<AppPackageInfoSource> {
  AppPackageInfoSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPackageInfoSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPackageInfoSourceHash();

  @$internal
  @override
  $ProviderElement<AppPackageInfoSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppPackageInfoSource create(Ref ref) {
    return appPackageInfoSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPackageInfoSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPackageInfoSource>(value),
    );
  }
}

String _$appPackageInfoSourceHash() =>
    r'153a6c2f2ac8b13f7328a2d4880cb7340d7e2dd1';

@ProviderFor(appPackageVersion)
final appPackageVersionProvider = AppPackageVersionProvider._();

final class AppPackageVersionProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppPackageVersion>,
          AppPackageVersion,
          FutureOr<AppPackageVersion>
        >
    with
        $FutureModifier<AppPackageVersion>,
        $FutureProvider<AppPackageVersion> {
  AppPackageVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPackageVersionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPackageVersionHash();

  @$internal
  @override
  $FutureProviderElement<AppPackageVersion> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppPackageVersion> create(Ref ref) {
    return appPackageVersion(ref);
  }
}

String _$appPackageVersionHash() => r'47f16dab7bed22dbb7cfbace8470f9f950580b33';
