// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LedgerActionsController)
final ledgerActionsControllerProvider = LedgerActionsControllerProvider._();

final class LedgerActionsControllerProvider
    extends $NotifierProvider<LedgerActionsController, void> {
  LedgerActionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerActionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerActionsControllerHash();

  @$internal
  @override
  LedgerActionsController create() => LedgerActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$ledgerActionsControllerHash() =>
    r'727710901acb4aaa55c2eb54aa8c07340f31a639';

abstract class _$LedgerActionsController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
