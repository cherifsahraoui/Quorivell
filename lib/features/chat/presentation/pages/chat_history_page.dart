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
import '../../data/providers/chat_providers.dart';
import '../../domain/entities/ai_chat_thread.dart';
import '../controllers/chat_session_controller.dart';
import '../widgets/confirm_delete_chat_thread_dialog.dart';

class ChatHistoryPage extends ConsumerStatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  ConsumerState<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends ConsumerState<ChatHistoryPage> {
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
    final confirmed = await confirmDeleteChatThread(context);
    if (!confirmed || !mounted) return false;

    try {
      await ref.read(chatSessionControllerProvider.notifier).deleteThread(id);
      if (mounted) {
        setState(() => _pendingDeletes.add(id));
      }
      return true;
    } on AppFailure {
      if (!mounted) return false;
      showAppSnackBar(context, content: Text(l10n.chatDeleteFailed));
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
      final confirmed = await confirmDeleteChatThreads(
        context,
        count: ids.length,
      );
      if (!confirmed || !mounted) return;

      setState(() => _isBulkDeleting = true);
      final actions = ref.read(chatSessionControllerProvider.notifier);
      for (final id in ids) {
        try {
          await actions.deleteThread(id);
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
      showAppSnackBar(context, content: Text(l10n.chatBulkDeleteFailed));
    }
  }

  List<Widget> _appBarActions(
    AppLocalizations l10n, {
    required List<String> visibleIds,
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
            onPressed: _selectedIds.isEmpty ? null : _confirmAndBulkDelete,
          ),
      ];
    }

    return [
      if (visibleIds.isNotEmpty)
        IconButton(
          tooltip: l10n.listSelectTooltip,
          icon: const Icon(Icons.library_add_check_outlined),
          onPressed: _enterSelectionMode,
        ),
      IconButton(
        icon: const Icon(Icons.edit_square),
        tooltip: l10n.chatNewTooltip,
        onPressed: () {
          ref.read(chatSessionControllerProvider.notifier).startNewChat();
          context.go('/chat');
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final threads = ref.watch(chatThreadsProvider);
    final activeId = ref.watch(chatSessionControllerProvider).threadId;

    final visibleIds = threads.maybeWhen(
      data: (items) => [
        for (final item in items)
          if (!_pendingDeletes.contains(item.id)) item.id,
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
                : l10n.chatHistoryTitle,
          ),
          actions: _appBarActions(l10n, visibleIds: visibleIds),
        ),
        body: threads.when(
          loading: () => const LoadingState(),
          error: (_, _) => EmptyState(
            icon: Icons.error_outline,
            title: l10n.chatHistoryUnavailable,
          ),
          data: (items) {
            final visible = items
                .where((item) => !_pendingDeletes.contains(item.id))
                .toList();
            if (visible.isEmpty) {
              return EmptyState(
                icon: Icons.forum_outlined,
                title: l10n.chatHistoryEmpty,
                subtitle: l10n.chatHistoryEmptySubtitle,
              );
            }
            final dateFormat = DateFormat.yMMMd().add_jm();
            return ListView.separated(
              padding: ShellBottomInset.listPadding(context),
              itemCount: visible.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final thread = visible[index];
                return _ChatHistoryTile(
                  thread: thread,
                  dateLabel: dateFormat.format(thread.updatedAt.toLocal()),
                  modelLabel: thread.modelId,
                  isActive: thread.id == activeId,
                  selectionMode: _isSelecting,
                  selected: _selectedIds.contains(thread.id),
                  onSelectionToggle: () => _toggleSelected(thread.id),
                  onOpen: () {
                    ref
                        .read(chatSessionControllerProvider.notifier)
                        .openThread(thread.id);
                    context.go('/chat');
                  },
                  onDeleteRequested: () => _confirmAndDelete(thread.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ChatHistoryTile extends StatelessWidget {
  const _ChatHistoryTile({
    required this.thread,
    required this.dateLabel,
    required this.modelLabel,
    required this.isActive,
    required this.onOpen,
    required this.onDeleteRequested,
    this.selectionMode = false,
    this.selected = false,
    this.onSelectionToggle,
  });

  final AiChatThread thread;
  final String dateLabel;
  final String? modelLabel;
  final bool isActive;
  final VoidCallback onOpen;
  final Future<bool> Function() onDeleteRequested;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onSelectionToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final highlight = !selectionMode && isActive;
    final secondaryColor = highlight
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;
    final trimmedModel = modelLabel?.trim();
    final hasModel = trimmedModel != null && trimmedModel.isNotEmpty;

    final card = Card(
      clipBehavior: Clip.antiAlias,
      color: highlight ? colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: selectionMode ? onSelectionToggle : onOpen,
        onLongPress: selectionMode
            ? onSelectionToggle
            : () async {
                await onDeleteRequested();
              },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (selectionMode)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
                  child: Checkbox(
                    value: selected,
                    onChanged: (_) => onSelectionToggle?.call(),
                  ),
                ),
              CircleAvatar(
                backgroundColor: highlight
                    ? colorScheme.primary
                    : colorScheme.secondaryContainer,
                foregroundColor: highlight
                    ? colorScheme.onPrimary
                    : colorScheme.onSecondaryContainer,
                child: const Icon(Icons.forum_outlined),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: highlight
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hasModel) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        trimmedModel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      dateLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondaryColor,
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
      key: ValueKey(thread.id),
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
