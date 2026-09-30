import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extraction_kinds/data/providers/extraction_item_kind_providers.dart';
import '../../../extraction_kinds/domain/entities/extraction_item_kind.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';
import '../../domain/entities/ledger_item.dart';
import '../controllers/ledger_actions_controller.dart';
import '../controllers/ledger_list_controller.dart';
import '../controllers/ledger_list_state.dart';
import '../widgets/confirm_delete_ledger_item_dialog.dart';
import '../widgets/ledger_item_tile.dart';
import '../../../../core/layout/shell_bottom_inset.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';

class LedgerPage extends ConsumerStatefulWidget {
  const LedgerPage({super.key});

  @override
  ConsumerState<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends ConsumerState<LedgerPage> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final Set<String> _pendingDeletes = <String>{};
  final Set<String> _selectedIds = <String>{};
  bool _isSelecting = false;
  bool _isBulkDeleting = false;
  var _bulkDeleteInFlight = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
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

  Future<bool> _confirmAndDelete(String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmDeleteLedgerItem(context);
    if (!confirmed || !mounted) return false;

    try {
      await ref.read(ledgerActionsControllerProvider.notifier).delete(id);
      if (mounted) {
        setState(() => _pendingDeletes.add(id));
      }
      return true;
    } on AppFailure {
      if (!mounted) return false;
      showAppSnackBar(context, content: Text(l10n.ledgerDeleteFailed));
      return false;
    }
  }

  Future<void> _confirmAndBulkDelete() async {
    if (_bulkDeleteInFlight) return;
    final l10n = AppLocalizations.of(context);
    final ids = _selectedIds.toList(growable: false);
    if (ids.isEmpty) return;

    _bulkDeleteInFlight = true;
    final deleted = <String>[];
    var failed = false;
    try {
      final confirmed = await confirmDeleteLedgerItems(
        context,
        count: ids.length,
      );
      if (!confirmed || !mounted) return;

      setState(() => _isBulkDeleting = true);
      final actions = ref.read(ledgerActionsControllerProvider.notifier);
      for (final id in ids) {
        try {
          await actions.delete(id);
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
          _pendingDeletes.addAll(deleted);
          _selectedIds.removeAll(deleted);
          _isBulkDeleting = false;
          if (_selectedIds.isEmpty) {
            _isSelecting = false;
          }
        });
      }
    }

    if (failed && mounted) {
      showAppSnackBar(context, content: Text(l10n.ledgerBulkDeleteFailed));
    }
  }

  Future<void> _toggleCompleted(LedgerItem item, bool completed) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(ledgerActionsControllerProvider.notifier)
          .setStatus(
            id: item.id,
            status: completed
                ? LedgerItemStatus.completed
                : LedgerItemStatus.open,
          );
    } on AppFailure {
      if (!mounted) return;
      showAppSnackBar(context, content: Text(l10n.ledgerUpdateFailed));
    }
  }

  Future<void> _openCreate(LedgerListState state) {
    final kind = state.kindFilter.slug ?? LedgerItemKind.commitment;
    return context.push('/ledger/new?kind=$kind');
  }

  Widget _header(
    AppLocalizations l10n,
    LedgerListState state, {
    required List<String> visibleIds,
  }) {
    if (_isSelecting) {
      final allSelected =
          visibleIds.isNotEmpty && visibleIds.every(_selectedIds.contains);
      return SectionHeader(
        title: l10n.navLedger,
        subtitle: l10n.ledgerSelectedCount(_selectedIds.length),
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: _isBulkDeleting ? null : _exitSelectionMode,
              child: Text(l10n.ledgerSelectionDone),
            ),
            if (visibleIds.isNotEmpty)
              IconButton(
                tooltip: allSelected
                    ? l10n.ledgerClearSelectionTooltip
                    : l10n.ledgerSelectAllTooltip,
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
                tooltip: l10n.ledgerBulkDeleteTooltip,
                icon: const Icon(Icons.delete_outline),
                onPressed: _selectedIds.isEmpty ? null : _confirmAndBulkDelete,
              ),
          ],
        ),
      );
    }

    return SectionHeader(
      title: l10n.navLedger,
      subtitle: _subtitle(l10n, state),
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!state.isEmpty)
            IconButton(
              tooltip: l10n.ledgerSelectTooltip,
              icon: const Icon(Icons.library_add_check_outlined),
              onPressed: _enterSelectionMode,
            ),
          IconButton(
            tooltip: l10n.ledgerAddTooltip,
            icon: const Icon(Icons.add),
            onPressed: () => _openCreate(state),
          ),
        ],
      ),
    );
  }

  String _subtitle(AppLocalizations l10n, LedgerListState state) {
    final count = state.visibleItems.length;
    if (state.statusFilter == LedgerStatusFilter.completed) {
      return l10n.ledgerCompletedCount(count);
    }
    if (state.kindFilter.isAll) {
      return l10n.ledgerItemCount(count);
    }
    return l10n.ledgerKindCount(state.kindFilter.slug ?? '', count);
  }

  String _emptyTitle(AppLocalizations l10n, LedgerListState state) {
    if (_offersCapturePath(state)) {
      return l10n.ledgerEmptyStartTitle;
    }
    return state.statusFilter == LedgerStatusFilter.completed
        ? l10n.ledgerEmptyCompleted
        : l10n.ledgerEmptyAll;
  }

  String _emptySubtitle(AppLocalizations l10n, LedgerListState state) {
    if (_offersCapturePath(state)) {
      return l10n.ledgerEmptyStartSubtitle;
    }
    return state.statusFilter == LedgerStatusFilter.completed
        ? l10n.ledgerEmptyCompletedSubtitle
        : l10n.ledgerEmptyAllSubtitle;
  }

  bool _offersCapturePath(LedgerListState state) {
    return state.statusFilter == LedgerStatusFilter.open &&
        state.kindFilter.isAll;
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(ledgerListControllerProvider);
    final catalog =
        ref.watch(extractionItemKindsProvider).asData?.value ??
        const <ExtractionItemKind>[];
    final enabledAsync = ref.watch(enabledExtractionItemKindsProvider);
    final enabledCatalog = enabledAsync.asData?.value;
    final filterCatalog = enabledCatalog ?? const <ExtractionItemKind>[];
    final kindFilter = ref.watch(ledgerKindFilterControllerProvider);
    final filteredSlug = kindFilter.slug;
    if (enabledCatalog != null &&
        filteredSlug != null &&
        !enabledCatalog.any((kind) => kind.slug == filteredSlug)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final current = ref.read(ledgerKindFilterControllerProvider);
        if (current.slug == null) return;
        final latestEnabled = ref
            .read(enabledExtractionItemKindsProvider)
            .asData
            ?.value;
        if (latestEnabled == null ||
            latestEnabled.any((kind) => kind.slug == current.slug)) {
          return;
        }
        ref
            .read(ledgerListControllerProvider.notifier)
            .setKindFilter(LedgerKindFilter.all);
      });
    }
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isSelecting,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || !_isSelecting || _isBulkDeleting) return;
        _exitSelectionMode();
      },
      child: list.when(
        loading: () => const LoadingState(),
        error: (_, _) => EmptyState(
          icon: Icons.error_outline,
          title: l10n.ledgerUnavailable,
        ),
        data: (state) {
          final visible = state.visibleItems
              .where((item) => !_pendingDeletes.contains(item.id))
              .toList();
          final selectedKind = state.kindFilter.slug == null
              ? null
              : kindBySlug(catalog, state.kindFilter.slug!);
          final showStatusFilter =
              selectedKind == null ||
              kindIsCompletable(selectedKind, selectedKind.slug);

          final visibleIds = [for (final item in visible) item.id];

          if (state.isEmpty) {
            final offerCapture = _offersCapturePath(state);
            final offerAdd =
                !offerCapture &&
                state.statusFilter != LedgerStatusFilter.completed;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _header(l10n, state, visibleIds: visibleIds),
                ),
                if (!_isSelecting)
                  SliverToBoxAdapter(
                    child: _FilterBar(state: state, catalog: filterCatalog),
                  ),
                if (showStatusFilter && !_isSelecting)
                  const SliverToBoxAdapter(child: _StatusFilterChips()),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: EmptyState(
                    icon: Icons.menu_book_outlined,
                    title: _emptyTitle(l10n, state),
                    subtitle: _emptySubtitle(l10n, state),
                    action: offerCapture
                        ? () => context.go('/capture')
                        : offerAdd
                        ? () => _openCreate(state)
                        : null,
                    actionLabel: offerCapture
                        ? l10n.ledgerEmptyGoToCapture
                        : offerAdd
                        ? l10n.ledgerEmptyAddItem
                        : null,
                    actionIcon: offerCapture
                        ? Icons.edit_note_outlined
                        : Icons.add,
                  ),
                ),
              ],
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _header(l10n, state, visibleIds: visibleIds),
              ),
              if (!_isSelecting) ...[
                SliverToBoxAdapter(
                  child: _FilterBar(state: state, catalog: filterCatalog),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: AppTextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      onChanged: (value) => ref
                          .read(ledgerListControllerProvider.notifier)
                          .search(value),
                      decoration: InputDecoration(
                        labelText: l10n.ledgerSearchLabel,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: state.query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: l10n.ledgerSearchClearTooltip,
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(
                                        ledgerListControllerProvider.notifier,
                                      )
                                      .search('');
                                  _searchFocus.requestFocus();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                if (showStatusFilter)
                  const SliverToBoxAdapter(child: _StatusFilterChips()),
              ],
              if (state.hasNoMatches || visible.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: EmptyState(
                    icon: Icons.search_off,
                    title: l10n.ledgerNoMatches,
                    subtitle: l10n.ledgerSearchNoMatchesSubtitle,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  sliver: SliverList.separated(
                    itemCount: visible.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = visible[index];
                      final match = kindBySlug(catalog, item.kind);
                      return LedgerItemTile(
                        item: item,
                        kindLabel: extractionKindDisplayName(
                          l10n,
                          item.kind,
                          snapshot: item.kindDisplayNameSnapshot,
                          catalog: catalog,
                        ),
                        selectionMode: _isSelecting,
                        selected: _selectedIds.contains(item.id),
                        onSelectionToggle: () => _toggleSelected(item.id),
                        onOpen: () => context.push('/ledger/items/${item.id}'),
                        onDeleteRequested: () => _confirmAndDelete(item.id),
                        showDueDate: kindAllowsDueDate(
                          match,
                          existingDueDate: item.dueDate,
                          slug: item.kind,
                        ),
                        onToggleCompleted: kindIsCompletable(match, item.kind)
                            ? (completed) => _toggleCompleted(item, completed)
                            : null,
                      );
                    },
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height:
                      AppSpacing.xxl +
                      ShellBottomInset.listFabClearance(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.state, required this.catalog});

  final LedgerListState state;
  final List<ExtractionItemKind> catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          FilterChip(
            label: Text(l10n.ledgerKindFilterAll),
            selected: state.kindFilter.isAll,
            onSelected: (_) {
              ref
                  .read(ledgerListControllerProvider.notifier)
                  .setKindFilter(LedgerKindFilter.all);
            },
          ),
          for (final kind in catalog)
            FilterChip(
              label: Text(
                extractionKindDisplayName(
                  l10n,
                  kind.slug,
                  snapshot: kind.displayName,
                  catalog: catalog,
                ),
              ),
              selected: state.kindFilter.slug == kind.slug,
              onSelected: (_) {
                ref
                    .read(ledgerListControllerProvider.notifier)
                    .setKindFilter(LedgerKindFilter.kind(kind.slug));
              },
            ),
        ],
      ),
    );
  }
}

class _StatusFilterChips extends ConsumerWidget {
  const _StatusFilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statusFilter = ref.watch(ledgerStatusFilterControllerProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        children: [
          FilterChip(
            label: Text(l10n.ledgerFilterOpen),
            selected: statusFilter == LedgerStatusFilter.open,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            visualDensity: VisualDensity.standard,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            onSelected: (_) => ref
                .read(ledgerListControllerProvider.notifier)
                .setStatusFilter(LedgerStatusFilter.open),
          ),
          FilterChip(
            label: Text(l10n.ledgerFilterCompleted),
            selected: statusFilter == LedgerStatusFilter.completed,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            visualDensity: VisualDensity.standard,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            onSelected: (_) => ref
                .read(ledgerListControllerProvider.notifier)
                .setStatusFilter(LedgerStatusFilter.completed),
          ),
        ],
      ),
    );
  }
}
