import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'core/config/app_config.dart';
import 'core/config/firebase_bootstrap.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/account/data/providers/locale_preference_providers.dart';
import 'features/account/data/providers/theme_preference_providers.dart';
import 'features/account/domain/entities/user_preference.dart';
import 'l10n/app_localizations.dart';

final _log = Logger('quorivell.bootstrap');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrapFirebase();
  runApp(const ProviderScope(child: AiFlutterApp()));
}

/// Quorivell captures, extracts, and stores everything on the device, so
/// Firebase is optional. A build that opts out, or a checkout without platform
/// Firebase configuration, still boots straight into the local-only flow.
@visibleForTesting
Future<void> bootstrapFirebase({
  bool enabled = AppConfig.firebaseEnabled,
  Future<void> Function() initialize = FirebaseBootstrap.initialize,
}) async {
  if (!enabled) return;
  try {
    await initialize();
  } on FirebaseBootstrapException catch (failure) {
    _log.warning('Continuing without Firebase: ${failure.kind.name}.');
  }
}

class AiFlutterApp extends ConsumerWidget {
  const AiFlutterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode =
        ref.watch(themeModePreferenceProvider).asData?.value ??
        ThemeMode.system;
    final localePreference =
        ref.watch(localePreferenceControllerProvider).asData?.value ??
        AppLocalePreference.system;

    return MaterialApp.router(
      title: 'Quorivell',
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: LocalePreferenceController.toMaterialLocale(localePreference),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
