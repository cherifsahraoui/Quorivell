// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extraction_item_kind.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExtractionTeachingExample _$ExtractionTeachingExampleFromJson(
  Map<String, dynamic> json,
) => _ExtractionTeachingExample(
  sourceExcerpt: json['sourceExcerpt'] as String,
  quoteSnippet: json['quoteSnippet'] as String,
  statement: json['statement'] as String,
);

Map<String, dynamic> _$ExtractionTeachingExampleToJson(
  _ExtractionTeachingExample instance,
) => <String, dynamic>{
  'sourceExcerpt': instance.sourceExcerpt,
  'quoteSnippet': instance.quoteSnippet,
  'statement': instance.statement,
};

_ExtractionItemKind _$ExtractionItemKindFromJson(Map<String, dynamic> json) =>
    _ExtractionItemKind(
      id: json['id'] as String,
      userId: json['userId'] as String,
      slug: json['slug'] as String,
      displayName: json['displayName'] as String,
      extractionHint: json['extractionHint'] as String?,
      behavior: $enumDecode(_$ExtractionKindBehaviorEnumMap, json['behavior']),
      datePolicy: $enumDecode(
        _$ExtractionKindFieldPolicyEnumMap,
        json['datePolicy'],
      ),
      notePolicy: $enumDecode(
        _$ExtractionKindFieldPolicyEnumMap,
        json['notePolicy'],
      ),
      ownerPolicy: $enumDecode(
        _$ExtractionKindFieldPolicyEnumMap,
        json['ownerPolicy'],
      ),
      enabledForExtraction: json['enabledForExtraction'] as bool,
      isBuiltIn: json['isBuiltIn'] as bool,
      sortOrder: (json['sortOrder'] as num).toInt(),
      teachingExamples:
          (json['teachingExamples'] as List<dynamic>?)
              ?.map(
                (e) => ExtractionTeachingExample.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$ExtractionItemKindToJson(_ExtractionItemKind instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'slug': instance.slug,
      'displayName': instance.displayName,
      'extractionHint': instance.extractionHint,
      'behavior': _$ExtractionKindBehaviorEnumMap[instance.behavior]!,
      'datePolicy': _$ExtractionKindFieldPolicyEnumMap[instance.datePolicy]!,
      'notePolicy': _$ExtractionKindFieldPolicyEnumMap[instance.notePolicy]!,
      'ownerPolicy': _$ExtractionKindFieldPolicyEnumMap[instance.ownerPolicy]!,
      'enabledForExtraction': instance.enabledForExtraction,
      'isBuiltIn': instance.isBuiltIn,
      'sortOrder': instance.sortOrder,
      'teachingExamples': instance.teachingExamples,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$ExtractionKindBehaviorEnumMap = {
  ExtractionKindBehavior.record: 'record',
  ExtractionKindBehavior.completable: 'completable',
};

const _$ExtractionKindFieldPolicyEnumMap = {
  ExtractionKindFieldPolicy.none: 'none',
  ExtractionKindFieldPolicy.optional: 'optional',
};
