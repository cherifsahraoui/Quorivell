import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/ai/extraction_kind_slugs.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/background_work_constraint_dialogs.dart';
import '../../../../core/platform/notification_permission_dialogs.dart';
import '../../../../core/routing/post_setup_home.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/debug_json_panel.dart';
import '../../../../core/widgets/due_date_picker_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/data/providers/debug_ai_settings_providers.dart';
import '../../../extraction_kinds/data/providers/extraction_item_kind_providers.dart';
import '../../../extraction_kinds/domain/entities/extraction_item_kind.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';
import '../../../meeting_notes/data/providers/source_conversation_providers.dart';
import '../../../onboarding/presentation/local_model_required_dialog.dart';
import '../../domain/entities/review_candidate.dart';
import '../controllers/review_controller.dart';
import '../widgets/review_candidate_kind_toggle.dart';
import '../widgets/empty_extract_example_dialog.dart';
import '../widgets/extract_source_chooser_sheet.dart';
import '../../../../core/layout/shell_bottom_inset.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';

/// Brief pause so the completion state can register before switching tabs.
const Duration kReviewLedgerHandoffDelay = Duration(milliseconds: 900);

class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({
    super.key,
    this.ledgerHandoffDelay = kReviewLedgerHandoffDelay,
  });

  /// Delay before auto-navigation to the ledger after the queue clears.
  /// Tests may shorten this; production uses [kReviewLedgerHandoffDelay].
  final Duration ledgerHandoffDelay;

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  bool _handingOffToLedger = false;
  Timer? _handoffTimer;
  var _openedTeachHelp = false;

  @override
  void dispose() {
    _handoffTimer?.cancel();
    super.dispose();
  }

  void _beginLedgerHandoff() {
    if (_handingOffToLedger) return;
    setState(() => _handingOffToLedger = true);
    _handoffTimer?.cancel();
    _handoffTimer = Timer(widget.ledgerHandoffDelay, _goToLedger);
  }

  void _goToLedger() {
    _handoffTimer?.cancel();
    if (!mounted) return;
    context.go('/ledger');
    setState(() => _handingOffToLedger = false);
  }

  String? _activeKindsSubtitle(
    AppLocalizations l10n,
    List<ExtractionItemKind> enabledKinds,
  ) {
    if (enabledKinds.isEmpty) return null;
    final names = [
      for (final kind in enabledKinds)
        extractionKindDisplayName(
          l10n,
          kind.slug,
          snapshot: kind.displayName,
          catalog: enabledKinds,
        ),
    ];
    return l10n.extractionKindsActiveSubtitle(names.join(', '));
  }

  Future<void> _showKindsInfo(BuildContext context) {
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
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  void _maybeOpenTeachHelp(BuildContext context) {
    final teach =
        GoRouterState.of(
          context,
        ).uri.queryParameters[PostSetupHome.teachQuery] ==
        PostSetupHome.teachValue;
    if (!teach) {
      _openedTeachHelp = false;
      return;
    }
    if (_openedTeachHelp) return;
    _openedTeachHelp = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go(PostSetupHome.review);
      final sheetL10n = AppLocalizations.of(context);
      showEmptyExtractExampleDialog(
        context,
        enabledKinds:
            ref.read(enabledExtractionItemKindsProvider).asData?.value ??
            const [],
        systemPromptModified: _systemPromptModified(sheetL10n),
      );
    });
  }

  bool _systemPromptModified(AppLocalizations l10n) {
    final prefs = ref.read(debugAiSettingsControllerProvider).asData?.value;
    return prefs?.extractionSystemPromptOverride?.trim().isNotEmpty ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final candidates = ref.watch(reviewQueueControllerProvider);
    final isExtracting = ref.watch(extractionRunningControllerProvider);
    final enabledKinds =
        ref.watch(enabledExtractionItemKindsProvider).asData?.value ??
        const <ExtractionItemKind>[];
    final l10n = AppLocalizations.of(context);
    _maybeOpenTeachHelp(context);

    ref.listen(reviewActionsControllerProvider, (previous, next) {
      if (next.hasError) {
        final alreadyShown =
            previous?.hasError == true &&
            previous?.isLoading != true &&
            previous?.error == next.error;
        if (alreadyShown) return;
        showAppSnackBar(
          context,
          content: Text(failureMessage(l10n, next.error)),
        );
        // Extract only targets active captures; send the user to add one.
        if (next.error is ExtractionNoSourceConversationFailure) {
          context.go('/capture');
        }
        return;
      }
      if (previous?.isLoading == true && next.hasValue && next.value == 0) {
        showEmptyExtractExampleDialog(
          context,
          enabledKinds:
              ref.read(enabledExtractionItemKindsProvider).asData?.value ??
              const [],
          systemPromptModified: _systemPromptModified(l10n),
        );
      }
    });

    ref.listen(reviewQueueControllerProvider, (previous, next) {
      final previousItems = previous?.asData?.value;
      final nextItems = next.asData?.value;
      if (previousItems == null || nextItems == null) return;

      // Only navigate to ledger when queue is empty AND extraction is not running
      final extractionComplete = !ref.read(extractionRunningControllerProvider);

      if (previousItems.isNotEmpty && nextItems.isEmpty && extractionComplete) {
        _beginLedgerHandoff();
      }
    });

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: candidates.when(
        loading: () => const LoadingState(key: ValueKey('review-loading')),
        error: (_, _) => EmptyState(
          key: const ValueKey('review-error'),
          icon: Icons.error_outline,
          title: l10n.reviewUnavailable,
        ),
        data: (items) {
          if (_handingOffToLedger) {
            return _ReviewCompleteHandoff(
              key: const ValueKey('review-complete'),
              onViewLedger: _goToLedger,
            );
          }
          if (items.isEmpty) {
            final activeCaptures = ref.watch(
              sourceConversationsProvider(false),
            );
            return CustomScrollView(
              key: const ValueKey('review-empty'),
              slivers: [
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: l10n.navReview,
                    subtitle: _activeKindsSubtitle(l10n, enabledKinds),
                    action: _ReviewHeaderActions(
                      onInfo: () => _showKindsInfo(context),
                      onKinds: () => context.push('/review/kinds'),
                      onHistory: () => context.push('/review/rejected'),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: _ExtractionKindsIntroBanner()),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: activeCaptures.when(
                    loading: () => const LoadingState(),
                    error: (_, _) => _EmptyReviewState(
                      hasActiveCapture: false,
                      onExtract: () => _extract(context, ref),
                      onGoToCapture: () => context.go('/capture'),
                      isExtracting: isExtracting,
                    ),
                    data: (captures) => _EmptyReviewState(
                      hasActiveCapture: captures.isNotEmpty,
                      onExtract: () => _extract(context, ref),
                      onGoToCapture: () => context.go('/capture'),
                      isExtracting: isExtracting,
                    ),
                  ),
                ),
              ],
            );
          }
          return CustomScrollView(
            key: const ValueKey('review-list'),
            slivers: [
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: l10n.navReview,
                  subtitle: [
                    l10n.reviewPendingCount(items.length),
                    ?_activeKindsSubtitle(l10n, enabledKinds),
                  ].join(' · '),
                  action: _ReviewHeaderActions(
                    onInfo: () => _showKindsInfo(context),
                    onKinds: () => context.push('/review/kinds'),
                    onHistory: () => context.push('/review/rejected'),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: _ExtractionKindsIntroBanner()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final candidate = items[index];
                    return _EditableCandidateCard(
                      key: ValueKey(candidate.id),
                      candidate: candidate,
                      catalog:
                          ref
                              .watch(extractionItemKindsProvider)
                              .asData
                              ?.value ??
                          const [],
                      showDebugJson:
                          ref
                              .watch(debugAiSettingsControllerProvider)
                              .asData
                              ?.value
                              ?.debugModeEnabled ??
                          false,
                      onAccept: (edited) => _accept(ref, edited),
                      onReject: () => ref
                          .read(reviewActionsControllerProvider.notifier)
                          .changeStatus(candidate, ReviewStatus.rejected),
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

  Future<void> _extract(BuildContext context, WidgetRef ref) async {
    final gate = await ensureLocalModelConfigured(context: context, ref: ref);
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    switch (gate) {
      case LocalModelGateResult.configure:
        context.go('/account/model');
      case LocalModelGateResult.dismissed:
        return;
      case LocalModelGateResult.ready:
        await showNotificationPermissionExtractionReminder(
          context: context,
          ref: ref,
        );
        if (!context.mounted) return;
        await showBackgroundWorkExtractionReminder(context: context, ref: ref);
        if (!context.mounted) return;

        final sourceRepository = ref.read(sourceConversationRepositoryProvider);
        final activeNewestFirst = await sourceRepository.listActive();
        if (!context.mounted) return;

        if (activeNewestFirst.isEmpty) {
          await ref
              .read(reviewActionsControllerProvider.notifier)
              .extractSourcesChunked(
                sourceConversationIds: const [],
                progressTitle: l10n.extractionInProgress,
                progressBody: l10n.extractionNotificationBody,
                completionTitle: l10n.extractionCompleteNotificationTitle,
                completionBody: (count) =>
                    l10n.extractionCompleteNotificationBody(count),
              );
          return;
        }

        List<String> idsToExtract;
        if (activeNewestFirst.length == 1) {
          idsToExtract = [activeNewestFirst.single.id];
        } else {
          final choice = await showExtractSourceChooser(
            context: context,
            conversations: activeNewestFirst,
          );
          if (!context.mounted || choice == null) return;
          idsToExtract = switch (choice) {
            ExtractAllActiveChoice() => [
              for (final conversation in activeNewestFirst.reversed)
                conversation.id,
            ],
            ExtractSingleChoice(:final conversation) => [conversation.id],
          };
          if (!context.mounted) return;
        }

        await ref
            .read(reviewActionsControllerProvider.notifier)
            .extractSourcesChunked(
              sourceConversationIds: idsToExtract,
              progressTitle: l10n.extractionInProgress,
              progressBody: l10n.extractionNotificationBody,
              completionTitle: l10n.extractionCompleteNotificationTitle,
              completionBody: (count) =>
                  l10n.extractionCompleteNotificationBody(count),
            );
    }
  }

  Future<void> _accept(WidgetRef ref, ReviewCandidate candidate) {
    return ref.read(reviewActionsControllerProvider.notifier).accept(candidate);
  }
}

class _ReviewCompleteHandoff extends StatelessWidget {
  const _ReviewCompleteHandoff({required this.onViewLedger, super.key});

  final VoidCallback onViewLedger;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.check_circle_outline,
      title: l10n.reviewCompleteTitle,
      subtitle: l10n.reviewCompleteSubtitle,
      action: onViewLedger,
      actionLabel: l10n.reviewCompleteGoToLedger,
      actionIcon: Icons.menu_book_outlined,
    );
  }
}

class _EmptyReviewState extends StatelessWidget {
  const _EmptyReviewState({
    required this.hasActiveCapture,
    required this.onExtract,
    required this.onGoToCapture,
    required this.isExtracting,
  });

  final bool hasActiveCapture;
  final VoidCallback onExtract;
  final VoidCallback onGoToCapture;
  final bool isExtracting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!hasActiveCapture) {
      return EmptyState(
        icon: Icons.edit_note_outlined,
        title: l10n.reviewEmptyNoCaptureTitle,
        subtitle: l10n.reviewEmptyNoCaptureSubtitle,
        action: onGoToCapture,
        actionLabel: l10n.reviewGoToCaptureButton,
        actionIcon: Icons.edit_note,
      );
    }
    return EmptyState(
      icon: Icons.fact_check_outlined,
      title: l10n.reviewEmptyTitle,
      subtitle: l10n.reviewEmptySubtitle,
      action: onExtract,
      actionLabel: l10n.reviewExtractButton,
      actionIcon: Icons.auto_awesome,
      isActionLoading: isExtracting,
    );
  }
}

class _ReviewHeaderActions extends StatelessWidget {
  const _ReviewHeaderActions({
    required this.onInfo,
    required this.onKinds,
    required this.onHistory,
  });

  final VoidCallback onInfo;
  final VoidCallback onKinds;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: l10n.extractionKindsInfoTooltip,
          onPressed: onInfo,
        ),
        IconButton(
          icon: const Icon(Icons.category_outlined),
          tooltip: l10n.extractionKindsOpenTooltip,
          onPressed: onKinds,
        ),
        IconButton(
          icon: const Icon(Icons.history),
          tooltip: l10n.reviewRejectedHistoryTooltip,
          onPressed: onHistory,
        ),
      ],
    );
  }
}

class _ExtractionKindsIntroBanner extends ConsumerWidget {
  const _ExtractionKindsIntroBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.watch(debugAiSettingsControllerProvider).asData?.value;
    final enabled =
        ref.watch(enabledExtractionItemKindsProvider).asData?.value ??
        const <ExtractionItemKind>[];
    final showIntro =
        prefs != null && prefs.extractionKindsIntroDismissed != true;
    final showAccuracy =
        enabled.length > ExtractionKindSlugs.accuracyGuidanceEnabledCount;

    if (!showIntro && !showAccuracy) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        children: [
          if (showIntro)
            InfoCard(
              icon: Icons.lightbulb_outline,
              title: l10n.extractionKindsBannerTitle,
              subtitle: l10n.extractionKindsBannerBody,
              onTap: () async {
                await ref
                    .read(debugAiSettingsControllerProvider.notifier)
                    .dismissExtractionKindsIntro();
              },
            ),
          if (showIntro && showAccuracy) const SizedBox(height: AppSpacing.sm),
          if (showAccuracy)
            InfoCard(
              icon: Icons.speed_outlined,
              title: l10n.extractionKindsAccuracyGuidance,
            ),
          if (showIntro)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () {
                  ref
                      .read(debugAiSettingsControllerProvider.notifier)
                      .dismissExtractionKindsIntro();
                },
                child: Text(l10n.extractionKindsBannerDismiss),
              ),
            ),
        ],
      ),
    );
  }
}

class _EditableCandidateCard extends StatefulWidget {
  const _EditableCandidateCard({
    super.key,
    required this.candidate,
    required this.catalog,
    required this.onAccept,
    required this.onReject,
    required this.showDebugJson,
  });

  final ReviewCandidate candidate;
  final List<ExtractionItemKind> catalog;
  final ValueChanged<ReviewCandidate> onAccept;
  final VoidCallback onReject;
  final bool showDebugJson;

  @override
  State<_EditableCandidateCard> createState() => _EditableCandidateCardState();
}

class _EditableCandidateCardState extends State<_EditableCandidateCard> {
  late final TextEditingController _statementController = TextEditingController(
    text: widget.candidate.statement,
  );
  late final TextEditingController _noteController = TextEditingController(
    text: widget.candidate.note ?? '',
  );
  late String _kind;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _kind = widget.candidate.kind;
    _dueDate = widget.candidate.dueDate;
    _statementController.addListener(_onFieldsChanged);
    _noteController.addListener(_onFieldsChanged);
  }

  void _onFieldsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(_EditableCandidateCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.candidate;
    final next = widget.candidate;
    final statementChanged =
        previous.id != next.id || previous.statement != next.statement;
    final kindChanged = previous.id != next.id || previous.kind != next.kind;
    final dueDateChanged =
        previous.id != next.id || previous.dueDate != next.dueDate;
    final noteChanged = previous.id != next.id || previous.note != next.note;
    if (statementChanged && _statementController.text != next.statement) {
      _statementController.text = next.statement;
    }
    if (kindChanged && _kind != next.kind) {
      _kind = next.kind;
    }
    if (dueDateChanged && _dueDate != next.dueDate) {
      _dueDate = next.dueDate;
    }
    final nextNote = next.note ?? '';
    if (noteChanged && _noteController.text != nextNote) {
      _noteController.text = nextNote;
    }
  }

  @override
  void dispose() {
    _statementController.removeListener(_onFieldsChanged);
    _noteController.removeListener(_onFieldsChanged);
    _statementController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  ReviewCandidate get _edited {
    final match = kindBySlug(widget.catalog, _kind);
    return widget.candidate.copyWith(
      kind: _kind,
      statement: _statementController.text,
      dueDate: match?.datePolicy == ExtractionKindFieldPolicy.none
          ? null
          : _dueDate,
      note: match?.notePolicy == ExtractionKindFieldPolicy.none
          ? null
          : _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final match = kindBySlug(widget.catalog, _kind);
    final showDue = kindAllowsDueDate(
      match,
      existingDueDate: _dueDate,
      slug: _kind,
    );
    final showNote = kindAllowsNote(
      match,
      existingNote: _noteController.text,
      slug: _kind,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReviewCandidateKindToggle(
              value: _kind,
              catalog: widget.catalog,
              onChanged: (kind) {
                final next = kindBySlug(widget.catalog, kind);
                setState(() {
                  _kind = kind;
                  if (next?.datePolicy == ExtractionKindFieldPolicy.none) {
                    _dueDate = null;
                  }
                });
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _statementController,
              maxLines: 3,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: l10n.reviewCandidateStatementLabel,
                helperText: l10n.teachingStatementHelp,
                helperMaxLines: 3,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      l10n.reviewEvidenceLabel(widget.candidate.quoteSnippet),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showDebugJson) ...[
              const SizedBox(height: AppSpacing.sm),
              _ReviewCandidateDebugJson(candidate: widget.candidate),
            ],
            if (widget.candidate.owner != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    l10n.ownerLabel(widget.candidate.owner!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: showDue
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDueDatePicker(
                              context: context,
                              initialDate: _dueDate,
                            );
                            if (picked != null) {
                              setState(() => _dueDate = picked.dueDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            _dueDate == null
                                ? l10n.reviewSetDueDateOptional
                                : DateFormat.yMMMd().add_jm().format(
                                    _dueDate!.toLocal(),
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            if (showNote) ...[
              AppTextField(
                controller: _noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: l10n.ledgerNoteFieldLabel,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                FilledButton.icon(
                  onPressed: _statementController.text.trim().isEmpty
                      ? null
                      : () => widget.onAccept(_edited),
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(l10n.reviewAcceptButton),
                ),
                TextButton(
                  onPressed: widget.onReject,
                  child: Text(
                    l10n.reviewRejectButton,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Debug-only panel showing the extraction-shaped JSON for a review candidate.
class _ReviewCandidateDebugJson extends StatelessWidget {
  const _ReviewCandidateDebugJson({required this.candidate});

  final ReviewCandidate candidate;

  String get _prettyJson {
    final payload = <String, Object?>{
      'id': candidate.id,
      'kind': candidate.kind,
      'statement': candidate.statement,
      'owner': candidate.owner,
      'dueDate': candidate.dueDate?.toUtc().toIso8601String(),
      'quoteStart': candidate.quoteStart,
      'quoteEnd': candidate.quoteEnd,
      'quoteSnippet': candidate.quoteSnippet,
      'sourceConversationId': candidate.sourceConversationId,
      'sourceRevision': candidate.sourceRevision,
      'reviewStatus': candidate.reviewStatus.name,
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  @override
  Widget build(BuildContext context) {
    return DebugJsonPanel(json: _prettyJson);
  }
}
