// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extraction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localAIService)
final localAIServiceProvider = LocalAIServiceProvider._();

final class LocalAIServiceProvider
    extends $FunctionalProvider<LocalAIService, LocalAIService, LocalAIService>
    with $Provider<LocalAIService> {
  LocalAIServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAIServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAIServiceHash();

  @$internal
  @override
  $ProviderElement<LocalAIService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalAIService create(Ref ref) {
    return localAIService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalAIService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalAIService>(value),
    );
  }
}

String _$localAIServiceHash() => r'2daa1e144417ab4ee957dde6fa94c4b3def48fa4';

@ProviderFor(extractionLocalDataSource)
final extractionLocalDataSourceProvider = ExtractionLocalDataSourceProvider._();

final class ExtractionLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ExtractionLocalDataSource,
          ExtractionLocalDataSource,
          ExtractionLocalDataSource
        >
    with $Provider<ExtractionLocalDataSource> {
  ExtractionLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExtractionLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExtractionLocalDataSource create(Ref ref) {
    return extractionLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtractionLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtractionLocalDataSource>(value),
    );
  }
}

String _$extractionLocalDataSourceHash() =>
    r'b0730ab9fe56d287047437e0beb42dba9ce2622b';

@ProviderFor(extractionRepository)
final extractionRepositoryProvider = ExtractionRepositoryProvider._();

final class ExtractionRepositoryProvider
    extends
        $FunctionalProvider<
          ExtractionRepository,
          ExtractionRepository,
          ExtractionRepository
        >
    with $Provider<ExtractionRepository> {
  ExtractionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExtractionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExtractionRepository create(Ref ref) {
    return extractionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtractionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtractionRepository>(value),
    );
  }
}

String _$extractionRepositoryHash() =>
    r'fb37caa39d52c05ef75112d488be07afc91e4a11';

@ProviderFor(extractionRunRepository)
final extractionRunRepositoryProvider = ExtractionRunRepositoryProvider._();

final class ExtractionRunRepositoryProvider
    extends
        $FunctionalProvider<
          ExtractionRunRepository,
          ExtractionRunRepository,
          ExtractionRunRepository
        >
    with $Provider<ExtractionRunRepository> {
  ExtractionRunRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionRunRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionRunRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExtractionRunRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExtractionRunRepository create(Ref ref) {
    return extractionRunRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtractionRunRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtractionRunRepository>(value),
    );
  }
}

String _$extractionRunRepositoryHash() =>
    r'81b82232f64602e2e140022b1753556bb8005870';
