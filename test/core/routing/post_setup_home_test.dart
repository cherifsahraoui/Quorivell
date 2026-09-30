import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/routing/post_setup_home.dart';

void main() {
  test('smart-open prefers review when pending count is positive', () {
    expect(PostSetupHome.locationForPendingCount(1), PostSetupHome.review);
    expect(PostSetupHome.locationForPendingCount(9), PostSetupHome.review);
  });

  test('smart-open falls back to ledger when pending is zero or unknown', () {
    expect(PostSetupHome.locationForPendingCount(0), PostSetupHome.ledger);
    expect(PostSetupHome.locationForPendingCount(null), PostSetupHome.ledger);
  });

  test('badge label hides at zero and caps above nine', () {
    expect(PostSetupHome.badgeLabel(0), isNull);
    expect(PostSetupHome.badgeLabel(3), '3');
    expect(PostSetupHome.badgeLabel(9), '9');
    expect(PostSetupHome.badgeLabel(10), '9+');
  });
}
