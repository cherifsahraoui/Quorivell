// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_permission_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationPermissionService)
final notificationPermissionServiceProvider =
    NotificationPermissionServiceProvider._();

final class NotificationPermissionServiceProvider
    extends
        $FunctionalProvider<
          NotificationPermissionService,
          NotificationPermissionService,
          NotificationPermissionService
        >
    with $Provider<NotificationPermissionService> {
  NotificationPermissionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPermissionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPermissionServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationPermissionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationPermissionService create(Ref ref) {
    return notificationPermissionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationPermissionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationPermissionService>(
        value,
      ),
    );
  }
}

String _$notificationPermissionServiceHash() =>
    r'43c0368c0ab62ca67beb6b498f98bb94696e176c';

/// Kept alive so Allow after a dialog does not drop the notifier (autoDispose
/// would make [enableFromUi] return without requesting the OS permission).
/// Refreshes on resume so Account can hide the notice while granted and show
/// it again if the user later turns notifications off in system settings.

@ProviderFor(NotificationPermissionController)
final notificationPermissionControllerProvider =
    NotificationPermissionControllerProvider._();

/// Kept alive so Allow after a dialog does not drop the notifier (autoDispose
/// would make [enableFromUi] return without requesting the OS permission).
/// Refreshes on resume so Account can hide the notice while granted and show
/// it again if the user later turns notifications off in system settings.
final class NotificationPermissionControllerProvider
    extends
        $AsyncNotifierProvider<
          NotificationPermissionController,
          NotificationPermissionStatus
        > {
  /// Kept alive so Allow after a dialog does not drop the notifier (autoDispose
  /// would make [enableFromUi] return without requesting the OS permission).
  /// Refreshes on resume so Account can hide the notice while granted and show
  /// it again if the user later turns notifications off in system settings.
  NotificationPermissionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPermissionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPermissionControllerHash();

  @$internal
  @override
  NotificationPermissionController create() =>
      NotificationPermissionController();
}

String _$notificationPermissionControllerHash() =>
    r'0ae9f24be1b52c0fc4c75c8c07e5386553fdb19d';

/// Kept alive so Allow after a dialog does not drop the notifier (autoDispose
/// would make [enableFromUi] return without requesting the OS permission).
/// Refreshes on resume so Account can hide the notice while granted and show
/// it again if the user later turns notifications off in system settings.

abstract class _$NotificationPermissionController
    extends $AsyncNotifier<NotificationPermissionStatus> {
  FutureOr<NotificationPermissionStatus> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationPermissionStatus>,
              NotificationPermissionStatus
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationPermissionStatus>,
                NotificationPermissionStatus
              >,
              AsyncValue<NotificationPermissionStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
