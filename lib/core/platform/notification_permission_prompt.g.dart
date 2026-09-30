// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_permission_prompt.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Device-local flag (SharedPreferences), same pattern as onboarding.
///
/// Kept alive so one-shot shell reads do not drop mid-load.

@ProviderFor(NotificationPermissionPromptDecisionController)
final notificationPermissionPromptDecisionControllerProvider =
    NotificationPermissionPromptDecisionControllerProvider._();

/// Device-local flag (SharedPreferences), same pattern as onboarding.
///
/// Kept alive so one-shot shell reads do not drop mid-load.
final class NotificationPermissionPromptDecisionControllerProvider
    extends
        $AsyncNotifierProvider<
          NotificationPermissionPromptDecisionController,
          NotificationPermissionPromptDecision
        > {
  /// Device-local flag (SharedPreferences), same pattern as onboarding.
  ///
  /// Kept alive so one-shot shell reads do not drop mid-load.
  NotificationPermissionPromptDecisionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPermissionPromptDecisionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$notificationPermissionPromptDecisionControllerHash();

  @$internal
  @override
  NotificationPermissionPromptDecisionController create() =>
      NotificationPermissionPromptDecisionController();
}

String _$notificationPermissionPromptDecisionControllerHash() =>
    r'25d72a4335c903ce2ff68afa3202862dbe5c3ab4';

/// Device-local flag (SharedPreferences), same pattern as onboarding.
///
/// Kept alive so one-shot shell reads do not drop mid-load.

abstract class _$NotificationPermissionPromptDecisionController
    extends $AsyncNotifier<NotificationPermissionPromptDecision> {
  FutureOr<NotificationPermissionPromptDecision> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationPermissionPromptDecision>,
              NotificationPermissionPromptDecision
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationPermissionPromptDecision>,
                NotificationPermissionPromptDecision
              >,
              AsyncValue<NotificationPermissionPromptDecision>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
