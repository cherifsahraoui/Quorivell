/// Built-in catalog slugs. Historical ledger/candidate `kind` values stay valid.
abstract final class ExtractionKindSlugs {
  static const decision = 'decision';
  static const commitment = 'commitment';

  static const reserved = {decision, commitment};

  static const defaultEnabled = {decision, commitment};

  /// `^[a-z][a-z0-9_]{0,31}$`
  static final slugPattern = RegExp(r'^[a-z][a-z0-9_]{0,31}$');

  static const maxSlugLength = 32;
  static const maxCatalogKinds = 12;
  static const maxEnabledKinds = 8;
  static const minEnabledKinds = 1;
  static const accuracyGuidanceEnabledCount = 4;
  static const maxDisplayNameLength = 80;
  static const maxHintLength = 400;
  static const maxNoteLength = 2000;
  static const maxTeachingExamples = 3;
  static const maxExampleFieldLength = 500;
  static const maxTeachingExamplesJsonLength = 4000;
  static const maxSortOrder = 1000;

  static bool isValidSlug(String slug) => slugPattern.hasMatch(slug);

  /// Builds a unique-looking slug from a display name. Caller still checks
  /// collisions and reserved built-ins.
  static String slugFromDisplayName(String displayName) {
    var slug = displayName.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '_',
    );
    slug = slug.replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_|_$'), '');
    if (slug.isEmpty) {
      return '';
    }
    if (!RegExp(r'^[a-z]').hasMatch(slug)) {
      slug = 'k_$slug';
    }
    if (slug.length > maxSlugLength) {
      slug = slug.substring(0, maxSlugLength);
    }
    return isValidSlug(slug) ? slug : '';
  }
}
