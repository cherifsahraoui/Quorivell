import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/extraction_item_kind_providers.dart';
import '../../domain/entities/extraction_item_kind.dart';

part 'extraction_kinds_controller.g.dart';

@riverpod
class ExtractionKindsController extends _$ExtractionKindsController {
  @override
  void build() {}

  Future<void> setEnabled({required String id, required bool enabled}) {
    return ref
        .read(extractionItemKindRepositoryProvider)
        .setEnabled(id: id, enabled: enabled);
  }

  Future<ExtractionItemKind> create({
    required String displayName,
    String? extractionHint,
    required ExtractionKindBehavior behavior,
    required ExtractionKindFieldPolicy datePolicy,
    required ExtractionKindFieldPolicy notePolicy,
    required ExtractionKindFieldPolicy ownerPolicy,
    required bool enabledForExtraction,
    List<ExtractionTeachingExample> teachingExamples = const [],
    String? slug,
  }) {
    return ref
        .read(extractionItemKindRepositoryProvider)
        .create(
          displayName: displayName,
          extractionHint: extractionHint,
          behavior: behavior,
          datePolicy: datePolicy,
          notePolicy: notePolicy,
          ownerPolicy: ownerPolicy,
          enabledForExtraction: enabledForExtraction,
          teachingExamples: teachingExamples,
          slug: slug,
        );
  }

  Future<ExtractionItemKind> update(ExtractionItemKind kind) {
    return ref.read(extractionItemKindRepositoryProvider).update(kind);
  }

  Future<void> archive(String id) {
    return ref.read(extractionItemKindRepositoryProvider).archive(id);
  }

  Future<void> resetBuiltIns() {
    return ref.read(extractionItemKindRepositoryProvider).resetBuiltIns();
  }
}
