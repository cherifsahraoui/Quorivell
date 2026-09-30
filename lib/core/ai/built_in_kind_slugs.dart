import '../ai/extraction_kind_slugs.dart';

/// Built-in ledger kind slugs. [LedgerItem.kind] is a catalog slug string.
abstract final class LedgerItemKind {
  static const decision = ExtractionKindSlugs.decision;
  static const commitment = ExtractionKindSlugs.commitment;
}

/// Built-in review candidate slugs. [ReviewCandidate.kind] is a catalog slug.
abstract final class ReviewCandidateKind {
  static const decision = ExtractionKindSlugs.decision;
  static const commitment = ExtractionKindSlugs.commitment;
}
