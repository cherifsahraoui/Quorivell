import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/due_date_picker_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extraction_kinds/domain/entities/extraction_item_kind.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';
import '../../domain/entities/review_candidate.dart';
import 'review_candidate_kind_toggle.dart';

/// Opens a dialog to accept a rejected suggestion into the ledger.
///
/// Returns the edited [ReviewCandidate] when the user confirms Accept, or
/// `null` when cancelled. Does not persist — callers own acceptance.
Future<ReviewCandidate?> showAcceptRejectedReviewDialog({
  required BuildContext context,
  required ReviewCandidate candidate,
  required List<ExtractionItemKind> catalog,
}) {
  return showDialog<ReviewCandidate>(
    context: context,
    builder: (context) =>
        _AcceptRejectedReviewDialog(candidate: candidate, catalog: catalog),
  );
}

class _AcceptRejectedReviewDialog extends StatefulWidget {
  const _AcceptRejectedReviewDialog({
    required this.candidate,
    required this.catalog,
  });

  final ReviewCandidate candidate;
  final List<ExtractionItemKind> catalog;

  @override
  State<_AcceptRejectedReviewDialog> createState() =>
      _AcceptRejectedReviewDialogState();
}

class _AcceptRejectedReviewDialogState
    extends State<_AcceptRejectedReviewDialog> {
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
    _statementController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _statementController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool get _canAccept => _statementController.text.trim().isNotEmpty;

  ExtractionItemKind? get _match => kindBySlug(widget.catalog, _kind);

  ReviewCandidate get _edited {
    final match = _match;
    final allowDue = kindAllowsDueDate(
      match,
      existingDueDate: _dueDate,
      slug: _kind,
    );
    final allowNote = kindAllowsNote(
      match,
      existingNote: _noteController.text,
      slug: _kind,
    );
    return widget.candidate.copyWith(
      kind: _kind,
      statement: _statementController.text,
      dueDate: allowDue ? _dueDate : null,
      note: allowNote
          ? (_noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim())
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final match = _match;
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

    return AlertDialog(
      title: Text(l10n.reviewRejectedAcceptTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: showNote
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _noteController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: l10n.ledgerNoteFieldLabel,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: showDue
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.md),
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
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.reviewRejectedDeleteCancel),
        ),
        FilledButton.icon(
          onPressed: _canAccept
              ? () => Navigator.of(context).pop(_edited)
              : null,
          icon: const Icon(Icons.check, size: 18),
          label: Text(l10n.reviewAcceptButton),
        ),
      ],
    );
  }
}
