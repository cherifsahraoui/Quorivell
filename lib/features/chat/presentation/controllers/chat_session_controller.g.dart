// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatSessionController)
final chatSessionControllerProvider = ChatSessionControllerProvider._();

final class ChatSessionControllerProvider
    extends $NotifierProvider<ChatSessionController, ChatSessionState> {
  ChatSessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionControllerHash();

  @$internal
  @override
  ChatSessionController create() => ChatSessionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSessionState>(value),
    );
  }
}

String _$chatSessionControllerHash() =>
    r'84ebb4dcf9f26a4e5a178f4a30293827cd77aa8e';

abstract class _$ChatSessionController extends $Notifier<ChatSessionState> {
  ChatSessionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ChatSessionState, ChatSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatSessionState, ChatSessionState>,
              ChatSessionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
