import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/database/database_providers.dart';

void main() {
  test('keeps the local database open after a one-shot read', () {
    expect(appDatabaseProvider.isAutoDispose, isFalse);
  });
}
