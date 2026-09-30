import 'entities/extraction_item_kind.dart';

/// In-app starter payloads. Persist only when the user saves a kind.
class ExtractionKindTemplate {
  const ExtractionKindTemplate({
    required this.id,
    required this.slug,
    required this.behavior,
    required this.datePolicy,
    required this.notePolicy,
    required this.ownerPolicy,
  });

  final String id;
  final String slug;
  final ExtractionKindBehavior behavior;
  final ExtractionKindFieldPolicy datePolicy;
  final ExtractionKindFieldPolicy notePolicy;
  final ExtractionKindFieldPolicy ownerPolicy;

  static const groceries = ExtractionKindTemplate(
    id: 'groceries',
    slug: 'groceries',
    behavior: ExtractionKindBehavior.completable,
    datePolicy: ExtractionKindFieldPolicy.optional,
    notePolicy: ExtractionKindFieldPolicy.optional,
    ownerPolicy: ExtractionKindFieldPolicy.none,
  );

  static const followUp = ExtractionKindTemplate(
    id: 'follow_up',
    slug: 'follow_up',
    behavior: ExtractionKindBehavior.completable,
    datePolicy: ExtractionKindFieldPolicy.optional,
    notePolicy: ExtractionKindFieldPolicy.optional,
    ownerPolicy: ExtractionKindFieldPolicy.optional,
  );

  static const all = [groceries, followUp];
}
