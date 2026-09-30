import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_spacing.dart';
import 'notification_permission_prompt.dart';
import 'notification_permission_service.dart';

/// Soft-dialog exit animation is ~200ms; wait past it before the OS sheet.
const _kSoftDialogSettle = Duration(milliseconds: 350);

/// After the soft [AlertDialog] pops, wait for its route to finish before the
/// Android runtime permission sheet. Requesting during the transition often
/// returns immediately with denied and never shows UI.
///
/// Calls the platform [NotificationPermissionService] directly so a disposed
/// autoDispose notifier cannot skip the OS request (download would then start).
Future<void> _requestAfterSoftDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final service = ref.read(notificationPermissionServiceProvider);
  final promptNotifier = ref.read(
    notificationPermissionPromptDecisionControllerProvider.notifier,
  );
  final cached = ref.read(notificationPermissionControllerProvider).value;

  await Future<void>.delayed(_kSoftDialogSettle);

  if (cached == NotificationPermissionStatus.permanentlyDenied) {
    if (context.mounted) {
      await service.openSettings();
    }
    return;
  }

  await service.request();
  await promptNotifier.markRequested();
}

/// OS notification prompt with no Flutter dialog — for work already started.
///
/// Model download/copy must not wait on this; the system sheet remounts
/// `/model-setup` if it is shown first.
Future<void> requestNotificationPermissionIfNeeded(WidgetRef ref) async {
  final service = ref.read(notificationPermissionServiceProvider);
  final promptNotifier = ref.read(
    notificationPermissionPromptDecisionControllerProvider.notifier,
  );
  final status = await service.checkStatus();
  switch (status) {
    case NotificationPermissionStatus.granted:
    case NotificationPermissionStatus.notApplicable:
    case NotificationPermissionStatus.permanentlyDenied:
      return;
    case NotificationPermissionStatus.denied:
      break;
  }
  await Future<void>.delayed(_kSoftDialogSettle);
  await service.request();
  await promptNotifier.markRequested();
}

/// Cold-start rationale: Allow → system request; Not now → persist deferral.
///
/// Pops the soft dialog before requesting the OS permission. Requesting while
/// the [AlertDialog] is still up often swallows the Android 13+ system sheet;
/// the MethodChannel returns and callers continue as if the user had responded.
Future<void> showNotificationPermissionStartupDialog({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final l10n = AppLocalizations.of(context);
  final enable = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.accountNotificationPermissionTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.accountNotificationPermissionBody),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.accountNotificationPermissionReason),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.accountNotificationPermissionNotNow),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.accountNotificationPermissionAllow),
          ),
        ],
      );
    },
  );

  if (!context.mounted || enable == null) return;

  if (enable) {
    await _requestAfterSoftDialog(context, ref);
  } else {
    await ref.read(notificationPermissionControllerProvider.notifier).defer();
  }
}

/// Soft reminder before background work when notifications are not granted.
///
/// Always returns after dismiss or Allow attempt so the work can continue.
///
/// Pops the soft dialog before requesting the OS permission so the system
/// sheet can appear (see [showNotificationPermissionStartupDialog]).
Future<void> showNotificationPermissionBackgroundWorkReminder({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  required String body,
}) async {
  final status = await ref.read(
    notificationPermissionControllerProvider.future,
  );
  if (!context.mounted) return;
  if (status == NotificationPermissionStatus.granted ||
      status == NotificationPermissionStatus.notApplicable) {
    return;
  }

  final l10n = AppLocalizations.of(context);
  final openSettings = status == NotificationPermissionStatus.permanentlyDenied;

  final enable = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.notificationPermissionExtractionReminderContinue),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              openSettings
                  ? l10n.accountNotificationPermissionOpenSettings
                  : l10n.accountNotificationPermissionAllow,
            ),
          ),
        ],
      );
    },
  );

  if (enable == true && context.mounted) {
    // Do not await the OS sheet — callers (download/extract) must continue,
    // and waiting through the activity pause remounts this page.
    unawaited(_requestAfterSoftDialog(context, ref));
  }
}

/// Soft reminder before extraction when notifications are not granted.
Future<void> showNotificationPermissionExtractionReminder({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  await showNotificationPermissionBackgroundWorkReminder(
    context: context,
    ref: ref,
    title: l10n.notificationPermissionExtractionReminderTitle,
    body: l10n.notificationPermissionExtractionReminderBody,
  );
}

/// Soft reminder before model download/copy when notifications are not granted.
Future<void> showNotificationPermissionModelInstallReminder({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  await showNotificationPermissionBackgroundWorkReminder(
    context: context,
    ref: ref,
    title: l10n.notificationPermissionModelInstallReminderTitle,
    body: l10n.notificationPermissionModelInstallReminderBody,
  );
}
