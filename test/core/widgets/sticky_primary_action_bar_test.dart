import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/layout/shell_bottom_inset.dart';
import 'package:quorivell/core/widgets/sticky_primary_action_bar.dart';

void main() {
  testWidgets('pins the primary action and invokes onPressed', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const Expanded(child: SizedBox.expand()),
              StickyPrimaryActionBar(
                label: 'Save kind',
                onPressed: () => pressed = true,
                clearRaisedFab: false,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Save kind'), findsOneWidget);
    await tester.tap(find.text('Save kind'));
    expect(pressed, isTrue);
  });

  testWidgets('shows a loading indicator and disables the button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StickyPrimaryActionBar(
            label: 'Saving…',
            onPressed: null,
            isLoading: true,
            clearRaisedFab: false,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets(
    'drops FAB clearance while the IME is open under a parent Scaffold',
    (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            // Mimics AppShell: consumes viewInsets for body descendants.
            bottomNavigationBar: SizedBox(height: 72),
            body: StickyPrimaryActionBar(
              label: 'Save overrides',
              onPressed: null,
            ),
          ),
        ),
      );
      await tester.pump();

      final closedHeight = tester
          .getSize(find.byType(StickyPrimaryActionBar))
          .height;

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pump();

      final openHeight = tester
          .getSize(find.byType(StickyPrimaryActionBar))
          .height;

      expect(
        closedHeight - openHeight,
        moreOrLessEquals(ShellBottomInset.fabOuterRadius),
      );
    },
  );

  testWidgets('imeBottomInset sees IME past a Scaffold-cleared MediaQuery', (
    tester,
  ) async {
    late double insetUnderCleared;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(400, 800),
          viewInsets: EdgeInsets.only(bottom: 280),
        ),
        child: Builder(
          builder: (outerContext) {
            return MediaQuery(
              data: MediaQuery.of(
                outerContext,
              ).removeViewInsets(removeBottom: true),
              child: Builder(
                builder: (innerContext) {
                  expect(MediaQuery.viewInsetsOf(innerContext).bottom, 0);
                  insetUnderCleared = StickyPrimaryActionBar.imeBottomInset(
                    innerContext,
                  );
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );

    expect(insetUnderCleared, 280);
  });

  testWidgets('skips FAB gap when the shell already reserved clearance', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<double> height({required bool shellReserves}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShellFabClearance(
              reservesClearance: shellReserves,
              child: const StickyPrimaryActionBar(
                label: 'Save overrides',
                onPressed: null,
              ),
            ),
          ),
        ),
      );
      return tester.getSize(find.byType(StickyPrimaryActionBar)).height;
    }

    final withShellReserve = await height(shellReserves: true);
    final withoutShellReserve = await height(shellReserves: false);
    expect(
      withoutShellReserve - withShellReserve,
      moreOrLessEquals(ShellBottomInset.fabOuterRadius),
    );

    // Painted strip stays the same height either way (gap is outside Material).
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShellFabClearance(
            reservesClearance: false,
            child: StickyPrimaryActionBar(
              label: 'Save overrides',
              onPressed: null,
            ),
          ),
        ),
      ),
    );
    final materialHeight = tester.getSize(find.byType(Material).first).height;
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShellFabClearance(
            reservesClearance: true,
            child: StickyPrimaryActionBar(
              label: 'Save overrides',
              onPressed: null,
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(Material).first).height,
      moreOrLessEquals(materialHeight),
    );
  });
}
