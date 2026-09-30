import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/theme/app_theme.dart';

void main() {
  testWidgets('filter chip label uses onSurfaceVariant in light mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: FilterChip(
            label: const Text('Open'),
            selected: false,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    final context = tester.element(find.text('Open'));
    final scheme = Theme.of(context).colorScheme;
    final style = DefaultTextStyle.of(context).style;
    expect(style.color, scheme.onSurfaceVariant);
  });
}
