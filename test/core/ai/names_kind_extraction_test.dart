import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/extraction_json_codec.dart';
import 'package:quorivell/core/ai/extraction_kind_prompt_spec.dart';
import 'package:quorivell/core/ai/extraction_prompt_builder.dart';
import 'package:quorivell/core/l10n/local_ai_copy.dart';
import 'package:quorivell/l10n/app_localizations.dart';

void main() {
  const codec = ExtractionJsonCodec();
  const conversation = 'Emila did pick up her child Manolis from school';

  test('parses names kind candidates from the Emila/Manolis conversation', () {
    const raw = '''
{"candidates":[
  {"kind":"names","statement":"Emila is named in the conversation","owner":"Emila","dueDate":null,"quoteSnippet":"Emila did pick up her child Manolis from school"},
  {"kind":"names","statement":"Manolis is named in the conversation","owner":"Manolis","dueDate":null,"quoteSnippet":"Emila did pick up her child Manolis from school"}
]}
''';

    final candidates = codec.parse(
      raw,
      conversation,
      enabledKindSlugs: {'names'},
    );

    expect(candidates, hasLength(2));
    expect(candidates.map((c) => c.kind).toSet(), {'names'});
    expect(
      candidates.map((c) => c.statement).toList(),
      containsAll([
        'Emila is named in the conversation',
        'Manolis is named in the conversation',
      ]),
    );
    for (final candidate in candidates) {
      expect(
        candidate.statement,
        isNot(equals(candidate.evidence.quoteSnippet)),
      );
    }
  });

  test('rewrites statement when it equals the evidence quote', () {
    const raw = '''
{"candidates":[
  {"kind":"names","statement":"Emila did pick up her child Manolis from school","owner":null,"dueDate":null,"quoteSnippet":"Emila did pick up her child Manolis from school"}
]}
''';

    final candidates = codec.parse(
      raw,
      conversation,
      enabledKindSlugs: {'names'},
    );

    expect(candidates, hasLength(1));
    expect(
      candidates.single.statement,
      isNot(equals(candidates.single.evidence.quoteSnippet)),
    );
  });

  test('custom names kind guidance is included in the system prompt', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final kinds = [
      ...defaultBuiltInKindSpecs(),
      const ExtractionKindPromptSpec(
        slug: 'names',
        displayName: 'Names',
        hint: 'Extract names in text like Alice or Thomas',
        behavior: 'record',
        datePolicy: 'none',
        notePolicy: 'optional',
        ownerPolicy: 'optional',
      ),
    ];

    final system = ExtractionPromptBuilder.systemInstruction(l10n, kinds);
    expect(system, contains('names'));
    expect(system, contains(l10n.extractionCustomKindsGuidance));
    expect(system, contains(l10n.extractionCustomKindsOnePerItemGuidance));
    expect(system.toLowerCase(), contains('emila'));
    expect(system.toLowerCase(), contains('manolis'));
    expect(system, contains('Alex explicitly committed'));

    final copy = localAICopyFromL10n(l10n, enabledKinds: kinds);
    expect(copy.enabledKindSlugs, contains('names'));
    final user = copy.buildPrompt(conversation);
    expect(user, contains('names'));
    expect(user, contains(conversation));
  });

  test('names-only prompt omits decision and commitment few-shots', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final system = ExtractionPromptBuilder.systemInstruction(l10n, [
      const ExtractionKindPromptSpec(
        slug: 'names',
        displayName: 'Names',
        hint: 'Extract person names.',
        behavior: 'record',
        datePolicy: 'none',
        notePolicy: 'none',
        ownerPolicy: 'optional',
      ),
    ]);

    expect(system, contains('names'));
    expect(system, contains(l10n.extractionCustomKindsOnePerItemGuidance));
    expect(system, isNot(contains('Alex explicitly committed')));
    expect(system, isNot(contains(l10n.extractionSystemDecisionRules)));
  });
}
