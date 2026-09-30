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
import '../../data/providers/source_conversation_providers.dart';
import '../../domain/entities/source_conversation.dart';
import '../controllers/conversation_actions_controller.dart';
import '../controllers/conversation_history_filter_controller.dart';
import '../widgets/confirm_delete_conversation_dialog.dart';
import '../widgets/confirm_unarchive_conversation_dialog.dart';

class ConversationHistoryPage extends ConsumerStatefulWidget {
  const ConversationHistoryPage({super.key});

  @override
  ConsumerState<ConversationHistoryPage> createState() =>
      _ConversationHistoryPageState();
}

class _ConversationHistoryPageState
    extends ConsumerState<ConversationHistoryPage> {
  final Set<String> _pendingDeletes = <String>{};
  final Set<String> _pendingUnarchives = <String>{};
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

  Future<bool> _confirmAndDelete(SourceConversation conversation) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmDeleteConversation(
      context,
      warnLedgerLinks: conversation.isArchived,
    );
    if (!confirmed || !mounted) return false;

    try {
      await ref
          .read(conversationActionsControllerProvider.notifier)
          .delete(conversation.id);
      if (mounted) {
        setState(() => _pendingDeletes.add(conversation.id));
      }
      return true;
    } on AppFailure {
      if (!mounted) return false;
      showAppSnackBar(context, content: Text(l10n.conversationDeleteFailed));
      return false;
    }
  }

  Future<void> _confirmAndBulkDelete(List<SourceConversation> visible) async {
    if (_bulkDeleteInFlight) return;
    final l10n = AppLocalizations.of(context);
    final ids = _selectedIds.toList(growable: false);
    if (ids.isEmpty) return;

    final selected = [
      for (final conversation in visible)
        if (_selectedIds.contains(conversation.id)) conversation,
    ];
    final warnLedgerLinks = selected.any((c) => c.isArchived);

    _bulkDeleteInFlight = true;
    final deleted = <String>[];
    var failed = false;
    try {
      final confirmed = await confirmDeleteConversations(
        context,
        count: ids.length,
        warnLedgerLinks: warnLedgerLinks,
      );
      if (!confirmed || !mounted) return;

      setState(() => _isBulkDeleting = true);
      final actions = ref.read(conversationActionsControllerProvider.notifier);
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
      showAppSnackBar(
        context,
        content: Text(l10n.conversationBulkDeleteFailed),
      );
    }
  }

  Future<void> _unarchive(SourceConversation conversation) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(conversationActionsControllerProvider.notifier)
          .unarchive(conversation.id);
      if (!mounted) return;
      setState(() => _pendingUnarchives.add(conversation.id));
      showAppSnackBar(
        context,
        content: Text(l10n.conversationUnarchiveSuccess),
      );
    } on AppFailure {
      if (!mounted) return;
      showAppSnackBar(context, content: Text(l10n.conversationUnarchiveFailed));
    }
  }

  Future<void> _onLongPress(SourceConversation conversation) async {
    if (conversation.isArchived) {
      final confirmed = await confirmUnarchiveConversation(context);
      if (!confirmed || !mounted) return;
      await _unarchive(conversation);
      return;
    }
    await _confirmAndDelete(conversation);
  }

  List<Widget> _appBarActions(
    AppLocalizations l10n, {
    required List<String> visibleIds,
    required List<SourceConversation> visible,
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
                : () => _confirmAndBulkDelete(visible),
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
    final filter = ref.watch(conversationHistoryFilterControllerProvider);
    final conversations = ref.watch(
      sourceConversationsProvider(filter == ConversationHistoryFilter.archived),
    );

    final visible = conversations.maybeWhen(
      data: (items) => items.where((item) {
        if (_pendingDeletes.contains(item.id)) return false;
        if (filter == ConversationHistoryFilter.archived &&
            _pendingUnarchives.contains(item.id)) {
          return false;
        }
        return true;
      }).toList(),
      orElse: () => const <SourceConversation>[],
    );
    final visibleIds = [for (final item in visible) item.id];

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
                : l10n.conversationHistoryTitle,
          ),
          actions: _appBarActions(
            l10n,
            visibleIds: visibleIds,
            visible: visible,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isSelecting)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    FilterChip(
                      label: Text(l10n.conversationHistoryFilterActive),
                      selected: filter == ConversationHistoryFilter.active,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      visualDensity: VisualDensity.standard,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                      onSelected: (_) => ref
                          .read(
                            conversationHistoryFilterControllerProvider
                                .notifier,
                          )
                          .select(ConversationHistoryFilter.active),
                    ),
                    FilterChip(
                      label: Text(l10n.conversationHistoryFilterArchived),
                      selected: filter == ConversationHistoryFilter.archived,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      visualDensity: VisualDensity.standard,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                      onSelected: (_) => ref
                          .read(
                            conversationHistoryFilterControllerProvider
                                .notifier,
                          )
                          .select(ConversationHistoryFilter.archived),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: conversations.when(
                loading: () => const LoadingState(),
                error: (_, _) => EmptyState(
                  icon: Icons.error_outline,
                  title: l10n.conversationHistoryUnavailable,
                ),
                data: (_) {
                  if (visible.isEmpty) {
                    final isArchived =
                        filter == ConversationHistoryFilter.archived;
                    return EmptyState(
                      icon: isArchived
                          ? Icons.inventory_2_outlined
                          : Icons.chat_bubble_outline,
                      title: isArchived
                          ? l10n.conversationHistoryEmptyArchived
                          : l10n.conversationHistoryEmpty,
                      subtitle: isArchived
                          ? l10n.conversationHistoryEmptyArchivedSubtitle
                          : l10n.conversationHistoryEmptySubtitle,
                    );
                  }
                  final dateFormat = DateFormat.yMMMd().add_jm();
                  return ListView.separated(
                    padding: ShellBottomInset.listPadding(context),
                    itemCount: visible.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final conversation = visible[index];
                      return _ConversationHistoryTile(
                        conversation: conversation,
                        dateLabel: dateFormat.format(
                          conversation.updatedAt.toLocal(),
                        ),
                        selectionMode: _isSelecting,
                        selected: _selectedIds.contains(conversation.id),
                        onSelectionToggle: () =>
                            _toggleSelected(conversation.id),
                        onOpen: () =>
                            context.push('/capture/sources/${conversation.id}'),
                        onDeleteRequested: () =>
                            _confirmAndDelete(conversation),
                        onLongPress: () => _onLongPress(conversation),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationHistoryTile extends StatelessWidget {
  const _ConversationHistoryTile({
    required this.conversation,
    required this.dateLabel,
    required this.onOpen,
    required this.onDeleteRequested,
    required this.onLongPress,
    this.selectionMode = false,
    this.selected = false,
    this.onSelectionToggle,
  });

  final SourceConversation conversation;
  final String dateLabel;
  final VoidCallback onOpen;
  final Future<bool> Function() onDeleteRequested;
  final Future<void> Function() onLongPress;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onSelectionToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final card = Card(
      child: InkWell(
        onTap: selectionMode ? onSelectionToggle : onOpen,
        onLongPress: selectionMode
            ? onSelectionToggle
            : () async {
                await onLongPress();
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
                  conversation.isArchived
                      ? Icons.inventory_2_outlined
                      : Icons.chat_bubble_outline,
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
                      conversation.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      dateLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (conversation.isArchived) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.conversationHistoryArchivedBadge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      if (!selectionMode)
                        Text(
                          l10n.conversationUnarchiveHint,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              if (!selectionMode)
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );

    if (selectionMode) return card;

    return Dismissible(
      key: ValueKey(conversation.id),
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
