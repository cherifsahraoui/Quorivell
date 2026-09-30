// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extraction_item_kind_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(extractionItemKindLocalDataSource)
final extractionItemKindLocalDataSourceProvider =
    ExtractionItemKindLocalDataSourceProvider._();

final class ExtractionItemKindLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ExtractionItemKindLocalDataSource,
          ExtractionItemKindLocalDataSource,
          ExtractionItemKindLocalDataSource
        >
    with $Provider<ExtractionItemKindLocalDataSource> {
  ExtractionItemKindLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionItemKindLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$extractionItemKindLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExtractionItemKindLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExtractionItemKindLocalDataSource create(Ref ref) {
    return extractionItemKindLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtractionItemKindLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtractionItemKindLocalDataSource>(
        value,
      ),
    );
  }
}

String _$extractionItemKindLocalDataSourceHash() =>
    r'f3b7b3a7a347b314752f9d5bb59415dab194ae31';

@ProviderFor(extractionItemKindRepository)
final extractionItemKindRepositoryProvider =
    ExtractionItemKindRepositoryProvider._();

final class ExtractionItemKindRepositoryProvider
    extends
        $FunctionalProvider<
          ExtractionItemKindRepository,
          ExtractionItemKindRepository,
          ExtractionItemKindRepository
        >
    with $Provider<ExtractionItemKindRepository> {
  ExtractionItemKindRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionItemKindRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionItemKindRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExtractionItemKindRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExtractionItemKindRepository create(Ref ref) {
    return extractionItemKindRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtractionItemKindRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtractionItemKindRepository>(value),
    );
  }
}

String _$extractionItemKindRepositoryHash() =>
    r'dfd1c680be877a6da484d50766333538cc675164';

@ProviderFor(extractionItemKinds)
final extractionItemKindsProvider = ExtractionItemKindsProvider._();

final class ExtractionItemKindsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ExtractionItemKind>>,
          List<ExtractionItemKind>,
          Stream<List<ExtractionItemKind>>
        >
    with
        $FutureModifier<List<ExtractionItemKind>>,
        $StreamProvider<List<ExtractionItemKind>> {
  ExtractionItemKindsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractionItemKindsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractionItemKindsHash();

  @$internal
  @override
  $StreamProviderElement<List<ExtractionItemKind>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ExtractionItemKind>> create(Ref ref) {
    return extractionItemKinds(ref);
  }
}

String _$extractionItemKindsHash() =>
    r'065f3670dece050eb75558fdfc1c3f139d283be6';

@ProviderFor(enabledExtractionItemKinds)
final enabledExtractionItemKindsProvider =
    EnabledExtractionItemKindsProvider._();

final class EnabledExtractionItemKindsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ExtractionItemKind>>,
          List<ExtractionItemKind>,
          Stream<List<ExtractionItemKind>>
        >
    with
        $FutureModifier<List<ExtractionItemKind>>,
        $StreamProvider<List<ExtractionItemKind>> {
  EnabledExtractionItemKindsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enabledExtractionItemKindsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enabledExtractionItemKindsHash();

  @$internal
  @override
  $StreamProviderElement<List<ExtractionItemKind>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ExtractionItemKind>> create(Ref ref) {
    return enabledExtractionItemKinds(ref);
  }
}

String _$enabledExtractionItemKindsHash() =>
    r'fc7d95b0645cf09964ec56ce13dfd59f948fc0b2';
