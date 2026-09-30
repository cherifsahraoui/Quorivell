// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatLocalDataSource)
final chatLocalDataSourceProvider = ChatLocalDataSourceProvider._();

final class ChatLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ChatLocalDataSource,
          ChatLocalDataSource,
          ChatLocalDataSource
        >
    with $Provider<ChatLocalDataSource> {
  ChatLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ChatLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatLocalDataSource create(Ref ref) {
    return chatLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatLocalDataSource>(value),
    );
  }
}

String _$chatLocalDataSourceHash() =>
    r'cc42abd6bcfcb53441fe58feea50c91e1234a99b';

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'b79ed71cf5869dcd22b09707b8b7a8ce9dfa3af3';

@ProviderFor(chatThreads)
final chatThreadsProvider = ChatThreadsProvider._();

final class ChatThreadsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AiChatThread>>,
          List<AiChatThread>,
          Stream<List<AiChatThread>>
        >
    with
        $FutureModifier<List<AiChatThread>>,
        $StreamProvider<List<AiChatThread>> {
  ChatThreadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatThreadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatThreadsHash();

  @$internal
  @override
  $StreamProviderElement<List<AiChatThread>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AiChatThread>> create(Ref ref) {
    return chatThreads(ref);
  }
}

String _$chatThreadsHash() => r'a6deeee3d97786a1e0d35c5187ab11a4a1652af6';

@ProviderFor(chatThreadById)
final chatThreadByIdProvider = ChatThreadByIdFamily._();

final class ChatThreadByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<AiChatThread?>,
          AiChatThread?,
          Stream<AiChatThread?>
        >
    with $FutureModifier<AiChatThread?>, $StreamProvider<AiChatThread?> {
  ChatThreadByIdProvider._({
    required ChatThreadByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatThreadByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatThreadByIdHash();

  @override
  String toString() {
    return r'chatThreadByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<AiChatThread?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AiChatThread?> create(Ref ref) {
    final argument = this.argument as String;
    return chatThreadById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatThreadByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatThreadByIdHash() => r'a0d59d5df98bcf684e18db1e10f5102e14fa961a';

final class ChatThreadByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<AiChatThread?>, String> {
  ChatThreadByIdFamily._()
    : super(
        retry: null,
        name: r'chatThreadByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatThreadByIdProvider call(String id) =>
      ChatThreadByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'chatThreadByIdProvider';
}

@ProviderFor(chatMessages)
final chatMessagesProvider = ChatMessagesFamily._();

final class ChatMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AiChatMessage>>,
          List<AiChatMessage>,
          Stream<List<AiChatMessage>>
        >
    with
        $FutureModifier<List<AiChatMessage>>,
        $StreamProvider<List<AiChatMessage>> {
  ChatMessagesProvider._({
    required ChatMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<AiChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AiChatMessage>> create(Ref ref) {
    final argument = this.argument as String;
    return chatMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'a908836728fbc6bced37a698a266b187d51bfaea';

final class ChatMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<AiChatMessage>>, String> {
  ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatMessagesProvider call(String threadId) =>
      ChatMessagesProvider._(argument: threadId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}
