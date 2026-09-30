import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/layout/shell_bottom_inset.dart';
import 'package:quorivell/core/theme/app_spacing.dart';
import 'package:quorivell/core/widgets/show_app_snack_bar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('floating snack bar margin clears the raised Ledger FAB', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () {
                    showAppSnackBar(context, content: const Text('Saved'));
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.behavior, SnackBarBehavior.floating);
    expect(
      snackBar.margin,
      EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        ShellBottomInset.fabOuterRadius + AppSpacing.sm,
      ),
    );
  });
}
