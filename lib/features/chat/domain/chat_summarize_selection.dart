import '../../../core/ai/local_ai_service.dart';

/// Builds the Chat user turn for Android PROCESS_TEXT summarize.
///
/// [interpolate] is the localized ARB template applied to the (possibly
/// clipped) selected text. The full prompt stays within [maxCharacters].
String buildChatSummarizeSelectionPrompt({
  required String Function(String text) interpolate,
  required String selectedText,
  int maxCharacters = LocalChatRequest.maxUserMessageCharacters,
}) {
  final overhead = interpolate('').length;
  final budget = (maxCharacters - overhead).clamp(0, maxCharacters);
  final trimmed = selectedText.trim();
  final clipped = budget <= 0
      ? ''
      : (trimmed.length <= budget ? trimmed : trimmed.substring(0, budget));
  final prompt = interpolate(clipped);
  if (prompt.length <= maxCharacters) return prompt;
  return prompt.substring(0, maxCharacters);
}
