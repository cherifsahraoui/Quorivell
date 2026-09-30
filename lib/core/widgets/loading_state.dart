import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// In-progress indicator with a localized semantics label.
///
/// List and page loading should use this instead of a bare
/// [CircularProgressIndicator] so TalkBack / VoiceOver announce loading.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key}) : inline = false;

  /// Labeled spinner without [Center], for overlays and stacked copy.
  const LoadingState.inline({super.key}) : inline = true;

  final bool inline;

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context).loadingSemantics;
    final indicator = Semantics(
      label: label,
      liveRegion: true,
      child: const ExcludeSemantics(child: CircularProgressIndicator()),
    );
    if (inline) {
      return indicator;
    }
    return Center(child: indicator);
  }
}
