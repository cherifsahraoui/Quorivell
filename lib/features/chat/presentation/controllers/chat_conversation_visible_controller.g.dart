// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation_visible_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatConversationVisibleController)
final chatConversationVisibleControllerProvider =
    ChatConversationVisibleControllerProvider._();

final class ChatConversationVisibleControllerProvider
    extends $NotifierProvider<ChatConversationVisibleController, bool> {
  ChatConversationVisibleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatConversationVisibleControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$chatConversationVisibleControllerHash();

  @$internal
  @override
  ChatConversationVisibleController create() =>
      ChatConversationVisibleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatConversationVisibleControllerHash() =>
    r'ad27b58f55cd696a007e443eeb20f5bfe854e777';

abstract class _$ChatConversationVisibleController extends $Notifier<bool> {
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
