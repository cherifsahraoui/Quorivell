import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('light mode selected radio/list tile is darker than primary', () {
    final theme = AppTheme.light();
    final selected = theme.listTileTheme.selectedColor!;
    final primary = theme.colorScheme.primary;

    expect(selected, isNot(equals(primary)));
    expect(selected.computeLuminance(), lessThan(primary.computeLuminance()));
    expect(
      theme.radioTheme.fillColor!.resolve({WidgetState.selected}),
      selected,
    );
  });

  test('dark mode selected radio/list tile matches primary', () {
    final theme = AppTheme.dark();
    final primary = theme.colorScheme.primary;

    expect(theme.listTileTheme.selectedColor, primary);
    expect(
      theme.radioTheme.fillColor!.resolve({WidgetState.selected}),
      primary,
    );
  });
}
