import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../extraction_kinds/domain/entities/extraction_item_kind.dart';
import '../../../extraction_kinds/presentation/extraction_kind_labels.dart';

/// Catalog-backed kind control for correcting extraction kind.
class ReviewCandidateKindToggle extends StatelessWidget {
  const ReviewCandidateKindToggle({
    required this.value,
    required this.catalog,
    required this.onChanged,
    super.key,
  });

  final String value;
  final List<ExtractionItemKind> catalog;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kinds = [for (final kind in catalog) kind.slug];
    if (!kinds.contains(value)) {
      kinds.insert(0, value);
    }
    if (kinds.length <= 2) {
      return Semantics(
        label: l10n.reviewKindToggleSemantics,
        child: SegmentedButton<String>(
          segments: [
            for (final slug in kinds)
              ButtonSegment(
                value: slug,
                label: Text(
                  extractionKindDisplayName(l10n, slug, catalog: catalog),
                ),
              ),
          ],
          selected: {value},
          onSelectionChanged: (selection) {
            if (selection.isEmpty) return;
            onChanged(selection.single);
          },
        ),
      );
    }
    return DropdownButtonFormField<String>(
      initialValue: kinds.contains(value) ? value : kinds.first,
      decoration: InputDecoration(labelText: l10n.reviewKindToggleSemantics),
      items: [
        for (final slug in kinds)
          DropdownMenuItem(
            value: slug,
            child: Text(
              extractionKindDisplayName(l10n, slug, catalog: catalog),
            ),
          ),
      ],
      onChanged: (slug) {
        if (slug == null) return;
        onChanged(slug);
      },
    );
  }
}
