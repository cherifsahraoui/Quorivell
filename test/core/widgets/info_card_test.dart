import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/theme/app_theme.dart';
import 'package:quorivell/core/widgets/info_card.dart';

import '../../helpers/layout_overflow.dart';

const _longSubtitle =
    'Quorivell stays an evidence-backed ledger. Decision and Commitment are '
    'the built-in example. Add kinds you need for daily use. Every candidate '
    'still needs an exact quote and your review. Fewer enabled kinds usually '
    'extract more cleanly on this device.';

void main() {
  testWidgets('wraps a long subtitle without overflowing on a narrow phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await expectNoLayoutOverflow(() async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: InfoCard(
                icon: Icons.info_outline,
                title: 'What to look for',
                subtitle: _longSubtitle,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    expect(find.text('What to look for'), findsOneWidget);
    expect(find.textContaining('evidence-backed ledger'), findsOneWidget);
  });

  testWidgets('scrollable sheet hosting InfoCard does not overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await expectNoLayoutOverflow(() async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        isScrollControlled: true,
                        builder: (sheetContext) {
                          return SafeArea(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const InfoCard(
                                    icon: Icons.info_outline,
                                    title: 'What to look for',
                                    subtitle: _longSubtitle,
                                  ),
                                  const SizedBox(height: 16),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.of(sheetContext).pop(),
                                    child: const Text('Dismiss'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    });

    expect(find.text('What to look for'), findsOneWidget);
    expect(find.text('Dismiss'), findsOneWidget);
  });

  testWidgets('tappable card invokes onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: InfoCard(
            icon: Icons.lightbulb_outline,
            title: 'Tips',
            subtitle: 'Short body',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tips'));
    expect(tapped, isTrue);
  });
}
