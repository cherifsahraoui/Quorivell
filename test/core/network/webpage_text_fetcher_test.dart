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

  test('extractMainTextFromHtml prefers Recipe JSON-LD ingredients', () {
    const html = '''
<html><head><title>Ignore noisy title</title>
<script type="application/ld+json">
{
  "@context": "https://schema.org/",
  "@type": "Recipe",
  "name": "Good Old-Fashioned Pancakes",
  "recipeIngredient": [
    "1.5 cups all-purpose flour",
    "3.5 teaspoons baking powder",
    "1 tablespoon white sugar",
    "0.25 teaspoon salt, or more to taste",
    "1.25 cups milk",
    "3 tablespoons butter, melted",
    "1 egg"
  ]
}
</script>
</head><body>
<article>
<p>Reviews and ads and related recipes should not dominate capture.</p>
<p>1.5 cups all-purpose flour appears again in prose noise.</p>
</article>
</body></html>
''';

    final result = extractMainTextFromHtml(html);
    expect(result.title, 'Good Old-Fashioned Pancakes');
    expect(result.text, startsWith('Good Old-Fashioned Pancakes'));
    expect(result.text, contains('Ingredients:'));
    expect(result.text, contains('1.5 cups all-purpose flour'));
    expect(result.text, contains('1 egg'));
    expect(result.text.toLowerCase(), isNot(contains('reviews and ads')));
  });

  test('Recipe JSON-LD works inside @graph', () {
    const html = '''
<html><body>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {"@type": "WebPage", "name": "Page"},
    {
      "@type": "Recipe",
      "name": "Simple Toast",
      "recipeIngredient": ["2 slices bread", "1 tbsp butter"]
    }
  ]
}
</script>
</body></html>
''';

    final recipe = extractRecipePlainTextFromJsonLd(html);
    expect(recipe, isNotNull);
    expect(recipe!.title, 'Simple Toast');
    expect(recipe.text, contains('2 slices bread'));
    expect(recipe.text, contains('1 tbsp butter'));
  });
}

