import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/layout/shell_bottom_inset.dart';
import 'package:quorivell/core/theme/app_spacing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('phone lists get FAB clearance; rail layouts do not', (
    tester,
  ) async {
    late double phoneClearance;
    late double railClearance;
    late EdgeInsets phonePadding;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: Builder(
            builder: (context) {
              phoneClearance = ShellBottomInset.listFabClearance(context);
              phonePadding = ShellBottomInset.listPadding(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(900, 1200)),
          child: Builder(
            builder: (context) {
              railClearance = ShellBottomInset.listFabClearance(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(phoneClearance, ShellBottomInset.raisedFabPad);
    expect(railClearance, 0);
    expect(phonePadding.bottom, AppSpacing.lg + phoneClearance);
  });

  testWidgets('ShellFabClearance zeroes list FAB clearance', (tester) async {
    late double withReserve;
    late double withoutReserve;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: ShellFabClearance(
            reservesClearance: true,
            child: Builder(
              builder: (context) {
                withReserve = ShellBottomInset.listFabClearance(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: ShellFabClearance(
            reservesClearance: false,
            child: Builder(
              builder: (context) {
                withoutReserve = ShellBottomInset.listFabClearance(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    expect(withReserve, 0);
    expect(withoutReserve, ShellBottomInset.raisedFabPad);
  });

  testWidgets('kind controls clearance exceeds list FAB clearance on phone', (
    tester,
  ) async {
    late double listClearance;
    late double kindClearance;
    late double railKind;
    late double kindWhenShellReserves;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: Builder(
            builder: (context) {
              listClearance = ShellBottomInset.listFabClearance(context);
              kindClearance = ShellBottomInset.kindControlsClearance(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(900, 1200)),
          child: Builder(
            builder: (context) {
              railKind = ShellBottomInset.kindControlsClearance(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: ShellFabClearance(
            reservesClearance: true,
            child: Builder(
              builder: (context) {
                kindWhenShellReserves = ShellBottomInset.kindControlsClearance(
                  context,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    expect(kindClearance, greaterThan(listClearance));
    expect(
      kindClearance,
      ShellBottomInset.fabOuterRadius +
          ShellBottomInset.kindControlHeight +
          AppSpacing.md,
    );
    expect(kindWhenShellReserves, 0);
    expect(railKind, 0);
  });

  test('shell metrics stay aligned with the raised center control', () {
    expect(ShellBottomInset.barHeight, 72);
    expect(ShellBottomInset.fabRadius, 28);
    expect(
      ShellBottomInset.fabOuterRadius,
      ShellBottomInset.fabRadius + ShellBottomInset.fabRingPadding,
    );
    expect(
      ShellBottomInset.raisedFabPad,
      ShellBottomInset.fabOuterRadius + AppSpacing.md,
    );
  });

  testWidgets('phone snack bars clear the raised FAB; rail uses safe padding', (
    tester,
  ) async {
    late double phoneSnack;
    late double railSnack;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: Builder(
            builder: (context) {
              phoneSnack = ShellBottomInset.snackBarBottom(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(900, 1200),
            padding: EdgeInsets.only(bottom: 20),
            viewPadding: EdgeInsets.only(bottom: 20),
          ),
          child: Builder(
            builder: (context) {
              railSnack = ShellBottomInset.snackBarBottom(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(phoneSnack, ShellBottomInset.fabOuterRadius + AppSpacing.sm);
    expect(phoneSnack, greaterThan(ShellBottomInset.fabOuterRadius));
    expect(railSnack, AppSpacing.md + 20);
  });
}
