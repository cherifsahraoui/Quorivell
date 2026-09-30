import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/layout/shell_bottom_inset.dart';
import 'package:quorivell/core/theme/app_spacing.dart';
import 'package:quorivell/core/widgets/quorivell_scaffold.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('under shell with local FAB, only pads for the page FAB', (
    tester,
  ) async {
    late double inset;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: ShellFabClearance(
            reservesClearance: true,
            child: Builder(
              builder: (context) {
                inset = QuorivellScaffold.contentBottomInset(
                  context: context,
                  clearKindControls: true,
                  hasLocalFab: true,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    expect(inset, QuorivellScaffold.localFabClearance);
  });

  testWidgets('under shell without local FAB, keeps light breathing room', (
    tester,
  ) async {
    late double inset;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: ShellFabClearance(
            reservesClearance: true,
            child: Builder(
              builder: (context) {
                inset = QuorivellScaffold.contentBottomInset(context: context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    expect(inset, AppSpacing.lg);
  });

  testWidgets('adds list FAB clearance outside the shell', (tester) async {
    late double inset;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: Builder(
            builder: (context) {
              inset = QuorivellScaffold.contentBottomInset(context: context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(inset, ShellBottomInset.raisedFabPad + AppSpacing.lg);
  });
}
