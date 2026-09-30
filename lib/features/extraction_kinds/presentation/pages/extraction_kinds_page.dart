import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/quorivell_scaffold.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/providers/extraction_item_kind_providers.dart';
import '../../domain/entities/extraction_item_kind.dart';
import '../controllers/extraction_kinds_controller.dart';
import '../extraction_kind_labels.dart';
import '../widgets/confirm_delete_extraction_kind_dialog.dart';

class ExtractionKindsPage extends ConsumerStatefulWidget {
  const ExtractionKindsPage({super.key});

  @override
  ConsumerState<ExtractionKindsPage> createState() =>
      _ExtractionKindsPageState();
}

class _ExtractionKindsPageState extends ConsumerState<ExtractionKindsPage> {
  final Set<String> _pendingDeletes = <String>{};
  final Set<String> _selectedIds = <String>{};
  bool _isSelecting = false;
  bool _isBulkDeleting = false;
  var _bulkDeleteInFlight = false;

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

  void _toggleSelectAll(List<String> selectableIds) {
    setState(() {
      final allSelected =
          selectableIds.isNotEmpty &&
          selectableIds.every(_selectedIds.contains);
      if (allSelected) {
        _selectedIds.removeAll(selectableIds);
      } else {
        _selectedIds.addAll(selectableIds);
      }
    });
  }

  Future<void> _setEnabled(
    BuildContext context,
    ExtractionItemKind kind,
    bool enabled,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(extractionKindsControllerProvider.notifier)
          .setEnabled(id: kind.id, enabled: enabled);
    } catch (error) {
      if (!context.mounted) return;
      final message = enabled
          ? l10n.extractionKindsEnabledFull
          : l10n.extractionKindsCannotDisableLast;
      showAppSnackBar(context, content: Text(message));
    }
  }

  Future<bool> _confirmAndDelete(ExtractionItemKind kind) async {
    if (kind.isBuiltIn) return false;
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmDeleteExtractionKind(context);
    if (!confirmed || !mounted) return false;

    try {
      await ref
          .read(extractionKindsControllerProvider.notifier)
          .archive(kind.id);
      if (mounted) {
        setState(() => _pendingDeletes.add(kind.id));
      }
      return true;
    } catch (error) {
      if (!mounted) return false;
      showAppSnackBar(
        context,
        content: Text(l10n.extractionKindsCannotArchiveInUse),
      );
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
      final confirmed = await confirmDeleteExtractionKinds(
        context,
        count: ids.length,
      );
      if (!confirmed || !mounted) return;

      setState(() => _isBulkDeleting = true);
      final actions = ref.read(extractionKindsControllerProvider.notifier);
      for (final id in ids) {
        try {
          await actions.archive(id);
          deleted.add(id);
        } catch (_) {
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
      showAppSnackBar(
        context,
        content: Text(l10n.extractionKindsBulkDeleteFailed),
      );
    }
  }

  Future<void> _resetBuiltIns(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(extractionKindsControllerProvider.notifier)
          .resetBuiltIns();
      if (!context.mounted) return;
      showAppSnackBar(context, content: Text(l10n.extractionKindsResetDone));
    } catch (error) {
      if (!context.mounted) return;
      showAppSnackBar(context, content: Text(failureMessage(l10n, error)));
    }
  }

  Future<void> _showInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InfoCard(
                  icon: Icons.info_outline,
                  title: l10n.extractionKindsInfoTitle,
                  subtitle: l10n.extractionKindsInfoBody,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(l10n.capturePrivacyDialogDismiss),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _appBarActions(
    AppLocalizations l10n, {
    required List<String> selectableIds,
  }) {
    if (_isSelecting) {
      final allSelected =
          selectableIds.isNotEmpty &&
          selectableIds.every(_selectedIds.contains);
      return [
        TextButton(
          onPressed: _isBulkDeleting ? null : _exitSelectionMode,
          child: Text(l10n.listSelectionDone),
        ),
        if (selectableIds.isNotEmpty)
          IconButton(
            tooltip: allSelected
                ? l10n.listClearSelectionTooltip
                : l10n.listSelectAllTooltip,
            icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
            onPressed: _isBulkDeleting
                ? null
                : () => _toggleSelectAll(selectableIds),
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
            onPressed: _selectedIds.isEmpty ? null : _confirmAndBulkDelete,
          ),
      ];
    }

    return [
      if (selectableIds.isNotEmpty)
        IconButton(
          tooltip: l10n.listSelectTooltip,
          icon: const Icon(Icons.library_add_check_outlined),
          onPressed: _enterSelectionMode,
        ),
      IconButton(
        tooltip: l10n.extractionKindsInfoTooltip,
        icon: const Icon(Icons.info_outline),
        onPressed: () => _showInfo(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kinds = ref.watch(extractionItemKindsProvider);

    final selectableIds = kinds.maybeWhen(
      data: (items) => [
        for (final kind in items)
          if (!_pendingDeletes.contains(kind.id) && !kind.isBuiltIn) kind.id,
      ],
      orElse: () => const <String>[],
    );

    return PopScope(
      canPop: !_isSelecting,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || !_isSelecting || _isBulkDeleting) return;
        _exitSelectionMode();
      },
      child: QuorivellScaffold(
        // List FAB clearance + Add button; body extends under the shell notch.
        appBar: AppBar(
          title: Text(
            _isSelecting
                ? l10n.listSelectedCount(_selectedIds.length)
                : l10n.extractionKindsTitle,
          ),
          actions: _appBarActions(l10n, selectableIds: selectableIds),
        ),
        floatingActionButton: _isSelecting
            ? null
            : FloatingActionButton.extended(
                onPressed: () => context.push('/review/kinds/new'),
                icon: const Icon(Icons.add),
                label: Text(l10n.extractionKindsAdd),
              ),
        body: kinds.when(
          loading: () => const LoadingState(),
          error: (error, _) => EmptyState(
            icon: Icons.error_outline,
            title: l10n.extractionKindsEmptyTitle,
            subtitle: failureMessage(l10n, error),
          ),
          data: (items) {
            final visible = [
              for (final kind in items)
                if (!_pendingDeletes.contains(kind.id)) kind,
            ];
            if (visible.isEmpty) {
              return EmptyState(
                icon: Icons.category_outlined,
                title: l10n.extractionKindsEmptyTitle,
                subtitle: l10n.extractionKindsEmptyBody,
                action: () => context.push('/review/kinds/new'),
                actionLabel: l10n.extractionKindsAdd,
              );
            }
            final ordered = orderedExtractionKinds(visible);
            return ListView(
              children: [
                SectionHeader(
                  title: l10n.extractionKindsTitle,
                  subtitle: _isSelecting
                      ? l10n.listSelectedCount(_selectedIds.length)
                      : l10n.extractionKindsSubtitle,
                ),
                if (!_isSelecting)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: TextButton(
                      onPressed: () => _resetBuiltIns(context),
                      child: Text(l10n.extractionKindResetBuiltIns),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                for (final kind in ordered)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    child: _KindTile(
                      kind: kind,
                      selectionMode: _isSelecting,
                      selected: _selectedIds.contains(kind.id),
                      onSelectionToggle: kind.isBuiltIn
                          ? null
                          : () => _toggleSelected(kind.id),
                      onOpen: () => context.push('/review/kinds/${kind.id}'),
                      onEnabledChanged: (enabled) =>
                          _setEnabled(context, kind, enabled),
                      onDeleteRequested: kind.isBuiltIn
                          ? null
                          : () => _confirmAndDelete(kind),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Enabled kinds first, then [ExtractionItemKind.sortOrder].
@visibleForTesting
List<ExtractionItemKind> orderedExtractionKinds(
  List<ExtractionItemKind> items,
) {
  final ordered = [...items];
  ordered.sort((a, b) {
    if (a.enabledForExtraction != b.enabledForExtraction) {
      return a.enabledForExtraction ? -1 : 1;
    }
    final byOrder = a.sortOrder.compareTo(b.sortOrder);
    if (byOrder != 0) return byOrder;
    return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
  });
  return ordered;
}

class _KindTile extends StatelessWidget {
  const _KindTile({
    required this.kind,
    required this.onOpen,
    required this.onEnabledChanged,
    this.onDeleteRequested,
    this.selectionMode = false,
    this.selected = false,
    this.onSelectionToggle,
  });

  final ExtractionItemKind kind;
  final VoidCallback onOpen;
  final ValueChanged<bool> onEnabledChanged;
  final Future<bool> Function()? onDeleteRequested;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onSelectionToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final deleteRequested = onDeleteRequested;
    final canSelect = selectionMode && onSelectionToggle != null;

    final tile = Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: canSelect
            ? onSelectionToggle
            : selectionMode
            ? null
            : onOpen,
        onLongPress: canSelect
            ? onSelectionToggle
            : deleteRequested == null
            ? null
            : () async {
                await deleteRequested();
              },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (selectionMode)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
                  child: Checkbox(
                    value: canSelect ? selected : false,
                    onChanged: canSelect
                        ? (_) => onSelectionToggle?.call()
                        : null,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      extractionKindDisplayName(
                        l10n,
                        kind.slug,
                        snapshot: kind.displayName,
                      ),
                      style: theme.textTheme.titleMedium,
                    ),
                    if (kind.isBuiltIn) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.extractionKindsBuiltInBadge,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.extractionKindsEnabledLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!selectionMode)
                Switch.adaptive(
                  value: kind.enabledForExtraction,
                  onChanged: onEnabledChanged,
                ),
            ],
          ),
        ),
      ),
    );

    if (selectionMode || deleteRequested == null) return tile;

    return Dismissible(
      key: ValueKey(kind.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => deleteRequested(),
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
      child: tile,
    );
  }
}
