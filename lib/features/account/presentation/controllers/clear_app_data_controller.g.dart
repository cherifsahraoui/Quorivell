// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clear_app_data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Debug-only wipe of Drift user content (ledger, conversations, review,
/// chat). Keeps local user scope, preferences, and AI consent.

@ProviderFor(ClearAppDataController)
final clearAppDataControllerProvider = ClearAppDataControllerProvider._();

/// Debug-only wipe of Drift user content (ledger, conversations, review,
/// chat). Keeps local user scope, preferences, and AI consent.
final class ClearAppDataControllerProvider
    extends $AsyncNotifierProvider<ClearAppDataController, void> {
  /// Debug-only wipe of Drift user content (ledger, conversations, review,
  /// chat). Keeps local user scope, preferences, and AI consent.
  ClearAppDataControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clearAppDataControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clearAppDataControllerHash();

  @$internal
  @override
  ClearAppDataController create() => ClearAppDataController();
}

String _$clearAppDataControllerHash() =>
    r'a8042c6e039359e2174e51484dac4ae4e323e93a';

/// Debug-only wipe of Drift user content (ledger, conversations, review,
/// chat). Keeps local user scope, preferences, and AI consent.

abstract class _$ClearAppDataController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
