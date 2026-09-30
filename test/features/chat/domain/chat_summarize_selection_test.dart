import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/local_ai_service.dart';
import 'package:quorivell/features/chat/domain/chat_summarize_selection.dart';
import 'package:quorivell/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('keeps the proofread instruction and selected text', () {
    const selected = 'Alex will send the checklist.';
    final prompt = buildChatSummarizeSelectionPrompt(
      interpolate: l10n.chatSummarizeSelectionPrompt,
      selectedText: selected,
    );

    expect(prompt, contains('do not summarize it again'));
    expect(prompt, contains('already a short summary'));
    expect(prompt, contains('Only correct spelling, grammar'));
    expect(prompt, contains(selected));
    expect(
      prompt.length,
      lessThanOrEqualTo(LocalChatRequest.maxUserMessageCharacters),
    );
  });

  test('clips a long selection so the prompt stays in budget', () {
    final selected = 'word ' * 800;
    final prompt = buildChatSummarizeSelectionPrompt(
      interpolate: l10n.chatSummarizeSelectionPrompt,
      selectedText: selected,
      maxCharacters: 200,
    );

    expect(prompt, contains('do not summarize it again'));
    expect(prompt.length, lessThanOrEqualTo(200));
    expect(prompt, isNot(equals(selected)));
  });
}
