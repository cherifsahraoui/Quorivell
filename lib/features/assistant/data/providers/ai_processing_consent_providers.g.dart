// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_processing_consent_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiProcessingConsentLocalDataSource)
final aiProcessingConsentLocalDataSourceProvider =
    AiProcessingConsentLocalDataSourceProvider._();

final class AiProcessingConsentLocalDataSourceProvider
    extends
        $FunctionalProvider<
          AiProcessingConsentLocalDataSource,
          AiProcessingConsentLocalDataSource,
          AiProcessingConsentLocalDataSource
        >
    with $Provider<AiProcessingConsentLocalDataSource> {
  AiProcessingConsentLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiProcessingConsentLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$aiProcessingConsentLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<AiProcessingConsentLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiProcessingConsentLocalDataSource create(Ref ref) {
    return aiProcessingConsentLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiProcessingConsentLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiProcessingConsentLocalDataSource>(
        value,
      ),
    );
  }
}

String _$aiProcessingConsentLocalDataSourceHash() =>
    r'8cceb63466339a3f98931aa82bd4abb1fffbd683';

@ProviderFor(aiProcessingConsentRepository)
final aiProcessingConsentRepositoryProvider =
    AiProcessingConsentRepositoryProvider._();

final class AiProcessingConsentRepositoryProvider
    extends
        $FunctionalProvider<
          AiProcessingConsentRepository,
          AiProcessingConsentRepository,
          AiProcessingConsentRepository
        >
    with $Provider<AiProcessingConsentRepository> {
  AiProcessingConsentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiProcessingConsentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiProcessingConsentRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiProcessingConsentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiProcessingConsentRepository create(Ref ref) {
    return aiProcessingConsentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiProcessingConsentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiProcessingConsentRepository>(
        value,
      ),
    );
  }
}

String _$aiProcessingConsentRepositoryHash() =>
    r'432898aaa7c4ddf74aabceaf063196e0b8570fce';
