import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'background_work_constraint_service.dart';

enum BackgroundWorkReminderKind { extraction, modelInstall }

/// Educational reminder when Restricted, OEM recommended Battery saver, or
/// system Battery Saver can interrupt on-device work. Does not block the work
/// if the user dismisses.
Future<void> showBackgroundWorkRestrictionReminder({
  required BuildContext context,
  required WidgetRef ref,
  required BackgroundWorkReminderKind kind,
  bool oncePerSession = false,
}) async {
  if (!context.mounted) return;
  final controller = ref.read(
    backgroundWorkConstraintControllerProvider.notifier,
  );
  if (oncePerSession && controller.modelInstallReminderShown) {
    return;
  }
  await controller.refresh();
  if (!context.mounted) return;
  final constraints = ref
      .read(backgroundWorkConstraintControllerProvider)
      .asData
      ?.value;
  if (constraints == null || !constraints.shouldRemind) return;
  if (oncePerSession) {
    controller.markModelInstallReminderShown();
  }

  final l10n = AppLocalizations.of(context);
  final cardKind = constraints.accountCardKind;
  final title = switch (cardKind) {
    BackgroundWorkAccountCardKind.restricted =>
      l10n.backgroundRestrictionReminderTitle,
    BackgroundWorkAccountCardKind.oemAllowlist =>
      l10n.backgroundOemBatteryReminderTitle,
    BackgroundWorkAccountCardKind.batterySaver =>
      l10n.backgroundBatterySaverReminderTitle,
    BackgroundWorkAccountCardKind.hidden ||
    BackgroundWorkAccountCardKind.informational =>
      l10n.backgroundBatterySaverReminderTitle,
  };
  final body = switch ((cardKind, kind)) {
    (
      BackgroundWorkAccountCardKind.restricted,
      BackgroundWorkReminderKind.extraction,
    ) =>
      l10n.backgroundRestrictionReminderExtractionBody,
    (
      BackgroundWorkAccountCardKind.restricted,
      BackgroundWorkReminderKind.modelInstall,
    ) =>
      l10n.backgroundRestrictionReminderModelInstallBody,
    (
      BackgroundWorkAccountCardKind.oemAllowlist,
      BackgroundWorkReminderKind.extraction,
    ) =>
      l10n.backgroundOemBatteryReminderExtractionBody,
    (
      BackgroundWorkAccountCardKind.oemAllowlist,
      BackgroundWorkReminderKind.modelInstall,
    ) =>
      l10n.backgroundOemBatteryReminderModelInstallBody,
    (
      BackgroundWorkAccountCardKind.batterySaver,
      BackgroundWorkReminderKind.extraction,
    ) =>
      l10n.backgroundBatterySaverReminderExtractionBody,
    (
      BackgroundWorkAccountCardKind.batterySaver,
      BackgroundWorkReminderKind.modelInstall,
    ) =>
      l10n.backgroundBatterySaverReminderModelInstallBody,
    (_, BackgroundWorkReminderKind.extraction) =>
      l10n.backgroundBatterySaverReminderExtractionBody,
    (_, BackgroundWorkReminderKind.modelInstall) =>
      l10n.backgroundBatterySaverReminderModelInstallBody,
  };

  final openSettings = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.backgroundWorkReminderContinue),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.accountNotificationPermissionOpenSettings),
          ),
        ],
      );
    },
  );

  if (openSettings == true && context.mounted) {
    // Do not await settings — Extract / install must continue either way.
    unawaited(ref.read(backgroundWorkConstraintServiceProvider).openSettings());
  }
}

Future<void> showBackgroundWorkExtractionReminder({
  required BuildContext context,
  required WidgetRef ref,
}) {
  return showBackgroundWorkRestrictionReminder(
    context: context,
    ref: ref,
    kind: BackgroundWorkReminderKind.extraction,
  );
}

Future<void> showBackgroundWorkModelInstallReminder({
  required BuildContext context,
  required WidgetRef ref,
  bool oncePerSession = true,
}) {
  return showBackgroundWorkRestrictionReminder(
    context: context,
    ref: ref,
    kind: BackgroundWorkReminderKind.modelInstall,
    oncePerSession: oncePerSession,
  );
}
