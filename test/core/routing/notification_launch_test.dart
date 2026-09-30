import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/routing/notification_launch.dart';
import 'package:quorivell/core/routing/post_setup_home.dart';

void main() {
  test('keeps review, ledger, and chat destinations', () {
    expect(
      sanitizeNotificationDestination('/review')?.toString(),
      PostSetupHome.review,
    );
    expect(
      sanitizeNotificationDestination('/ledger')?.toString(),
      PostSetupHome.ledger,
    );
    expect(
      sanitizeNotificationDestination('/chat')?.toString(),
      PostSetupHome.chat,
    );
  });

  test('keeps extract teaching query and drops unknown query', () {
    expect(
      sanitizeNotificationDestination('/review?teach=1')?.toString(),
      PostSetupHome.reviewEmptyHelp,
    );
    expect(
      sanitizeNotificationDestination('/review?other=1')?.toString(),
      PostSetupHome.review,
    );
  });

  test('rejects schemes, hosts, and unknown paths', () {
    expect(sanitizeNotificationDestination(null), isNull);
    expect(sanitizeNotificationDestination(''), isNull);
    expect(sanitizeNotificationDestination('https://example/review'), isNull);
    expect(sanitizeNotificationDestination('/capture'), isNull);
    expect(sanitizeNotificationDestination('/hack'), isNull);
  });
}
