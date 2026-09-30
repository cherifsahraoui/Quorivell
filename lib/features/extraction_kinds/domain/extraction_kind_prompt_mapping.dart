import '../../../../core/ai/extraction_kind_prompt_spec.dart';
import 'entities/extraction_item_kind.dart';

ExtractionKindPromptSpec promptSpecFromKind(ExtractionItemKind kind) {
  return ExtractionKindPromptSpec(
    slug: kind.slug,
    displayName: kind.displayName,
    hint: kind.extractionHint,
    behavior: kind.behavior.name,
    datePolicy: kind.datePolicy.name,
    notePolicy: kind.notePolicy.name,
    ownerPolicy: kind.ownerPolicy.name,
    isBuiltIn: kind.isBuiltIn,
    teachingExamples: [
      for (final example in kind.teachingExamples)
        ExtractionTeachingExampleSpec(
          sourceExcerpt: example.sourceExcerpt,
          quoteSnippet: example.quoteSnippet,
          statement: example.statement,
        ),
    ],
  );
}
