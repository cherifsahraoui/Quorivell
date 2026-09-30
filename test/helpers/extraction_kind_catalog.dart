import 'package:quorivell/features/extraction_kinds/data/providers/extraction_item_kind_providers.dart';
import 'package:quorivell/features/extraction_kinds/domain/entities/extraction_item_kind.dart';
import 'package:riverpod/misc.dart' show Override;

final _stamp = DateTime.utc(2026, 9, 21);

ExtractionItemKind testExtractionKind({
  required String slug,
  String? id,
  String? displayName,
  ExtractionKindBehavior behavior = ExtractionKindBehavior.record,
  ExtractionKindFieldPolicy datePolicy = ExtractionKindFieldPolicy.none,
  ExtractionKindFieldPolicy notePolicy = ExtractionKindFieldPolicy.optional,
  ExtractionKindFieldPolicy ownerPolicy = ExtractionKindFieldPolicy.optional,
  bool enabledForExtraction = true,
  bool isBuiltIn = false,
  int sortOrder = 0,
  List<ExtractionTeachingExample> teachingExamples = const [],
}) {
  return ExtractionItemKind(
    id: id ?? slug,
    userId: 'user-1',
    slug: slug,
    displayName: displayName ?? slug,
    behavior: behavior,
    datePolicy: datePolicy,
    notePolicy: notePolicy,
    ownerPolicy: ownerPolicy,
    enabledForExtraction: enabledForExtraction,
    isBuiltIn: isBuiltIn,
    sortOrder: sortOrder,
    teachingExamples: teachingExamples,
    createdAt: _stamp,
    updatedAt: _stamp,
  );
}

List<ExtractionItemKind> builtInExtractionKinds() => [
  testExtractionKind(
    slug: 'decision',
    displayName: 'Decision',
    behavior: ExtractionKindBehavior.record,
    datePolicy: ExtractionKindFieldPolicy.none,
    isBuiltIn: true,
    sortOrder: 0,
  ),
  testExtractionKind(
    slug: 'commitment',
    displayName: 'Commitment',
    behavior: ExtractionKindBehavior.completable,
    datePolicy: ExtractionKindFieldPolicy.optional,
    isBuiltIn: true,
    sortOrder: 1,
  ),
];

List<Override> extractionKindCatalogOverrides([
  List<ExtractionItemKind>? kinds,
]) {
  final catalog = kinds ?? builtInExtractionKinds();
  final enabled = [
    for (final kind in catalog)
      if (kind.enabledForExtraction) kind,
  ];
  return [
    extractionItemKindsProvider.overrideWith((ref) => Stream.value(catalog)),
    enabledExtractionItemKindsProvider.overrideWith(
      (ref) => Stream.value(enabled),
    ),
  ];
}
