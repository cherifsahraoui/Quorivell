// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_capability_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceCapabilityService)
final deviceCapabilityServiceProvider = DeviceCapabilityServiceProvider._();

final class DeviceCapabilityServiceProvider
    extends
        $FunctionalProvider<
          DeviceCapabilityService,
          DeviceCapabilityService,
          DeviceCapabilityService
        >
    with $Provider<DeviceCapabilityService> {
  DeviceCapabilityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceCapabilityServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceCapabilityServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceCapabilityService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceCapabilityService create(Ref ref) {
    return deviceCapabilityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceCapabilityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceCapabilityService>(value),
    );
  }
}

String _$deviceCapabilityServiceHash() =>
    r'd94352264843437556725c82c68c7e8cc04e441c';

@ProviderFor(deviceCapability)
final deviceCapabilityProvider = DeviceCapabilityProvider._();

final class DeviceCapabilityProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeviceCapability>,
          DeviceCapability,
          FutureOr<DeviceCapability>
        >
    with $FutureModifier<DeviceCapability>, $FutureProvider<DeviceCapability> {
  DeviceCapabilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceCapabilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceCapabilityHash();

  @$internal
  @override
  $FutureProviderElement<DeviceCapability> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DeviceCapability> create(Ref ref) {
    return deviceCapability(ref);
  }
}

String _$deviceCapabilityHash() => r'8fbb1e044cb374e78d5fc3122071706767b90f76';
