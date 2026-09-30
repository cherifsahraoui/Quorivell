import '../entities/extraction_item_kind.dart';

abstract interface class ExtractionItemKindRepository {
  Stream<List<ExtractionItemKind>> watchAll({int limit, int offset});

  Stream<List<ExtractionItemKind>> watchEnabled({int limit, int offset});

  Future<List<ExtractionItemKind>> listAll();

  Future<List<ExtractionItemKind>> listEnabled();

  Future<ExtractionItemKind> create({
    required String displayName,
    String? extractionHint,
    required ExtractionKindBehavior behavior,
    required ExtractionKindFieldPolicy datePolicy,
    required ExtractionKindFieldPolicy notePolicy,
    required ExtractionKindFieldPolicy ownerPolicy,
    required bool enabledForExtraction,
    List<ExtractionTeachingExample> teachingExamples,
    String? slug,
  });

  Future<ExtractionItemKind> update(ExtractionItemKind kind);

  Future<void> setEnabled({required String id, required bool enabled});

  Future<void> archive(String id);

  Future<void> resetBuiltIns();
}
