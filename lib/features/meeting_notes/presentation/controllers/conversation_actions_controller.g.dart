// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConversationActionsController)
final conversationActionsControllerProvider =
    ConversationActionsControllerProvider._();

final class ConversationActionsControllerProvider
    extends $NotifierProvider<ConversationActionsController, void> {
  ConversationActionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationActionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationActionsControllerHash();

  @$internal
  @override
  ConversationActionsController create() => ConversationActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$conversationActionsControllerHash() =>
    r'c7b8795a433b24a1a9a795b8261363c6c185ebf4';

abstract class _$ConversationActionsController extends $Notifier<void> {
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
