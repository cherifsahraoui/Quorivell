import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/routing/conversation_highlight.dart';

void main() {
  test('includes quote offsets and the evidence snippet', () {
    final uri = Uri.parse(
      conversationSourceHighlightPath(
        sourceId: 'source-1',
        quoteStart: 12,
        quoteEnd: 30,
        quoteSnippet: 'we chose option B.',
      ),
    );

    expect(uri.path, '/capture/sources/source-1');
    expect(uri.queryParameters['quoteStart'], '12');
    expect(uri.queryParameters['quoteEnd'], '30');
    expect(uri.queryParameters['quoteSnippet'], 'we chose option B.');
  });

  test('omits an empty snippet', () {
    final uri = Uri.parse(
      conversationSourceHighlightPath(
        sourceId: 'source-1',
        quoteStart: 0,
        quoteEnd: 4,
        quoteSnippet: '  ',
      ),
    );

    expect(uri.path, '/capture/sources/source-1');
    expect(uri.queryParameters['quoteStart'], '0');
    expect(uri.queryParameters.containsKey('quoteSnippet'), isFalse);
  });
}
