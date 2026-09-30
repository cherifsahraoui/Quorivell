import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ledger_item.dart';

/// One ledger row: checkbox todo for commitments, seal-style card for decisions.
///
/// In [selectionMode], the row shows a selection checkbox and taps toggle
/// selection instead of navigating.
class LedgerItemTile extends StatelessWidget {
  const LedgerItemTile({
    super.key,
    required this.item,
    required this.onOpen,
    required this.onDeleteRequested,
    this.onToggleCompleted,
    this.kindLabel,
    this.showDueDate = true,
    this.selectionMode = false,
    this.selected = false,
    this.onSelectionToggle,
  });

  final LedgerItem item;
  final VoidCallback onOpen;
  final Future<bool> Function() onDeleteRequested;
  final ValueChanged<bool>? onToggleCompleted;
  final String? kindLabel;
  final bool showDueDate;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onSelectionToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final isCompletable = onToggleCompleted != null;
    final isCompleted =
        item.status == LedgerItemStatus.completed ||
        item.status == LedgerItemStatus.cancelled;
    final label =
        kindLabel ??
        (item.kind == LedgerItemKind.commitment
            ? l10n.reviewKindCommitment
            : item.kind == LedgerItemKind.decision
            ? l10n.reviewKindDecision
            : (item.kindDisplayNameSnapshot.isNotEmpty
                  ? item.kindDisplayNameSnapshot
                  : item.kind));
    final dueDate = showDueDate ? item.dueDate : null;

    final card = Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: selectionMode ? onSelectionToggle : onOpen,
        onLongPress: selectionMode
            ? onSelectionToggle
            : () async {
                await onDeleteRequested();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectionMode)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: AppSpacing.md,
                    top: AppSpacing.xs,
                  ),
                  child: Checkbox(
                    value: selected,
                    onChanged: (_) => onSelectionToggle?.call(),
                  ),
                )
              else if (isCompletable && onToggleCompleted != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: AppSpacing.md,
                    top: AppSpacing.xs,
                  ),
                  child: Checkbox(
                    value: isCompleted,
                    onChanged: (checked) {
                      if (checked == null) return;
                      onToggleCompleted!(checked);
                    },
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.7,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.verified_outlined,
                      size: 22,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: isCompletable
                                ? colorScheme.tertiaryContainer.withValues(
                                    alpha: 0.6,
                                  )
                                : colorScheme.primaryContainer.withValues(
                                    alpha: 0.6,
                                  ),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isCompletable
                                  ? colorScheme.onTertiaryContainer
                                  : colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      item.statement,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration: isCompleted && isCompletable
                            ? TextDecoration.lineThrough
                            : null,
                        color: isCompleted && isCompletable
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.owner != null ||
                        dueDate != null ||
                        (item.note != null && item.note!.isNotEmpty)) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.xs,
                        children: [
                          if (item.owner != null)
                            _MetaChip(
                              icon: Icons.person_outline,
                              label: l10n.ownerLabel(item.owner!),
                            ),
                          if (dueDate != null)
                            _MetaChip(
                              icon: Icons.event_outlined,
                              label: l10n.ledgerDueDateLabel(
                                DateFormat.yMMMd().add_jm().format(
                                  dueDate.toLocal(),
                                ),
                              ),
                              isOverdue:
                                  dueDate.isBefore(DateTime.now()) &&
                                  !isCompleted,
                            ),
                          if (item.note != null && item.note!.isNotEmpty)
                            _MetaChip(
                              icon: Icons.notes_outlined,
                              label: l10n.ledgerNoteLabel(item.note!),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (!selectionMode) ...[
                const SizedBox(width: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (selectionMode) {
      return KeyedSubtree(key: ValueKey(item.id), child: card);
    }

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => onDeleteRequested(),
      background: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Icon(
              Icons.delete_outline,
              color: colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
      child: card,
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    this.isOverdue = false,
  });

  final IconData icon;
  final String label;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
            fontWeight: isOverdue ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
  }
}
