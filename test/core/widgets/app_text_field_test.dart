import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/widgets/app_text_field.dart';

const _overflowingPrompt = '''
Line 00 of a synthetic debug prompt.
Line 01 of a synthetic debug prompt.
Line 02 of a synthetic debug prompt.
Line 03 of a synthetic debug prompt.
Line 04 of a synthetic debug prompt.
Line 05 of a synthetic debug prompt.
Line 06 of a synthetic debug prompt.
Line 07 of a synthetic debug prompt.
Line 08 of a synthetic debug prompt.
Line 09 of a synthetic debug prompt.
Line 10 of a synthetic debug prompt.
Line 11 of a synthetic debug prompt.
Line 12 of a synthetic debug prompt.
Line 13 of a synthetic debug prompt.
Line 14 of a synthetic debug prompt.
Line 15 of a synthetic debug prompt.
Line 16 of a synthetic debug prompt.
Line 17 of a synthetic debug prompt.
Line 18 of a synthetic debug prompt.
Line 19 of a synthetic debug prompt.
''';

Finder _innerScrollable() {
  return find.descendant(
    of: find.byType(AppTextField),
    matching: find.byType(Scrollable),
  );
}

Future<void> _pumpNestedPage(
  WidgetTester tester, {
  required TextEditingController textController,
  required ScrollController pageController,
  required ScrollController fieldScrollController,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView(
          controller: pageController,
          children: [
            AppTextField(
              controller: textController,
              scrollController: fieldScrollController,
              minLines: 4,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Prompt',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 1600),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('AppTextField hosts a Material TextField', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppTextField(decoration: InputDecoration(labelText: 'Prompt')),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(AppTextField), findsOneWidget);
  });

  testWidgets('scrolls the page when field text already fits', (tester) async {
    final textController = TextEditingController(text: 'Short prompt.');
    final pageController = ScrollController();
    final fieldScrollController = ScrollController();
    addTearDown(textController.dispose);
    addTearDown(pageController.dispose);
    addTearDown(fieldScrollController.dispose);

    await _pumpNestedPage(
      tester,
      textController: textController,
      pageController: pageController,
      fieldScrollController: fieldScrollController,
    );
    await tester.pumpAndSettle();

    expect(pageController.offset, 0);

    await tester.drag(_innerScrollable(), const Offset(0, -240));
    await tester.pumpAndSettle();

    expect(pageController.offset, greaterThan(0));
  });

  testWidgets('scrolls field text before handing leftover drag to the page', (
    tester,
  ) async {
    final textController = TextEditingController(text: _overflowingPrompt);
    final pageController = ScrollController();
    final fieldScrollController = ScrollController();
    addTearDown(textController.dispose);
    addTearDown(pageController.dispose);
    addTearDown(fieldScrollController.dispose);

    await _pumpNestedPage(
      tester,
      textController: textController,
      pageController: pageController,
      fieldScrollController: fieldScrollController,
    );
    await tester.pumpAndSettle();

    expect(fieldScrollController.position.maxScrollExtent, greaterThan(0));
    expect(pageController.offset, 0);

    await tester.drag(_innerScrollable(), const Offset(0, -80));
    await tester.pumpAndSettle();

    expect(fieldScrollController.offset, greaterThan(0));
    expect(pageController.offset, 0);

    fieldScrollController.jumpTo(
      fieldScrollController.position.maxScrollExtent,
    );
    await tester.pumpAndSettle();

    final pageBeforeHandoff = pageController.offset;
    await tester.drag(_innerScrollable(), const Offset(0, -240));
    await tester.pumpAndSettle();

    expect(pageController.offset, greaterThan(pageBeforeHandoff));
  });
}
