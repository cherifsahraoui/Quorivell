import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/account/presentation/widgets/local_model_size_label.dart';
import 'package:quorivell/l10n/app_localizations.dart';

void main() {
  test('formats megabytes and gigabytes from l10n', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    expect(localModelSizeLabel(l10n, 5 * 1000 * 1000), '5 MB');
    expect(localModelSizeLabel(l10n, 1120 * 1000 * 1000), '1.1 GB');
  });
}
