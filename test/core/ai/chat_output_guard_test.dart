import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/chat_output_guard.dart';

void main() {
  test('halts at ChatML stop markers', () {
    expect(chatGenerationShouldHalt('Hello from the model.<|im_end|>'), isTrue);
    expect(
      clipGeneratedChatText('Hello from the model.<|im_end|><|im_start|>user'),
      'Hello from the model.',
    );
  });

  test('clips a consecutive repeated paragraph', () {
    const block = 'This is a synthetic fixture paragraph used only in tests. ';
    expect(block.length, greaterThanOrEqualTo(48));
    final looping = '$block$block$block';
    expect(chatGenerationShouldHalt(looping), isTrue);
    expect(clipGeneratedChatText(looping), block);
  });

  test('does not halt a normal short reply', () {
    expect(chatGenerationShouldHalt('Hello from the model.'), isFalse);
    expect(
      clipGeneratedChatText('Hello from the model.'),
      'Hello from the model.',
    );
  });

  test('guard stops forwarding after a loop is detected', () {
    final guard = ChatOutputGuard();
    const block = 'This is a synthetic fixture paragraph used only in tests. ';
    expect(guard.add(block), isFalse);
    expect(guard.add(block), isTrue);
    expect(guard.visibleText, block.trim());
    expect(guard.add(block), isTrue);
  });
}
