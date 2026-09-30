import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/extraction_json_codec.dart';
import 'package:quorivell/core/ai/local_ai_service.dart';
import 'package:quorivell/core/l10n/local_ai_copy.dart';
import 'package:flutter/widgets.dart';

void main() {
  final copy = localAICopyForLocale(const Locale('en'));

  test('parses typed candidates from model JSON', () {
    const source = 'Alex will send the checklist.';
    const raw = '''
```json
{"candidates":[{"kind":"commitment","statement":"Alex will send the checklist.","owner":"Alex","dueDate":null,"quoteSnippet":"Alex will send the checklist."}]}
```
''';

    final candidates = const ExtractionJsonCodec().parse(raw, source);

    expect(candidates, hasLength(1));
    expect(candidates.single.kind, ExtractionCandidateKind.commitment);
    expect(candidates.single.owner, 'Alex');
    expect(candidates.single.dueDate, isNull);
    expect(candidates.single.evidence.quoteStart, 0);
    expect(candidates.single.evidence.quoteEnd, source.length);
  });

  test('locates a repeated quote using stored offsets as a hint', () {
    const phrase = 'we will ship Friday';
    const source = 'First we will ship Friday. Then we will ship Friday.';
    final second = source.lastIndexOf(phrase);
    final raw =
        '{"candidates":[{"kind":"decision","statement":"Ship Friday.","owner":null,"dueDate":null,"quoteSnippet":"$phrase","quoteStart":$second,"quoteEnd":${second + 2}}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.evidence.quoteStart, second);
    expect(candidate.evidence.quoteEnd, second + phrase.length);
  });

  test('ignores hallucinated offsets when the snippet is in the source', () {
    const source = 'Alpha noted it. Later we chose option B.';
    const snippet = 'we chose option B.';
    const raw =
        '{"candidates":[{"kind":"decision","statement":"Chose option B.","owner":null,"dueDate":null,"quoteSnippet":"$snippet","quoteStart":0,"quoteEnd":5}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.evidence.quoteStart, source.indexOf(snippet));
    expect(
      candidate.evidence.quoteEnd,
      source.indexOf(snippet) + snippet.length,
    );
  });

  test('parses a bare candidates array', () {
    const source = 'Alex will send the checklist.';
    const raw =
        '[{"kind":"commitment","statement":"Alex will send the checklist.","owner":"Alex","dueDate":null,"quoteSnippet":"Alex will send the checklist."}]';

    final candidates = const ExtractionJsonCodec().parse(raw, source);

    expect(candidates, hasLength(1));
    expect(candidates.single.kind, ExtractionCandidateKind.commitment);
  });

  test('treats unspecified owner values as unknown', () {
    const source = 'We decided to ship.';
    const raw =
        '{"candidates":[{"kind":"decision","statement":"We decided to ship.","owner":"Not stated","dueDate":"Nicht angegeben","quoteSnippet":"We decided to ship."}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.kind, ExtractionCandidateKind.decision);
    expect(candidate.owner, isNull);
    expect(candidate.dueDate, isNull);
  });

  test('ignores dueDate on decision candidates', () {
    const source = 'We decided to ship by Friday.';
    const raw =
        '{"candidates":[{"kind":"decision","statement":"We decided to ship.","owner":null,"dueDate":"2026-09-10T15:30:00.000Z","quoteSnippet":"We decided to ship."}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.kind, ExtractionCandidateKind.decision);
    expect(candidate.dueDate, isNull);
  });

  test('uses nested evidence.quoteSnippet instead of statement', () {
    const source = 'We decided to ship.';
    const raw =
        '{"candidates":[{"kind":"decision","statement":"We will ship Friday","owner":null,"dueDate":null,"evidence":{"quoteSnippet":"We decided to ship.","quoteStart":0,"quoteEnd":19}}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.statement, 'We will ship Friday');
    expect(candidate.evidence.quoteSnippet, 'We decided to ship.');
    expect(candidate.evidence.quoteStart, 0);
    expect(candidate.evidence.quoteEnd, source.length);
  });

  test('uses nested evidence string as the quote snippet', () {
    const source = 'Alex will send the checklist.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Alex owns the follow-up.","owner":"Alex","dueDate":null,"evidence":"Alex will send the checklist."}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.statement, 'Alex owns the follow-up.');
    expect(candidate.evidence.quoteSnippet, 'Alex will send the checklist.');
    expect(candidate.evidence.quoteStart, 0);
    expect(candidate.evidence.quoteEnd, source.length);
  });

  test('prefers top-level quoteSnippet over nested evidence', () {
    const source = 'We decided to ship. Alex will send the checklist.';
    const raw =
        '{"candidates":[{"kind":"decision","statement":"We will ship Friday","owner":null,"dueDate":null,"quoteSnippet":"We decided to ship.","evidence":{"quoteSnippet":"Alex will send the checklist."}}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.evidence.quoteSnippet, 'We decided to ship.');
    expect(candidate.evidence.quoteStart, 0);
    expect(candidate.evidence.quoteEnd, 'We decided to ship.'.length);
  });

  test('parses October 15th dueDate from ISO field', () {
    const source =
        'Alex explicitly committed to delivering the API documentation by October 15th.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Alex will deliver the API documentation by October 15th","owner":"Alex","dueDate":"2026-10-15","quoteSnippet":"Alex explicitly committed to delivering the API documentation by October 15th"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate, DateTime.utc(2026, 10, 15));
  });

  test('recovers October 15th from statement when dueDate is null', () {
    const source =
        'During today\'s sync, Alex explicitly committed to delivering the API documentation by October 15th.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Alex will deliver the API documentation by October 15th","owner":"Alex","dueDate":null,"quoteSnippet":"Alex explicitly committed to delivering the API documentation by October 15th"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate?.month, 10);
    expect(candidate.dueDate?.day, 15);
  });

  test('uses year from statement when month-day has no year', () {
    const source =
        'Meeting date: 2026-01-03. Sam will set up CI by October 15th 2027.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Sam will set up CI by October 15th 2027","owner":"Sam","dueDate":null,"quoteSnippet":"Sam will set up CI by October 15th 2027"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate, DateTime.utc(2027, 10, 15));
  });

  test('does not take calendar day from unrelated conversation text', () {
    const source =
        'Budget review is October 15th. Alex will send the checklist.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Alex will send the checklist","owner":"Alex","dueDate":null,"quoteSnippet":"Alex will send the checklist"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate, isNull);
  });

  test('leaves relative deadlines null even if model invents ISO', () {
    const source = 'Alex will send the checklist next week.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Alex will send the checklist next week","owner":"Alex","dueDate":"2026-09-22","quoteSnippet":"Alex will send the checklist next week"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate, isNull);
  });

  test('leaves EOD and nächste Woche due dates null', () {
    const source = 'Alex liefert die Doku bis Ende der Woche.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Alex liefert die Doku bis Ende der Woche","owner":"Alex","dueDate":null,"quoteSnippet":"bis Ende der Woche"}]}';

    final candidate = const ExtractionJsonCodec()
        .parse(raw, source, languageCode: 'de')
        .single;

    expect(candidate.dueDate, isNull);
  });

  test('de locale treats ambiguous slash dates as day/month', () {
    const source = 'Lieferung bis 05/06/2026.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Lieferung bis 05/06/2026","owner":"Sam","dueDate":null,"quoteSnippet":"bis 05/06/2026"}]}';

    final candidate = const ExtractionJsonCodec()
        .parse(raw, source, languageCode: 'de')
        .single;

    expect(candidate.dueDate, DateTime.utc(2026, 6, 5));
  });

  test('drops Arabic soft-cue-only candidates', () {
    const source =
        'ربما نرسل التقرير لاحقاً. التزم أليكس بالتسليم بحلول 15 أكتوبر.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"ربما نرسل التقرير","owner":null,"dueDate":null,"quoteSnippet":"ربما نرسل التقرير لاحقاً"},{"kind":"commitment","statement":"أليكس يسلّم بحلول 15 أكتوبر","owner":"Alex","dueDate":null,"quoteSnippet":"التزم أليكس بالتسليم بحلول 15 أكتوبر"}]}';

    final candidates = const ExtractionJsonCodec().parse(
      raw,
      source,
      languageCode: 'ar',
    );

    expect(candidates, hasLength(1));
    expect(candidates.single.owner, 'Alex');
    expect(candidates.single.dueDate?.month, 10);
    expect(candidates.single.dueDate?.day, 15);
  });

  test('leaves Friday-only due dates unknown', () {
    const source = "Jamie: I'll have the privacy wireframes ready by Friday.";
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Jamie will draft privacy consent wireframes by Friday","owner":"Jamie","dueDate":null,"quoteSnippet":"I\'ll have the privacy wireframes ready by Friday"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate, isNull);
  });

  test('parses November the 7th at 5 PM from statement', () {
    const source =
        'Sam committed to delivering the report by November the 7th at 5 PM.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Sam will deliver the report by November the 7th at 5 PM","owner":"Sam","dueDate":null,"quoteSnippet":"Sam committed to delivering the report by November the 7th at 5 PM"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;
    final year = DateTime.now().toUtc().year;

    expect(candidate.dueDate, DateTime.utc(year, 11, 7, 17));
  });

  test('parses German 15. Oktober due dates from statement', () {
    const source =
        'Alex hat sich verpflichtet, die API-Dokumentation bis zum 15. Oktober zu liefern.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Alex liefert die API-Dokumentation bis zum 15. Oktober","owner":"Alex","dueDate":null,"quoteSnippet":"bis zum 15. Oktober zu liefern"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate?.month, 10);
    expect(candidate.dueDate?.day, 15);
  });

  test('parses Arabic 15 أكتوبر due dates from statement', () {
    const source = 'التزم أليكس بتسليم الوثائق بحلول 15 أكتوبر.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"أليكس يسلّم الوثائق بحلول 15 أكتوبر","owner":"Alex","dueDate":null,"quoteSnippet":"بحلول 15 أكتوبر"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate?.month, 10);
    expect(candidate.dueDate?.day, 15);
  });

  test('parses German um 17 Uhr with November date', () {
    const source = 'Sam liefert den Bericht bis zum 7. November um 17 Uhr.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Sam liefert den Bericht bis zum 7. November um 17 Uhr","owner":"Sam","dueDate":null,"quoteSnippet":"bis zum 7. November um 17 Uhr"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;
    final year = DateTime.now().toUtc().year;

    expect(candidate.dueDate, DateTime.utc(year, 11, 7, 17));
  });

  test('parses German DD.MM.YYYY numeric dates', () {
    const source = 'Alex liefert die Doku bis zum 20.05.2026.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Alex liefert die Doku bis zum 20.05.2026","owner":"Alex","dueDate":null,"quoteSnippet":"bis zum 20.05.2026"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate, DateTime.utc(2026, 5, 20));
  });

  test('prefers day.month for ambiguous dotted German dates', () {
    const source = 'Lieferung bis 05.06.2026.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Lieferung bis 05.06.2026","owner":"Sam","dueDate":null,"quoteSnippet":"bis 05.06.2026"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    // DD.MM.YYYY → 5 June 2026 (not US 6 May).
    expect(candidate.dueDate, DateTime.utc(2026, 6, 5));
  });

  test('keeps slash dates as month/day when ambiguous', () {
    const source = 'Deliver by 05/06/2026.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Deliver by 05/06/2026","owner":"Sam","dueDate":null,"quoteSnippet":"by 05/06/2026"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate, DateTime.utc(2026, 5, 6));
  });

  test('preserves time from ISO dueDate field', () {
    const source = 'Sam will deliver the report by November the 7th at 5 PM.';
    const raw =
        '{"candidates":[{"kind":"commitment","statement":"Sam will deliver the report","owner":"Sam","dueDate":"2026-11-07T17:00:00","quoteSnippet":"Sam will deliver the report by November the 7th at 5 PM"}]}';

    final candidate = const ExtractionJsonCodec().parse(raw, source).single;

    expect(candidate.dueDate, DateTime.utc(2026, 11, 7, 17));
  });

  test(
    'on-device service sends the localized prompt and returns candidates',
    () async {
      final runtime = _RecordingRuntime(
        '{"candidates":[{"kind":"commitment","statement":"Alex will send the checklist.","owner":"Alex","dueDate":null,"quoteSnippet":"Alex will send the checklist."}]}',
      );
      final service = OnDeviceLocalAIService(runtime);
      const conversation = 'Alex will send the checklist.';

      final response = await service.extract(
        LocalAIRequest(text: conversation, copy: copy),
      );

      expect(runtime.prompt, contains(copy.remoteSystemInstruction));
      expect(runtime.prompt, contains(copy.buildPrompt(conversation)));
      expect(runtime.prompt, contains('<|im_start|>assistant'));
      expect(response.candidates, hasLength(1));
      expect(response.candidates.single.owner, 'Alex');
    },
  );

  test('rejects empty and oversized note input', () async {
    final service = OnDeviceLocalAIService(
      _RecordingRuntime('{"candidates":[]}'),
    );

    await expectLater(
      service.extract(LocalAIRequest(text: '', copy: copy)),
      throwsA(
        isA<LocalAIException>().having(
          (error) => error.code,
          'code',
          'invalid-input',
        ),
      ),
    );
    await expectLater(
      service.extract(
        LocalAIRequest(
          text: 'x' * (LocalAIRequest.maxInputCharacters + 1),
          copy: copy,
        ),
      ),
      throwsA(
        isA<LocalAIException>().having(
          (error) => error.code,
          'code',
          'invalid-input',
        ),
      ),
    );
  });

  test('unavailable runtime becomes a typed local exception', () async {
    final service = OnDeviceLocalAIService(
      _RecordingRuntime('{}', available: false),
    );

    await expectLater(
      service.extract(
        LocalAIRequest(text: 'Alex will send the checklist.', copy: copy),
      ),
      throwsA(
        isA<LocalAIException>().having(
          (error) => error.code,
          'code',
          'unavailable',
        ),
      ),
    );
  });

  test('chat sends ChatML history and streams tokens', () async {
    final runtime = _RecordingRuntime('Hello from the model.');
    final service = OnDeviceLocalAIService(runtime);
    final tokens = <String>[];

    final reply = await service.chat(
      LocalChatRequest(
        turns: const [
          LocalChatTurn(role: LocalChatRole.user, content: 'Say hello.'),
        ],
        copy: copy,
      ),
      onToken: tokens.add,
    );

    expect(runtime.prompt, contains(copy.chatSystemInstruction));
    expect(copy.chatSystemInstruction, contains('Capture'));
    expect(copy.chatSystemInstruction, contains('Ledger'));
    expect(runtime.prompt, contains('Say hello.'));
    expect(runtime.prompt, contains('<|im_start|>assistant\n'));
    expect(reply, 'Hello from the model.');
    expect(tokens, ['Hello from the model.']);
  });

  test('chat stops a repeating reply instead of returning the loop', () async {
    const block = 'This is a synthetic fixture paragraph used only in tests. ';
    final runtime = _RecordingRuntime('$block$block$block');
    final service = OnDeviceLocalAIService(runtime);

    final reply = await service.chat(
      LocalChatRequest(
        turns: const [
          LocalChatTurn(role: LocalChatRole.user, content: 'Say hello.'),
        ],
        copy: copy,
      ),
    );

    expect(reply, block.trim());
    expect(runtime.stopCount, 1);
  });

  test('chat rejects an empty user turn', () async {
    final service = OnDeviceLocalAIService(
      _RecordingRuntime('Hello from the model.'),
    );

    await expectLater(
      service.chat(LocalChatRequest(turns: const [], copy: copy)),
      throwsA(
        isA<LocalAIException>().having(
          (error) => error.code,
          'code',
          'invalid-input',
        ),
      ),
    );
  });

  test('buildLocalChatPrompt drops oldest turns when over budget', () {
    final request = LocalChatRequest(
      turns: const [
        LocalChatTurn(role: LocalChatRole.user, content: 'first turn'),
        LocalChatTurn(role: LocalChatRole.assistant, content: 'first reply'),
        LocalChatTurn(role: LocalChatRole.user, content: 'latest turn'),
      ],
      copy: copy,
    );

    final prompt = buildLocalChatPrompt(request, budget: 180);

    expect(prompt, contains('latest turn'));
    expect(prompt, isNot(contains('first turn')));
  });

  test('chunked extraction remaps evidence offsets to the full source', () async {
    final prefix = 'Intro paragraph. ' * 80;
    const snippet = 'Alex will send the checklist.';
    final source = '$prefix$snippet';
    final runtime = _RecordingRuntime(
      '{"candidates":[{"kind":"commitment","statement":"Alex will send the checklist.","owner":"Alex","dueDate":null,"quoteSnippet":"Alex will send the checklist."}]}',
    );
    final service = OnDeviceLocalAIService(runtime);

    final response = await service.extractChunked(
      LocalAIRequest(text: source, copy: copy),
    );

    expect(response.candidates, hasLength(1));
    final evidence = response.candidates.single.evidence;
    expect(evidence.quoteStart, source.indexOf(snippet));
    expect(evidence.quoteEnd, source.indexOf(snippet) + snippet.length);
  });

  test('chunked extraction deduplicates overlap candidates', () async {
    const snippet = 'Alex will send the checklist.';
    final source = '$snippet ${'More context. ' * 120}';
    final runtime = _RecordingRuntime(
      '{"candidates":[{"kind":"commitment","statement":"Alex will send the checklist.","owner":"Alex","dueDate":null,"quoteSnippet":"Alex will send the checklist."}]}',
    );
    final service = OnDeviceLocalAIService(runtime);

    final response = await service.extractChunked(
      LocalAIRequest(text: source, copy: copy),
    );

    expect(response.candidates, hasLength(1));
  });

  test('chunked extraction stops when cancelExtraction is called', () async {
    final runtime = _HoldingRuntime();
    final service = OnDeviceLocalAIService(runtime);
    final future = service.extractChunked(
      LocalAIRequest(text: 'Alex will send the checklist.', copy: copy),
    );
    await runtime.started.future;
    // Attach the matcher before stop completes generate, or the cancelled
    // throw is an unhandled async error in the test zone.
    final expectation = expectLater(
      future,
      throwsA(
        isA<LocalAIException>().having(
          (error) => error.code,
          'code',
          'cancelled',
        ),
      ),
    );
    await service.cancelExtraction();
    await expectation;
    expect(runtime.stopCount, 1);
  });

  test('extractChunked stays cancelled until prepareExtraction', () async {
    final runtime = _HoldingRuntime();
    final service = OnDeviceLocalAIService(runtime);
    final first = service.extractChunked(
      LocalAIRequest(text: 'Alex will send the checklist.', copy: copy),
    );
    await runtime.started.future;
    final firstExpectation = expectLater(
      first,
      throwsA(
        isA<LocalAIException>().having(
          (error) => error.code,
          'code',
          'cancelled',
        ),
      ),
    );
    await service.cancelExtraction();
    await firstExpectation;

    await expectLater(
      service.extractChunked(
        LocalAIRequest(text: 'Alex will send the checklist.', copy: copy),
      ),
      throwsA(
        isA<LocalAIException>().having(
          (error) => error.code,
          'code',
          'cancelled',
        ),
      ),
    );
    expect(runtime.generateCount, 1);

    service.prepareExtraction();
    runtime.armNextHold();
    final resumed = service.extractChunked(
      LocalAIRequest(text: 'Alex will send the checklist.', copy: copy),
    );
    await runtime.started.future;
    await runtime.stopGeneration();
    final response = await resumed;
    expect(response.candidates, isEmpty);
    expect(runtime.generateCount, 2);
  });

  test('chunked extraction yields to the event loop between chunks', () async {
    final order = <String>[];
    final runtime = _RecordingRuntime('{"candidates":[]}');
    final service = OnDeviceLocalAIService(runtime);
    final conversation = 'Alex will send the checklist. ' * 90;

    unawaited(Future<void>(() => order.add('event')));
    await service.extractChunked(
      LocalAIRequest(text: conversation, copy: copy),
      onChunk: (_) => order.add('chunk'),
    );

    expect(order.where((item) => item == 'chunk').length, greaterThan(1));
    expect(order, contains('event'));
    expect(order.indexOf('event'), lessThan(order.lastIndexOf('chunk')));
  });

  test('chunked extraction can skip already finished chunks', () async {
    final conversation = 'Alex will send the checklist. ' * 90;
    final fullRuntime = _RecordingRuntime('{"candidates":[]}');
    await OnDeviceLocalAIService(
      fullRuntime,
    ).extractChunked(LocalAIRequest(text: conversation, copy: copy));

    final skippedRuntime = _RecordingRuntime('{"candidates":[]}');
    await OnDeviceLocalAIService(skippedRuntime).extractChunked(
      LocalAIRequest(text: conversation, copy: copy),
      skipChunks: 1,
    );

    expect(fullRuntime.generateCount, greaterThan(1));
    expect(skippedRuntime.generateCount, fullRuntime.generateCount - 1);
  });
}

class _HoldingRuntime implements LocalTextModelRuntime {
  Completer<void> started = Completer<void>();
  Completer<void> proceed = Completer<void>();
  var stopCount = 0;
  var generateCount = 0;

  void armNextHold() {
    started = Completer<void>();
    proceed = Completer<void>();
  }

  @override
  String get modelId => 'test-runtime';

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<String> generate(
    String prompt, {
    void Function(String token)? onToken,
  }) async {
    generateCount += 1;
    if (!started.isCompleted) {
      started.complete();
    }
    await proceed.future;
    return '{"candidates":[]}';
  }

  @override
  Future<void> stopGeneration() async {
    stopCount += 1;
    if (!proceed.isCompleted) {
      proceed.complete();
    }
  }

  @override
  Future<void> dispose() async {}
}

class _RecordingRuntime implements LocalTextModelRuntime {
  _RecordingRuntime(this.output, {this.available = true});

  final String output;
  final bool available;
  String? prompt;
  var generateCount = 0;
  var stopCount = 0;

  @override
  String get modelId => 'test-runtime';

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<String> generate(
    String prompt, {
    void Function(String token)? onToken,
  }) async {
    generateCount += 1;
    this.prompt = prompt;
    onToken?.call(output);
    return output;
  }

  @override
  Future<void> stopGeneration() async {
    stopCount += 1;
  }

  @override
  Future<void> dispose() async {}
}
