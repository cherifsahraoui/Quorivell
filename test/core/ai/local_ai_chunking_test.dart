import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/ai/local_ai_service.dart';

LocalAICopy _copy() => LocalAICopy(
  emptySummary: 'none',
  candidateCommitments: 'c',
  reviewEachItem: 'r',
  buildPrompt: (conversation) => conversation,
  remoteSystemInstruction: 'sys',
  chatSystemInstruction: 'chat',
);

void main() {
  test('chunked extraction accepts long text within the hard cap', () {
    final text = 'Decision made. ' * 600; // ~9000 chars
    final request = LocalAIRequest(text: text, copy: _copy());
    expect(request.isValid, isFalse);
    expect(request.isValidForChunked, isTrue);
    expect(text.length, lessThan(LocalAIRequest.maxChunkedInputCharacters));
  });

  test('chunked extraction rejects text over the hard cap', () {
    final text = 'x' * (LocalAIRequest.maxChunkedInputCharacters + 1);
    final request = LocalAIRequest(text: text, copy: _copy());
    expect(request.isValidForChunked, isFalse);
  });
}
