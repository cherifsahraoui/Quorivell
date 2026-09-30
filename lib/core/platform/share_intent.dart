/// How Android delivered incoming plain text.
enum IncomingTextKind {
  /// ACTION_SEND share sheet → Capture.
  share,

  /// ACTION_PROCESS_TEXT system text-selection menu → Chat summarize.
  processText,
}

/// One Android ACTION_SEND or ACTION_PROCESS_TEXT plain-text payload, identified across cold/warm
/// delivery so the same intent is not applied twice.
class IncomingSharePayload {
  const IncomingSharePayload({
    required this.id,
    required this.text,
    this.kind = IncomingTextKind.share,
  });

  final int id;
  final String text;
  final IncomingTextKind kind;

  bool get isShare => kind == IncomingTextKind.share;

  bool get isProcessText => kind == IncomingTextKind.processText;

  @override
  bool operator ==(Object other) =>
      other is IncomingSharePayload &&
      other.id == id &&
      other.text == text &&
      other.kind == kind;

  @override
  int get hashCode => Object.hash(id, text, kind);
}

/// Trims [raw] and drops empty / whitespace-only shares.
String? sanitizeSharedPlainText(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  return trimmed;
}

IncomingTextKind parseIncomingTextKind(Object? raw) {
  return raw == 'processText'
      ? IncomingTextKind.processText
      : IncomingTextKind.share;
}

/// Parses a MethodChannel map `{id, text, kind?}` from native. Never logs [raw].
IncomingSharePayload? parseIncomingSharePayload(Object? raw) {
  if (raw is! Map) return null;
  final id = switch (raw['id']) {
    final int value => value,
    final num value => value.toInt(),
    _ => null,
  };
  final textRaw = raw['text'];
  final text = textRaw is String ? sanitizeSharedPlainText(textRaw) : null;
  if (id == null || text == null) return null;
  return IncomingSharePayload(
    id: id,
    text: text,
    kind: parseIncomingTextKind(raw['kind']),
  );
}
