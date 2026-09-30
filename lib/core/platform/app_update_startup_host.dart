import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_update_check.dart';
import 'app_update_dialog.dart';

/// Host that shows the new-version dialog after [AppShell] is visible.
///
/// Retries when the first check returns null (offline / no update) so a later
/// successful fetch in the same session can still present the dialog once.
class AppUpdateStartupHost extends ConsumerStatefulWidget {
  const AppUpdateStartupHost({super.key});

  @override
  ConsumerState<AppUpdateStartupHost> createState() =>
      _AppUpdateStartupHostState();
}

class _AppUpdateStartupHostState extends ConsumerState<AppUpdateStartupHost> {
  var _shown = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AppUpdateAvailability?>>(
      appUpdatePromptControllerProvider,
      (previous, next) {
        final availability = next.asData?.value;
        if (_shown || availability == null || !mounted) return;
        _shown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          await showAppUpdateAvailableDialog(
            context: context,
            ref: ref,
            availability: availability,
          );
        });
      },
    );
    // Keep the provider alive so listen receives updates.
    ref.watch(appUpdatePromptControllerProvider);
    return const SizedBox.shrink();
  }
}
