// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_intent_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shareIntentService)
final shareIntentServiceProvider = ShareIntentServiceProvider._();

final class ShareIntentServiceProvider
    extends
        $FunctionalProvider<
          ShareIntentService,
          ShareIntentService,
          ShareIntentService
        >
    with $Provider<ShareIntentService> {
  ShareIntentServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareIntentServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareIntentServiceHash();

  @$internal
  @override
  $ProviderElement<ShareIntentService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShareIntentService create(Ref ref) {
    return shareIntentService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareIntentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareIntentService>(value),
    );
  }
}

String _$shareIntentServiceHash() =>
    r'0a36a3bd3734e3ceb8b2ec974dbc9956a729fb7f';
