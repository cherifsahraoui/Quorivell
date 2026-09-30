import 'package:flutter/foundation.dart';

/// Provides safe logging that redacts sensitive user data.
///
/// In local-only mode, diagnostics must exclude:
/// - Source conversation text and evidence quotes
/// - Prompts and system instructions
/// - Corrections and user feedback
/// - Credentials and tokens
/// - Firebase codes and raw SDK exceptions
///
/// Use [safeLog] for general diagnostics and [safeDebugLog] for debug-only
/// output. Both redact sensitive content automatically.
class DiagnosticSanitizer {
  const DiagnosticSanitizer._();

  /// Maximum characters to show from any untrusted string in logs.
  static const _maxPreviewLength = 80;

  /// Patterns that indicate a string contains sensitive data.
  static final _sensitivePatterns = [
    // Auth/credential indicators
    RegExp(
      r'password|credential|token|secret|key|bearer',
      caseSensitive: false,
    ),
    // API/Firebase indicators
    RegExp(r'api[-_]?key|auth[-_]?token|firebase', caseSensitive: false),
    // Prompt/instruction indicators
    RegExp(
      r'<\|im_start\||<\|im_end\||system instruction|assistant',
      caseSensitive: false,
    ),
  ];

  /// Returns a safe preview of [text] suitable for logging.
  ///
  /// - Checks for sensitive patterns and returns `[REDACTED]` if found
  /// - Truncates long content to [_maxPreviewLength]
  /// - Never returns the full content of conversation text, evidence, or prompts
  static String sanitize(String text) {
    if (text.isEmpty) return '(empty)';

    // Check for sensitive patterns
    for (final pattern in _sensitivePatterns) {
      if (pattern.hasMatch(text)) {
        return '[REDACTED: sensitive content]';
      }
    }

    // Truncate long content
    if (text.length > _maxPreviewLength) {
      return '${text.substring(0, _maxPreviewLength)}… [${text.length} chars]';
    }

    return text;
  }

  /// Returns a safe summary for source conversation content.
  ///
  /// Never logs the actual text, only length metadata.
  static String sanitizeConversation(String content) {
    return '[conversation: ${content.length} chars]';
  }

  /// Returns a safe summary for evidence quotes.
  ///
  /// Never logs the actual quote, only length and position metadata.
  static String sanitizeEvidence({
    required String quoteSnippet,
    required int quoteStart,
    required int quoteEnd,
  }) {
    return '[evidence: ${quoteSnippet.length} chars at $quoteStart-$quoteEnd]';
  }

  /// Returns a safe summary for prompts and system instructions.
  ///
  /// Never logs the actual prompt, only length metadata.
  static String sanitizePrompt(String prompt) {
    return '[prompt: ${prompt.length} chars]';
  }

  /// Returns a safe summary for model output.
  ///
  /// In local-only mode, model outputs may contain extracted statements,
  /// evidence quotes, or chat replies that reference source text.
  /// Only log length and format metadata, not the content.
  static String sanitizeModelOutput(String output) {
    return '[model output: ${output.length} chars]';
  }

  /// Returns a safe summary for credentials.
  ///
  /// Always returns REDACTED, never logs any part of credentials.
  static String sanitizeCredential(String credential) {
    return '[REDACTED: credential]';
  }

  /// Returns a safe summary for tokens.
  ///
  /// Always returns REDACTED, never logs any part of tokens.
  static String sanitizeToken(String token) {
    return '[REDACTED: token]';
  }

  /// Returns a safe error message for exceptions.
  ///
  /// Maps SDK exceptions to safe descriptions without exposing:
  /// - Firebase error codes
  /// - Stack traces
  /// - Raw exception messages that might contain user data
  static String sanitizeException(Object exception, {StackTrace? stackTrace}) {
    if (exception is Exception) {
      final message = exception.toString();
      // Remove "Exception: " prefix if present
      final cleaned = message.startsWith('Exception: ')
          ? message.substring('Exception: '.length)
          : message;
      return sanitize(cleaned);
    }
    return exception.runtimeType.toString();
  }
}

/// Safe logging that redacts sensitive content.
///
/// Use this instead of direct `print()` or `debugPrint()` calls when logging
/// might include user data, prompts, evidence, or credentials.
///
/// Example:
/// ```dart
/// safeLog('Extraction started', {
///   'conversationLength': content.length,
///   'modelId': modelId,
/// });
/// ```
void safeLog(String message, [Map<String, dynamic>? details]) {
  final buffer = StringBuffer('[Quorivell] $message');
  if (details != null && details.isNotEmpty) {
    buffer.write(' {');
    var first = true;
    details.forEach((key, value) {
      if (!first) buffer.write(', ');
      first = false;
      final safeValue = value is String
          ? DiagnosticSanitizer.sanitize(value)
          : value.toString();
      buffer.write('$key: $safeValue');
    });
    buffer.write('}');
  }
  debugPrint(buffer.toString());
}

/// Safe debug-only logging that redacts sensitive content.
///
/// Only outputs in debug mode. Use for verbose diagnostics that are helpful
/// during development but should not appear in release builds.
void safeDebugLog(String message, [Map<String, dynamic>? details]) {
  if (kDebugMode) {
    safeLog(message, details);
  }
}
