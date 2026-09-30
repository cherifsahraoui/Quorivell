import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/meeting_notes/presentation/widgets/conversation_evidence_highlight.dart';

void main() {
  group('resolveEvidenceQuoteRange', () {
    test('returns the span when offsets are valid', () {
      expect(
        resolveEvidenceQuoteRange(
          content: 'We chose option B.',
          quoteStart: 3,
          quoteEnd: 8,
        ),
        (start: 3, end: 8),
      );
    });

    test('returns null when offsets are missing or inverted', () {
      expect(
        resolveEvidenceQuoteRange(
          content: 'abc',
          quoteStart: null,
          quoteEnd: 1,
        ),
        isNull,
      );
      expect(
        resolveEvidenceQuoteRange(content: 'abc', quoteStart: 2, quoteEnd: 2),
        isNull,
      );
      expect(
        resolveEvidenceQuoteRange(content: 'abc', quoteStart: 0, quoteEnd: 4),
        isNull,
      );
    });

    test('prefers the snippet over stale offsets', () {
      const content = 'Alpha decided. Later we chose option B.';
      expect(
        resolveEvidenceQuoteRange(
          content: content,
          quoteStart: 0,
          quoteEnd: 5,
          quoteSnippet: 'we chose option B.',
        ),
        (
          start: content.indexOf('we chose option B.'),
          end:
              content.indexOf('we chose option B.') +
              'we chose option B.'.length,
        ),
      );
    });

    test('picks the repeated phrase closest to the stored offset', () {
      const phrase = 'we will ship Friday';
      const content = 'First we will ship Friday. Then we will ship Friday.';
      final second = content.lastIndexOf(phrase);
      expect(
        resolveEvidenceQuoteRange(
          content: content,
          quoteStart: second,
          quoteEnd: second + 3,
          quoteSnippet: phrase,
        ),
        (start: second, end: second + phrase.length),
      );
    });

    test('matches a snippet when whitespace differs', () {
      const content = 'Team decided to ship option B tomorrow.';
      expect(
        resolveEvidenceQuoteRange(
          content: content,
          quoteStart: 0,
          quoteEnd: 4,
          quoteSnippet: 'Team  decided   to ship option B tomorrow.',
        ),
        (start: 0, end: content.length),
      );
    });

    test('returns null when the snippet is not in the source', () {
      expect(
        resolveEvidenceQuoteRange(
          content: 'Team decided to ship.',
          quoteStart: 0,
          quoteEnd: 4,
          quoteSnippet: 'a quote that is not present',
        ),
        isNull,
      );
    });
  });

  group('ConversationEvidenceHighlight', () {
    testWidgets('auto-scrolls so a late highlight is near the top', (
      tester,
    ) async {
      final prefix = List.filled(40, 'Line of conversation text.\n').join();
      const quote = 'EVIDENCE_QUOTE';
      final content = '$prefix$quote\nTrailing notes.';
      final quoteStart = prefix.length;
      final quoteEnd = quoteStart + quote.length;
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: controller,
              padding: const EdgeInsets.all(16),
              children: [
                ConversationEvidenceHighlight(
                  content: content,
                  quoteStart: quoteStart,
                  quoteEnd: quoteEnd,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(controller.hasClients, isTrue);
      expect(controller.offset, greaterThan(0));
      expect(
        controller.offset,
        lessThanOrEqualTo(controller.position.maxScrollExtent),
      );
    });

    testWidgets('does not scroll when there is no highlight range', (
      tester,
    ) async {
      final content = List.filled(40, 'Line of conversation text.\n').join();
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: controller,
              padding: const EdgeInsets.all(16),
              children: [ConversationEvidenceHighlight(content: content)],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(controller.offset, 0);
    });

    testWidgets('highlights the snippet when offsets point at the wrong span', (
      tester,
    ) async {
      const content = 'Alpha noted it. Later we chose option B.';
      const snippet = 'we chose option B.';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConversationEvidenceHighlight(
              content: content,
              quoteStart: 0,
              quoteEnd: 5,
              quoteSnippet: snippet,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final richText = tester.widget<SelectableText>(
        find.byType(SelectableText),
      );
      final span = richText.textSpan!;
      expect(span.children, hasLength(3));
      expect((span.children![0] as TextSpan).text, 'Alpha noted it. Later ');
      expect((span.children![1] as TextSpan).text, snippet);
      expect((span.children![1] as TextSpan).style?.backgroundColor, isNotNull);
    });
  });
}
