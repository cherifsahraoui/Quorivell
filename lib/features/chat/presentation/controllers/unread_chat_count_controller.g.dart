// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_chat_count_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Count of Chat replies finished while the transcript was off-screen.
///
/// Session-scoped (not persisted). Generation is one reply at a time, so
/// the badge is almost always `0` or `1`. Opening the live transcript
/// clears the count.

@ProviderFor(UnreadChatCountController)
final unreadChatCountControllerProvider = UnreadChatCountControllerProvider._();

/// Count of Chat replies finished while the transcript was off-screen.
///
/// Session-scoped (not persisted). Generation is one reply at a time, so
/// the badge is almost always `0` or `1`. Opening the live transcript
/// clears the count.
final class UnreadChatCountControllerProvider
    extends $NotifierProvider<UnreadChatCountController, int> {
  /// Count of Chat replies finished while the transcript was off-screen.
  ///
  /// Session-scoped (not persisted). Generation is one reply at a time, so
  /// the badge is almost always `0` or `1`. Opening the live transcript
  /// clears the count.
  UnreadChatCountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadChatCountControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadChatCountControllerHash();

  @$internal
  @override
  UnreadChatCountController create() => UnreadChatCountController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadChatCountControllerHash() =>
    r'9904d9d07a34a3967ade302a478424e9a6170b3d';

/// Count of Chat replies finished while the transcript was off-screen.
///
/// Session-scoped (not persisted). Generation is one reply at a time, so
/// the badge is almost always `0` or `1`. Opening the live transcript
/// clears the count.

abstract class _$UnreadChatCountController extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
