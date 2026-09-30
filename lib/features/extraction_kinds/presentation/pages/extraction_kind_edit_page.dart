import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ai/extraction_kind_slugs.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirm_unsaved_changes_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';
import '../../../../core/widgets/sticky_primary_action_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/providers/extraction_item_kind_providers.dart';
import '../../domain/entities/extraction_item_kind.dart';
import '../../domain/extraction_kind_templates.dart';
import '../controllers/extraction_kinds_controller.dart';
import '../widgets/confirm_delete_extraction_kind_dialog.dart';

class ExtractionKindEditPage extends ConsumerStatefulWidget {
  const ExtractionKindEditPage({this.kindId, super.key});

  final String? kindId;

  @override
  ConsumerState<ExtractionKindEditPage> createState() =>
      _ExtractionKindEditPageState();
}

class _ExtractionKindEditPageState
    extends ConsumerState<ExtractionKindEditPage> {
  final _nameController = TextEditingController();
  final _hintController = TextEditingController();
  var _behavior = ExtractionKindBehavior.completable;
  var _datePolicy = ExtractionKindFieldPolicy.optional;
  var _notePolicy = ExtractionKindFieldPolicy.optional;
  var _ownerPolicy = ExtractionKindFieldPolicy.none;
  var _enabled = true;
  var _saving = false;
  var _hydrated = false;
  var _allowPop = false;
  ExtractionItemKind? _existing;

  /// Stable catalog slug from a starter template (e.g. groceries), independent
  /// of the localized display name.
  String? _pendingSlug;
  final _examples = <_ExampleDraft>[];

  bool get _isNew => widget.kindId == null;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _hintController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  void _attachExampleListeners(_ExampleDraft draft) {
    draft.quote.addListener(_onFormChanged);
    draft.statement.addListener(_onFormChanged);
  }

  void _detachExampleListeners(_ExampleDraft draft) {
    draft.quote.removeListener(_onFormChanged);
    draft.statement.removeListener(_onFormChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _hintController.removeListener(_onFormChanged);
    _nameController.dispose();
    _hintController.dispose();
    for (final example in _examples) {
      _detachExampleListeners(example);
      example.dispose();
    }
    super.dispose();
  }

  bool get _hasUnsavedChanges {
    if (_allowPop) return false;
    final existing = _existing;
    if (existing == null) {
      return _nameController.text.trim().isNotEmpty ||
          _hintController.text.trim().isNotEmpty ||
          _pendingSlug != null ||
          _examples.isNotEmpty ||
          _behavior != ExtractionKindBehavior.completable ||
          _datePolicy != ExtractionKindFieldPolicy.optional ||
          _notePolicy != ExtractionKindFieldPolicy.optional ||
          _ownerPolicy != ExtractionKindFieldPolicy.none ||
          !_enabled;
    }
    final hint = _hintController.text.trim();
    final storedHint = existing.extractionHint?.trim() ?? '';
    if (_nameController.text.trim() != existing.displayName.trim()) {
      return true;
    }
    if (hint != storedHint) return true;
    if (_behavior != existing.behavior) return true;
    if (_datePolicy != existing.datePolicy) return true;
    if (_notePolicy != existing.notePolicy) return true;
    if (_ownerPolicy != existing.ownerPolicy) return true;
    if (_enabled != existing.enabledForExtraction) return true;
    if (_examples.length != existing.teachingExamples.length) return true;
    for (var i = 0; i < _examples.length; i++) {
      final draft = _examples[i];
      final stored = existing.teachingExamples[i];
      if (draft.quote.text.trim() != stored.quoteSnippet.trim()) return true;
      if (draft.statement.text.trim() != stored.statement.trim()) return true;
    }
    return false;
  }

  Future<void> _onPopRequested() async {
    if (!_hasUnsavedChanges) {
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

  void _hydrate(ExtractionItemKind kind) {
    if (_hydrated) return;
    _hydrated = true;
    _existing = kind;
    _nameController.text = kind.displayName;
    _hintController.text = kind.extractionHint ?? '';
    _behavior = kind.behavior;
    _datePolicy = kind.datePolicy;
    _notePolicy = kind.notePolicy;
    _ownerPolicy = kind.ownerPolicy;
    _enabled = kind.enabledForExtraction;
    for (final example in kind.teachingExamples) {
      final draft = _ExampleDraft.from(example);
      _attachExampleListeners(draft);
      _examples.add(draft);
    }
  }

  void _applyTemplate(ExtractionKindTemplate template, AppLocalizations l10n) {
    setState(() {
      _pendingSlug = template.slug;
      _nameController.text = switch (template.id) {
        'groceries' => l10n.extractionKindTemplateGroceries,
        'follow_up' => l10n.extractionKindTemplateFollowUp,
        _ => template.slug,
      };
      _hintController.text = switch (template.id) {
        'groceries' => l10n.extractionKindTemplateGroceriesHint,
        'follow_up' => l10n.extractionKindTemplateFollowUpHint,
        _ => '',
      };
      _behavior = template.behavior;
      _datePolicy = template.datePolicy;
      _notePolicy = template.notePolicy;
      _ownerPolicy = template.ownerPolicy;
      _enabled = true;
      if (template.id == 'groceries' && _examples.isEmpty) {
        final drafts = _groceriesSampleDrafts(l10n);
        for (final draft in drafts) {
          _attachExampleListeners(draft);
        }
        _examples.addAll(drafts);
      }
    });
  }

  void _insertSampleExample(AppLocalizations l10n) {
    if (_examples.length >= ExtractionKindSlugs.maxTeachingExamples) return;
    final samples = <(String, String)>[
      (
        l10n.extractionKindSampleQuoteMilk,
        l10n.extractionKindSampleStatementMilk,
      ),
      (
        l10n.extractionKindSampleQuoteEggs,
        l10n.extractionKindSampleStatementEggs,
      ),
      (
        l10n.extractionKindSampleQuoteBread,
        l10n.extractionKindSampleStatementBread,
      ),
    ];
    final index = _examples.length.clamp(0, samples.length - 1);
    final sample = samples[index];
    setState(() {
      final draft = _ExampleDraft.filled(
        quote: sample.$1,
        statement: sample.$2,
      );
      _attachExampleListeners(draft);
      _examples.add(draft);
    });
  }

  List<_ExampleDraft> _groceriesSampleDrafts(AppLocalizations l10n) {
    return [
      _ExampleDraft.filled(
        quote: l10n.extractionKindSampleQuoteMilk,
        statement: l10n.extractionKindSampleStatementMilk,
      ),
      _ExampleDraft.filled(
        quote: l10n.extractionKindSampleQuoteEggs,
        statement: l10n.extractionKindSampleStatementEggs,
      ),
      _ExampleDraft.filled(
        quote: l10n.extractionKindSampleQuoteBread,
        statement: l10n.extractionKindSampleStatementBread,
      ),
    ];
  }

  Future<void> _save() async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final incompleteExample = _examples.any(
      (draft) => draft.isPartial && !draft.isComplete,
    );
    if (incompleteExample) {
      showAppSnackBar(
        context,
        content: Text(l10n.extractionKindExamplesIncomplete),
      );
      return;
    }

    setState(() => _saving = true);
    final examples = [
      for (final draft in _examples)
        if (draft.isComplete)
          ExtractionTeachingExample(
            // Kept for stored schema compat; UI teaches quote + statement only.
            sourceExcerpt: draft.quote.text.trim(),
            quoteSnippet: draft.quote.text.trim(),
            statement: draft.statement.text.trim(),
          ),
    ];
    try {
      final existing = _existing;
      if (existing == null) {
        await ref
            .read(extractionKindsControllerProvider.notifier)
            .create(
              displayName: name,
              extractionHint: _hintController.text,
              behavior: _behavior,
              datePolicy: _datePolicy,
              notePolicy: _notePolicy,
              ownerPolicy: _ownerPolicy,
              enabledForExtraction: _enabled,
              teachingExamples: examples,
              slug: _pendingSlug,
            );
      } else {
        await ref
            .read(extractionKindsControllerProvider.notifier)
            .update(
              existing.copyWith(
                displayName: name,
                extractionHint: _hintController.text.trim().isEmpty
                    ? null
                    : _hintController.text,
                behavior: _behavior,
                datePolicy: _datePolicy,
                notePolicy: _notePolicy,
                ownerPolicy: _ownerPolicy,
                enabledForExtraction: _enabled,
                teachingExamples: examples,
              ),
            );
      }
      if (!mounted) return;
      showAppSnackBar(context, content: Text(l10n.extractionKindsSaved));
      setState(() => _allowPop = true);
      context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnackBar(context, content: Text(failureMessage(l10n, error)));
    }
  }

  Future<void> _archive() async {
    final existing = _existing;
    if (existing == null || existing.isBuiltIn) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmDeleteExtractionKind(context);
    if (!confirmed || !mounted) return;
    try {
      await ref
          .read(extractionKindsControllerProvider.notifier)
          .archive(existing.id);
      if (!mounted) return;
      setState(() => _allowPop = true);
      context.pop();
    } catch (error) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        content: Text(l10n.extractionKindsCannotArchiveInUse),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_isNew) {
      final catalog = ref.watch(extractionItemKindsProvider);
      return catalog.when(
        loading: () => Scaffold(
          appBar: AppBar(title: Text(l10n.extractionKindsEditTitle)),
          body: const LoadingState(),
        ),
        error: (_, _) => Scaffold(
          appBar: AppBar(title: Text(l10n.extractionKindsEditTitle)),
          body: EmptyState(
            icon: Icons.error_outline,
            title: l10n.extractionKindsEmptyTitle,
          ),
        ),
        data: (items) {
          ExtractionItemKind? match;
          for (final kind in items) {
            if (kind.id == widget.kindId) {
              match = kind;
              break;
            }
          }
          if (match == null) {
            return Scaffold(
              appBar: AppBar(title: Text(l10n.extractionKindsEditTitle)),
              body: EmptyState(
                icon: Icons.search_off,
                title: l10n.extractionKindsEmptyTitle,
              ),
            );
          }
          _hydrate(match);
          return _form(l10n);
        },
      );
    }
    return _form(l10n);
  }

  Widget _form(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: _allowPop || !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onPopRequested();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isNew
                ? l10n.extractionKindsNewTitle
                : l10n.extractionKindsEditTitle,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  if (_isNew) ...[
                    Text(
                      l10n.extractionKindTemplateSection,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        ActionChip(
                          label: Text(l10n.extractionKindTemplateGroceries),
                          onPressed: () => _applyTemplate(
                            ExtractionKindTemplate.groceries,
                            l10n,
                          ),
                        ),
                        ActionChip(
                          label: Text(l10n.extractionKindTemplateFollowUp),
                          onPressed: () => _applyTemplate(
                            ExtractionKindTemplate.followUp,
                            l10n,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  AppTextField(
                    controller: _nameController,
                    enabled: !_saving,
                    decoration: InputDecoration(
                      labelText: l10n.extractionKindsNameLabel,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _hintController,
                    enabled: !_saving,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.extractionKindsHintLabel,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _enabled,
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _enabled = value),
                    title: Text(l10n.extractionKindsEnabledLabel),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _PolicyDropdown<ExtractionKindBehavior>(
                    label: l10n.extractionKindsBehaviorLabel,
                    value: _behavior,
                    enabled: !_saving && !(_existing?.isBuiltIn ?? false),
                    items: [
                      DropdownMenuItem(
                        value: ExtractionKindBehavior.record,
                        child: Text(l10n.extractionKindsBehaviorRecord),
                      ),
                      DropdownMenuItem(
                        value: ExtractionKindBehavior.completable,
                        child: Text(l10n.extractionKindsBehaviorCompletable),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _behavior = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _PolicyDropdown<ExtractionKindFieldPolicy>(
                    label: l10n.extractionKindsDatePolicyLabel,
                    value: _datePolicy,
                    enabled: !_saving,
                    items: _policyItems(l10n),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _datePolicy = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _PolicyDropdown<ExtractionKindFieldPolicy>(
                    label: l10n.extractionKindsNotePolicyLabel,
                    value: _notePolicy,
                    enabled: !_saving,
                    items: _policyItems(l10n),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _notePolicy = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _PolicyDropdown<ExtractionKindFieldPolicy>(
                    label: l10n.extractionKindsOwnerPolicyLabel,
                    value: _ownerPolicy,
                    enabled: !_saving,
                    items: _policyItems(l10n),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _ownerPolicy = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHeader(
                    title: l10n.extractionKindExamplesTitle,
                    subtitle: l10n.extractionKindExamplesHelp,
                  ),
                  InfoCard(
                    icon: Icons.school_outlined,
                    title: l10n.extractionKindTeachingWalkthroughTitle,
                    subtitle: l10n.extractionKindTeachingWalkthroughBody,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_examples.length >=
                      ExtractionKindSlugs.maxTeachingExamples)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                        l10n.extractionKindExamplesFull,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  for (var i = 0; i < _examples.length; i++) ...[
                    _ExampleFields(draft: _examples[i], enabled: !_saving),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: _saving
                            ? null
                            : () {
                                setState(() {
                                  final removed = _examples.removeAt(i);
                                  _detachExampleListeners(removed);
                                  removed.dispose();
                                });
                              },
                        child: Text(l10n.extractionKindExampleRemove),
                      ),
                    ),
                  ],
                  if (_examples.length <
                      ExtractionKindSlugs.maxTeachingExamples) ...[
                    OutlinedButton.icon(
                      onPressed: _saving
                          ? null
                          : () {
                              setState(() {
                                final draft = _ExampleDraft();
                                _attachExampleListeners(draft);
                                _examples.add(draft);
                              });
                            },
                      icon: const Icon(Icons.add),
                      label: Text(l10n.extractionKindAddExample),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton.icon(
                      onPressed: _saving
                          ? null
                          : () => _insertSampleExample(l10n),
                      icon: const Icon(Icons.lightbulb_outline),
                      label: Text(l10n.extractionKindInsertSampleExample),
                    ),
                  ],
                  if (_existing != null && !_existing!.isBuiltIn) ...[
                    const SizedBox(height: AppSpacing.xl),
                    TextButton(
                      onPressed: _saving ? null : _archive,
                      child: Text(l10n.extractionKindsDelete),
                    ),
                  ],
                  if (_existing?.isBuiltIn ?? false) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l10n.extractionKindsCannotDeleteBuiltIn,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            StickyPrimaryActionBar(
              label: l10n.extractionKindsSave,
              onPressed: _saving ? null : _save,
              isLoading: _saving,
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<ExtractionKindFieldPolicy>> _policyItems(
    AppLocalizations l10n,
  ) {
    return [
      DropdownMenuItem(
        value: ExtractionKindFieldPolicy.none,
        child: Text(l10n.extractionKindsPolicyNone),
      ),
      DropdownMenuItem(
        value: ExtractionKindFieldPolicy.optional,
        child: Text(l10n.extractionKindsPolicyOptional),
      ),
    ];
  }
}

class _PolicyDropdown<T> extends StatelessWidget {
  const _PolicyDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.enabled,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}

class _ExampleDraft {
  _ExampleDraft()
    : quote = TextEditingController(),
      statement = TextEditingController();

  _ExampleDraft.filled({required String quote, required String statement})
    : quote = TextEditingController(text: quote),
      statement = TextEditingController(text: statement);

  _ExampleDraft.from(ExtractionTeachingExample example)
    : quote = TextEditingController(text: example.quoteSnippet),
      statement = TextEditingController(text: example.statement);

  final TextEditingController quote;
  final TextEditingController statement;

  bool get isComplete =>
      quote.text.trim().isNotEmpty && statement.text.trim().isNotEmpty;

  /// Any field filled without both complete — would otherwise be dropped.
  bool get isPartial {
    final filled = [
      quote.text.trim().isNotEmpty,
      statement.text.trim().isNotEmpty,
    ].where((value) => value).length;
    return filled == 1;
  }

  void dispose() {
    quote.dispose();
    statement.dispose();
  }
}

class _ExampleFields extends StatelessWidget {
  const _ExampleFields({required this.draft, required this.enabled});

  final _ExampleDraft draft;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppTextField(
              controller: draft.statement,
              enabled: enabled,
              decoration: InputDecoration(
                labelText: l10n.extractionKindExampleStatement,
                helperText: l10n.teachingStatementHelp,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: draft.quote,
              enabled: enabled,
              decoration: InputDecoration(
                labelText: l10n.extractionKindExampleQuote,
                helperText: l10n.teachingQuoteHelp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
