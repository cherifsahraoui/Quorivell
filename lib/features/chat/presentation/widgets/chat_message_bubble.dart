import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ai_chat_message.dart';

/// Max width of a chat bubble relative to the screen.
@visibleForTesting
const chatBubbleMaxWidthFactor = 0.82;

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    required this.message,
    required this.onCopied,
    super.key,
  });

  final AiChatMessage message;
  final VoidCallback onCopied;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  bool _showCopied = false;

  bool get _isUser => widget.message.role == AiChatRole.user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final timeLabel = DateFormat.jm().format(
      widget.message.createdAt.toLocal(),
    );
    final isError = widget.message.status == AiChatMessageStatus.error;

    final bubbleColor = _isUser
        ? colorScheme.primaryContainer
        : isError
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final textColor = _isUser
        ? colorScheme.onPrimaryContainer
        : isError
        ? colorScheme.onErrorContainer
        : colorScheme.onSurface;

    return Align(
      alignment: _isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * chatBubbleMaxWidthFactor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: _isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!_isUser) ...[
                CircleAvatar(
                  radius: AppSpacing.md,
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                  child: const Icon(Icons.auto_awesome, size: AppSpacing.md),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: _isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: bubbleColor,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: const Radius.circular(AppRadius.lg),
                        topEnd: const Radius.circular(AppRadius.lg),
                        bottomStart: Radius.circular(
                          _isUser ? AppRadius.lg : AppRadius.sm,
                        ),
                        bottomEnd: Radius.circular(
                          _isUser ? AppRadius.sm : AppRadius.lg,
                        ),
                      ).resolve(Directionality.of(context)),
                      child: InkWell(
                        onTap: widget.message.content.isEmpty ? null : _copy,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            widget.message.content,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: textColor,
                            ),
                            semanticsLabel: _isUser
                                ? l10n.chatMessageUserSemantics
                                : l10n.chatMessageAssistantSemantics,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _showCopied
                          ? Text(
                              key: const ValueKey('copied'),
                              l10n.chatCopiedSnackbar,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            )
                          : Text(
                              key: const ValueKey('time'),
                              timeLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.message.content));
    widget.onCopied();
    if (!mounted) return;
    setState(() => _showCopied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _showCopied = false);
  }
}

class ChatStreamingBubble extends StatelessWidget {
  const ChatStreamingBubble({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final body = text.isEmpty ? l10n.chatGeneratingLabel : text;

    final bubbleWidth =
        MediaQuery.sizeOf(context).width * chatBubbleMaxWidthFactor;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: bubbleWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: AppSpacing.md,
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
                child: const Icon(Icons.auto_awesome, size: AppSpacing.md),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Semantics(
                  liveRegion: text.isEmpty,
                  label: l10n.chatGeneratingSemantics,
                  child: Material(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: const Radius.circular(AppRadius.lg),
                      topEnd: const Radius.circular(AppRadius.lg),
                      bottomStart: const Radius.circular(AppRadius.sm),
                      bottomEnd: const Radius.circular(AppRadius.lg),
                    ).resolve(Directionality.of(context)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: text.isEmpty
                          ? Row(
                              children: [
                                SizedBox.square(
                                  dimension: AppSpacing.md,
                                  child: ExcludeSemantics(
                                    child: CircularProgressIndicator(
                                      strokeWidth: AppSpacing.xs / 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Flexible(
                                  child: Text(
                                    body,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              body,
                              textWidthBasis: TextWidthBasis.parent,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
