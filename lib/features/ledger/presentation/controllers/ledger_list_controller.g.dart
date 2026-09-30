// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LedgerSearchQuery)
final ledgerSearchQueryProvider = LedgerSearchQueryProvider._();

final class LedgerSearchQueryProvider
    extends $NotifierProvider<LedgerSearchQuery, String> {
  LedgerSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerSearchQueryHash();

  @$internal
  @override
  LedgerSearchQuery create() => LedgerSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$ledgerSearchQueryHash() => r'9f8ec5c0ae4663eaa246f69301b98f5a939db113';

abstract class _$LedgerSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(LedgerKindFilterController)
final ledgerKindFilterControllerProvider =
    LedgerKindFilterControllerProvider._();

final class LedgerKindFilterControllerProvider
    extends $NotifierProvider<LedgerKindFilterController, LedgerKindFilter> {
  LedgerKindFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerKindFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerKindFilterControllerHash();

  @$internal
  @override
  LedgerKindFilterController create() => LedgerKindFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LedgerKindFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LedgerKindFilter>(value),
    );
  }
}

String _$ledgerKindFilterControllerHash() =>
    r'552c572b9b6eff89d24782de3b1ef89d311c2c10';

abstract class _$LedgerKindFilterController
    extends $Notifier<LedgerKindFilter> {
  LedgerKindFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LedgerKindFilter, LedgerKindFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LedgerKindFilter, LedgerKindFilter>,
              LedgerKindFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(LedgerStatusFilterController)
final ledgerStatusFilterControllerProvider =
    LedgerStatusFilterControllerProvider._();

final class LedgerStatusFilterControllerProvider
    extends
        $NotifierProvider<LedgerStatusFilterController, LedgerStatusFilter> {
  LedgerStatusFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerStatusFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerStatusFilterControllerHash();

  @$internal
  @override
  LedgerStatusFilterController create() => LedgerStatusFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LedgerStatusFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LedgerStatusFilter>(value),
    );
  }
}

String _$ledgerStatusFilterControllerHash() =>
    r'fba08822f375dccc54387d1f79a278e38679c3a9';

abstract class _$LedgerStatusFilterController
    extends $Notifier<LedgerStatusFilter> {
  LedgerStatusFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LedgerStatusFilter, LedgerStatusFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LedgerStatusFilter, LedgerStatusFilter>,
              LedgerStatusFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Owns ledger search and filters so the page only renders what it is given.
///
/// Filter and search live in their own providers, so changing them re-runs the
/// in-memory filter without resubscribing to the underlying database stream.

@ProviderFor(LedgerListController)
final ledgerListControllerProvider = LedgerListControllerProvider._();

/// Owns ledger search and filters so the page only renders what it is given.
///
/// Filter and search live in their own providers, so changing them re-runs the
/// in-memory filter without resubscribing to the underlying database stream.
final class LedgerListControllerProvider
    extends
        $NotifierProvider<LedgerListController, AsyncValue<LedgerListState>> {
  /// Owns ledger search and filters so the page only renders what it is given.
  ///
  /// Filter and search live in their own providers, so changing them re-runs the
  /// in-memory filter without resubscribing to the underlying database stream.
  LedgerListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerListControllerHash();

  @$internal
  @override
  LedgerListController create() => LedgerListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<LedgerListState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<LedgerListState>>(value),
    );
  }
}

String _$ledgerListControllerHash() =>
    r'ab3a3c8184d67c21a6998736708f61da5cc92b2c';

/// Owns ledger search and filters so the page only renders what it is given.
///
/// Filter and search live in their own providers, so changing them re-runs the
/// in-memory filter without resubscribing to the underlying database stream.

abstract class _$LedgerListController
    extends $Notifier<AsyncValue<LedgerListState>> {
  AsyncValue<LedgerListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<LedgerListState>, AsyncValue<LedgerListState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<LedgerListState>,
                AsyncValue<LedgerListState>
              >,
              AsyncValue<LedgerListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
