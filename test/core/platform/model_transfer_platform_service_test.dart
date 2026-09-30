import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/platform/model_transfer_platform_service.dart';

void main() {
  test('stub transfer does not claim a native runner', () {
    final stub = StubModelTransferPlatformService();
    expect(stub.canRunNativeTransfers, isFalse);
  });

  test('picked GGUF names are accepted case-insensitively', () {
    const picked = PickedGguf(
      uri: 'content://com.android.providers.downloads/1',
      displayName: 'Model.GGUF',
      size: 12,
    );
    expect(picked.isGguf, isTrue);
    expect(
      const PickedGguf(uri: 'content://x', displayName: 'notes.txt').isGguf,
      isFalse,
    );
  });
}
