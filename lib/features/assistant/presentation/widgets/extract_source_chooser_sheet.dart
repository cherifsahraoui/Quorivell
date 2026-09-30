import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../meeting_notes/domain/entities/source_conversation.dart';

/// Result of the Review extract target chooser.
sealed class ExtractSourceChoice {
  const ExtractSourceChoice();
}

/// Extract every active capture, oldest → newest, one conversation at a time.
final class ExtractAllActiveChoice extends ExtractSourceChoice {
  const ExtractAllActiveChoice();
}

/// Extract a single active capture chosen by the user.
final class ExtractSingleChoice extends ExtractSourceChoice {
  const ExtractSingleChoice(this.conversation);

  final SourceConversation conversation;
}

/// Polished Material 3 sheet: all active captures vs pick one.
///
/// [conversations] should be newest-first for the pick list. Returns `null`
/// when dismissed.
Future<ExtractSourceChoice?> showExtractSourceChooser({
  required BuildContext context,
  required List<SourceConversation> conversations,
}) {
  assert(
    conversations.isNotEmpty,
    'Chooser requires at least one active capture',
  );
  return showModalBottomSheet<ExtractSourceChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return _ExtractSourceChooserSheet(conversations: conversations);
    },
  );
}

enum _ChooserStep { mode, pick }

class _ExtractSourceChooserSheet extends StatefulWidget {
  const _ExtractSourceChooserSheet({required this.conversations});

  final List<SourceConversation> conversations;

  @override
  State<_ExtractSourceChooserSheet> createState() =>
      _ExtractSourceChooserSheetState();
}

class _ExtractSourceChooserSheetState
    extends State<_ExtractSourceChooserSheet> {
  _ChooserStep _step = _ChooserStep.mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    final count = widget.conversations.length;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.lg + bottomInset,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _step == _ChooserStep.mode
                ? _ModeStep(
                    key: const ValueKey('mode'),
                    title: l10n.extractChooserTitle,
                    subtitle: l10n.extractChooserSubtitle,
                    allTitle: l10n.extractChooserAllTitle,
                    allSubtitle: l10n.extractChooserAllSubtitle(count),
                    pickTitle: l10n.extractChooserPickTitle,
                    pickSubtitle: l10n.extractChooserPickSubtitle,
                    cancelLabel: l10n.extractChooserCancel,
                    onAll: () => Navigator.of(
                      context,
                    ).pop(const ExtractAllActiveChoice()),
                    onPick: () => setState(() => _step = _ChooserStep.pick),
                    onCancel: () => Navigator.of(context).pop(),
                    theme: theme,
                    colorScheme: colorScheme,
                  )
                : _PickStep(
                    key: const ValueKey('pick'),
                    title: l10n.extractChooserPickListTitle,
                    backLabel: l10n.extractChooserBack,
                    conversations: widget.conversations,
                    onBack: () => setState(() => _step = _ChooserStep.mode),
                    onSelected: (conversation) => Navigator.of(
                      context,
                    ).pop(ExtractSingleChoice(conversation)),
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ModeStep extends StatelessWidget {
  const _ModeStep({
    required this.title,
    required this.subtitle,
    required this.allTitle,
    required this.allSubtitle,
    required this.pickTitle,
    required this.pickSubtitle,
    required this.cancelLabel,
    required this.onAll,
    required this.onPick,
    required this.onCancel,
    required this.theme,
    required this.colorScheme,
    super.key,
  });

  final String title;
  final String subtitle;
  final String allTitle;
  final String allSubtitle;
  final String pickTitle;
  final String pickSubtitle;
  final String cancelLabel;
  final VoidCallback onAll;
  final VoidCallback onPick;
  final VoidCallback onCancel;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.auto_awesome_outlined, color: colorScheme.primary, size: 28),
        const SizedBox(height: AppSpacing.sm),
        Text(
          title,
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        _ChooserOptionTile(
          icon: Icons.library_books_outlined,
          title: allTitle,
          subtitle: allSubtitle,
          onTap: onAll,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ChooserOptionTile(
          icon: Icons.chat_bubble_outline,
          title: pickTitle,
          subtitle: pickSubtitle,
          onTap: onPick,
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(onPressed: onCancel, child: Text(cancelLabel)),
      ],
    );
  }
}

class _PickStep extends StatelessWidget {
  const _PickStep({
    required this.title,
    required this.backLabel,
    required this.conversations,
    required this.onBack,
    required this.onSelected,
    required this.theme,
    required this.colorScheme,
    super.key,
  });

  final String title;
  final String backLabel;
  final List<SourceConversation> conversations;
  final VoidCallback onBack;
  final ValueChanged<SourceConversation> onSelected;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd().add_jm();
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              tooltip: backLabel,
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: conversations.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final preview = conversation.content.trim();
              final dateLabel = dateFormat.format(
                conversation.updatedAt.toLocal(),
              );
              return Semantics(
                button: true,
                label: l10n.extractChooserConversationSemantics(
                  preview.isEmpty ? dateLabel : preview,
                  dateLabel,
                ),
                child: _ChooserOptionTile(
                  icon: Icons.chat_bubble_outline,
                  title: preview.isEmpty ? dateLabel : preview,
                  titleMaxLines: 2,
                  subtitle: dateLabel,
                  onTap: () => onSelected(conversation),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChooserOptionTile extends StatelessWidget {
  const _ChooserOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleMaxLines = 1,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int titleMaxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: titleMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
