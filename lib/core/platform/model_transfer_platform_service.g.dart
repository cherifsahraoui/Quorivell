// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_transfer_platform_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(modelTransferPlatformService)
final modelTransferPlatformServiceProvider =
    ModelTransferPlatformServiceProvider._();

final class ModelTransferPlatformServiceProvider
    extends
        $FunctionalProvider<
          ModelTransferPlatformService,
          ModelTransferPlatformService,
          ModelTransferPlatformService
        >
    with $Provider<ModelTransferPlatformService> {
  ModelTransferPlatformServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelTransferPlatformServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelTransferPlatformServiceHash();

  @$internal
  @override
  $ProviderElement<ModelTransferPlatformService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ModelTransferPlatformService create(Ref ref) {
    return modelTransferPlatformService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ModelTransferPlatformService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ModelTransferPlatformService>(value),
    );
  }
}

String _$modelTransferPlatformServiceHash() =>
    r'6bcdce2586c28b52adbbc8463c1e04100254dcd0';
