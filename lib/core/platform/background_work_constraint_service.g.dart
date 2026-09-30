// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_work_constraint_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(backgroundWorkConstraintService)
final backgroundWorkConstraintServiceProvider =
    BackgroundWorkConstraintServiceProvider._();

final class BackgroundWorkConstraintServiceProvider
    extends
        $FunctionalProvider<
          BackgroundWorkConstraintService,
          BackgroundWorkConstraintService,
          BackgroundWorkConstraintService
        >
    with $Provider<BackgroundWorkConstraintService> {
  BackgroundWorkConstraintServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backgroundWorkConstraintServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backgroundWorkConstraintServiceHash();

  @$internal
  @override
  $ProviderElement<BackgroundWorkConstraintService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BackgroundWorkConstraintService create(Ref ref) {
    return backgroundWorkConstraintService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackgroundWorkConstraintService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackgroundWorkConstraintService>(
        value,
      ),
    );
  }
}

String _$backgroundWorkConstraintServiceHash() =>
    r'7daab2527c1b607d02d4f41d013b0136b37b9610';

/// Kept alive so Account battery guidance can refresh after returning from
/// system settings without disposing mid-flight.

@ProviderFor(BackgroundWorkConstraintController)
final backgroundWorkConstraintControllerProvider =
    BackgroundWorkConstraintControllerProvider._();

/// Kept alive so Account battery guidance can refresh after returning from
/// system settings without disposing mid-flight.
final class BackgroundWorkConstraintControllerProvider
    extends
        $AsyncNotifierProvider<
          BackgroundWorkConstraintController,
          BackgroundWorkConstraints
        > {
  /// Kept alive so Account battery guidance can refresh after returning from
  /// system settings without disposing mid-flight.
  BackgroundWorkConstraintControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backgroundWorkConstraintControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$backgroundWorkConstraintControllerHash();

  @$internal
  @override
  BackgroundWorkConstraintController create() =>
      BackgroundWorkConstraintController();
}

String _$backgroundWorkConstraintControllerHash() =>
    r'470928ad83982ba5aa6ad6a5db896d50416fac41';

/// Kept alive so Account battery guidance can refresh after returning from
/// system settings without disposing mid-flight.

abstract class _$BackgroundWorkConstraintController
    extends $AsyncNotifier<BackgroundWorkConstraints> {
  FutureOr<BackgroundWorkConstraints> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<BackgroundWorkConstraints>,
              BackgroundWorkConstraints
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<BackgroundWorkConstraints>,
                BackgroundWorkConstraints
              >,
              AsyncValue<BackgroundWorkConstraints>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
