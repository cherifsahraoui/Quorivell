import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extraction_kinds/domain/entities/extraction_item_kind.dart';
import '../../../ledger/domain/entities/ledger_item.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';

/// Teaching dialog shown when extract finds no explicit candidates.
Future<void> showEmptyExtractExampleDialog(
  BuildContext context, {
  List<ExtractionItemKind> enabledKinds = const [],
  bool systemPromptModified = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return _EmptyExtractExampleDialog(
        enabledKinds: enabledKinds,
        systemPromptModified: systemPromptModified,
      );
    },
  );
}

enum _ExampleKind { match, skipped }

class _EmptyExtractExampleDialog extends StatelessWidget {
  const _EmptyExtractExampleDialog({
    required this.enabledKinds,
    required this.systemPromptModified,
  });

  final List<ExtractionItemKind> enabledKinds;
  final bool systemPromptModified;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(l10n.reviewEmptyExtractExampleTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.reviewEmptyExtractExampleBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (systemPromptModified) ...[
              const SizedBox(height: AppSpacing.md),
              InfoCard(
                icon: Icons.warning_amber_outlined,
                title: l10n.extractionSettingsSystemPromptModifiedTitle,
                subtitle: l10n.extractionSettingsSystemPromptModifiedWarning,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            _ExampleTranscript(sentences: _sentencesForEnabledKinds(l10n)),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.capturePrivacyDialogDismiss),
        ),
      ],
    );
  }

  List<_ExampleSentence> _sentencesForEnabledKinds(AppLocalizations l10n) {
    final enabled = [
      for (final kind in enabledKinds)
        if (kind.enabledForExtraction) kind,
    ];
    final useBuiltInExamples = enabled.isEmpty;
    final sentences = <_ExampleSentence>[];

    void add({
      required String fullText,
      required String highlight,
      required String label,
      required _ExampleKind kind,
    }) {
      sentences.add(
        _ExampleSentence(
          fullText: fullText,
          highlight: highlight,
          kind: kind,
          label: label,
        ),
      );
    }

    if (useBuiltInExamples ||
        enabled.any((kind) => kind.slug == LedgerItemKind.commitment)) {
      add(
        fullText: l10n.reviewEmptyExtractExampleCommitmentSentence,
        highlight: l10n.reviewEmptyExtractExampleCommitmentSpan,
        label: l10n.reviewKindCommitment,
        kind: _ExampleKind.match,
      );
    }
    if (useBuiltInExamples ||
        enabled.any((kind) => kind.slug == LedgerItemKind.decision)) {
      add(
        fullText: l10n.reviewEmptyExtractExampleDecisionSentence,
        highlight: l10n.reviewEmptyExtractExampleDecisionSpan,
        label: l10n.reviewKindDecision,
        kind: _ExampleKind.match,
      );
    }
    for (final kind in enabled) {
      if (kind.slug == LedgerItemKind.decision ||
          kind.slug == LedgerItemKind.commitment) {
        continue;
      }
      final name = extractionKindDisplayName(
        l10n,
        kind.slug,
        snapshot: kind.displayName,
        catalog: enabled,
      );
      add(
        fullText: l10n.reviewEmptyExtractExampleCustomSentence(name),
        highlight: l10n.reviewEmptyExtractExampleCustomSpan,
        label: name,
        kind: _ExampleKind.match,
      );
    }
    add(
      fullText: l10n.reviewEmptyExtractExampleSkippedSentence,
      highlight: l10n.reviewEmptyExtractExampleSkippedSpan,
      label: l10n.reviewEmptyExtractExampleSkippedLabel,
      kind: _ExampleKind.skipped,
    );
    return sentences;
  }
}

class _ExampleSentence {
  const _ExampleSentence({
    required this.fullText,
    required this.highlight,
    required this.kind,
    required this.label,
  });

  final String fullText;
  final String highlight;
  final _ExampleKind kind;
  final String label;
}

class _ExampleTranscript extends StatelessWidget {
  const _ExampleTranscript({required this.sentences});

  final List<_ExampleSentence> sentences;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context).reviewEmptyExtractExampleCaption,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < sentences.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              _AnnotatedExampleSentence(sentence: sentences[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnnotatedExampleSentence extends StatelessWidget {
  const _AnnotatedExampleSentence({required this.sentence});

  final _ExampleSentence sentence;

  _ExamplePalette _palette(ColorScheme scheme) {
    return switch (sentence.kind) {
      _ExampleKind.match => _ExamplePalette(
        fill: scheme.primaryContainer,
        onFill: scheme.onPrimaryContainer,
        accent: scheme.primary,
        icon: Icons.check_circle_outline,
      ),
      _ExampleKind.skipped => _ExamplePalette(
        fill: scheme.surfaceContainerHigh,
        onFill: scheme.onSurfaceVariant,
        accent: scheme.outline,
        icon: Icons.not_interested,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = _palette(colorScheme);
    final isSkipped = sentence.kind == _ExampleKind.skipped;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          _buildAnnotatedText(
            fullText: sentence.fullText,
            highlight: sentence.highlight,
            baseStyle: theme.textTheme.bodyMedium?.copyWith(
              height: 1.35,
              color: colorScheme.onSurface,
            ),
            highlightStyle: theme.textTheme.labelLarge?.copyWith(
              height: 1.35,
              color: colors.onFill,
              decoration: isSkipped ? TextDecoration.lineThrough : null,
              decorationColor: colorScheme.outline,
            ),
            highlightBackground: colors.fill,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Material(
          color: colors.fill,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(colors.icon, size: 12, color: colors.accent),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  sentence.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onFill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextSpan _buildAnnotatedText({
    required String fullText,
    required String highlight,
    required TextStyle? baseStyle,
    required TextStyle? highlightStyle,
    required Color highlightBackground,
  }) {
    final index = fullText.indexOf(highlight);
    if (index < 0 || highlight.isEmpty) {
      return TextSpan(text: fullText, style: baseStyle);
    }

    final before = fullText.substring(0, index);
    final after = fullText.substring(index + highlight.length);

    return TextSpan(
      style: baseStyle,
      children: [
        if (before.isNotEmpty) TextSpan(text: before),
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              color: highlightBackground,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(highlight, style: highlightStyle),
          ),
        ),
        if (after.isNotEmpty) TextSpan(text: after),
      ],
    );
  }
}

class _ExamplePalette {
  const _ExamplePalette({
    required this.fill,
    required this.onFill,
    required this.accent,
    required this.icon,
  });

  final Color fill;
  final Color onFill;
  final Color accent;
  final IconData icon;
}
