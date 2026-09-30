import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirm_unsaved_changes_dialog.dart';
import '../../../../core/widgets/due_date_picker_dialog.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';
import '../../../../core/widgets/sticky_primary_action_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extraction_kinds/data/providers/extraction_item_kind_providers.dart';
import '../../../extraction_kinds/domain/entities/extraction_item_kind.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';
import '../../domain/entities/ledger_item.dart';
import '../controllers/ledger_actions_controller.dart';

class LedgerCreatePage extends ConsumerStatefulWidget {
  const LedgerCreatePage({
    this.initialKind = LedgerItemKind.commitment,
    super.key,
  });

  final String initialKind;

  @override
  ConsumerState<LedgerCreatePage> createState() => _LedgerCreatePageState();
}

class _LedgerCreatePageState extends ConsumerState<LedgerCreatePage> {
  late String _kind = widget.initialKind;
  final _statementController = TextEditingController();
  final _ownerController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _dueDate;
  var _saving = false;
  var _allowPop = false;

  @override
  void initState() {
    super.initState();
    _statementController.addListener(_onFormChanged);
    _ownerController.addListener(_onFormChanged);
    _noteController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _statementController.removeListener(_onFormChanged);
    _ownerController.removeListener(_onFormChanged);
    _noteController.removeListener(_onFormChanged);
    _statementController.dispose();
    _ownerController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool get _canSave => !_saving && _statementController.text.trim().isNotEmpty;

  String _effectiveInitialKind(List<ExtractionItemKind> enabled) {
    if (enabled.any((kind) => kind.slug == widget.initialKind)) {
      return widget.initialKind;
    }
    if (enabled.isNotEmpty) return enabled.first.slug;
    return widget.initialKind;
  }

  bool _hasUnsavedChanges(List<ExtractionItemKind> enabled) {
    if (_allowPop) return false;
    return _statementController.text.trim().isNotEmpty ||
        _ownerController.text.trim().isNotEmpty ||
        _noteController.text.trim().isNotEmpty ||
        _dueDate != null ||
        _kind != _effectiveInitialKind(enabled);
  }

  void _clampKindToEnabled(List<ExtractionItemKind> enabled) {
    if (enabled.isEmpty) return;
    if (enabled.any((kind) => kind.slug == _kind)) return;
    final next = _effectiveInitialKind(enabled);
    if (next == _kind) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (enabled.any((kind) => kind.slug == _kind)) return;
      setState(() => _kind = next);
    });
  }

  Future<void> _onPopRequested(List<ExtractionItemKind> enabled) async {
    if (!_hasUnsavedChanges(enabled)) {
      _allowPop = true;
      if (mounted) context.pop();
      return;
    }
    final action = await confirmUnsavedChanges(context);
    if (!mounted) return;
    switch (action) {
      case UnsavedChangesAction.keepEditing:
        return;
      case UnsavedChangesAction.discard:
        setState(() => _allowPop = true);
        if (mounted) context.pop();
        return;
      case UnsavedChangesAction.save:
        await _save();
    }
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final catalog =
        ref.read(enabledExtractionItemKindsProvider).asData?.value ??
        const <ExtractionItemKind>[];
    final match = kindBySlug(catalog, _kind);
    try {
      await ref
          .read(ledgerActionsControllerProvider.notifier)
          .createManual(
            kind: _kind,
            statement: _statementController.text,
            owner: _ownerController.text,
            dueDate: _dueDate,
            note: _noteController.text,
            kindDisplayNameSnapshot:
                match?.displayName ??
                extractionKindDisplayName(l10n, _kind, catalog: catalog),
            allowsDueDate: kindAllowsDueDate(match),
          );
      if (!mounted) return;
      setState(() => _allowPop = true);
      context.pop();
    } on AppFailure {
      if (!mounted) return;
      showAppSnackBar(context, content: Text(l10n.ledgerCreateFailed));
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final catalog =
        ref.watch(enabledExtractionItemKindsProvider).asData?.value ??
        const <ExtractionItemKind>[];
    _clampKindToEnabled(catalog);
    final match = kindBySlug(catalog, _kind);
    final showDue = kindAllowsDueDate(match, slug: _kind);
    final showNote = kindAllowsNote(match, slug: _kind);
    final showOwner = kindAllowsOwner(match, slug: _kind);

    return PopScope(
      canPop: _allowPop || !_hasUnsavedChanges(catalog),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onPopRequested(catalog);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.ledgerCreateTitle)),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _LedgerKindToggle(
                    value: _kind,
                    catalog: catalog,
                    onChanged: (kind) => setState(() => _kind = kind),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _statementController,
                    enabled: !_saving,
                    maxLines: 4,
                    maxLength: LedgerItemLimits.statementMaxLength,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: l10n.ledgerCreateStatementLabel,
                      helperText: l10n.teachingStatementHelp,
                      helperMaxLines: 3,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (showOwner) ...[
                    AppTextField(
                      controller: _ownerController,
                      enabled: !_saving,
                      maxLength: LedgerItemLimits.ownerMaxLength,
                      decoration: InputDecoration(
                        labelText: l10n.ledgerCreateOwnerLabel,
                        prefixIcon: const Icon(Icons.person_outline),
                        counterText: '',
                      ),
                    ),
                  ],
                  if (showNote) ...[
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _noteController,
                      enabled: !_saving,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: l10n.ledgerNoteFieldLabel,
                      ),
                    ),
                  ],
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: showDue
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: AppSpacing.lg),
                              OutlinedButton.icon(
                                onPressed: _saving
                                    ? null
                                    : () async {
                                        final picked = await showDueDatePicker(
                                          context: context,
                                          initialDate: _dueDate,
                                        );
                                        if (picked != null) {
                                          setState(
                                            () => _dueDate = picked.dueDate,
                                          );
                                        }
                                      },
                                icon: const Icon(Icons.event_outlined),
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
            StickyPrimaryActionBar(
              label: l10n.ledgerCreateSave,
              icon: Icons.add,
              onPressed: _canSave ? _save : null,
              isLoading: _saving,
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerKindToggle extends StatelessWidget {
  const _LedgerKindToggle({
    required this.value,
    required this.catalog,
    required this.onChanged,
  });

  final String value;
  final List<ExtractionItemKind> catalog;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kinds = catalog.isNotEmpty ? catalog : const <ExtractionItemKind>[];
    final slugs = [for (final kind in kinds) kind.slug];
    if (slugs.isEmpty) {
      slugs.addAll([LedgerItemKind.decision, LedgerItemKind.commitment]);
    }
    final selected = slugs.contains(value) ? value : slugs.first;
    return DropdownButtonFormField<String>(
      key: ValueKey(selected),
      initialValue: selected,
      decoration: InputDecoration(labelText: l10n.ledgerCreateKindSemantics),
      items: [
        for (final slug in slugs)
          DropdownMenuItem(
            value: slug,
            child: Text(extractionKindDisplayName(l10n, slug, catalog: kinds)),
          ),
      ],
      onChanged: (slug) {
        if (slug == null) return;
        onChanged(slug);
      },
    );
  }
}
