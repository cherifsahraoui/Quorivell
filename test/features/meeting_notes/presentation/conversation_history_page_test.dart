import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/meeting_notes/data/providers/source_conversation_providers.dart';
import 'package:quorivell/features/meeting_notes/domain/entities/source_conversation.dart';
import 'package:quorivell/features/meeting_notes/domain/repositories/source_conversation_repository.dart';
import 'package:quorivell/features/meeting_notes/presentation/pages/conversation_detail_page.dart';
import 'package:quorivell/features/meeting_notes/presentation/pages/conversation_history_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

class _FakeSourceConversationRepository
    implements SourceConversationRepository {
  _FakeSourceConversationRepository(
    this.conversations, {
    Stream<List<SourceConversation>>? stream,
  }) : _stream = stream,
       _controller = stream == null
           ? StreamController<List<SourceConversation>>.broadcast()
           : null;

  final List<SourceConversation> conversations;
  final StreamController<List<SourceConversation>>? _controller;
  final Stream<List<SourceConversation>>? _stream;
  Completer<SourceConversation?>? pendingFind;
  int? lastLimit;
  bool? lastArchivedOnly;
  final deletedIds = <String>[];

  void _emit() {
    final archivedOnly = lastArchivedOnly ?? false;
    _controller?.add(
      conversations
          .where((conversation) => conversation.isArchived == archivedOnly)
          .toList(),
    );
  }

  @override
  Future<SourceConversation> capture(String content) async =>
      throw UnimplementedError();

  @override
  Future<SourceConversation?> latest() async => null;

  @override
  Future<List<SourceConversation>> listActive({
    int? limit,
    bool newestFirst = true,
  }) async {
    final active = conversations
        .where((conversation) => !conversation.isArchived)
        .toList();
    if (!newestFirst) return active;
    return active.reversed.toList();
  }

  @override
  Stream<List<SourceConversation>> watchAll({
    int limit = 50,
    int offset = 0,
    bool archivedOnly = false,
  }) {
    lastLimit = limit;
    lastArchivedOnly = archivedOnly;
    if (_stream != null) return _stream;
    final controller = _controller!;
    scheduleMicrotask(_emit);
    return controller.stream;
  }

  @override
  Future<SourceConversation?> find(String id) async {
    if (pendingFind != null) return pendingFind!.future;
    for (final conversation in conversations) {
      if (conversation.id == id) return conversation;
    }
    return null;
  }

  @override
  Future<void> delete(String id) async {
    deletedIds.add(id);
    conversations.removeWhere((conversation) => conversation.id == id);
    _emit();
  }

  @override
  Future<void> archive(String id) async {
    final index = conversations.indexWhere(
      (conversation) => conversation.id == id,
    );
    if (index < 0) return;
    conversations[index] = conversations[index].copyWith(isArchived: true);
    _emit();
  }

  @override
  Future<void> unarchive(String id) async {
    final index = conversations.indexWhere(
      (conversation) => conversation.id == id,
    );
    if (index < 0) return;
    conversations[index] = conversations[index].copyWith(isArchived: false);
    _emit();
  }
}

Future<void> _pump(
  WidgetTester tester,
  SourceConversationRepository repository,
  Widget page,
) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        sourceConversationRepositoryProvider.overrideWithValue(repository),
      ],
      child: _wrap(page),
    ),
  );
}

void main() {
  final conversation = SourceConversation(
    id: 'source-1',
    userId: 'user-id',
    content: 'Synthetic conversation about the roadmap.',
    sourceRevision: 1,
    createdAt: DateTime.utc(2026, 9, 7),
    updatedAt: DateTime.utc(2026, 9, 7),
  );

  final archived = SourceConversation(
    id: 'source-archived',
    userId: 'user-id',
    content: 'Already extracted conversation.',
    sourceRevision: 1,
    createdAt: DateTime.utc(2026, 9, 6),
    updatedAt: DateTime.utc(2026, 9, 6),
    isArchived: true,
  );

  testWidgets('shows a loading state before history emits', (tester) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository(
        [],
        stream: StreamController<List<SourceConversation>>().stream,
      ),
      const ConversationHistoryPage(),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no conversations', (
    tester,
  ) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository([]),
      const ConversationHistoryPage(),
    );
    await tester.pumpAndSettle();

    expect(find.text('No conversations captured yet.'), findsOneWidget);
  });

  testWidgets('shows a localized error state when history fails', (
    tester,
  ) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository(
        [],
        stream: Stream<List<SourceConversation>>.error(
          const LocalPersistenceFailure.readFailed(),
        ),
      ),
      const ConversationHistoryPage(),
    );
    await tester.pumpAndSettle();

    expect(find.text('Conversation history unavailable.'), findsOneWidget);
  });

  testWidgets('lists captured conversations with a bounded query', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([
      conversation,
      archived,
    ]);
    await _pump(tester, repository, const ConversationHistoryPage());
    await tester.pumpAndSettle();

    expect(
      find.text('Synthetic conversation about the roadmap.'),
      findsOneWidget,
    );
    expect(find.text('Already extracted conversation.'), findsNothing);
    expect(repository.lastLimit, isNotNull);
    expect(repository.lastArchivedOnly, isFalse);
  });

  testWidgets('select mode bulk-deletes conversations after confirm', (
    tester,
  ) async {
    final second = SourceConversation(
      id: 'source-2',
      userId: 'user-id',
      content: 'Second synthetic conversation.',
      sourceRevision: 1,
      createdAt: DateTime.utc(2026, 9, 12),
      updatedAt: DateTime.utc(2026, 9, 12, 9),
      isArchived: false,
    );
    final repository = _FakeSourceConversationRepository([
      conversation,
      second,
    ]);
    await _pump(tester, repository, const ConversationHistoryPage());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsOneWidget);
    expect(find.byType(Checkbox), findsNWidgets(2));
    expect(find.byType(Dismissible), findsNothing);
    expect(find.byType(FilterChip), findsNothing);

    await tester.tap(find.byTooltip('Select all'));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();
    expect(find.text('Delete 2 conversations?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds, ['source-1', 'source-2']);
  });

  testWidgets('archived filter shows only archived conversations', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([
      conversation,
      archived,
    ]);
    await _pump(tester, repository, const ConversationHistoryPage());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Archived'));
    await tester.pumpAndSettle();

    expect(find.text('Already extracted conversation.'), findsOneWidget);
    expect(
      find.text('Synthetic conversation about the roadmap.'),
      findsNothing,
    );
    expect(find.text('Archived'), findsWidgets);
    expect(repository.lastArchivedOnly, isTrue);
  });

  testWidgets('history filter chips meet the 48dp tap target', (tester) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository([conversation]),
      const ConversationHistoryPage(),
    );
    await tester.pumpAndSettle();

    final activeChip = tester.getSize(
      find.widgetWithText(FilterChip, 'Active'),
    );
    expect(activeChip.height, greaterThanOrEqualTo(48));
    expect(activeChip.width, greaterThanOrEqualTo(48));

    final archivedChip = tester.getSize(
      find.widgetWithText(FilterChip, 'Archived'),
    );
    expect(archivedChip.height, greaterThanOrEqualTo(48));
    expect(archivedChip.width, greaterThanOrEqualTo(48));
  });

  testWidgets('archived filter shows an empty state when none exist', (
    tester,
  ) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository([conversation]),
      const ConversationHistoryPage(),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Archived'));
    await tester.pumpAndSettle();

    expect(find.text('No archived conversations.'), findsOneWidget);
  });

  testWidgets('detail page shows a loading state before the source loads', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([conversation])
      ..pendingFind = Completer();
    await _pump(
      tester,
      repository,
      const ConversationDetailPage(sourceId: 'source-1'),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('detail page shows the full conversation content', (
    tester,
  ) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository([conversation]),
      const ConversationDetailPage(sourceId: 'source-1'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Synthetic conversation about the roadmap.'),
      findsOneWidget,
    );
  });

  testWidgets('detail page highlights evidence quote offsets', (tester) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository([conversation]),
      const ConversationDetailPage(
        sourceId: 'source-1',
        highlightQuoteStart: 0,
        highlightQuoteEnd: 9,
      ),
    );
    await tester.pumpAndSettle();

    final richText = tester.widget<SelectableText>(find.byType(SelectableText));
    final span = richText.textSpan!;
    expect(span.children, isNotNull);
    expect(span.children, hasLength(3));
    expect((span.children![0] as TextSpan).text, '');
    expect((span.children![1] as TextSpan).text, 'Synthetic');
    expect((span.children![1] as TextSpan).style?.backgroundColor, isNotNull);
    expect(
      (span.children![2] as TextSpan).text,
      ' conversation about the roadmap.',
    );
  });

  testWidgets('detail page prefers the snippet over mismatched offsets', (
    tester,
  ) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository([conversation]),
      const ConversationDetailPage(
        sourceId: 'source-1',
        highlightQuoteStart: 0,
        highlightQuoteEnd: 5,
        highlightQuoteSnippet: 'roadmap',
      ),
    );
    await tester.pumpAndSettle();

    final richText = tester.widget<SelectableText>(find.byType(SelectableText));
    final span = richText.textSpan!;
    expect((span.children![1] as TextSpan).text, 'roadmap');
  });

  testWidgets('detail page shows a not-found state for a missing id', (
    tester,
  ) async {
    await _pump(
      tester,
      _FakeSourceConversationRepository([]),
      const ConversationDetailPage(sourceId: 'missing'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('This conversation is no longer available.'),
      findsOneWidget,
    );
  });

  testWidgets('long-press confirms then deletes a conversation', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([conversation]);
    await _pump(tester, repository, const ConversationHistoryPage());
    await tester.pumpAndSettle();

    await tester.longPress(
      find.text('Synthetic conversation about the roadmap.'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Delete this conversation?'), findsOneWidget);
    expect(
      find.text(
        'This removes the conversation from your history on this device. '
        'It cannot be undone.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds, ['source-1']);
    expect(
      find.text('Synthetic conversation about the roadmap.'),
      findsNothing,
    );
    expect(
      find.text('Could not delete the conversation. Try again.'),
      findsNothing,
    );
  });

  testWidgets('long-press restores an archived conversation to Active', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([archived]);
    await _pump(tester, repository, const ConversationHistoryPage());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Archived'));
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Already extracted conversation.'));
    await tester.pumpAndSettle();

    expect(find.text('Restore to Active?'), findsOneWidget);
    expect(find.text('Delete this conversation?'), findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
    await tester.pumpAndSettle();

    expect(find.text('Conversation restored to Active.'), findsOneWidget);
    expect(find.text('Already extracted conversation.'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'Active'));
    await tester.pumpAndSettle();
    expect(find.text('Already extracted conversation.'), findsOneWidget);
    expect(
      repository.conversations
          .singleWhere((c) => c.id == 'source-archived')
          .isArchived,
      isFalse,
    );
  });

  testWidgets(
    'swiping an archived conversation warns about ledger evidence links',
    (tester) async {
      final repository = _FakeSourceConversationRepository([archived]);
      await _pump(tester, repository, const ConversationHistoryPage());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilterChip, 'Archived'));
      await tester.pumpAndSettle();

      await tester.drag(
        find.text('Already extracted conversation.'),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete this conversation?'), findsOneWidget);
      expect(
        find.text(
          'This removes the conversation from your history on this device. '
          'Decisions and commitments that link here will no longer be able '
          'to open the original evidence. It cannot be undone.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(repository.deletedIds, ['source-archived']);
    },
  );

  testWidgets('canceling unarchive confirmation keeps the archived row', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([archived]);
    await _pump(tester, repository, const ConversationHistoryPage());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Archived'));
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Already extracted conversation.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Already extracted conversation.'), findsOneWidget);
    expect(
      repository.conversations
          .singleWhere((c) => c.id == 'source-archived')
          .isArchived,
      isTrue,
    );
  });

  testWidgets('canceling delete confirmation keeps the conversation', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([conversation]);
    await _pump(tester, repository, const ConversationHistoryPage());
    await tester.pumpAndSettle();

    await tester.longPress(
      find.text('Synthetic conversation about the roadmap.'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds, isEmpty);
    expect(
      find.text('Synthetic conversation about the roadmap.'),
      findsOneWidget,
    );
  });

  testWidgets('swiping left asks for confirmation before deleting', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([conversation]);
    await _pump(tester, repository, const ConversationHistoryPage());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Delete this conversation?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds, ['source-1']);
    expect(
      find.text('Synthetic conversation about the roadmap.'),
      findsNothing,
    );
    expect(
      find.text('Could not delete the conversation. Try again.'),
      findsNothing,
    );
  });

  testWidgets('detail page delete action confirms then deletes', (
    tester,
  ) async {
    final repository = _FakeSourceConversationRepository([conversation]);
    await _pump(
      tester,
      repository,
      const ConversationDetailPage(sourceId: 'source-1'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete conversation'));
    await tester.pumpAndSettle();

    expect(find.text('Delete this conversation?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds, ['source-1']);
    expect(
      find.text('Could not delete the conversation. Try again.'),
      findsNothing,
    );
  });
}
