import 'extraction_kind_slugs.dart';

/// Prompt-time view of a catalog kind. Lives in `core/ai` so the codec and
/// prompt builder do not import the extraction_kinds feature.
class ExtractionKindPromptSpec {
  const ExtractionKindPromptSpec({
    required this.slug,
    required this.displayName,
    this.hint,
    required this.behavior,
    required this.datePolicy,
    required this.notePolicy,
    required this.ownerPolicy,
    this.isBuiltIn = false,
    this.teachingExamples = const [],
  });

  final String slug;
  final String displayName;
  final String? hint;

  /// `record` or `completable`.
  final String behavior;

  /// `none` or `optional`.
  final String datePolicy;

  /// `none` or `optional`.
  final String notePolicy;

  /// `none` or `optional`.
  final String ownerPolicy;
  final bool isBuiltIn;
  final List<ExtractionTeachingExampleSpec> teachingExamples;

  bool get allowsDueDate => datePolicy == 'optional';

  bool get isCompletable => behavior == 'completable';
}

class ExtractionTeachingExampleSpec {
  const ExtractionTeachingExampleSpec({
    required this.sourceExcerpt,
    required this.quoteSnippet,
    required this.statement,
  });

  final String sourceExcerpt;
  final String quoteSnippet;
  final String statement;
}

/// Built-in Decision / Commitment specs used when no catalog is wired.
List<ExtractionKindPromptSpec> defaultBuiltInKindSpecs() => const [
  ExtractionKindPromptSpec(
    slug: ExtractionKindSlugs.decision,
    displayName: 'Decision',
    hint:
        'Group or product direction is locked. Cues: officially decided, '
        'decision made, moving forward with. Prefer the FINAL locked choice.',
    behavior: 'record',
    datePolicy: 'none',
    notePolicy: 'optional',
    ownerPolicy: 'optional',
    isBuiltIn: true,
  ),
  ExtractionKindPromptSpec(
    slug: ExtractionKindSlugs.commitment,
    displayName: 'Commitment',
    hint:
        'Named person accepts work. Cues: explicitly committed, will deliver, '
        "I'll have, I will.",
    behavior: 'completable',
    datePolicy: 'optional',
    notePolicy: 'optional',
    ownerPolicy: 'optional',
    isBuiltIn: true,
  ),
];
