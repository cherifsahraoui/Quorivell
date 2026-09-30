import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/routing/conversation_highlight.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/debug_json_panel.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/data/providers/debug_ai_settings_providers.dart';
import '../../../extraction_kinds/data/providers/extraction_item_kind_providers.dart';
import '../../../extraction_kinds/domain/entities/extraction_item_kind.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';
import '../../../meeting_notes/data/providers/source_conversation_providers.dart';
import '../../data/providers/ledger_providers.dart';
import '../../domain/entities/ledger_item.dart';
import '../controllers/ledger_actions_controller.dart';
import '../widgets/confirm_delete_ledger_item_dialog.dart';
import '../widgets/evidence_source_unavailable_dialog.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';

class LedgerItemDetailPage extends ConsumerWidget {
  const LedgerItemDetailPage({super.key, required this.itemId});

  final String itemId;

  Future<void> _openEvidenceSource(
    BuildContext context,
    WidgetRef ref,
    EvidenceReference evidence,
  ) async {
    final source = await ref.read(
      sourceConversationByIdProvider(evidence.sourceConversationId).future,
    );
    if (!context.mounted) return;
    if (source == null) {
      await showEvidenceSourceUnavailableDialog(context);
      return;
    }
    await context.push(
      conversationSourceHighlightPath(
        sourceId: evidence.sourceConversationId,
        quoteStart: evidence.quoteStart,
        quoteEnd: evidence.quoteEnd,
        quoteSnippet: evidence.quoteSnippet,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(ledgerItemByIdProvider(itemId));
    final evidenceAsync = ref.watch(ledgerEvidenceProvider(itemId));
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showDebugJson =
        ref
            .watch(debugAiSettingsControllerProvider)
            .asData
            ?.value
            ?.debugModeEnabled ??
        false;

    return itemAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.ledgerDetailTitle)),
        body: const LoadingState(),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.ledgerDetailTitle)),
        body: EmptyState(
          icon: Icons.error_outline,
          title: l10n.ledgerDetailUnavailable,
        ),
      ),
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.ledgerDetailTitle)),
            body: EmptyState(
              icon: Icons.search_off,
              title: l10n.ledgerDetailNotFound,
            ),
          );
        }

        final catalog =
            ref.watch(extractionItemKindsProvider).asData?.value ??
            const <ExtractionItemKind>[];
        final match = kindBySlug(catalog, item.kind);
        final isCompletable = kindIsCompletable(match, item.kind);
        final kindLabel = extractionKindDisplayName(
          l10n,
          item.kind,
          snapshot: item.kindDisplayNameSnapshot,
          catalog: catalog,
        );
        final isCompleted =
            item.status == LedgerItemStatus.completed ||
            item.status == LedgerItemStatus.cancelled;

        return Scaffold(
          appBar: AppBar(
            title: Text(kindLabel),
            actions: [
              IconButton(
                tooltip: l10n.ledgerDeleteTooltip,
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final confirmed = await confirmDeleteLedgerItem(context);
                  if (!confirmed || !context.mounted) return;
                  try {
                    await ref
                        .read(ledgerActionsControllerProvider.notifier)
                        .delete(item.id);
                    if (!context.mounted) return;
                    context.pop();
                  } on AppFailure {
                    if (!context.mounted) return;
                    showAppSnackBar(
                      context,
                      content: Text(l10n.ledgerDeleteFailed),
                    );
                  }
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isCompletable
                          ? colorScheme.tertiaryContainer
                          : colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(
                      isCompletable
                          ? Icons.checklist_outlined
                          : Icons.verified_outlined,
                      color: isCompletable
                          ? colorScheme.onTertiaryContainer
                          : colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      kindLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isCompletable
                            ? colorScheme.tertiary
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                  if (isCompletable)
                    FilterChip(
                      label: Text(
                        isCompleted
                            ? l10n.ledgerStatusCompleted
                            : l10n.ledgerStatusOpen,
                      ),
                      selected: isCompleted,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      visualDensity: VisualDensity.standard,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                      onSelected: (selected) async {
                        try {
                          await ref
                              .read(ledgerActionsControllerProvider.notifier)
                              .setStatus(
                                id: item.id,
                                status: selected
                                    ? LedgerItemStatus.completed
                                    : LedgerItemStatus.open,
                              );
                        } on AppFailure {
                          if (!context.mounted) return;
                          showAppSnackBar(
                            context,
                            content: Text(l10n.ledgerUpdateFailed),
                          );
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                item.statement,
                style: theme.textTheme.headlineSmall?.copyWith(
                  decoration: isCompleted && isCompletable
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              if (item.owner != null) ...[
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline),
                  title: Text(l10n.ownerLabel(item.owner!)),
                ),
              ],
              if (kindAllowsDueDate(
                    match,
                    existingDueDate: item.dueDate,
                    slug: item.kind,
                  ) &&
                  item.dueDate != null) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: Text(
                    l10n.ledgerDueDateLabel(
                      DateFormat.yMMMd().add_jm().format(
                        item.dueDate!.toLocal(),
                      ),
                    ),
                  ),
                ),
              ],
              if (item.note != null && item.note!.isNotEmpty) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.notes_outlined),
                  title: Text(l10n.ledgerNoteLabel(item.note!)),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.ledgerEvidenceSectionTitle,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              evidenceAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: LoadingState(),
                ),
                error: (_, _) => Text(l10n.ledgerEvidenceUnavailable),
                data: (evidence) {
                  if (evidence.isEmpty) {
                    return Text(
                      l10n.ledgerManualOriginNote,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final refItem in evidence) ...[
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () =>
                                _openEvidenceSource(context, ref, refItem),
                            child: Semantics(
                              button: true,
                              label: l10n.ledgerEvidenceOpenSource,
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.format_quote,
                                      size: 18,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        refItem.quoteSnippet,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Icon(
                                      Icons.chevron_right,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  );
                },
              ),
              if (showDebugJson) ...[
                const SizedBox(height: AppSpacing.lg),
                DebugJsonPanel(
                  title: l10n.ledgerDebugItemJson,
                  json: const JsonEncoder.withIndent(
                    '  ',
                  ).convert(item.toJson()),
                ),
                if ((evidenceAsync.asData?.value ?? const []).isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  DebugJsonPanel(
                    title: l10n.ledgerDebugEvidenceJson,
                    json: JsonEncoder.withIndent('  ').convert([
                      for (final evidence in evidenceAsync.asData!.value)
                        evidence.toJson(),
                    ]),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
