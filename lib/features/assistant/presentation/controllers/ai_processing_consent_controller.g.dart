// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_processing_consent_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiProcessingConsentController)
final aiProcessingConsentControllerProvider =
    AiProcessingConsentControllerProvider._();

final class AiProcessingConsentControllerProvider
    extends
        $AsyncNotifierProvider<
          AiProcessingConsentController,
          AiProcessingConsent
        > {
  AiProcessingConsentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiProcessingConsentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiProcessingConsentControllerHash();

  @$internal
  @override
  AiProcessingConsentController create() => AiProcessingConsentController();
}

String _$aiProcessingConsentControllerHash() =>
    r'1c1cc9b02ee5f3c53cff2ae1c4447e825626444a';

abstract class _$AiProcessingConsentController
    extends $AsyncNotifier<AiProcessingConsent> {
  FutureOr<AiProcessingConsent> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AiProcessingConsent>, AiProcessingConsent>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiProcessingConsent>, AiProcessingConsent>,
              AsyncValue<AiProcessingConsent>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
