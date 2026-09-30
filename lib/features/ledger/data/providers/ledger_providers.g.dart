// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ledgerLocalDataSource)
final ledgerLocalDataSourceProvider = LedgerLocalDataSourceProvider._();

final class LedgerLocalDataSourceProvider
    extends
        $FunctionalProvider<
          LedgerLocalDataSource,
          LedgerLocalDataSource,
          LedgerLocalDataSource
        >
    with $Provider<LedgerLocalDataSource> {
  LedgerLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<LedgerLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LedgerLocalDataSource create(Ref ref) {
    return ledgerLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LedgerLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LedgerLocalDataSource>(value),
    );
  }
}

String _$ledgerLocalDataSourceHash() =>
    r'451095b723501dd58a19b5e3a41a769c976151dd';

@ProviderFor(ledgerRepository)
final ledgerRepositoryProvider = LedgerRepositoryProvider._();

final class LedgerRepositoryProvider
    extends
        $FunctionalProvider<
          LedgerRepository,
          LedgerRepository,
          LedgerRepository
        >
    with $Provider<LedgerRepository> {
  LedgerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerRepositoryHash();

  @$internal
  @override
  $ProviderElement<LedgerRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LedgerRepository create(Ref ref) {
    return ledgerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LedgerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LedgerRepository>(value),
    );
  }
}

String _$ledgerRepositoryHash() => r'2c0402788f87c1e6973c6448638cc3344ece75f5';

/// All non-deleted ledger items for the local user (decisions + commitments).

@ProviderFor(ledgerItems)
final ledgerItemsProvider = LedgerItemsProvider._();

/// All non-deleted ledger items for the local user (decisions + commitments).

final class LedgerItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LedgerItem>>,
          List<LedgerItem>,
          Stream<List<LedgerItem>>
        >
    with $FutureModifier<List<LedgerItem>>, $StreamProvider<List<LedgerItem>> {
  /// All non-deleted ledger items for the local user (decisions + commitments).
  LedgerItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<LedgerItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LedgerItem>> create(Ref ref) {
    return ledgerItems(ref);
  }
}

String _$ledgerItemsHash() => r'e0bb711527b4b84ffc4c91b545d9eb4dedd68fd1';

@ProviderFor(openCommitments)
final openCommitmentsProvider = OpenCommitmentsProvider._();

final class OpenCommitmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LedgerItem>>,
          List<LedgerItem>,
          Stream<List<LedgerItem>>
        >
    with $FutureModifier<List<LedgerItem>>, $StreamProvider<List<LedgerItem>> {
  OpenCommitmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openCommitmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openCommitmentsHash();

  @$internal
  @override
  $StreamProviderElement<List<LedgerItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LedgerItem>> create(Ref ref) {
    return openCommitments(ref);
  }
}

String _$openCommitmentsHash() => r'ea5bba51015a0342a32da3724e9a9611cd586b58';

@ProviderFor(ledgerItemById)
final ledgerItemByIdProvider = LedgerItemByIdFamily._();

final class LedgerItemByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<LedgerItem?>,
          LedgerItem?,
          Stream<LedgerItem?>
        >
    with $FutureModifier<LedgerItem?>, $StreamProvider<LedgerItem?> {
  LedgerItemByIdProvider._({
    required LedgerItemByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ledgerItemByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ledgerItemByIdHash();

  @override
  String toString() {
    return r'ledgerItemByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<LedgerItem?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<LedgerItem?> create(Ref ref) {
    final argument = this.argument as String;
    return ledgerItemById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LedgerItemByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ledgerItemByIdHash() => r'53b92d62d217cec40008a8d9934b25832fefc37d';

final class LedgerItemByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<LedgerItem?>, String> {
  LedgerItemByIdFamily._()
    : super(
        retry: null,
        name: r'ledgerItemByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LedgerItemByIdProvider call(String id) =>
      LedgerItemByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'ledgerItemByIdProvider';
}

@ProviderFor(ledgerEvidence)
final ledgerEvidenceProvider = LedgerEvidenceFamily._();

final class LedgerEvidenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EvidenceReference>>,
          List<EvidenceReference>,
          Stream<List<EvidenceReference>>
        >
    with
        $FutureModifier<List<EvidenceReference>>,
        $StreamProvider<List<EvidenceReference>> {
  LedgerEvidenceProvider._({
    required LedgerEvidenceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ledgerEvidenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ledgerEvidenceHash();

  @override
  String toString() {
    return r'ledgerEvidenceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<EvidenceReference>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<EvidenceReference>> create(Ref ref) {
    final argument = this.argument as String;
    return ledgerEvidence(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LedgerEvidenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ledgerEvidenceHash() => r'8df56f10dc98edd0d651777b47611c9dde559bf6';

final class LedgerEvidenceFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<EvidenceReference>>, String> {
  LedgerEvidenceFamily._()
    : super(
        retry: null,
        name: r'ledgerEvidenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LedgerEvidenceProvider call(String ledgerItemId) =>
      LedgerEvidenceProvider._(argument: ledgerItemId, from: this);

  @override
  String toString() => r'ledgerEvidenceProvider';
}
