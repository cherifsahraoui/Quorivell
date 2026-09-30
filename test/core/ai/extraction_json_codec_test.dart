import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/extraction_json_codec.dart';
import 'package:quorivell/core/ai/extraction_kind_slugs.dart';

void main() {
  const codec = ExtractionJsonCodec();
  const source =
      'Alex explicitly committed to delivering the API documentation. '
      'Please pick up milk, eggs, and bread.';

  test('keeps built-in kinds when those slugs are enabled', () {
    const raw = '''
{"candidates":[
  {"kind":"commitment","statement":"Alex will deliver the API documentation","owner":"Alex","dueDate":null,"quoteSnippet":"Alex explicitly committed to delivering the API documentation"},
  {"kind":"decision","statement":"Buy milk eggs and bread","owner":null,"dueDate":null,"quoteSnippet":"Please pick up milk, eggs, and bread"}
]}
''';

    final candidates = codec.parse(raw, source);
    expect(candidates.map((item) => item.kind), ['commitment', 'decision']);
  });

  test('accepts groceries when enabled and still requires quoteSnippet', () {
    const raw = '''
{"candidates":[
  {"kind":"groceries","statement":"Buy milk, eggs, and bread","owner":null,"dueDate":"2026-10-15","quoteSnippet":"Please pick up milk, eggs, and bread","note":"invented"}
]}
''';

    final candidates = codec.parse(
      raw,
      source,
      enabledKindSlugs: {'groceries'},
      slugsAllowingDates: {'groceries'},
    );

    expect(candidates, hasLength(1));
    expect(candidates.single.kind, 'groceries');
    expect(candidates.single.dueDate, DateTime.utc(2026, 10, 15));
    expect(
      candidates.single.evidence.quoteSnippet,
      'Please pick up milk, eggs, and bread',
    );
  });

  test('drops unknown and disabled kinds including task', () {
    const raw = '''
{"candidates":[
  {"kind":"task","statement":"Do the dishes","owner":null,"dueDate":null,"quoteSnippet":"Please pick up milk, eggs, and bread"},
  {"kind":"commitment","statement":"Alex will deliver the API documentation","owner":"Alex","dueDate":null,"quoteSnippet":"Alex explicitly committed to delivering the API documentation"}
]}
''';

    final candidates = codec.parse(
      raw,
      source,
      enabledKindSlugs: {ExtractionKindSlugs.commitment},
    );

    expect(candidates, hasLength(1));
    expect(candidates.single.kind, ExtractionKindSlugs.commitment);
  });

  test('ignores model-produced notes', () {
    const raw = '''
{"candidates":[
  {"kind":"commitment","statement":"Alex will deliver the API documentation","owner":"Alex","dueDate":null,"quoteSnippet":"Alex explicitly committed to delivering the API documentation","note":"do not persist"}
]}
''';

    final candidates = codec.parse(raw, source);
    expect(candidates, hasLength(1));
    expect(candidates.single.toString(), isNot(contains('do not persist')));
  });
}
