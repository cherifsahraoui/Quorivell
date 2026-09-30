import 'package:flutter/material.dart';

import '../../../../core/ai/local_ai_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    required this.controller,
    required this.enabled,
    required this.isGenerating,
    required this.onSend,
    required this.onStop,
    super.key,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool isGenerating;
  final VoidCallback onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final l10n = AppLocalizations.of(context);
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final text = value.text.trim();
        final overLimit =
            text.length > LocalChatRequest.maxUserMessageCharacters;
        final showCounter =
            text.length >=
            (LocalChatRequest.maxUserMessageCharacters * 0.9).floor();
        final canSend =
            enabled && !isGenerating && text.isNotEmpty && !overLimit;

        return Material(
          color: colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, color: colorScheme.outlineVariant),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: controller,
                        enabled: enabled && !isGenerating,
                        minLines: 1,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) {
                          if (canSend) onSend();
                        },
                        decoration: InputDecoration(
                          labelText: l10n.chatComposerLabel,
                          hintText: l10n.chatComposerHint,
                          alignLabelWithHint: true,
                          counterText: '',
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: isGenerating
                          ? IconButton.filledTonal(
                              onPressed: onStop,
                              tooltip: l10n.chatStopTooltip,
                              icon: const Icon(Icons.stop_circle_outlined),
                            )
                          : IconButton.filled(
                              onPressed: canSend ? onSend : null,
                              tooltip: l10n.chatSendTooltip,
                              icon: const Icon(Icons.send),
                            ),
                    ),
                  ],
                ),
              ),
              if (showCounter)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      l10n.chatComposerCount(
                        text.length,
                        LocalChatRequest.maxUserMessageCharacters,
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: overLimit
                            ? colorScheme.error
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
