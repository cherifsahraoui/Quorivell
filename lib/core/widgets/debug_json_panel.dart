import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_spacing.dart';
import 'show_app_snack_bar.dart';

/// Expandable, selectable JSON for debug mode. Uses [AppTheme] type styles.
class DebugJsonPanel extends StatelessWidget {
  const DebugJsonPanel({required this.json, this.title, super.key});

  final String json;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final heading = title ?? l10n.reviewDebugSourceJson;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        title: Text(
          heading,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: json));
                if (!context.mounted) return;
                showAppSnackBar(
                  context,
                  content: Text(l10n.reviewDebugSourceJsonCopied),
                );
              },
              icon: const Icon(Icons.copy_outlined, size: AppSpacing.md),
              label: Text(l10n.reviewDebugCopySourceJson),
            ),
          ),
          SelectableText(
            json,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
