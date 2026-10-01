// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_model_install_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalModelInstallController)
final localModelInstallControllerProvider =
    LocalModelInstallControllerProvider._();

final class LocalModelInstallControllerProvider
    extends
        $AsyncNotifierProvider<
          LocalModelInstallController,
          LocalModelInstallSnapshot
        > {
  LocalModelInstallControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localModelInstallControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localModelInstallControllerHash();

  @$internal
  @override
  LocalModelInstallController create() => LocalModelInstallController();
}

String _$localModelInstallControllerHash() =>
    r'237e7a0908b93b359623d2301fa2d4a9cb0d81a2';

abstract class _$LocalModelInstallController
    extends $AsyncNotifier<LocalModelInstallSnapshot> {
  FutureOr<LocalModelInstallSnapshot> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<LocalModelInstallSnapshot>,
              LocalModelInstallSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<LocalModelInstallSnapshot>,
                LocalModelInstallSnapshot
              >,
              AsyncValue<LocalModelInstallSnapshot>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
