// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_generation_hold_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// True while Chat holds the shared Android dataSync foreground service.
///
/// Extraction resume must not cancel that shade while a reply is still
/// generating. Kept in its own provider so Review can read it without
/// importing [ChatSessionController].

@ProviderFor(ChatGenerationHoldController)
final chatGenerationHoldControllerProvider =
    ChatGenerationHoldControllerProvider._();

/// True while Chat holds the shared Android dataSync foreground service.
///
/// Extraction resume must not cancel that shade while a reply is still
/// generating. Kept in its own provider so Review can read it without
/// importing [ChatSessionController].
final class ChatGenerationHoldControllerProvider
    extends $NotifierProvider<ChatGenerationHoldController, bool> {
  /// True while Chat holds the shared Android dataSync foreground service.
  ///
  /// Extraction resume must not cancel that shade while a reply is still
  /// generating. Kept in its own provider so Review can read it without
  /// importing [ChatSessionController].
  ChatGenerationHoldControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatGenerationHoldControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatGenerationHoldControllerHash();

  @$internal
  @override
  ChatGenerationHoldController create() => ChatGenerationHoldController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatGenerationHoldControllerHash() =>
    r'39d5f02c180d119bf224fcf3f5df8a0f94994fad';

/// True while Chat holds the shared Android dataSync foreground service.
///
/// Extraction resume must not cancel that shade while a reply is still
/// generating. Kept in its own provider so Review can read it without
/// importing [ChatSessionController].

abstract class _$ChatGenerationHoldController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
