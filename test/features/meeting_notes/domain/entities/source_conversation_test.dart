import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/meeting_notes/domain/entities/source_conversation.dart';

SourceConversation _conversation() => SourceConversation(
  id: 'source-1',
  userId: 'user-1',
  content: 'Synthetic conversation.',
  sourceRevision: 1,
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

void main() {
  test('compares by value', () {
    expect(_conversation(), _conversation());
  });

  test('round-trips through json', () {
    expect(
      SourceConversation.fromJson(_conversation().toJson()),
      _conversation(),
    );
  });

  test('copyWith bumps a revision without touching the content', () {
    final revised = _conversation().copyWith(sourceRevision: 2);

    expect(revised.sourceRevision, 2);
    expect(revised.content, 'Synthetic conversation.');
    expect(revised.isArchived, isFalse);
  });

  test('copyWith can mark a conversation archived', () {
    expect(_conversation().copyWith(isArchived: true).isArchived, isTrue);
  });

  test('copyWith can attach a webpage sourceUrl', () {
    final withUrl = _conversation().copyWith(
      sourceUrl: 'https://example.com/article',
    );

    expect(withUrl.sourceUrl, 'https://example.com/article');
    expect(
      SourceConversation.fromJson(withUrl.toJson()).sourceUrl,
      'https://example.com/article',
    );
  });
}
