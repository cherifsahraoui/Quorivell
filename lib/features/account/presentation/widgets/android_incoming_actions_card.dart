import 'package:flutter/material.dart';

import '../../../../core/platform/android_incoming_actions.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../l10n/app_localizations.dart';

/// Explains the Android share-sheet and text-selection entry points.
///
/// Hidden on iOS, web, and desktop. Not tappable — this is discoverability,
/// not a second settings page.
class AndroidIncomingActionsCard extends StatelessWidget {
  const AndroidIncomingActionsCard({this.platform, super.key});

  /// Test seam; production uses [defaultTargetPlatform].
  final TargetPlatform? platform;

  @override
  Widget build(BuildContext context) {
    if (!showsAndroidIncomingActions(platform: platform)) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return InfoCard(
      icon: Icons.phone_android_outlined,
      title: l10n.androidIncomingActionsTitle,
      subtitle: l10n.androidIncomingActionsBody,
      color: colorScheme.tertiary,
    );
  }
}
