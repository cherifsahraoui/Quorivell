import '../../../l10n/app_localizations.dart';
import '../../ledger/domain/entities/ledger_item.dart';
import '../domain/entities/extraction_item_kind.dart';

const _builtInSeedNames = {
  LedgerItemKind.decision: 'Decision',
  LedgerItemKind.commitment: 'Commitment',
};

String extractionKindDisplayName(
  AppLocalizations l10n,
  String slug, {
  String? snapshot,
  List<ExtractionItemKind>? catalog,
}) {
  String? fromCatalog;
  if (catalog != null) {
    for (final kind in catalog) {
      if (kind.slug == slug && kind.displayName.trim().isNotEmpty) {
        fromCatalog = kind.displayName;
        break;
      }
    }
  }
  final renamed = fromCatalog ?? snapshot?.trim();
  if (slug == LedgerItemKind.decision || slug == LedgerItemKind.commitment) {
    if (renamed != null &&
        renamed.isNotEmpty &&
        renamed != _builtInSeedNames[slug]) {
      return renamed;
    }
    return slug == LedgerItemKind.decision
        ? l10n.reviewKindDecision
        : l10n.reviewKindCommitment;
  }
  if (fromCatalog != null) {
    return fromCatalog;
  }
  final trimmed = snapshot?.trim();
  if (trimmed != null && trimmed.isNotEmpty) {
    return trimmed;
  }
  return l10n.reviewKindGeneric(slug);
}

ExtractionItemKind? kindBySlug(List<ExtractionItemKind> catalog, String slug) {
  for (final kind in catalog) {
    if (kind.slug == slug) return kind;
  }
  return null;
}

bool kindAllowsDueDate(
  ExtractionItemKind? kind, {
  DateTime? existingDueDate,
  String? slug,
}) {
  if (kind != null) {
    return kind.datePolicy == ExtractionKindFieldPolicy.optional;
  }
  if (slug == LedgerItemKind.commitment) return true;
  if (slug == LedgerItemKind.decision) return false;
  return existingDueDate != null;
}

bool kindAllowsNote(
  ExtractionItemKind? kind, {
  String? existingNote,
  String? slug,
}) {
  if (kind != null) {
    return kind.notePolicy == ExtractionKindFieldPolicy.optional;
  }
  if (slug == LedgerItemKind.decision || slug == LedgerItemKind.commitment) {
    return true;
  }
  return existingNote != null && existingNote.trim().isNotEmpty;
}

bool kindAllowsOwner(
  ExtractionItemKind? kind, {
  String? existingOwner,
  String? slug,
}) {
  if (kind != null) {
    return kind.ownerPolicy == ExtractionKindFieldPolicy.optional;
  }
  if (slug == LedgerItemKind.decision || slug == LedgerItemKind.commitment) {
    return true;
  }
  return existingOwner != null && existingOwner.trim().isNotEmpty;
}

bool kindIsCompletable(ExtractionItemKind? kind, String slug) {
  if (kind != null) {
    return kind.behavior == ExtractionKindBehavior.completable;
  }
  return slug == LedgerItemKind.commitment;
}
