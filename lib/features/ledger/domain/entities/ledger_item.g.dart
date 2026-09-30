// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LedgerItem _$LedgerItemFromJson(Map<String, dynamic> json) => _LedgerItem(
  id: json['id'] as String,
  userId: json['userId'] as String,
  kind: json['kind'] as String,
  statement: json['statement'] as String,
  status: $enumDecode(_$LedgerItemStatusEnumMap, json['status']),
  owner: json['owner'] as String?,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  note: json['note'] as String?,
  kindDisplayNameSnapshot: json['kindDisplayNameSnapshot'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$LedgerItemToJson(_LedgerItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'kind': instance.kind,
      'statement': instance.statement,
      'status': _$LedgerItemStatusEnumMap[instance.status]!,
      'owner': instance.owner,
      'dueDate': instance.dueDate?.toIso8601String(),
      'note': instance.note,
      'kindDisplayNameSnapshot': instance.kindDisplayNameSnapshot,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$LedgerItemStatusEnumMap = {
  LedgerItemStatus.open: 'open',
  LedgerItemStatus.completed: 'completed',
  LedgerItemStatus.cancelled: 'cancelled',
};

_EvidenceReference _$EvidenceReferenceFromJson(Map<String, dynamic> json) =>
    _EvidenceReference(
      id: json['id'] as String,
      ledgerItemId: json['ledgerItemId'] as String,
      sourceConversationId: json['sourceConversationId'] as String,
      sourceRevision: (json['sourceRevision'] as num).toInt(),
      quoteStart: (json['quoteStart'] as num).toInt(),
      quoteEnd: (json['quoteEnd'] as num).toInt(),
      quoteSnippet: json['quoteSnippet'] as String,
    );

Map<String, dynamic> _$EvidenceReferenceToJson(_EvidenceReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ledgerItemId': instance.ledgerItemId,
      'sourceConversationId': instance.sourceConversationId,
      'sourceRevision': instance.sourceRevision,
      'quoteStart': instance.quoteStart,
      'quoteEnd': instance.quoteEnd,
      'quoteSnippet': instance.quoteSnippet,
    };
