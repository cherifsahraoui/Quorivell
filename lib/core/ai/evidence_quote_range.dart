/// Inclusive-exclusive character range inside conversation content.
typedef EvidenceQuoteRange = ({int start, int end});

/// Resolves the highlight span for a stored evidence quote.
///
/// Prefers a [quoteSnippet] match in [content] over raw offsets. When the
/// snippet occurs more than once, the occurrence closest to [quoteStart] is
/// used. Offsets are trusted only when they are in range and (if a snippet is
/// provided) actually contain that snippet. Whitespace-flexible matching is a
/// last resort when the model quote does not match the source exactly.
EvidenceQuoteRange? resolveEvidenceQuoteRange({
  required String content,
  int? quoteStart,
  int? quoteEnd,
  String? quoteSnippet,
}) {
  final snippet = quoteSnippet?.trim();
  final hasSnippet = snippet != null && snippet.isNotEmpty;

  if (quoteStart != null &&
      quoteEnd != null &&
      _offsetsValid(content, quoteStart, quoteEnd)) {
    final slice = content.substring(quoteStart, quoteEnd);
    if (!hasSnippet) {
      return (start: quoteStart, end: quoteEnd);
    }
    if (slice == snippet) {
      return (start: quoteStart, end: quoteEnd);
    }
    final inner = slice.indexOf(snippet);
    if (inner >= 0) {
      return (
        start: quoteStart + inner,
        end: quoteStart + inner + snippet.length,
      );
    }
  }

  if (!hasSnippet) {
    return null;
  }

  return _closestOccurrence(content, snippet, quoteStart) ??
      _closestWhitespaceFlexibleMatch(content, snippet, quoteStart);
}

bool _offsetsValid(String content, int start, int end) {
  return start >= 0 && end <= content.length && start < end;
}

EvidenceQuoteRange? _closestOccurrence(
  String content,
  String snippet,
  int? hintStart,
) {
  final starts = <int>[];
  var from = 0;
  while (true) {
    final index = content.indexOf(snippet, from);
    if (index < 0) {
      break;
    }
    starts.add(index);
    from = index + 1;
  }
  if (starts.isEmpty) {
    return null;
  }
  final chosen = _closestIndex(starts, hintStart);
  return (start: chosen, end: chosen + snippet.length);
}

int _closestIndex(List<int> starts, int? hint) {
  if (hint == null || starts.length == 1) {
    return starts.first;
  }
  var best = starts.first;
  var bestDist = (best - hint).abs();
  for (final start in starts.skip(1)) {
    final dist = (start - hint).abs();
    if (dist < bestDist) {
      best = start;
      bestDist = dist;
    }
  }
  return best;
}

EvidenceQuoteRange? _closestWhitespaceFlexibleMatch(
  String content,
  String snippet,
  int? hintStart,
) {
  final pattern = RegExp(
    RegExp.escape(snippet).replaceAll(RegExp(r'\s+'), r'\s+'),
    unicode: true,
  );
  final matches = pattern.allMatches(content).toList();
  if (matches.isEmpty) {
    return null;
  }
  var best = matches.first;
  if (hintStart != null && matches.length > 1) {
    var bestDist = (best.start - hintStart).abs();
    for (final match in matches.skip(1)) {
      final dist = (match.start - hintStart).abs();
      if (dist < bestDist) {
        best = match;
        bestDist = dist;
      }
    }
  }
  return (start: best.start, end: best.end);
}
