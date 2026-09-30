import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/theme/app_theme.dart';

void main() {
  testWidgets('text buttons meet the 48dp tap target', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: TextButton(onPressed: () {}, child: const Text('Not now')),
        ),
      ),
    );

    final size = tester.getSize(find.widgetWithText(TextButton, 'Not now'));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
  });
}
