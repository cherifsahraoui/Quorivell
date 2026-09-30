// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_history_filter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConversationHistoryFilterController)
final conversationHistoryFilterControllerProvider =
    ConversationHistoryFilterControllerProvider._();

final class ConversationHistoryFilterControllerProvider
    extends
        $NotifierProvider<
          ConversationHistoryFilterController,
          ConversationHistoryFilter
        > {
  ConversationHistoryFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationHistoryFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$conversationHistoryFilterControllerHash();

  @$internal
  @override
  ConversationHistoryFilterController create() =>
      ConversationHistoryFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationHistoryFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationHistoryFilter>(value),
    );
  }
}

String _$conversationHistoryFilterControllerHash() =>
    r'072a05539b496462f338444b3b5323acbfa331af';

abstract class _$ConversationHistoryFilterController
    extends $Notifier<ConversationHistoryFilter> {
  ConversationHistoryFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<ConversationHistoryFilter, ConversationHistoryFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConversationHistoryFilter, ConversationHistoryFilter>,
              ConversationHistoryFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
