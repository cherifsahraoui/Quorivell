// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_share_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds one pending Android share until the user saves or discards it.
///
/// Sharing never extracts or syncs; [CaptureController] persists locally.

@ProviderFor(IncomingShareController)
final incomingShareControllerProvider = IncomingShareControllerProvider._();

/// Holds one pending Android share until the user saves or discards it.
///
/// Sharing never extracts or syncs; [CaptureController] persists locally.
final class IncomingShareControllerProvider
    extends $NotifierProvider<IncomingShareController, IncomingSharePayload?> {
  /// Holds one pending Android share until the user saves or discards it.
  ///
  /// Sharing never extracts or syncs; [CaptureController] persists locally.
  IncomingShareControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomingShareControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomingShareControllerHash();

  @$internal
  @override
  IncomingShareController create() => IncomingShareController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IncomingSharePayload? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IncomingSharePayload?>(value),
    );
  }
}

String _$incomingShareControllerHash() =>
    r'55aa659a95e93af4a4e86f00d1aba5f4ae74790f';

/// Holds one pending Android share until the user saves or discards it.
///
/// Sharing never extracts or syncs; [CaptureController] persists locally.

abstract class _$IncomingShareController
    extends $Notifier<IncomingSharePayload?> {
  IncomingSharePayload? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<IncomingSharePayload?, IncomingSharePayload?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IncomingSharePayload?, IncomingSharePayload?>,
              IncomingSharePayload?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
