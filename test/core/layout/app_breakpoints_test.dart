import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/layout/app_breakpoints.dart';
import 'package:flutter/widgets.dart';

void main() {
  test('classifies phone, 7in, and 10in widths', () {
    expect(appWindowSizeForWidth(390), AppWindowSize.compact);
    expect(appWindowSizeForWidth(599), AppWindowSize.compact);
    expect(appWindowSizeForWidth(600), AppWindowSize.medium);
    expect(appWindowSizeForWidth(800), AppWindowSize.medium);
    expect(appWindowSizeForWidth(839), AppWindowSize.medium);
    expect(appWindowSizeForWidth(840), AppWindowSize.expanded);
  });

  test('split layout triggers for tablet width or landscape', () {
    expect(
      appUsesSplitLayout(const BoxConstraints(maxWidth: 390, maxHeight: 844)),
      isFalse,
    );
    expect(
      appUsesSplitLayout(const BoxConstraints(maxWidth: 600, maxHeight: 960)),
      isTrue,
    );
    expect(
      appUsesSplitLayout(const BoxConstraints(maxWidth: 800, maxHeight: 360)),
      isTrue,
    );
  });
}
