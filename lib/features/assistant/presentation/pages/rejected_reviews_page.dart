import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/layout/shell_bottom_inset.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extraction_kinds/data/providers/extraction_item_kind_providers.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';
import '../../domain/entities/extraction_run.dart';
import '../../domain/entities/review_candidate.dart';
import '../controllers/review_controller.dart';
import '../widgets/accept_rejected_review_dialog.dart';
import '../widgets/confirm_delete_extraction_run_dialog.dart';
import '../widgets/confirm_delete_rejected_review_dialog.dart';

class RejectedReviewsPage extends ConsumerStatefulWidget {
  const RejectedReviewsPage({super.key});

  @override
  ConsumerState<RejectedReviewsPage> createState() =>
      _RejectedReviewsPageState();
}

class _RejectedReviewsPageState extends ConsumerState<RejectedReviewsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final Set<String> _pendingRemovals = <String>{};
  final Set<String> _pendingRunDeletes = <String>{};
  final Set<String> _selectedIds = <String>{};
  bool _isSelecting = false;
  bool _isBulkDeleting = false;
  var _bulkDeleteInFlight = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabs.removeListener(_onTabChanged);
    _tabs.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabs.indexIsChanging) return;
    if (_isSelecting) {
      _exitSelectionMode();
    } else {
      setState(() {});
    }
  }

  void _enterSelectionMode() {
    setState(() {
      _isSelecting = true;
      _selectedIds.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelecting = false;
      _selectedIds.clear();
    });
  }

  void _toggleSelected(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _toggleSelectAll(List<String> visibleIds) {
    setState(() {
      final allSelected =
          visibleIds.isNotEmpty && visibleIds.every(_selectedIds.contains);
      if (allSelected) {
        _selectedIds.removeAll(visibleIds);
      } else {
        _selectedIds.addAll(visibleIds);
      }
    });
  }

  Future<void> _acceptCandidate(ReviewCandidate candidate) async {
    final l10n = AppLocalizations.of(context);
    final catalog =
        ref.read(extractionItemKindsProvider).asData?.value ?? const [];
    final edited = await showAcceptRejectedReviewDialog(
      context: context,
      candidate: candidate,
      catalog: catalog,
    );
    if (edited == null || !mounted) return;

    try {
      await ref.read(reviewActionsControllerProvider.notifier).accept(edited);
    } on AppFailure {
      if (!mounted) return;
      showAppSnackBar(context, content: Text(l10n.reviewRejectedAcceptFailed));
      return;
    }

    if (!mounted) return;
    final actionState = ref.read(reviewActionsControllerProvider);
    if (actionState.hasError) {
      showAppSnackBar(context, content: Text(l10n.reviewRejectedAcceptFailed));
      return;
    }

    setState(() => _pendingRemovals.add(candidate.id));
    showAppSnackBar(context, content: Text(l10n.reviewRejectedAcceptSuccess));
  }

  Future<bool> _confirmAndDeleteCandidate(String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmDeleteRejectedReview(context);
    if (!confirmed || !mounted) return false;

    try {
      await ref
          .read(reviewActionsControllerProvider.notifier)
          .deleteCandidate(id);
      if (mounted) {
        setState(() => _pendingRemovals.add(id));
      }
      return true;
    } on AppFailure {
      if (!mounted) return false;
      showAppSnackBar(context, content: Text(l10n.reviewRejectedDeleteFailed));
      return false;
    }
  }

  Future<bool> _confirmAndDeleteRun(String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmDeleteExtractionRun(context);
    if (!confirmed || !mounted) return false;

    try {
      await ref.read(reviewActionsControllerProvider.notifier).deleteRun(id);
      if (mounted) {
        setState(() => _pendingRunDeletes.add(id));
      }
      return true;
    } on AppFailure {
      if (!mounted) return false;
      showAppSnackBar(
        context,
        content: Text(l10n.extractionHistoryDeleteFailed),
      );
      return false;
    }
  }

  Future<void> _confirmAndBulkDelete({required bool runsTab}) async {
    if (_bulkDeleteInFlight) return;
    final l10n = AppLocalizations.of(context);
    final ids = _selectedIds.toList(growable: false);
    if (ids.isEmpty) return;

    _bulkDeleteInFlight = true;
    final deleted = <String>[];
    var failed = false;
    try {
      final confirmed = runsTab
          ? await confirmDeleteExtractionRuns(context, count: ids.length)
          : await confirmDeleteRejectedReviews(context, count: ids.length);
      if (!confirmed || !mounted) return;

      setState(() => _isBulkDeleting = true);
      final actions = ref.read(reviewActionsControllerProvider.notifier);
      for (final id in ids) {
        try {
          if (runsTab) {
            await actions.deleteRun(id);
          } else {
            await actions.deleteCandidate(id);
          }
          deleted.add(id);
        } on AppFailure {
          failed = true;
          break;
        }
      }
    } finally {
      _bulkDeleteInFlight = false;
      if (mounted) {
        setState(() {
          if (runsTab) {
            _pendingRunDeletes.addAll(deleted);
          } else {
            _pendingRemovals.addAll(deleted);
          }
          _selectedIds.removeAll(deleted);
          _isBulkDeleting = false;
          if (_selectedIds.isEmpty) {
            _isSelecting = false;
          }
        });
      }
    }

    if (failed && mounted) {
      showAppSnackBar(
        context,
        content: Text(
          runsTab
              ? l10n.extractionHistoryBulkDeleteFailed
              : l10n.reviewRejectedBulkDeleteFailed,
        ),
      );
    }
  }

  List<Widget> _appBarActions(
    AppLocalizations l10n, {
    required List<String> visibleIds,
    required bool runsTab,
  }) {
    if (_isSelecting) {
      final allSelected =
          visibleIds.isNotEmpty && visibleIds.every(_selectedIds.contains);
      return [
        TextButton(
          onPressed: _isBulkDeleting ? null : _exitSelectionMode,
          child: Text(l10n.listSelectionDone),
        ),
        if (visibleIds.isNotEmpty)
          IconButton(
            tooltip: allSelected
                ? l10n.listClearSelectionTooltip
                : l10n.listSelectAllTooltip,
            icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
            onPressed: _isBulkDeleting
                ? null
                : () => _toggleSelectAll(visibleIds),
          ),
        if (_isBulkDeleting)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: SizedBox(
              width: AppSpacing.lg,
              height: AppSpacing.lg,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          IconButton(
            tooltip: l10n.listBulkDeleteTooltip,
            icon: const Icon(Icons.delete_outline),
            onPressed: _selectedIds.isEmpty
                ? null
                : () => _confirmAndBulkDelete(runsTab: runsTab),
          ),
      ];
    }

    if (visibleIds.isEmpty) return const [];
    return [
      IconButton(
        tooltip: l10n.listSelectTooltip,
        icon: const Icon(Icons.library_add_check_outlined),
        onPressed: _enterSelectionMode,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Keep the autoDispose actions controller alive while this page is open
    // so accept/delete can update AsyncValue across await gaps.
    ref.listen(reviewActionsControllerProvider, (_, _) {});
    ref.watch(extractionItemKindsProvider);

    final runsTab = _tabs.index == 1;
    final rejected = ref.watch(rejectedReviewQueueControllerProvider);
    final runs = ref.watch(extractionHistoryControllerProvider);

    final visibleIds = runsTab
        ? runs.maybeWhen(
            data: (items) => [
              for (final item in items)
                if (!_pendingRunDeletes.contains(item.id)) item.id,
            ],
            orElse: () => const <String>[],
          )
        : rejected.maybeWhen(
            data: (items) => [
              for (final item in items)
                if (!_pendingRemovals.contains(item.id)) item.id,
            ],
            orElse: () => const <String>[],
          );

    return PopScope(
      canPop: !_isSelecting,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || !_isSelecting || _isBulkDeleting) return;
        _exitSelectionMode();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isSelecting
                ? l10n.listSelectedCount(_selectedIds.length)
                : l10n.reviewRejectedHistoryTitle,
          ),
          actions: _appBarActions(
            l10n,
            visibleIds: visibleIds,
            runsTab: runsTab,
          ),
          bottom: TabBar(
            controller: _tabs,
            tabs: [
              Tab(text: l10n.reviewRejectedTabTitle),
              Tab(text: l10n.extractionHistoryTabTitle),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: [
            _RejectedCandidatesTab(
              pendingRemovals: _pendingRemovals,
              selectionMode: _isSelecting,
              selectedIds: _selectedIds,
              onSelectionToggle: _toggleSelected,
              onAccept: _acceptCandidate,
              onDelete: _confirmAndDeleteCandidate,
            ),
            _ExtractionHistoryTab(
              pendingDeletes: _pendingRunDeletes,
              selectionMode: _isSelecting,
              selectedIds: _selectedIds,
              onSelectionToggle: _toggleSelected,
              onDelete: _confirmAndDeleteRun,
            ),
          ],
        ),
      ),
    );
  }
}

class _RejectedCandidatesTab extends ConsumerWidget {
  const _RejectedCandidatesTab({
    required this.pendingRemovals,
    required this.selectionMode,
    required this.selectedIds,
    required this.onSelectionToggle,
    required this.onAccept,
    required this.onDelete,
  });

  final Set<String> pendingRemovals;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onSelectionToggle;
  final void Function(ReviewCandidate) onAccept;
  final Future<bool> Function(String) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rejected = ref.watch(rejectedReviewQueueControllerProvider);

    return rejected.when(
      loading: () => const LoadingState(),
      error: (_, _) => EmptyState(
        icon: Icons.error_outline,
        title: l10n.reviewRejectedHistoryUnavailable,
      ),
      data: (items) {
        final visible = items
            .where((item) => !pendingRemovals.contains(item.id))
            .toList();
        if (visible.isEmpty) {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            title: l10n.reviewRejectedHistoryEmpty,
            subtitle: l10n.reviewRejectedHistoryEmptySubtitle,
          );
        }
        return ListView.separated(
          padding: ShellBottomInset.listPadding(context),
          itemCount: visible.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final candidate = visible[index];
            return _RejectedReviewTile(
              candidate: candidate,
              selectionMode: selectionMode,
              selected: selectedIds.contains(candidate.id),
              onSelectionToggle: () => onSelectionToggle(candidate.id),
              onTap: () => onAccept(candidate),
              onDeleteRequested: () => onDelete(candidate.id),
            );
          },
        );
      },
    );
  }
}

class _ExtractionHistoryTab extends ConsumerWidget {
  const _ExtractionHistoryTab({
    required this.pendingDeletes,
    required this.selectionMode,
    required this.selectedIds,
    required this.onSelectionToggle,
    required this.onDelete,
  });

  final Set<String> pendingDeletes;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onSelectionToggle;
  final Future<bool> Function(String) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final runs = ref.watch(extractionHistoryControllerProvider);

    return runs.when(
      loading: () => const LoadingState(),
      error: (_, _) => EmptyState(
        icon: Icons.error_outline,
        title: l10n.extractionHistoryUnavailable,
      ),
      data: (runList) {
        final visible = [
          for (final run in runList)
            if (!pendingDeletes.contains(run.id)) run,
        ];
        if (visible.isEmpty) {
          return EmptyState(
            icon: Icons.history_outlined,
            title: l10n.extractionHistoryEmpty,
            subtitle: l10n.extractionHistoryEmptySubtitle,
          );
        }

        return ListView.separated(
          padding: ShellBottomInset.listPadding(context),
          itemCount: visible.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final run = visible[index];
            return _ExtractionRunTile(
              run: run,
              selectionMode: selectionMode,
              selected: selectedIds.contains(run.id),
              onSelectionToggle: () => onSelectionToggle(run.id),
              onTap: () => context.push('/review/rejected/runs/${run.id}'),
              onDeleteRequested: () => onDelete(run.id),
            );
          },
        );
      },
    );
  }
}

class _ExtractionRunTile extends StatelessWidget {
  const _ExtractionRunTile({
    required this.run,
    required this.onTap,
    required this.onDeleteRequested,
    this.selectionMode = false,
    this.selected = false,
    this.onSelectionToggle,
  });

  final ExtractionRun run;
  final VoidCallback onTap;
  final Future<bool> Function() onDeleteRequested;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onSelectionToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final dateFormat = DateFormat.yMd(l10n.localeName).add_jm();
    final durationSeconds = (run.durationMs / 1000.0).toStringAsFixed(1);

    final card = Card(
      child: InkWell(
        onTap: selectionMode ? onSelectionToggle : onTap,
        onLongPress: selectionMode
            ? onSelectionToggle
            : () async {
                await onDeleteRequested();
              },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (selectionMode)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: AppSpacing.md,
                      ),
                      child: Checkbox(
                        value: selected,
                        onChanged: (_) => onSelectionToggle?.call(),
                      ),
                    ),
                  Icon(
                    run.status == ExtractionRunStatus.success
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    size: 20,
                    color: run.status == ExtractionRunStatus.success
                        ? colorScheme.primary
                        : colorScheme.error,
                    semanticLabel: run.status == ExtractionRunStatus.success
                        ? l10n.extractionHistoryStatusSuccess
                        : l10n.extractionHistoryStatusFailure,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      run.modelDisplayName ?? run.modelId,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!selectionMode)
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
              if (run.status == ExtractionRunStatus.failure) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.extractionHistoryStatusFailure,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.extractionHistoryCompletedAt(
                  dateFormat.format(run.completedAt.toLocal()),
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.extractionHistoryDuration(durationSeconds),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                [
                  l10n.extractionHistoryAcceptedCount(run.acceptedCount),
                  l10n.extractionHistoryRejectedCount(run.rejectedCount),
                  l10n.extractionHistoryPendingCount(run.pendingCount),
                ].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (run.kindCounts.values.any((count) => count > 0)) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final entry in run.kindCounts.entries)
                      if (entry.value > 0)
                        Chip(
                          label: Text(
                            l10n.extractionHistoryKindCount(
                              extractionKindDisplayName(l10n, entry.key),
                              entry.value,
                            ),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (selectionMode) return card;

    return Dismissible(
      key: ValueKey(run.id),
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

class _RejectedReviewTile extends StatelessWidget {
  const _RejectedReviewTile({
    required this.candidate,
    required this.onTap,
    required this.onDeleteRequested,
    this.selectionMode = false,
    this.selected = false,
    this.onSelectionToggle,
  });

  final ReviewCandidate candidate;
  final VoidCallback onTap;
  final Future<bool> Function() onDeleteRequested;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onSelectionToggle;

  String _kindLabel(AppLocalizations l10n, String kind) =>
      extractionKindDisplayName(l10n, kind);

  IconData _kindIcon(String kind) {
    if (kind == ReviewCandidateKind.commitment) {
      return Icons.pending_actions_outlined;
    }
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final card = Card(
      child: InkWell(
        onTap: selectionMode ? onSelectionToggle : onTap,
        onLongPress: selectionMode
            ? onSelectionToggle
            : () async {
                await onDeleteRequested();
              },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
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
                ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  _kindIcon(candidate.kind),
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
                      _kindLabel(l10n, candidate.kind),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      candidate.statement,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.reviewRejectedBadge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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

    if (selectionMode) return card;

    return Dismissible(
      key: ValueKey(candidate.id),
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
