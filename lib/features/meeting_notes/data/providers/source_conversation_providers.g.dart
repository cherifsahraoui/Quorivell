// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_conversation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sourceConversationLocalDataSource)
final sourceConversationLocalDataSourceProvider =
    SourceConversationLocalDataSourceProvider._();

final class SourceConversationLocalDataSourceProvider
    extends
        $FunctionalProvider<
          SourceConversationLocalDataSource,
          SourceConversationLocalDataSource,
          SourceConversationLocalDataSource
        >
    with $Provider<SourceConversationLocalDataSource> {
  SourceConversationLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceConversationLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$sourceConversationLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<SourceConversationLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SourceConversationLocalDataSource create(Ref ref) {
    return sourceConversationLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SourceConversationLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SourceConversationLocalDataSource>(
        value,
      ),
    );
  }
}

String _$sourceConversationLocalDataSourceHash() =>
    r'5a625310ee723a47ee812b57709aef0e3f6aee3b';

@ProviderFor(sourceConversationRepository)
final sourceConversationRepositoryProvider =
    SourceConversationRepositoryProvider._();

final class SourceConversationRepositoryProvider
    extends
        $FunctionalProvider<
          SourceConversationRepository,
          SourceConversationRepository,
          SourceConversationRepository
        >
    with $Provider<SourceConversationRepository> {
  SourceConversationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceConversationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourceConversationRepositoryHash();

  @$internal
  @override
  $ProviderElement<SourceConversationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SourceConversationRepository create(Ref ref) {
    return sourceConversationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SourceConversationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SourceConversationRepository>(value),
    );
  }
}

String _$sourceConversationRepositoryHash() =>
    r'd3ca967d5d063794f0f2d260714b9b46a5c0efba';

/// Active history when [archivedOnly] is false; archived when true.

@ProviderFor(sourceConversations)
final sourceConversationsProvider = SourceConversationsFamily._();

/// Active history when [archivedOnly] is false; archived when true.

final class SourceConversationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SourceConversation>>,
          List<SourceConversation>,
          Stream<List<SourceConversation>>
        >
    with
        $FutureModifier<List<SourceConversation>>,
        $StreamProvider<List<SourceConversation>> {
  /// Active history when [archivedOnly] is false; archived when true.
  SourceConversationsProvider._({
    required SourceConversationsFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'sourceConversationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sourceConversationsHash();

  @override
  String toString() {
    return r'sourceConversationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SourceConversation>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SourceConversation>> create(Ref ref) {
    final argument = this.argument as bool;
    return sourceConversations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SourceConversationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sourceConversationsHash() =>
    r'63dab891297bfd144b2467ebfa603a941ac452b3';

/// Active history when [archivedOnly] is false; archived when true.

final class SourceConversationsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SourceConversation>>, bool> {
  SourceConversationsFamily._()
    : super(
        retry: null,
        name: r'sourceConversationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Active history when [archivedOnly] is false; archived when true.

  SourceConversationsProvider call(bool archivedOnly) =>
      SourceConversationsProvider._(argument: archivedOnly, from: this);

  @override
  String toString() => r'sourceConversationsProvider';
}

@ProviderFor(sourceConversationById)
final sourceConversationByIdProvider = SourceConversationByIdFamily._();

final class SourceConversationByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<SourceConversation?>,
          SourceConversation?,
          FutureOr<SourceConversation?>
        >
    with
        $FutureModifier<SourceConversation?>,
        $FutureProvider<SourceConversation?> {
  SourceConversationByIdProvider._({
    required SourceConversationByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sourceConversationByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sourceConversationByIdHash();

  @override
  String toString() {
    return r'sourceConversationByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SourceConversation?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SourceConversation?> create(Ref ref) {
    final argument = this.argument as String;
    return sourceConversationById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SourceConversationByIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sourceConversationByIdHash() =>
    r'38f5022c27532dc0b5c8d11bb106d8d8a4473280';

final class SourceConversationByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SourceConversation?>, String> {
  SourceConversationByIdFamily._()
    : super(
        retry: null,
        name: r'sourceConversationByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SourceConversationByIdProvider call(String id) =>
      SourceConversationByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'sourceConversationByIdProvider';
}
