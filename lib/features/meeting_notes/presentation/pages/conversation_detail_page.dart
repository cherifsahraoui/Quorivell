import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/providers/source_conversation_providers.dart';
import '../controllers/conversation_actions_controller.dart';
import '../widgets/confirm_delete_conversation_dialog.dart';
import '../widgets/conversation_evidence_highlight.dart';
import '../widgets/source_conversation_website_link.dart';

class ConversationDetailPage extends ConsumerWidget {
  const ConversationDetailPage({
    required this.sourceId,
    this.highlightQuoteStart,
    this.highlightQuoteEnd,
    this.highlightQuoteSnippet,
    super.key,
  });

  final String sourceId;
  final int? highlightQuoteStart;
  final int? highlightQuoteEnd;
  final String? highlightQuoteSnippet;

  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref, {
    required bool isArchived,
  }) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmDeleteConversation(
      context,
      warnLedgerLinks: isArchived,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await ref
          .read(conversationActionsControllerProvider.notifier)
          .delete(sourceId);
      if (!context.mounted) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      }
    } on AppFailure {
      if (!context.mounted) return;
      showAppSnackBar(context, content: Text(l10n.conversationDeleteFailed));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final conversation = ref.watch(sourceConversationByIdProvider(sourceId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.conversationDetailTitle),
        actions: [
          conversation.maybeWhen(
            data: (value) {
              if (value == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: l10n.conversationDeleteTooltip,
                onPressed: () => _confirmAndDelete(
                  context,
                  ref,
                  isArchived: value.isArchived,
                ),
                icon: Icon(Icons.delete_outline, color: colorScheme.error),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: conversation.when(
        loading: () => const LoadingState(),
        error: (_, _) => EmptyState(
          icon: Icons.error_outline,
          title: l10n.conversationDetailUnavailable,
        ),
        data: (value) {
          if (value == null) {
            return EmptyState(
              icon: Icons.chat_bubble_outline_outlined,
              title: l10n.conversationDetailNotFound,
            );
          }
          final dateFormat = DateFormat.yMMMd().add_jm();
          final sourceUrl = value.sourceUrl;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            dateFormat.format(value.updatedAt.toLocal()),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (sourceUrl != null && sourceUrl.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: SourceConversationWebsiteLink(
                          sourceUrl: sourceUrl,
                        ),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: ConversationEvidenceHighlight(
                        content: value.content,
                        quoteStart: highlightQuoteStart,
                        quoteEnd: highlightQuoteEnd,
                        quoteSnippet: highlightQuoteSnippet,
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
            ],
          );
        },
      ),
    );
  }
}
