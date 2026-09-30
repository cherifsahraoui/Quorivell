// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CaptureController)
final captureControllerProvider = CaptureControllerProvider._();

final class CaptureControllerProvider
    extends
        $NotifierProvider<CaptureController, AsyncValue<SourceConversation?>> {
  CaptureControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'captureControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$captureControllerHash();

  @$internal
  @override
  CaptureController create() => CaptureController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SourceConversation?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SourceConversation?>>(
        value,
      ),
    );
  }
}

String _$captureControllerHash() => r'0e7b371421412a906e25b3e2f6f3bd9656250ec2';

abstract class _$CaptureController
    extends $Notifier<AsyncValue<SourceConversation?>> {
  AsyncValue<SourceConversation?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SourceConversation?>,
              AsyncValue<SourceConversation?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SourceConversation?>,
                AsyncValue<SourceConversation?>
              >,
              AsyncValue<SourceConversation?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
