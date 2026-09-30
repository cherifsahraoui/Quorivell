import 'package:freezed_annotation/freezed_annotation.dart';

part 'extraction_item_kind.freezed.dart';
part 'extraction_item_kind.g.dart';

enum ExtractionKindBehavior { record, completable }

enum ExtractionKindFieldPolicy { none, optional }

@freezed
abstract class ExtractionTeachingExample with _$ExtractionTeachingExample {
  const factory ExtractionTeachingExample({
    required String sourceExcerpt,
    required String quoteSnippet,
    required String statement,
  }) = _ExtractionTeachingExample;

  factory ExtractionTeachingExample.fromJson(Map<String, dynamic> json) =>
      _$ExtractionTeachingExampleFromJson(json);
}

@freezed
abstract class ExtractionItemKind with _$ExtractionItemKind {
  const factory ExtractionItemKind({
    required String id,
    required String userId,
    required String slug,
    required String displayName,
    String? extractionHint,
    required ExtractionKindBehavior behavior,
    required ExtractionKindFieldPolicy datePolicy,
    required ExtractionKindFieldPolicy notePolicy,
    required ExtractionKindFieldPolicy ownerPolicy,
    required bool enabledForExtraction,
    required bool isBuiltIn,
    required int sortOrder,
    @Default([]) List<ExtractionTeachingExample> teachingExamples,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _ExtractionItemKind;

  factory ExtractionItemKind.fromJson(Map<String, dynamic> json) =>
      _$ExtractionItemKindFromJson(json);
}
