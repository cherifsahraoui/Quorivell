import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/network/webpage_text_fetcher.dart';

void main() {
  test('looksLikeHttpUrl accepts bare http(s) links only', () {
    expect(looksLikeHttpUrl('https://example.com/a'), isTrue);
    expect(looksLikeHttpUrl('  http://example.com  '), isTrue);
    expect(looksLikeHttpUrl('not a url'), isFalse);
    expect(looksLikeHttpUrl('https://example.com and more text'), isFalse);
  });

  test('extractMainTextFromHtml prefers article body over chrome', () {
    const html = '''
<html><head><title>School note</title>
<style>body{color:red}</style>
<script>alert(1)</script>
</head><body>
<nav>Home</nav>
<article>
<p>Emila did pick up her child Manolis from school.</p>
<p>Please bring snacks tomorrow.</p>
</article>
<footer>Copyright</footer>
</body></html>
''';

    final result = extractMainTextFromHtml(html);
    expect(result.title, 'School note');
    expect(result.text, contains('Emila did pick up her child Manolis'));
    expect(result.text, contains('Please bring snacks tomorrow'));
    expect(result.text.toLowerCase(), isNot(contains('alert')));
    expect(result.text.toLowerCase(), isNot(contains('copyright')));
  });
}
