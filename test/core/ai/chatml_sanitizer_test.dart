import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/ai/chatml_sanitizer.dart';

void main() {
  group('stripChatMLTokens', () {
    test('returns empty string for empty input', () {
      expect(stripChatMLTokens(''), '');
    });

    test('returns unchanged text when no ChatML tokens present', () {
      const input = 'This is a normal response without any special tokens.';
      expect(stripChatMLTokens(input), input);
    });

    test('strips <|im_end|> from end of text', () {
      const input = 'Here is my response<|im_end|>';
      expect(stripChatMLTokens(input), 'Here is my response');
    });

    test('strips <|im_end|> from middle of text', () {
      const input = 'Here is my<|im_end|> response';
      expect(stripChatMLTokens(input), 'Here is my response');
    });

    test('strips multiple <|im_end|> tokens', () {
      const input = 'Text<|im_end|> with<|im_end|> multiple markers';
      expect(stripChatMLTokens(input), 'Text with multiple markers');
    });

    test('strips <|im_start|> without role', () {
      const input = '<|im_start|>This is a response';
      expect(stripChatMLTokens(input), 'This is a response');
    });

    test('strips <|im_start|>assistant', () {
      const input = '<|im_start|>assistant\nThis is a response';
      expect(stripChatMLTokens(input), 'This is a response');
    });

    test('strips <|im_start|>user', () {
      const input = '<|im_start|>user\nThis is user text';
      expect(stripChatMLTokens(input), 'This is user text');
    });

    test('strips <|im_start|>system', () {
      const input = '<|im_start|>system\nSystem instruction';
      expect(stripChatMLTokens(input), 'System instruction');
    });

    test('strips <|im_start|> with an unknown role', () {
      const input = '<|im_start|>tool\nCall the function';
      expect(stripChatMLTokens(input), 'Call the function');
    });

    test('strips both start and end markers', () {
      const input = '<|im_start|>assistant\nHere is the answer<|im_end|>';
      expect(stripChatMLTokens(input), 'Here is the answer');
    });

    test('strips markers with surrounding whitespace', () {
      const input = '<|im_start|>assistant\n  Response text  <|im_end|>  ';
      expect(stripChatMLTokens(input), 'Response text');
    });

    test('strips markers from complex multi-line response', () {
      const input = '''<|im_start|>assistant
Here is a longer response
with multiple lines
and various content<|im_end|>''';
      const expected = '''Here is a longer response
with multiple lines
and various content''';
      expect(stripChatMLTokens(input), expected);
    });

    test('strips all markers from conversation-like text', () {
      const input =
          '<|im_start|>user\nQuestion<|im_end|><|im_start|>assistant\nAnswer<|im_end|>';
      expect(stripChatMLTokens(input), 'Question\nAnswer');
    });

    test('handles text with partial marker-like strings', () {
      // Should not strip text that looks like markers but isn't exact
      const input = 'Use <|other|> tag or im_start keyword';
      expect(stripChatMLTokens(input), input);
    });

    test('preserves other special characters and formatting', () {
      const input =
          '<|im_start|>assistant\n**Bold** and *italic* with [links](url)<|im_end|>';
      expect(
        stripChatMLTokens(input),
        '**Bold** and *italic* with [links](url)',
      );
    });

    test('handles realistic chat output with trailing marker', () {
      const input = '''To answer your question: Yes, I can help with that.

Here are the steps:
1. First step
2. Second step
3. Third step

Let me know if you need more information.<|im_end|>''';
      const expected = '''To answer your question: Yes, I can help with that.

Here are the steps:
1. First step
2. Second step
3. Third step

Let me know if you need more information.''';
      expect(stripChatMLTokens(input), expected);
    });

    test('handles extraction-style output with markers', () {
      const input = '''<|im_start|>assistant
```json
{
  "decisions": [],
  "commitments": []
}
```<|im_end|>''';
      const expected = '''```json
{
  "decisions": [],
  "commitments": []
}
```''';
      expect(stripChatMLTokens(input), expected);
    });
  });
}
