/// Sanitizes user-authored kind names, hints, and teaching examples before
/// they enter ChatML as delimited data.
abstract final class ExtractionPromptSanitizer {
  static final _controlChars = RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]');

  static final _injection = RegExp(
    r'(ignore\s+(all\s+)?(previous|prior|above)\s+instructions|'
    r'you\s+are\s+now|'
    r'system\s+prompt|'
    r'<\|im_start\|>|'
    r'<\|im_end\|>|'
    r'chatml)',
    caseSensitive: false,
  );

  static const redactedToken = '[redacted]';

  static String sanitize(String input, {required int maxLength}) {
    var text = input.replaceAll(_controlChars, ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    text = text.replaceAll(_injection, redactedToken);
    if (text.length > maxLength) {
      text = text.substring(0, maxLength).trim();
    }
    return text;
  }
}
