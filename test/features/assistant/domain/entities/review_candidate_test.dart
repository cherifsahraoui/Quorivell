import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/assistant/domain/entities/review_candidate.dart';

ReviewCandidate _candidate() => ReviewCandidate(
  id: 'candidate-1',
  userId: 'user-1',
  sourceConversationId: 'source-1',
  sourceRevision: 1,
  kind: ReviewCandidateKind.commitment,
  statement: 'Alex will send the checklist.',
  owner: 'Alex',
  dueDate: DateTime.utc(2026, 9, 10),
  quoteStart: 0,
  quoteEnd: 29,
  quoteSnippet: 'Alex will send the checklist.',
  reviewStatus: ReviewStatus.pending,
);

void main() {
  test('compares by value', () {
    expect(_candidate(), _candidate());
    expect(_candidate().hashCode, _candidate().hashCode);
  });

  test('generated copyWith changes only the named fields', () {
    final corrected = _candidate().copyWith(
      statement: 'Alex will send the agenda.',
      reviewStatus: ReviewStatus.deferred,
    );

    expect(corrected.statement, 'Alex will send the agenda.');
    expect(corrected.reviewStatus, ReviewStatus.deferred);
    expect(corrected.id, _candidate().id);
    expect(corrected.quoteSnippet, _candidate().quoteSnippet);
    expect(corrected.owner, 'Alex');
  });

  test('generated copyWith can clear a nullable field', () {
    expect(_candidate().copyWith(owner: null).owner, isNull);
    expect(_candidate().copyWith(dueDate: null).dueDate, isNull);
  });

  test('round-trips through json', () {
    final candidate = _candidate();

    expect(ReviewCandidate.fromJson(candidate.toJson()), candidate);
  });
}
