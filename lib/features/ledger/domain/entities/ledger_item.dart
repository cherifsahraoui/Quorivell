import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/ai/extraction_kind_slugs.dart';

export '../../../../core/ai/built_in_kind_slugs.dart' show LedgerItemKind;

part 'ledger_item.freezed.dart';
part 'ledger_item.g.dart';

enum LedgerItemStatus { open, completed, cancelled }

/// Bounds aligned with `firestore.rules` `isValidLedgerItem`.
abstract final class LedgerItemLimits {
  static const int statementMaxLength = 2000;
  static const int ownerMaxLength = 200;
  static const int noteMaxLength = ExtractionKindSlugs.maxNoteLength;
  static const int displayNameSnapshotMaxLength =
      ExtractionKindSlugs.maxDisplayNameLength;
}

@freezed
abstract class LedgerItem with _$LedgerItem {
  const factory LedgerItem({
    required String id,
    required String userId,
    required String kind,
    required String statement,
    required LedgerItemStatus status,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    @Default('') String kindDisplayNameSnapshot,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LedgerItem;

  factory LedgerItem.fromJson(Map<String, dynamic> json) =>
      _$LedgerItemFromJson(json);
}

@freezed
abstract class EvidenceReference with _$EvidenceReference {
  const factory EvidenceReference({
    required String id,
    required String ledgerItemId,
    required String sourceConversationId,
    required int sourceRevision,
    required int quoteStart,
    required int quoteEnd,
    required String quoteSnippet,
  }) = _EvidenceReference;

  factory EvidenceReference.fromJson(Map<String, dynamic> json) =>
      _$EvidenceReferenceFromJson(json);
}
