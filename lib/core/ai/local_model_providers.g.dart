// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_model_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localModelSpec)
final localModelSpecProvider = LocalModelSpecProvider._();

final class LocalModelSpecProvider
    extends $FunctionalProvider<LocalModelSpec, LocalModelSpec, LocalModelSpec>
    with $Provider<LocalModelSpec> {
  LocalModelSpecProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localModelSpecProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localModelSpecHash();

  @$internal
  @override
  $ProviderElement<LocalModelSpec> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalModelSpec create(Ref ref) {
    return localModelSpec(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalModelSpec value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalModelSpec>(value),
    );
  }
}

String _$localModelSpecHash() => r'01583fec78a9fdac11a23fe34ce43e08f5c23ed4';

@ProviderFor(localModelStore)
final localModelStoreProvider = LocalModelStoreProvider._();

final class LocalModelStoreProvider
    extends
        $FunctionalProvider<LocalModelStore, LocalModelStore, LocalModelStore>
    with $Provider<LocalModelStore> {
  LocalModelStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localModelStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localModelStoreHash();

  @$internal
  @override
  $ProviderElement<LocalModelStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalModelStore create(Ref ref) {
    return localModelStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalModelStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalModelStore>(value),
    );
  }
}

String _$localModelStoreHash() => r'b22265f6b04b550dd951004ec57437d88c75ebe9';

@ProviderFor(localModelDownloader)
final localModelDownloaderProvider = LocalModelDownloaderProvider._();

final class LocalModelDownloaderProvider
    extends
        $FunctionalProvider<
          LocalModelDownloader,
          LocalModelDownloader,
          LocalModelDownloader
        >
    with $Provider<LocalModelDownloader> {
  LocalModelDownloaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localModelDownloaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localModelDownloaderHash();

  @$internal
  @override
  $ProviderElement<LocalModelDownloader> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalModelDownloader create(Ref ref) {
    return localModelDownloader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalModelDownloader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalModelDownloader>(value),
    );
  }
}

String _$localModelDownloaderHash() =>
    r'd48022f9404493431967aea5ef4fc52d943aecee';
