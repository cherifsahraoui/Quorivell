import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/layout/shell_bottom_inset.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';
import '../../../meeting_notes/data/providers/source_conversation_providers.dart';
import '../../../meeting_notes/presentation/widgets/source_conversation_website_link.dart';
import '../../data/providers/extraction_providers.dart';
import '../../domain/entities/extraction_run.dart';
import '../controllers/review_controller.dart';
import '../utils/extraction_run_results.dart';

/// Detail view for one completed extraction run from History.
class ExtractionRunDetailPage extends ConsumerWidget {
  const ExtractionRunDetailPage({required this.runId, super.key});

  final String runId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final runs = ref.watch(extractionHistoryControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.extractionHistoryDetailTitle)),
      body: runs.when(
        loading: () => const LoadingState(),
        error: (_, _) => EmptyState(
          icon: Icons.error_outline,
          title: l10n.extractionHistoryUnavailable,
        ),
        data: (runList) {
          ExtractionRun? match;
          for (final run in runList) {
            if (run.id == runId) {
              match = run;
              break;
            }
          }
          if (match == null) {
            return EmptyState(
              icon: Icons.search_off,
              title: l10n.extractionHistoryUnavailable,
            );
          }
          return _ExtractionRunDetailBody(run: match);
        },
      ),
    );
  }
}

class _ExtractionRunDetailBody extends ConsumerWidget {
  const _ExtractionRunDetailBody({required this.run});

  final ExtractionRun run;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat.yMd(l10n.localeName).add_jm();
    final durationSeconds = (run.durationMs / 1000.0).toStringAsFixed(1);
    final sourceId = run.sourceConversationId;
    final sourceAsync = sourceId == null
        ? null
        : ref.watch(sourceConversationByIdProvider(sourceId));

    return ListView(
      padding: ShellBottomInset.listPadding(context),
      children: [
        SectionHeader(
          title: run.modelDisplayName ?? run.modelId,
          subtitle: run.status == ExtractionRunStatus.success
              ? l10n.extractionHistoryStatusSuccess
              : l10n.extractionHistoryStatusFailure,
        ),
        InfoCard(
          icon: run.status == ExtractionRunStatus.success
              ? Icons.check_circle_outline
              : Icons.error_outline,
          title: l10n.extractionHistoryCompletedAt(
            dateFormat.format(run.completedAt.toLocal()),
          ),
          subtitle: l10n.extractionHistoryDuration(durationSeconds),
          color: run.status == ExtractionRunStatus.success
              ? colorScheme.primary
              : colorScheme.error,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.extractionHistoryResultsTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _ExtractionRunLiveResults(run: run),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.extractionHistorySourceTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (sourceId == null)
          Text(
            l10n.extractionHistorySourceMissing,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          sourceAsync!.when(
            loading: () => const LoadingState(),
            error: (_, _) => Text(
              l10n.extractionHistorySourceMissing,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            data: (conversation) {
              if (conversation == null) {
                return Text(
                  l10n.extractionHistorySourceMissing,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              }
              final sourceUrl = conversation.sourceUrl;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (sourceUrl != null && sourceUrl.isNotEmpty) ...[
                        SourceConversationWebsiteLink(sourceUrl: sourceUrl),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      InkWell(
                        onTap: () =>
                            context.push('/capture/sources/${conversation.id}'),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversation.content,
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.extractionHistoryOpenSource,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Live accepted / rejected / pending + kind totals for one history run.
class _ExtractionRunLiveResults extends ConsumerWidget {
  const _ExtractionRunLiveResults({required this.run});

  final ExtractionRun run;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep listening so accept / reject / delete on other tabs refresh counts.
    ref.watch(pendingReviewCountProvider);
    ref.watch(rejectedReviewQueueControllerProvider);
    final sourceId = run.sourceConversationId;
    if (sourceId == null) {
      return _ResultsChips(
        accepted: run.acceptedCount,
        rejected: run.rejectedCount,
        pending: run.pendingCount,
        kindCounts: run.kindCounts,
        enabledKindSlugs: run.enabledKindSlugs,
      );
    }

    final stream = ref
        .read(extractionLocalDataSourceProvider)
        .watchCandidatesForSource(sourceId);

    return StreamBuilder<List<ExtractionCandidateRow>>(
      stream: stream,
      builder: (context, snapshot) {
        final counts = recountExtractionRunResults(
          run: run,
          rows: snapshot.data,
        );
        return _ResultsChips(
          accepted: counts.accepted,
          rejected: counts.rejected,
          pending: counts.pending,
          kindCounts: counts.kindCounts,
          enabledKindSlugs: run.enabledKindSlugs,
        );
      },
    );
  }
}

class _ResultsChips extends StatelessWidget {
  const _ResultsChips({
    required this.accepted,
    required this.rejected,
    required this.pending,
    required this.kindCounts,
    required this.enabledKindSlugs,
  });

  final int accepted;
  final int rejected;
  final int pending;
  final Map<String, int> kindCounts;
  final List<String> enabledKindSlugs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            Chip(label: Text(l10n.extractionHistoryAcceptedCount(accepted))),
            Chip(label: Text(l10n.extractionHistoryRejectedCount(rejected))),
            Chip(label: Text(l10n.extractionHistoryPendingCount(pending))),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.extractionHistoryKindsTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (enabledKindSlugs.isEmpty)
          Text(
            l10n.extractionHistoryNoKinds,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final slug in enabledKindSlugs)
                Chip(
                  label: Text(
                    l10n.extractionHistoryKindCount(
                      extractionKindDisplayName(l10n, slug),
                      kindCounts[slug] ?? 0,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
