import '../../l10n/app_localizations.dart';
import 'extraction_kind_prompt_spec.dart';
import 'extraction_kind_slugs.dart';
import 'extraction_prompt_sanitizer.dart';

/// Composes extraction system + user prompts from ARB skeletons and the
/// enabled kind catalog.
///
/// Built-in Decision/Commitment rules and few-shots are included **only** when
/// those kinds are enabled. Custom kinds get list-splitting guidance instead of
/// inheriting decision/commitment examples.
abstract final class ExtractionPromptBuilder {
  static String legalKindsList(List<ExtractionKindPromptSpec> kinds) {
    if (kinds.isEmpty) {
      return '${ExtractionKindSlugs.decision}, ${ExtractionKindSlugs.commitment}';
    }
    return kinds.map((kind) => kind.slug).join(', ');
  }

  static String systemInstruction(
    AppLocalizations l10n,
    List<ExtractionKindPromptSpec> kinds,
  ) {
    final enabled = kinds.isEmpty ? defaultBuiltInKindSpecs() : kinds;
    final legal = legalKindsList(enabled);
    final catalog = _catalogBlock(l10n, enabled);
    final hasDecision = enabled.any(
      (kind) => kind.slug == ExtractionKindSlugs.decision,
    );
    final hasCommitment = enabled.any(
      (kind) => kind.slug == ExtractionKindSlugs.commitment,
    );
    final hasCustom = _hasCustomKinds(enabled);

    final buffer = StringBuffer()
      ..writeln(
        l10n.assistantRemoteSystemInstruction('{', '}', legal, catalog),
      );

    if (hasCommitment) {
      buffer
        ..writeln()
        ..writeln(l10n.extractionSystemCommitmentRules);
    }
    if (hasDecision) {
      buffer
        ..writeln()
        ..writeln(l10n.extractionSystemDecisionRules);
    }

    if (hasDecision && hasCommitment) {
      buffer
        ..writeln()
        ..writeln(l10n.extractionSystemBuiltInExamplesBoth('{', '}'));
    } else if (hasDecision) {
      buffer
        ..writeln()
        ..writeln(l10n.extractionSystemBuiltInExamplesDecision('{', '}'));
    } else if (hasCommitment) {
      buffer
        ..writeln()
        ..writeln(l10n.extractionSystemBuiltInExamplesCommitment('{', '}'));
    }

    if (hasCustom) {
      buffer
        ..writeln()
        ..writeln(l10n.extractionCustomKindsGuidance)
        ..writeln()
        ..writeln(l10n.extractionCustomKindsOnePerItemGuidance);
    }

    return buffer.toString().trim();
  }

  static String userPrompt(
    AppLocalizations l10n,
    List<ExtractionKindPromptSpec> kinds,
    String conversation,
  ) {
    final enabled = kinds.isEmpty ? defaultBuiltInKindSpecs() : kinds;
    final legal = legalKindsList(enabled);
    final allowsDates = enabled.any((kind) => kind.allowsDueDate);
    final dueClause = allowsDates ? l10n.extractionPromptDueDateClause : '';
    return l10n.extractionPrompt(legal, dueClause, conversation);
  }

  static bool _hasCustomKinds(List<ExtractionKindPromptSpec> kinds) {
    return kinds.any(
      (kind) => !ExtractionKindSlugs.reserved.contains(kind.slug),
    );
  }

  static String _catalogBlock(
    AppLocalizations l10n,
    List<ExtractionKindPromptSpec> kinds,
  ) {
    final buffer = StringBuffer();
    for (final kind in kinds) {
      final name = ExtractionPromptSanitizer.sanitize(
        kind.displayName,
        maxLength: ExtractionKindSlugs.maxDisplayNameLength,
      );
      final hint = ExtractionPromptSanitizer.sanitize(
        kind.hint ?? '',
        maxLength: ExtractionKindSlugs.maxHintLength,
      );
      buffer.writeln(
        l10n.extractionKindRule(
          kind.slug,
          name,
          hint,
          kind.behavior,
          kind.datePolicy,
          kind.notePolicy,
          kind.ownerPolicy,
        ),
      );
    }
    final examples = _teachingExamples(kinds);
    if (examples.isNotEmpty) {
      buffer.writeln(l10n.extractionTeachingExamplesHeader);
      buffer.write(examples);
    }
    return buffer.toString().trim();
  }

  static String _teachingExamples(List<ExtractionKindPromptSpec> kinds) {
    final buffer = StringBuffer();
    for (final kind in kinds) {
      for (final example in kind.teachingExamples.take(
        ExtractionKindSlugs.maxTeachingExamples,
      )) {
        final quote = ExtractionPromptSanitizer.sanitize(
          example.quoteSnippet,
          maxLength: ExtractionKindSlugs.maxExampleFieldLength,
        );
        final statement = ExtractionPromptSanitizer.sanitize(
          example.statement,
          maxLength: ExtractionKindSlugs.maxExampleFieldLength,
        );
        if (quote.isEmpty || statement.isEmpty) {
          continue;
        }
        buffer
          ..writeln('<<<KIND_EXAMPLE')
          ..writeln('kind=${kind.slug}')
          ..writeln('quote=$quote')
          ..writeln('statement=$statement')
          ..writeln('>>>');
      }
    }
    return buffer.toString();
  }
}
