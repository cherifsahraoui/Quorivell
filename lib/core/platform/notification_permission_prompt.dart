import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_permission_prompt.g.dart';

const notificationPermissionPromptDecisionKey =
    'notification_permission_prompt_decision';

/// Durable app-level choice for the startup notification rationale.
///
/// Distinct from OS permission status: tapping **Not now** leaves the OS
/// undecided/denied but must stop cold-start prompts.
enum NotificationPermissionPromptDecision {
  /// User has never answered Allow or Not now in-app.
  neverAsked,

  /// User dismissed with Not now; startup prompt stays off.
  deferred,

  /// User tapped Allow (system request was shown), regardless of grant/deny.
  requested,
}

NotificationPermissionPromptDecision parseNotificationPermissionPromptDecision(
  String? raw,
) {
  switch (raw) {
    case 'deferred':
      return NotificationPermissionPromptDecision.deferred;
    case 'requested':
      return NotificationPermissionPromptDecision.requested;
    case 'neverAsked':
    default:
      return NotificationPermissionPromptDecision.neverAsked;
  }
}

String notificationPermissionPromptDecisionStorageValue(
  NotificationPermissionPromptDecision decision,
) {
  switch (decision) {
    case NotificationPermissionPromptDecision.neverAsked:
      return 'neverAsked';
    case NotificationPermissionPromptDecision.deferred:
      return 'deferred';
    case NotificationPermissionPromptDecision.requested:
      return 'requested';
  }
}

/// Device-local flag (SharedPreferences), same pattern as onboarding.
///
/// Kept alive so one-shot shell reads do not drop mid-load.
@Riverpod(keepAlive: true)
class NotificationPermissionPromptDecisionController
    extends _$NotificationPermissionPromptDecisionController {
  @override
  Future<NotificationPermissionPromptDecision> build() async {
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) {
      return NotificationPermissionPromptDecision.neverAsked;
    }
    return parseNotificationPermissionPromptDecision(
      prefs.getString(notificationPermissionPromptDecisionKey),
    );
  }

  Future<void> markDeferred() =>
      _persist(NotificationPermissionPromptDecision.deferred);

  Future<void> markRequested() =>
      _persist(NotificationPermissionPromptDecision.requested);

  Future<void> _persist(NotificationPermissionPromptDecision decision) async {
    // Wait for [build] so an in-flight load cannot overwrite this write.
    await future;
    if (!ref.mounted) return;
    state = AsyncValue.data(decision);
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) return;
    await prefs.setString(
      notificationPermissionPromptDecisionKey,
      notificationPermissionPromptDecisionStorageValue(decision),
    );
  }
}
