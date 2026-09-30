import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/app_logo_loading.dart';

/// Holds the first paint while onboarding prefs and model readiness resolve.
///
/// Avoids flashing the welcome tour or model-setup gate for returning users.
class BootPage extends StatelessWidget {
  const BootPage({super.key});

  static const Key pageKey = Key('app_boot_page');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      key: pageKey,
      body: SafeArea(
        child: Center(
          child: AppLogoLoading(semanticLabel: l10n.appBootLoadingSemantics),
        ),
      ),
    );
  }
}
