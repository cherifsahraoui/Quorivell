import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingChatTip extends StatelessWidget {
  const OnboardingChatTip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.chat_bubble_outline, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l10n.onboardingChatTip,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
