import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/widgets/empty_state.dart';

void main() {
  testWidgets('EmptyState fits a short landscape viewport without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            height: 280,
            child: EmptyState(
              icon: Icons.fact_check_outlined,
              title: 'No candidates waiting for review.',
              subtitle:
                  'Extract explicit decisions and commitments from your latest local capture.',
              action: _noop,
              actionLabel: 'Extract',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('No candidates waiting for review.'), findsOneWidget);
    expect(find.text('Extract'), findsOneWidget);
  });

  testWidgets('EmptyState lays icon left of copy in a short viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 280);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.auto_awesome,
            title: 'Ask the on-device model',
            subtitle: 'Answers stay on this device.',
          ),
        ),
      ),
    );

    final iconRect = tester.getRect(find.byIcon(Icons.auto_awesome));
    final titleRect = tester.getRect(find.text('Ask the on-device model'));
    expect(iconRect.center.dx, lessThan(titleRect.center.dx));
    expect((iconRect.center.dy - titleRect.center.dy).abs(), lessThan(40));
  });

  testWidgets('EmptyState works inside scrollable SliverFillRemaining', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 120)),
              SliverFillRemaining(
                hasScrollBody: true,
                child: EmptyState(
                  icon: Icons.menu_book_outlined,
                  title: 'No ledger items yet',
                  subtitle: 'Capture a conversation to get started.',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('No ledger items yet'), findsOneWidget);
  });

  testWidgets(
    'EmptyState uses horizontal layout in landscape above height breakpoint',
    (tester) async {
      // Phone landscape often has height ~390, above the short-height cutoff.
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                EmptyState(
                  icon: Icons.auto_awesome,
                  title: 'Ask the on-device model',
                  subtitle: 'Answers stay on this device.',
                ),
              ],
            ),
          ),
        ),
      );

      final iconRect = tester.getRect(find.byIcon(Icons.auto_awesome));
      final titleRect = tester.getRect(find.text('Ask the on-device model'));
      expect(iconRect.center.dx, lessThan(titleRect.center.dx));
      expect((iconRect.center.dy - titleRect.center.dy).abs(), lessThan(40));
    },
  );
}

void _noop() {}
