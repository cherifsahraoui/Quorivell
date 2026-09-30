import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/ledger/domain/entities/ledger_item.dart';

LedgerItem _item() => LedgerItem(
  id: 'item-1',
  userId: 'user-1',
  kind: LedgerItemKind.commitment,
  statement: 'Send the checklist.',
  status: LedgerItemStatus.open,
  owner: 'Alex',
  dueDate: null,
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

const _evidence = EvidenceReference(
  id: 'evidence-1',
  ledgerItemId: 'item-1',
  sourceConversationId: 'source-1',
  sourceRevision: 1,
  quoteStart: 0,
  quoteEnd: 19,
  quoteSnippet: 'Send the checklist.',
);

void main() {
  test('ledger items compare by value and round-trip through json', () {
    expect(_item(), _item());
    expect(LedgerItem.fromJson(_item().toJson()), _item());
  });

  test('ledger item copyWith keeps untouched fields', () {
    final completed = _item().copyWith(status: LedgerItemStatus.completed);

    expect(completed.status, LedgerItemStatus.completed);
    expect(completed.statement, 'Send the checklist.');
    expect(completed.id, 'item-1');
  });

  test('evidence references compare by value and round-trip through json', () {
    expect(EvidenceReference.fromJson(_evidence.toJson()), _evidence);
    expect(_evidence.quoteSnippet, 'Send the checklist.');
  });
}
