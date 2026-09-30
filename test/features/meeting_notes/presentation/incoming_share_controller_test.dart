import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/platform/share_intent.dart';
import 'package:quorivell/features/meeting_notes/presentation/controllers/incoming_share_controller.dart';

void main() {
  ProviderContainer container() {
    final result = ProviderContainer.test();
    addTearDown(result.dispose);
    result.listen(incomingShareControllerProvider, (_, _) {});
    return result;
  }

  test('offers a new share and ignores a duplicate id', () {
    final c = container();
    final notifier = c.read(incomingShareControllerProvider.notifier);
    const first = IncomingSharePayload(id: 1, text: '  First synthetic.  ');
    const duplicate = IncomingSharePayload(id: 1, text: 'Ignored copy.');

    expect(notifier.offer(first), isTrue);
    expect(
      c.read(incomingShareControllerProvider),
      const IncomingSharePayload(id: 1, text: 'First synthetic.'),
    );
    expect(notifier.offer(duplicate), isFalse);
    expect(
      c.read(incomingShareControllerProvider),
      const IncomingSharePayload(id: 1, text: 'First synthetic.'),
    );
  });

  test('replaces pending text when a later share has a new id', () {
    final c = container();
    final notifier = c.read(incomingShareControllerProvider.notifier);

    expect(
      notifier.offer(const IncomingSharePayload(id: 1, text: 'Earlier.')),
      isTrue,
    );
    expect(
      notifier.offer(const IncomingSharePayload(id: 2, text: 'Later.')),
      isTrue,
    );
    expect(
      c.read(incomingShareControllerProvider),
      const IncomingSharePayload(id: 2, text: 'Later.'),
    );
  });

  test('rejects empty shares and discard clears the pending payload', () {
    final c = container();
    final notifier = c.read(incomingShareControllerProvider.notifier);

    expect(
      notifier.offer(const IncomingSharePayload(id: 1, text: '   ')),
      isFalse,
    );
    expect(c.read(incomingShareControllerProvider), isNull);

    expect(
      notifier.offer(const IncomingSharePayload(id: 2, text: 'Keep.')),
      isTrue,
    );
    notifier.discard();
    expect(c.read(incomingShareControllerProvider), isNull);
  });

  test('stores PROCESS_TEXT kind separately from share', () {
    final c = container();
    final notifier = c.read(incomingShareControllerProvider.notifier);
    expect(
      notifier.offer(
        const IncomingSharePayload(
          id: 3,
          text: '  Selected synthetic.  ',
          kind: IncomingTextKind.processText,
        ),
      ),
      isTrue,
    );
    expect(
      c.read(incomingShareControllerProvider),
      const IncomingSharePayload(
        id: 3,
        text: 'Selected synthetic.',
        kind: IncomingTextKind.processText,
      ),
    );
  });
}
