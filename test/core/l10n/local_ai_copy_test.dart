import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/extraction_kind_prompt_spec.dart';
import 'package:quorivell/core/l10n/local_ai_copy.dart';
import 'package:quorivell/l10n/app_localizations.dart';

void main() {
  test('English extraction prompts come from AppLocalizations', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final copy = localAICopyFromL10n(l10n);
    const conversation = 'Alex will send the checklist.';

    expect(copy.emptySummary, l10n.extractionEmptySummary);
    expect(copy.buildPrompt(conversation), contains(conversation));
    expect(copy.buildPrompt(conversation), contains('Return raw JSON only'));
    expect(copy.buildPrompt(conversation), contains('decision, commitment'));
    expect(
      copy.remoteSystemInstruction,
      contains('Alex explicitly committed to delivering the API documentation'),
    );
    expect(copy.remoteSystemInstruction, contains('"candidates"'));
    expect(
      copy.remoteSystemInstruction,
      contains('Never invent a kind other than the enabled kinds'),
    );
    expect(copy.remoteSystemInstruction, contains('decision, commitment'));
    expect(copy.remoteSystemInstruction, contains('"dueDate":"2026-10-15"'));
    expect(copy.languageCode, 'en');
  });

  test('German extraction prompts come from AppLocalizations', () {
    final l10n = lookupAppLocalizations(const Locale('de'));
    final copy = localAICopyForLocale(const Locale('de'));
    const conversation = 'Alex schickt die Checkliste.';

    expect(copy.emptySummary, l10n.extractionEmptySummary);
    expect(copy.buildPrompt(conversation), contains(conversation));
    expect(copy.remoteSystemInstruction, contains('YYYY-MM-DD'));
    expect(
      copy.remoteSystemInstruction,
      contains('Alex ausdrücklich verpflichtet'),
    );
    expect(copy.remoteSystemInstruction, contains('"dueDate":"2026-10-15"'));
    expect(copy.languageCode, 'de');
  });

  test('Arabic extraction prompts come from AppLocalizations', () {
    final copy = localAICopyForLocale(const Locale('ar'));
    const conversation = 'Alex سيرسل قائمة التحقق.';

    expect(copy.buildPrompt(conversation), contains(conversation));
    expect(copy.remoteSystemInstruction, contains('candidates'));
    expect(copy.remoteSystemInstruction, contains('التزم أليكس صراحةً'));
    expect(copy.remoteSystemInstruction, contains('"dueDate":"2026-10-15"'));
    expect(copy.languageCode, 'ar');
  });

  test('prompt overrides replace chat and extraction templates', () {
    final base = localAICopyForLocale(const Locale('en'));
    const conversation = 'Alex will send the checklist.';
    final overridden = applyAiPromptOverrides(
      base,
      debugModeEnabled: true,
      chatSystemPromptOverride: 'Stay on this device.',
      extractionPromptOverride: 'Extract only.\n\n{conversation}',
      extractionSystemPromptOverride: 'Return JSON only.',
    );

    expect(overridden.chatSystemInstruction, 'Stay on this device.');
    expect(overridden.remoteSystemInstruction, 'Return JSON only.');
    expect(
      overridden.buildPrompt(conversation),
      'Extract only.\n\n$conversation',
    );
  });

  test('non-empty prompt overrides apply when debug mode is off', () {
    final base = localAICopyForLocale(const Locale('en'));
    final overridden = applyAiPromptOverrides(
      base,
      debugModeEnabled: false,
      chatSystemPromptOverride: 'Stay on this device.',
    );

    expect(overridden.chatSystemInstruction, 'Stay on this device.');
  });

  test('empty prompt overrides keep ARB defaults', () {
    final base = localAICopyForLocale(const Locale('en'));
    final overridden = applyAiPromptOverrides(
      base,
      debugModeEnabled: false,
      chatSystemPromptOverride: '  ',
    );

    expect(overridden.chatSystemInstruction, base.chatSystemInstruction);
  });

  test('groceries catalog is listed as a legal kind', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final copy = localAICopyFromL10n(
      l10n,
      enabledKinds: [
        ...defaultBuiltInKindSpecs(),
        const ExtractionKindPromptSpec(
          slug: 'groceries',
          displayName: 'Groceries',
          hint: 'Things we need to buy.',
          behavior: 'completable',
          datePolicy: 'optional',
          notePolicy: 'optional',
          ownerPolicy: 'none',
        ),
      ],
    );

    expect(copy.buildPrompt('Need milk.'), contains('groceries'));
    expect(copy.remoteSystemInstruction, contains('groceries'));
    expect(copy.remoteSystemInstruction, contains('Things we need to buy.'));
    expect(copy.enabledKindSlugs, contains('groceries'));
  });

  test('chatSystemInstruction follows locale for en/de/ar', () {
    final en = localAICopyForLocale(const Locale('en'));
    final de = localAICopyForLocale(const Locale('de'));
    final ar = localAICopyForLocale(const Locale('ar'));

    expect(
      en.chatSystemInstruction,
      contains("Quorivell's on-device assistant"),
    );
    expect(de.chatSystemInstruction, contains('Assistent auf dem Gerät'));
    expect(ar.chatSystemInstruction, contains('مساعد كوريڤيل'));
    expect(en.chatSystemInstruction, contains('kinds you enable'));
    expect(en.languageCode, 'en');
    expect(de.languageCode, 'de');
    expect(ar.languageCode, 'ar');
  });
}
