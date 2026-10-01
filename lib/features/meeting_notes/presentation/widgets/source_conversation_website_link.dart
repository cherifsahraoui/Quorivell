import 'package:flutter/material.dart';

import '../../../../core/platform/open_external_url.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// Tappable origin row when a capture was fetched from a webpage URL.
class SourceConversationWebsiteLink extends StatelessWidget {
  const SourceConversationWebsiteLink({
    required this.sourceUrl,
    this.compact = false,
    super.key,
  });

  final String sourceUrl;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final uri = Uri.tryParse(sourceUrl);
    if (uri == null) return const SizedBox.shrink();

    final labelStyle =
        (compact ? theme.textTheme.labelSmall : theme.textTheme.labelLarge)
            ?.copyWith(color: colorScheme.primary);
    final urlStyle =
        (compact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
            ?.copyWith(color: colorScheme.onSurfaceVariant);

    return InkWell(
      onTap: () => openExternalUrl(uri),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: compact ? AppSpacing.xs : AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.language,
              size: compact ? 16 : 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.sourceConversationWebsiteLabel, style: labelStyle),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    sourceUrl,
                    maxLines: compact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: urlStyle,
                  ),
                  if (!compact) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.sourceConversationOpenWebsite,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
