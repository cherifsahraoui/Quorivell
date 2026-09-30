/// Strips ChatML special tokens from model output.
///
/// ChatML tokens like `<|im_start|>` and `<|im_end|>` are protocol markers
/// used internally by the model during generation. They must not appear in
/// user-visible content.
///
/// When [trimResult] is false, surrounding whitespace is kept so repeat-loop
/// detection can match a trailing paragraph that ends in a space.
String stripChatMLTokens(String text, {bool trimResult = true}) {
  if (text.isEmpty) return text;

  var result = text;

  // Strip <|im_start|> with optional role prefix (e.g., "<|im_start|>assistant")
  result = result.replaceAll(
    RegExp(r'<\|im_start\|>(?:[A-Za-z]+(?=[\n<]|$))?'),
    '',
  );

  // Strip <|im_end|> markers
  result = result.replaceAll(RegExp(r'<\|im_end\|>'), '');

  return trimResult ? result.trim() : result;
}
