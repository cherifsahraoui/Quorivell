// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extraction_platform_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(extractionPlatformService)
final extractionPlatformServiceProvider = ExtractionPlatformServiceProvider._();

final class ExtractionPlatformServiceProvider
    extends
        $FunctionalProvider<
          ExtractionPlatformService,
          ExtractionPlatformService,
          ExtractionPlatformService
        >
    with $Provider<ExtractionPlatformService> {
  ExtractionPlatformServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionPlatformServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionPlatformServiceHash();

  @$internal
  @override
  $ProviderElement<ExtractionPlatformService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExtractionPlatformService create(Ref ref) {
    return extractionPlatformService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtractionPlatformService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtractionPlatformService>(value),
    );
  }
}

String _$extractionPlatformServiceHash() =>
    r'733423ca7175e7f2e5e29a282c807cc52e36006e';
