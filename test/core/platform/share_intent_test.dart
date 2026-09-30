import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/platform/share_intent.dart';

void main() {
  test('drops null, empty, and whitespace-only shares', () {
    expect(sanitizeSharedPlainText(null), isNull);
    expect(sanitizeSharedPlainText(''), isNull);
    expect(sanitizeSharedPlainText('   \n\t  '), isNull);
  });

  test('trims shared plain text without changing inner wording', () {
    expect(
      sanitizeSharedPlainText('  Alex will send the checklist.  '),
      'Alex will send the checklist.',
    );
  });

  test('keeps long shared text', () {
    final longText = 'x' * 20000;
    expect(sanitizeSharedPlainText(longText), longText);
  });

  test('parses native share maps and rejects invalid payloads', () {
    expect(
      parseIncomingSharePayload({'id': 3, 'text': '  Keep this.  '}),
      const IncomingSharePayload(id: 3, text: 'Keep this.'),
    );
    expect(
      parseIncomingSharePayload({
        'id': 4,
        'text': '  Selected synthetic.  ',
        'kind': 'processText',
      }),
      const IncomingSharePayload(
        id: 4,
        text: 'Selected synthetic.',
        kind: IncomingTextKind.processText,
      ),
    );
    expect(parseIncomingSharePayload({'id': 1, 'text': '   '}), isNull);
    expect(parseIncomingSharePayload({'text': 'Missing id'}), isNull);
    expect(parseIncomingSharePayload('not a map'), isNull);
    expect(parseIncomingSharePayload(null), isNull);
  });
}
